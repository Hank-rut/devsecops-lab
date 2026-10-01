from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()
Instrumentator().instrument(app).expose(app)   # метрики на /metrics

@app.get("/")
def root():
    return {"status": "ok"}
