from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
from datetime import datetime, timedelta
# creo el proyecto flask
app = Flask(__name__)
# permito que reciba peticiones de todas las direcciones
CORS(app)
# creo la conexion


def obtener_conexion():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="root",
            database="petmatch"
        )
        if connection.is_connected():
            print("Conexión exitosa a la base de datos")
            return connection
    except:
        print(f"Error al conectar a MySQL")
        return None


@app.route('/login', methods=['POST'])
def login():
    db = obtener_conexion()
    data = request.json
    email = data.get('email')
    # password pasada al endpoint
    password = data.get('password')

    cursor = db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM usuario where email= %s', (email, ))
    usuario = cursor.fetchone()
    if (usuario) and (usuario["contrasena"] == password):
        return jsonify({
               "msg": "successful",
               "usuario": usuario,
            }), 200
    else:
        return jsonify({
                "msg": "failed",
                "user": None,
          }), 401


@app.route('/createAccount', methods=['POST'])
def createAccount():
    db = obtener_conexion()
    try:
        data=request.json
        email=data.get('email')
        nombre=data.get('nombre')
        apellido=data.get('apellido')
        ocupacion=data.get('ocupacion')
        password=data.get('password')

        cursor = db.cursor(dictionary=True)
        cursor.execute("""INSERT INTO Usuario (email, contrasena, nombre,
                       apellido, num_adopciones, cantidad_donaciones,ocupacion,
                       biografia, carta_motivacional, rol_de_pago)
                       VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)""",
                       (email, password, nombre, apellido, 0, 0,
                        ocupacion, '', '', ''))
        db.commit()
        return jsonify({"msg": "Account created successfully!"}), 201
    except Exception as e:
        print(e)
        db.rollback()
        return jsonify({"msg": "Failed to create account",
                        "error": str(e)}), 500
    finally:
         db.close()

@app.route('/editAccount', methods=['POST'])
def editAccount():
    db = obtener_conexion()
    try:
        data = request.json
        email = data.get('email')
        biografia = data.get('biografia')
        ocupacion = data.get('ocupacion')
        contrasena = data.get('contrasena')

        fields_to_update = []
        values = []

        if ocupacion != '':
            fields_to_update.append("ocupacion = %s")
            values.append(ocupacion)

        if biografia != '':
            fields_to_update.append("biografia = %s")
            values.append(biografia)
        
        if contrasena != '':
            fields_to_update.append("contrasena = %s")
            values.append(contrasena)

        print(fields_to_update)
        print(values)
        # If there are fields to update, proceed
        if fields_to_update:
            query = "UPDATE Usuario SET " + ", ".join(fields_to_update) + " WHERE email = %s"
            values.append(email)
            
            cursor = db.cursor(dictionary=True)
            cursor.execute(query, tuple(values))
            db.commit()
            return jsonify({"msg": "Account updated successfully!"}), 200
        else:
            return jsonify({"msg": "No fields to update"}), 400

    except Exception as e:
        print(e)
        db.rollback()
        return jsonify({"msg": "Failed to update account", "error": str(e)}), 500

    finally:
        db.close()


@app.route('/getTotalDonaciones', methods=['GET'])
def getTotalDonaciones():
    db = obtener_conexion()
    data = request.json
    total_donaciones = 0
    with db.cursor() as cursor:
        usuario_id = data.get("id")
        func_agregacion = """SELECT COUNT(codigo_usuario) AS
            totalDonaciones FROM Donaciones
            WHERE codigo_usuario=%s;"""
        cursor.execute(func_agregacion, (usuario_id, ))
        total_donaciones = cursor.fetchone()
    db.close()
    return jsonify({"msg": "transaccion exitosa",
                    "total": total_donaciones[0]}), 201


@app.route('/getTotalAdopciones', methods=['GET'])
def getTotalAdopciones():
    #dado el id de un usuario me devuelve el total de donaciones que ha realizado
    db=obtener_conexion();
    data=request.json
    total_adopciones=0;
    with db.cursor() as cursor: 
            usuario_id=data.get("id");  
            func_agregacion="""SELECT COUNT(codigo_usuario) AS totalAdopciones FROM Adopcion WHERE codigo_usuario=%s;"""
            cursor.execute(func_agregacion,(usuario_id,));
            total_adopciones=cursor.fetchone();
    db.close();
    return jsonify({"msg":"transaccion exitosa", "total":total_adopciones[0]}),201
    
