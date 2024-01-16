import os
import requests

from flask import Flask, request, render_template

app = Flask(__name__)


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/register", methods=["POST"])
def handle_registration():
    username = request.form["username"]
    password = request.form["password"]

    response = requests.post(
        "http://user:5001/register", json={"username": username, "password": password}
    )

    return response.text


@app.route("/login", methods=["POST"])
def handle_login():
    username = request.form["username"]
    password = request.form["password"]

    response = requests.post(
        "http://user:5001/login", json={"username": username, "password": password}
    )

    return response.text


@app.route("/store", methods=["POST"])
def store_data():
    user = request.form["user"]
    message = request.form["message"]

    response = requests.post(
        "http://data:5002/store", json={"user": user, "message": message}
    )

    return response.text


if __name__ == "__main__":
    app.run(port=os.environ.get("PORT", 5003), host="0.0.0.0")
