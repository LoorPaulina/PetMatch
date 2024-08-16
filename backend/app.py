from flask import Flask, json,jsonify, request
from flask_cors import CORS
import mysql.connector
#creo el proyecto flask 
app= Flask(__name__)
#permito que reciba peticiones de todas las direcciones
CORS(app)
#creo la conexion

def obtener_conexion():
    return mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="petmatch"
    )

@app.route('/login',methods=['POST'])
def login():
    db = obtener_conexion()
    data=request.json
    email=data.get('email')
    #password pasada al endpoint 
    password=data.get('password')

    cursor=db.cursor(dictionary=True)
    cursor.execute('SELECT * FROM usuario where email= %s',(email,)) 
    usuario=cursor.fetchone();
    if (usuario) and (usuario["contrasena"]==password):
          return jsonify({
               "msg":"successful",
               "usuario":usuario, 
          }),200
    else:
          return jsonify({
                "msg":"failed",
                "user":None,
          }),401

@app.route('/createAccount',methods=['POST'])
def createAccount():
    db = obtener_conexion()
    try:
      data=request.json
      email=data.get('email')
      username=data.get('username')
      nombre=data.get('nombre')
      apellido=data.get('apellido')
      ocupacion=data.get('ocupacion')
      #password pasada al endpoint 
      password=data.get('password')

      cursor=db.cursor(dictionary=True)
      cursor.execute("INSERT INTO Usuario (email, contrasena, nombre, apellido, num_adopciones, cantidad_donaciones, ocupacion, biografia, carta_motivacional, rol_de_pago) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                                    (email, password, nombre, apellido, 0, 0, ocupacion, '', '', ''))
      db.commit()
      return jsonify({"msg": "Account created successfully!"}), 201
    except Exception as e:
      print(e)
      db.rollback()
      return jsonify({"msg": "Failed to create account", "error": str(e)}), 500
    finally:
         db.close()

@app.route('/getMascotas',methods=['GET'])
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



if __name__ == '__main__':
        app.run(host='0.0.0.0', port=5000, debug=True)


