from nexus import app1
from flask import render_template

"""
from flask import Blueprint, request, Response
from cryptography import x509
from cryptography.x509 import ocsp
from cryptography.hazmat.primitives import hashes, serialization
from datetime import datetime, timezone, timedelta
import os
"""

# ----------------------------------------
# Blueprint
# ----------------------------------------
#, methods=["POST"]

ocsp_bp = app1.blueprint("ocsp_bp", "/ocsp/")
@ocsp_bp.route("/ocsp")
def index_s():
    return render_template('index.html')


# ----------------------------------------
# OCSP Endpoint
# ----------------------------------------
"""
@ocsp_bp.route("/", methods=["POST"])
def ocsp_responder():
    req_bytes = request.get_data()

    # Parse OCSP request
    ocsp_req = ocsp.load_der_ocsp_request(req_bytes)

    # Build OCSP response
    builder = ocsp.OCSPResponseBuilder()

    builder = builder.add_response(
        cert=LEAF_CERT,
        issuer=ISSUER_CERT,
        algorithm=hashes.SHA1(),
        cert_status=ocsp.OCSPCertStatus.GOOD,
        this_update=datetime.now(timezone.utc),
        next_update=datetime.now(timezone.utc) + timedelta(days=1),
        revocation_time=None,
        revocation_reason=None,
    )

    builder = builder.responder_id(
        ocsp.OCSPResponderEncoding.HASH,
        ISSUER_CERT
    )

    response = builder.sign(
        private_key=ISSUER_KEY,
        algorithm=hashes.SHA256()
    )

    return Response(
        response.public_bytes(),
        mimetype="application/ocsp-response"
    )

# ----------------------------------------
# Export for Nexus loader
# ----------------------------------------

def get_blueprint():
    return ocsp_bp
"""
