from jinja2 import PackageLoader, ChoiceLoader, Environment, select_autoescape
from flask import Flask, Blueprint, url_for, flash, get_flashed_messages, redirect
from jinja2.ext import do, i18n, loopcontrols
import secrets
import socket
import os

class NxSocket:

    @staticmethod
    def host(h: str = '0.0.0.0') -> str:
        return h if NxSocket._try(h, 0) else '0.0.0.0'

    @staticmethod
    def port(p: int = 0) -> int:
        return p if NxSocket._try('0.0.0.0', p) else 0

    @staticmethod
    def _try(host: str, port: int) -> bool:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            try:
                s.bind((host, port))
                return True
            except OSError:
                return False

class NxJinjaBase(Environment):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.autoescape = select_autoescape(
            disabled_extensions=('txt','log','md',),
            default_for_string=True,
            default=True
        )

        self.add_extension(loopcontrols)
        self.add_extension(i18n)
        self.add_extension(do)

        self.globals['secrets'] = secrets
        self.globals['python_version'] = sys.version
        self.globals['python_version_info'] = sys.version_info
        self.globals['redirect'] = redirect
        self.globals['url_for'] = url_for
        self.globals['get_flashed_messages'] = get_flashed_messages
        self.globals['flash'] = flash
        self.globals['dir'] = dir

class NxFlaskBase:

    def __init__(self, **kwds):
        # Core app
        self.app = Flask(__name__)

        self.app.config["NEXUS_LIB"] = os.environ["NEXUS_LIB"]
        self.app.config["WTF_CSRF_TIME_LIMIT"] = kwds.get('csrf_limit', 1800)
        self.app.config["SECRET_KEY"] = kwds.get('secret', secrets.token_hex(32))
        self.app.config["WTF_CSRF_FIELD_NAME"] = kwds.get('csrf_name', 'flask_csrf_token')
        self.app.config["WTF_CSRF_SECRET_KEY"] = kwds.get('csrf_secret', secrets.token_bytes(32))

        # Config
        self.debug = kwds.get("debug", False)
        self.host = NxSocket.host(kwds.get("host", "0.0.0.0"))
        self.templates = kwds.get("templates", "templates")
        self.static = kwds.get("static", "static")



        # Auto-allocate port if not provided
        self.port = NxSocket.port(kwds.get("port", 0))

        # Blueprint system
        self.bp = {}
        self.pkgs = []
        self.url = lambda p: p + self.static

    # -------------------------
    # Blueprint Management
    # -------------------------

    def blueprint(self, name, url_prefix):
        bp = Blueprint(
            name,
            self.app.import_name,
            template_folder=self.templates,
            static_folder=self.static,
            static_url_path=self.url(url_prefix)
        )

        self.bp[name] = bp
        return bp

    def register(self, name):
        self.app.register_blueprint(self.bp[name])

    def load(self, name):
        self.pkgs.append(PackageLoader(name, self.templates))
        return self.pkgs

    # -------------------------
    # Start Server
    # -------------------------

    def start(self):
        if self.pkgs:
            self.app.jinja_env = NxJinjaBase(loader = ChoiceLoader(self.pkgs))
        self.app.run(
            debug = self.debug,
            host = self.host,
            port = self.port
        )
        return self.app

