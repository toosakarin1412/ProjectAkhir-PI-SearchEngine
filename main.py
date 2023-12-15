from flask import Flask, render_template, request
import os
import requests
import json

app = Flask(__name__)

@app.route("/",methods = ['GET'])
def index():
    return render_template("index.html")

@app.route("/search", methods = ['POST', 'GET'])
def search():
    query = str()
    k = int()
    engine = str()
    if request.method == "POST":
        query = request.form["query"]
        k = request.form["k"]
        engine = request.form["engine"]

    return render_template("search.html", query=query, k=k, engine=engine)