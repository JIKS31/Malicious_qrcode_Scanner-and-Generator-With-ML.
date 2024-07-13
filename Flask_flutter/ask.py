from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<h1>Hello, World!</h1>"
    return "<p1>quite a superise right???</p1>"
    return "<p2>well,i like u</p1>"
