from flask import render_template
from flask import Blueprint
from posix_nexus import nexus

@nexus.app.route("/")
def main():
    return render_template("main.html")

