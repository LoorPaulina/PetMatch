from flask import Flask,jsonify, request
from flask_cors import CORS
import mysql.connector
#creo el proyecto flask 
app= Flask(__name__)
#permito que reciba peticiones de todas las direcciones
CORS(app)
#creo la conexion

db=mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="petmatch"
)

@app.route('/login',methods=['POST'])
def login():

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


if __name__ == '__main__':
        app.run(debug=True)


