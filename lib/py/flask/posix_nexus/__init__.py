#!/usr/bin/env python3
from flask_sqlalchemy import SQLAlchemy
from jinja2 import Environment
from flask import Flask
import sys, os, socket
from typing import *

class TemplateEngine(Environment):
    __doc__ = """
        Jinja2 Template Engine.
    """

    def __init__(self, *args, **kwargs):
        self.loaders = []
        super().__init__(*args, **kwargs)

    def load_route(self, *args, **kwargs) -> None:
        pass

class Networking:

    def __init__(self, **kwargs) -> None:
        self.hostname = Networking.get_hostname(kwargs.get('hostname', 'localhost'))

    @staticmethod
    def get_hostname(hostname: str) -> str:
        try:
            if socket.gethostbyname(hostname):
                return hostname
        except socket.gaierror:
            return socket.gethostname()

    def assign_port(self, port: int) -> int:
        if not isinstance(port, int) or port < 1 or port > 65535:
            port: int = 1024
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            if s.connect_ex((self.hostname, port)) == 0:
                if port >= 65535:
                    raise RuntimeError("No available ports.")
                return self.assign_port(port + 1)
            else:
                return port

    def resolve_hostname(self) -> list[str | None]:
        try:
            return list(set([addr[4][0] for addr in socket.getaddrinfo(self.hostname, None)]))
        except socket.gaierror:
            return []


class PosixNexus(Networking):
    prop: dict[str: Any] = {
        'count': 0,
        'port_index': 1024,
        'ports': []
    }

    def __init__(self, **kwargs) ->  None:
        if hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
            super().__init__(**kwargs)
            self.debug = self.state(kwargs.get('debug', 'False'))
            self.dotenv = self.state(kwargs.get('dotenv', 'True'))
            self.port = self.assign_port(kwargs.get('port', PosixNexus.prop['port_index']))
            if self.port == PosixNexus.prop['port_index'] and self.port < 65535:
                    PosixNexus.prop['port_index'] += 1
            PosixNexus.prop['ports'].append(self.port)
            PosixNexus.prop['count'] += 1
            self.template_engine = TemplateEngine()
            self.create_app()

    def state(self, state: bool) -> bool:
        if not isinstance(state, bool):
            return False
        else:
            return state

    def create_app(self, **kwargs)-> object:
        self.app = Flask(__name__, instance_relative_config=True)
        self.template_engine = TemplateEngine()
        try:
            os.makedirs(self.app.instance_path)
        except OSError:
            pass
        return self

    def run_app(self) -> object:
        self.app.run(host =  '0.0.0.0', port = self.port, debug = self.debug, load_dotenv = self.dotenv)
        return self

nexus = PosixNexus(port = 5050, debug = True, dotenv = True)
from posix_nexus import routes

