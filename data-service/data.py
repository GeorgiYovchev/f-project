import os

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:////app/db/data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class Data(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user = db.Column(db.String(80), nullable=False)
    message = db.Column(db.String(200), nullable=False)

@app.route('/store', methods=['POST'])
def store_data():
    user = request.json['user']
    message = request.json['message']

    new_data = Data(user=user, message=message)
    db.session.add(new_data)
    db.session.commit()

    return jsonify({"message": "Data stored"}), 201

@app.route('/retrieve', methods=['GET'])
def retrieve_data():
    user = request.args.get('user')
    user_data = Data.query.filter_by(user=user).all()
    messages = [data.message for data in user_data]

    return jsonify({"data": messages}), 200

with app.app_context():
    db.create_all()

if __name__ == '__main__':
    app.run(port=os.environ.get("PORT", 5002), host="0.0.0.0")
