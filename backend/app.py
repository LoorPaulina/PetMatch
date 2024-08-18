from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
import datetime
# creo el proyecto flask
app = Flask(__name__)
# permito que reciba peticiones de todas las direcciones
CORS(app)
# creo la conexion


def obtener_conexion():

    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="root",
        database="petmatch"
    )


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
        data = request.json
        email = data.get('email')
        nombre = data.get('nombre')
        apellido = data.get('apellido')
        ocupacion = data.get('ocupacion')
        # password pasada al endpoint
        password = data.get('password')

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
    db = obtener_conexion()
    data = request.json
    total_adopciones = 0
    with db.cursor() as cursor:
        usuario_id = data.get("id")
        func_agregacion = """SELECT COUNT(codigo_usuario) AS
                               totalAdopciones FROM Adopcion WHERE
                               codigo_usuario=%s;"""
        cursor.execute(func_agregacion, (usuario_id, ))
        total_adopciones = cursor.fetchone()
    db.close()
    return jsonify({"msg": "transaccion exitosa",
                    "total": total_adopciones[0]}), 201


@app.route('/getMascotas', methods=['GET'])
def getMascotas():
    conexion = obtener_conexion()
    mascotas = []
    with conexion.cursor() as cursor:
        cursor.execute("SELECT * FROM Animal")
        mascotas = cursor.fetchall()
    conexion.close()
    mascotas_json = []
    for mascota in mascotas:
        print(mascota)
        mascota_dict = {
            'nombre': mascota[0],
            'edad': mascota[1],
            'peso': mascota[2],
            'sexo': mascota[3],
            'estado_adopcion': mascota[4],
            'altura': mascota[5]
        }
        mascotas_json.append(mascota_dict)
    return jsonify({"data": mascotas_json}), 201


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
