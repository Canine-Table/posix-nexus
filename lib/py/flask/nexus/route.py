from nexus import app1
from flask import render_template

main = app1.blueprint("main", "/")

@main.route('/')
def index():
    return render_template('index.html')

