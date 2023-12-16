import subprocess
import requests
import json
import os
import re

def read_docname_c(docList):
    with open("index_c/index-db/data.nme", "r") as f:
        data = f.readlines()
    f.close()

    listDocs = dict()
    for doc in data:
        res = doc.split("\t")
        listDocs[res[0]] = res[1]

    result = list()

    for doc in docList:
        dokumen = dict()
        berita = str()
        dokumen["title"] = listDocs[str(doc)]

        docname = listDocs[str(doc)].replace("\n", '')

        with open(f"data/{docname}") as f:
            berita = f.read()
        f.close()

        dokumen["content"] = berita

        result.append(dokumen)

    return result

def search_c(query, k):
    result = dict()

    # hasil = os.popen(f"./querydb {query} {k}").read()
    hasil, err = subprocess.Popen(["./querydb", f"{query}", f"{k}"], cwd="index_c", stdout=subprocess.PIPE, stderr=subprocess.PIPE).communicate()
    hasil = hasil.splitlines()

    for i, value in enumerate(hasil):
        hasil[i] = value.decode()

    q = max(len(query.split()), len(query.split(",")))

    try:
        total = 0

        for i in range(0, q):
            total += int(float(re.findall("\d+\.\d+",hasil[2+i])[0]))

        result["total"] = total
    except:
        result["total"] = 0

    try:
        result["time"] = int(float(re.findall("\d+\.\d+",hasil[4+q+k])[0]))
    except:
        result["time"] = 0

    docs = list()
    for doc in hasil[4+q:4+q+k]:
        no = int(float(re.findall("\d+",doc)[0]))
        if(int(float(re.findall("\d+",doc)[1])) != 0 and int(float(re.findall("\d+",doc)[2])) != 0):
            docs.append(no)

    result["docs"] = read_docname_c(docs)

    return result

def search_nutch(query, k):
    result = dict()

    query = re.split(r'\W+', query)

    url = f"http://127.0.0.1:8983/solr/indexing/select?indent=true&q.op=OR&rows={k}&q="

    for index, value in enumerate(query):
        if index == 0:
            url += f"content%3A{value}"
        else:
            url += f"OR%20content%3A{value}"

    hasil = json.loads(requests.get(url).text)

    result["time"] = hasil["responseHeader"]["QTime"]
    result["total"] = hasil["response"]["numFound"]
    result["docs"] = hasil["response"]["docs"]

    return result

def search_swish_e(query, k):
    pass