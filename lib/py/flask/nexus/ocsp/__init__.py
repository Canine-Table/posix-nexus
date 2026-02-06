"""
from flask import Blueprint, request, Response
from cryptography import x509
from cryptography.x509 import ocsp
from cryptography.hazmat.primitives import hashes, serialization
from datetime import datetime, timezone, timedelta
import os
"""

#from nexus import app1
#from .route import ocsp_bp
#app1.register("ocsp_bp")


# ----------------------------------------
# Load Certificates (self-signed for test)
# ----------------------------------------
"""
BASE = os.environ.get("NEXUS_ENV", ".")

CERT_PATH = os.path.join(BASE, "python-flask-certificate.pem")
KEY_PATH  = os.path.join(BASE, "python-flask-private_key.pem")

with open(CERT_PATH, "rb") as f:
    LEAF_CERT = x509.load_pem_x509_certificate(f.read())

with open(KEY_PATH, "rb") as f:
    LEAF_KEY = serialization.load_pem_private_key(f.read(), password=None)

# For testing, issuer = leaf (self-signed)
ISSUER_CERT = LEAF_CERT
ISSUER_KEY  = LEAF_KEY
"""
