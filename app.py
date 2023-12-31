from flask import Flask, render_template, request
import search_engine.search_engine as se
import urllib.parse

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
            result = se.search_c(query, int(k))
            pass
        elif engine == "nutch":
            result = se.search_nutch(query, int(k))
        elif engine == "swish_e":
            result = se.search_swish_e(query, int(k))
    return render_template("search.html", query=query, k=k, engine=engine, result=result)

@app.route("/open/<file>", methods = ["POST", "GET"])
def openfile(file):
    filename = urllib.parse.unquote(file).replace("\n", '')

    with open(f"data/{filename}", "r") as f:
        berita = f.read()
    f.close()

    return render_template("open.html", file=file, berita=berita)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')