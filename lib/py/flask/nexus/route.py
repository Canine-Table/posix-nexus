from nexus import app1
from flask import render_template

main = app1.blueprint("main", "/")

@main.route('/')
def main():
    return render_template('index.html')

