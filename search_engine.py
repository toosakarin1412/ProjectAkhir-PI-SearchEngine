import os
import subprocess
import requests
import re

os.chdir("index_c")

def read_docname_c(docList):
    with open("index-db/data.nme", "r") as f:
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
    hasil = os.popen(f"./querydb {query} {k}").read()
    hasil = hasil.splitlines()

    result["total"] = int(float(re.findall("\d+\.\d+",hasil[2])[0]))
    result["time"] = int(float(re.findall("\d+\.\d+",hasil[5+k])[0]))

    docs = list()
    for doc in hasil[5:5+k]:
        no = int(float(re.findall("\d+",doc)[0]))
        docs.append(no)

    result["docs"] = read_docname_c(docs)

    return result

def search_nutch(query, k):
    pass

def search_swish_e(query, k):
    pass