@app.route('/getMascotas', methods=['GET'])
def getMascotas():
    conexion = obtener_conexion()
    mascotas = []
    
    tipo_animal = request.args.get('tipo', default='', type=str)
    antiguedad = request.args.get('antiguedad', default='', type=str)

    try:
        with conexion.cursor() as cursor:
            # Base de la consulta SQL
            sql_query = """
                SELECT Animal.*, Categoria.descripcion as especie_descripcion
                FROM Animal
                JOIN Categoria ON Animal.especie = Categoria.id
                WHERE 1=1
            """
            
            # Agregar condiciones de filtro si existen
            params = []
            if tipo_animal:
                sql_query += " AND Categoria.descripcion = %s"
                params.append(tipo_animal)
            if antiguedad:
                antiguedad_fecha = calcular_fecha_antiguedad(antiguedad)
                sql_query += " AND Animal.en_adopcion_desde < %s"
                params.append(antiguedad_fecha)

            # Ejecutar consulta
            cursor.execute(sql_query, params)
            mascotas = cursor.fetchall()

        mascotas_json = []
        for mascota in mascotas:
            print(mascota)
            try:
                peso = float(mascota[3]) if mascota[3] else None
                altura = float(mascota[6]) if mascota[6] else None
            except ValueError:
                peso = None
                altura = None

            mascota_dict = {
                "codigo": mascota[0],
                'nombre': mascota[1],
                'fecha_nacimiento': mascota[2],
                'peso': peso,
                'sexo': mascota[4],
                'estado_adopcion': mascota[5],
                'altura': altura,
                'especie': mascota[11],  # Aquí usamos el índice correcto para la descripción de la especie
                'photo_url': mascota[8],
                'en_adopcion_desde': mascota[9],
                'historia': mascota[10]
            }
            mascotas_json.append(mascota_dict)

    except Exception as e:
        print(f"Error fetching mascotas: {e}")
        return jsonify({"error": "Internal Server Error"}), 500
    finally:
        conexion.close() 

    return jsonify({"data": mascotas_json}), 200

def calcular_fecha_antiguedad(antiguedad):
    hoy = datetime.now()
    if antiguedad == 'Mayor a 1 mes':
        return hoy - timedelta(days=30)
    elif antiguedad == 'Mayor a 3 meses':
        return hoy - timedelta(days=90)
    elif antiguedad == 'Mayor a 6 meses':
        return hoy - timedelta(days=180)
    elif antiguedad == 'Mayor a 1 año':
        return hoy - timedelta(days=365)
    return hoy



@app.route('/getMascotasPorCategoria/<string:categoria>', methods=['GET'])
def getMascotasPorCategoria(categoria):
    conexion = obtener_conexion()
    mascotas = []
    with conexion.cursor() as cursor:
        # Use a tuple for the parameter
        cursor.execute("SELECT * FROM Animal WHERE especie = %s", (categoria,))
        mascotas = cursor.fetchall()
    conexion.close()
    mascotas_json = []
    for mascota in mascotas:
        mascota_dict = {
            'nombre': mascota[1],
            'fecha_nacimiento': mascota[2],
            'peso': mascota[3],
            'sexo': mascota[4],
            'estado_adopcion': mascota[4],
            'altura': mascota[5],
            'especie': categoria,
            'photo_url': mascota[7],
            'en_adopcion_desde': mascota[8],
            'historia': mascota[9]
        }
        mascotas_json.append(mascota_dict)

    return jsonify({"data": mascotas_json}), 201


@app.route('/getMascotasASC', methods=['GET'])
def getMascotasASC():
    conexion = obtener_conexion()
    mascotas = []
    try:
        with conexion.cursor() as cursor:
            cursor.execute("SELECT * FROM Animal ORDER BY en_adopcion_desde ASC")
            mascotas = cursor.fetchall()

        mascotas_json = []
        for mascota in mascotas:
            categoria = ''
            try:
                with conexion.cursor() as cursor:
                    cursor.execute("SELECT * FROM Categoria WHERE Categoria.id = %s", (mascota[7],))
                    categoria = cursor.fetchone()[1]
            except Exception as e:
                print(f"Error fetching category: {e}")

            mascota_dict = {
                'nombre': mascota[1],
                'fecha_nacimiento': mascota[2],
                'peso': mascota[3],
                'sexo': mascota[4],
                'estado_adopcion': mascota[5],
                'altura': mascota[6],
                'especie': categoria,
                'photo_url': mascota[8],
                'en_adopcion_desde': mascota[9],
                'historia': mascota[10]
            }
            mascotas_json.append(mascota_dict)

    except Exception as e:
        print(f"Error fetching mascotas: {e}")
        return jsonify({"error": "Internal Server Error"}), 500
    finally:
        conexion.close()

    return jsonify({"data": mascotas_json}), 200

