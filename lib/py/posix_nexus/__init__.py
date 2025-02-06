#!/usr/bin/python3
from flask_login import LoginManager
from flask_webpack import Webpack
from flask_bcrypt import Bcrypt
from flask_scss import Scss
from flask import Flask
import random

app = Flask(__name__)

bcrypt = Bcrypt(app)
@app.route('/')
def home():
    return

