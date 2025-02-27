from flask import render_template
from flask import Blueprint
from posix_nexus import nexus

@nexus.app.route("/")
def main():
    return render_template("index.html")

@nexus.app.route("/svg")
def main_svg():
    return render_template("index_svg.html")

