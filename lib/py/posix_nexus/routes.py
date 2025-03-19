from flask import render_template
from flask import Blueprint
from posix_nexus import nexus

@nexus.app.route("/", methods=['GET','POST'])
def posix_nexus():
    return render_template("index_nex.html")


