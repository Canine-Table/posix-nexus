from typing import Optional, Any
from flask import Flask, Blueprint, Response
from .nx_path import NxPath
from .nx_inet import NxSocket
from pathlib import Path
from jinja2 import FileSystemLoader
from .nx_jinja2 import NxJinjaBase
import os

from .nx_pki import NxPKISerializer

class NxFlaskBase:
    app: Flask
    host: str
    port: int
    debug: bool

    def __init__(
        self,
        hostname: str,
        name: str = __name__,
        host: str = "0.0.0.0",
        port: int = 0,
        debug: bool = False,
    ) -> None:

        # Create Flask app
        self.app = Flask(name, static_folder=None)

        @self.app.after_request
        def add_ngrok_header(response):
            response.headers['ngrok-skip-browser-warning'] = 'true'
            response.headers['Cache-Control'] = 'no-store'
            #response.headers['Cross-Origin-Opener-Policy'] = 'same-origin'
            #response.headers['Cross-Origin-Embedder-Policy'] = 'require-corp'
            #response.headers['Cross-Origin-Resource-Policy'] = 'cross-origin'
            #response.headers['Access-Control-Allow-Origin'] = '*'
            #response.headers['Access-Control-Allow-Headers'] = '*'
            #response.headers['Access-Control-Allow-Methods'] = '*'
            #response.headers['Cross-Origin-Embedder-Policy'] = 'credentialless'
            #response.headers['Service-Worker-Allowed'] = '/'
            return response

        # Restore NxSocket resolution
        self.host = NxSocket.host(host)
        self.port = NxSocket.port(port)
        self.hostname = NxSocket.hostname(hostname);

        self.debug = debug

    # ---------------------------------------------------------
    # Register all blueprints discovered in NxPath registry
    # ---------------------------------------------------------
    def register_all(self) -> None:
        tree = NxPath._modules["tree"]

        def walk(node):
            twig = node.get("twig", {})
            bp = twig.get("blueprint")
            if bp is not None:
                self.app.register_blueprint(bp)

            for child in node["leaf"].values():
                walk(child)

        for top in tree.values():
            walk(top)

    def start(self) -> None:

        cert_path, key_path = NxPKISerializer.apply_ssl_context(
            "python-flask-cert.pem",
            "python-flask-key.pem",
            self.hostname
        )

        # ---------------------------------------------------------
        # Register routes, blueprints, etc.
        # ---------------------------------------------------------
        self.register_all()

        # ---------------------------------------------------------
        # Start Flask with generated TLS
        # ---------------------------------------------------------
        self.app.run(
            host=self.host,
            port=self.port,
            debug=self.debug,
            ssl_context=(str(cert_path), str(key_path)),
        )


class NxFlaskBlueprint:
    def __init__(
        self,
        file: str,
        url_prefix: str = None,
        static_url_prefix: str = None,
        templates_dirname: str = None,
        static_dirname: str = None,
    ) -> None:
        file_dir = Path(file).resolve().parent

        self.node = NxPath.resolve(file_dir)
        twig = self.node["twig"]

        twig["url_prefix"] = url_prefix or self._inherit("url_prefix", "/")
        twig["static_url_prefix"] = (
            static_url_prefix or self._inherit("static_url_prefix", "/static")
        )
        twig["templates_dirname"] = (
            templates_dirname or self._inherit("templates_dirname", "templates")
        )
        twig["static_dirname"] = (
            static_dirname or self._inherit("static_dirname", "static")
        )

        templates_path = file_dir / twig["templates_dirname"]
        static_path = file_dir / twig["static_dirname"]

        # NOTE: static_url_prefix is a URL, NOT a filesystem path
        static_url_path = twig["static_url_prefix"]

        twig["jinja"] = NxJinjaBase(
            loader=FileSystemLoader(str(templates_path)),
            autoescape=True,
            trim_blocks=True,
            lstrip_blocks=True,
        )

        twig["blueprint"] = Blueprint(
            name=self.node["path"].replace(".", "_"),
            import_name=__name__,
            template_folder=str(templates_path),
            static_folder=str(static_path),
            static_url_path=static_url_path,
            url_prefix=twig["url_prefix"],
        )

    # -----------------------------------------
    # inherit defaults through stem chain
    # -----------------------------------------
    def _inherit(self, key: str, default: Any):
        node = self.node
        while isinstance(node, dict) and "twig" in node:
            twig = node["twig"]
            if key in twig:
                return twig[key]
            node = node["stem"]
        return default

    def render(self, template_name: str, **context):
        env = self.node["twig"]["jinja"]
        template = env.get_template(template_name)
        return template.render(**context)

    @property
    def route(self):
        return self.node["twig"]["blueprint"].route

    @property
    def get(self):
        return self.node["twig"]["blueprint"].get

    @property
    def post(self):
        return self.node["twig"]["blueprint"].post

    @property
    def put(self):
        return self.node["twig"]["blueprint"].put

    @property
    def delete(self):
        return self.node["twig"]["blueprint"].delete

    @property
    def patch(self):
        return self.node["twig"]["blueprint"].patch

    @property
    def options(self):
        return self.node["twig"]["blueprint"].options

    @property
    def head(self):
        return self.node["twig"]["blueprint"].head

    @property
    def static_folder(self):
        return self.node["twig"]["blueprint"].static_folder

    @property
    def static_url_path(self):
        return self.node["twig"]["blueprint"].static_url_path

    @property
    def template_folder(self):
        return self.node["twig"]["blueprint"].template_folder

    @property
    def name(self):
        return self.node["twig"]["blueprint"].name

    @property
    def url_prefix(self):
        return self.node["twig"]["blueprint"].url_prefix

    @property
    def has_static_folder(self):
        return self.node["twig"]["blueprint"].has_static_folder

    def send_static_file(self, filename):
        return self.node["twig"]["blueprint"].send_static_file(filename)


