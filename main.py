from flask import Flask, render_template, request
import os
import requests
import json

app = Flask(__name__)

@app.route("/",methods = ['GET'])
def index():
    return render_template("index.html")