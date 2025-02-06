#!/usr/bin/env python3
from posix_nexus import app
import sys

def start_posix_nexus():
    if hasattr(sys, 'real_prefix') or (hasattr(sys, 'base_prefix') and sys.base_prefix != sys.prefix):
        app.run(port=5555, debug=True, load_dotenv=True)

if __name__ == '__main__':
    start_posix_nexus()

