from flask import Flask, render_template, request
import search_engine
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
    result = dict()

    if request.method == "POST":
        query = request.form["query"].lower()
        k = request.form["k"]
        engine = request.form["engine"]

        if engine == "index_c":
            result = search_engine.search_c(query, int(k))
        elif engine == "nutch":
            result["docs"] = []
            result["total"] = len(result["docs"])
            result["time"] = 0.0001
        elif engine == "swish_e":
            result["docs"] = []
            result["total"] = len(result["docs"])
            result["time"] = 0.0001



    return render_template("search.html", query=query, k=k, engine=engine, result=result)