@app.route('/getMascotasDESC', methods=['GET'])
def getMascotasDESC():
    conexion = obtener_conexion()
    mascotas = []
    try:
        with conexion.cursor() as cursor:
            cursor.execute("SELECT * FROM Animal ORDER BY en_adopcion_desde DESC")
            mascotas = cursor.fetchall()

        mascotas_json = []
        for mascota in mascotas:
            categoria = ''
            try:
                with conexion.cursor() as cursor:
                    cursor.execute("SELECT * FROM Categoria WHERE Categoria.id = %s", (mascota[7],))
                    categoria = cursor.fetchone()[1]
            except Exception as e:
                print(f"Error fetching category: {e}")

            mascota_dict = {
                'nombre': mascota[1],
                'fecha_nacimiento': mascota[2],
                'peso': mascota[3],
                'sexo': mascota[4],
                'estado_adopcion': mascota[5],
                'altura': mascota[6],
                'especie': categoria,
                'photo_url': mascota[8],
                'en_adopcion_desde': mascota[9],
                'historia': mascota[10]
            }
            mascotas_json.append(mascota_dict)

    except Exception as e:
        print(f"Error fetching mascotas: {e}")
        return jsonify({"error": "Internal Server Error"}), 500
    finally:
        conexion.close()

    return jsonify({"data": mascotas_json}), 200

@app.route('/getHealthyRecord/<string:nombre>', methods=['GET'])
def getHealthyRecord(nombre):
    conexion = obtener_conexion()
    try:
        with conexion.cursor() as cursor:
            cursor.execute("select * from historialMedico WHERE nombre = %s", (nombre,))
            mascota = cursor.fetchone()

            mascota_dict = {
                'nombre': mascota[0],
                'esterilizado': mascota[1],
                'ultima_desparasitacion': mascota[2],
            }

    except Exception as e:
        print(f"Error fetching mascotas: {e}")
        return jsonify({"error": "Internal Server Error"}), 500
    finally:
        conexion.close()

    return jsonify({"data": mascota_dict}), 200

@app.route('/getVacunas/<string:nombre>', methods=['GET'])
def getVacunas(nombre):
    conexion = obtener_conexion()
    try:
        with conexion.cursor() as cursor:
            cursor.execute("select * from vacunasView where nombre= %s", (nombre,))
            vacunas = cursor.fetchall()

            vacunasFetch = []
            for vacuna in vacunas:
                vacuna_dict = {
                    'nombre': vacuna[0],
                    'fecha': vacuna[1],
                    'vacuna': vacuna[2],
                }
                vacunasFetch.append(vacuna_dict)
            
    except Exception as e:
        print(f"Error fetching mascotas: {e}")
        return jsonify({"error": "Internal Server Error"}), 500
    finally:
        conexion.close()

    return jsonify({"data": vacunasFetch}), 200


@app.route('/registrarDonacion', methods=['POST'])
def registrarDonacion():
    # cuando el usuario hace una donacion la registra en la tabla donaciones
    # que debo recibir para registrar la donacion?
    # usuario que realizo la donacion , monto, fecha de donacion
    data = request.json
    conection = obtener_conexion()
    try:
        id_usuario = data.get('codigo')
        id_usuario = int(id_usuario)
        monto_donacion = data.get('monto')
        fecha_donacion = datetime.datetime.now().date()
        fecha_donacion = fecha_donacion.strftime('%Y-%m-%d')
        with conection.cursor() as cursor:
            query = """INSERT INTO Donaciones
            (codigo_usuario, monto, fecha_donacion)
            VALUES (%s, %s, %s)"""
            cursor.execute(query,
                           (id_usuario, float(monto_donacion), fecha_donacion))
            conection.commit()
        return jsonify({"msg": "se registro la donacion"}), 201

    except Exception as e:
        print(e)
        conection.rollback()
        return jsonify({"msg": "Failed to register donation",
                        "error": str(e)}), 500
    finally:
        conection.close()
# registrar ficha de donante


@app.route('/actualizarFicha', methods=['PUT'])
def actualizarFicha():
    db_conection = obtener_conexion()
    data = request.json
    try:
        # id unico(aqui se hace la insercion)
        id = data.get('codigo')
        id = int(id)
        # datos del adoptante
        nombre = data.get('nombre')
        apellido = data.get('apellido')
        ocupacion = data.get('ocupacion')
        descripcion = data.get('descripcion')
        rolPago = data.get('rol')
        motivacion = data.get('motivacion')
        with db_conection.cursor() as cursor:
            cursor.execute("""UPDATE usuario
            SET nombre = %s, apellido = %s, ocupacion=%s,
            biografia=%s,   rol_de_pago=%s, carta_motivacional=%s
            WHERE codigo = %s;""",
                           (nombre, apellido, ocupacion,
                            descripcion, rolPago, motivacion, id))
            db_conection.commit()
        return jsonify({"msg": "se realizo el update exitoso"}), 201
    except Exception as e:
        print(e)
        db_conection.rollback()
        return jsonify({"msg": "Failed to update", "error": str(e)}), 500
    finally:
        db_conection.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
