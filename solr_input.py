import os
import requests
import json
import time

def read_docs(path):
    listdocs = os.listdir(path)

    docs = list()
    for doc in listdocs:
        obj = dict()

        obj["title"] = doc
    
        with open(f"{path}/{doc}", "r") as f:
            content = f.read()
            obj["content"] = content
            f.close()
        
        docs.append(obj)

    return docs

start_time = time.time()

docs = read_docs("data")
res = requests.post('http://localhost:8983/solr/indexing/update/json/docs?f=/**&commit=true', headers={'Content-type' : 'application/json'}, data=json.dumps(docs))

end_time = time.time()
elapsed_time = end_time - start_time
print(f"Execution time: {elapsed_time} seconds")