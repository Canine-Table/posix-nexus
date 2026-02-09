from flask import request, Response
from cryptography.x509 import ocsp
from cryptography import x509
from cryptography.hazmat.primitives import serialization
from pathlib import Path
import os

from nexus.modules.nx_flask import NxFlaskBase, NxFlaskBlueprint
from nexus.modules.nx_pki import NxPKIOCSPService, NxPKISerializer, NxPKIOCSPResolver
from nexus.modules.nx_sqlalchemy import NxSQLSession, NxPKIOCSPStatus

# -------------------------------------------------------------------
# One-time responder cert/key load
# -------------------------------------------------------------------
env_root = Path(os.environ["NEXUS_ENV"])
resolver = NxPKIOCSPResolver(env_root)

RESPONDER_CERT, RESPONDER_KEY = resolver.load_responder_credentials(
    "python-flask-ocsp-cert.pem",
    "python-flask-ocsp-key.pem"
)


# -------------------------------------------------------------------
# Blueprint
# -------------------------------------------------------------------
ocsp_bp = NxFlaskBlueprint(__file__, "/ocsp")

# -------------------------------------------------------------------
# OCSP RESPONSE ENDPOINT
# -------------------------------------------------------------------
@ocsp_bp.post("")
def ocsp_responder():
    der = request.data

    try:
        req = ocsp.load_der_ocsp_request(der)
    except Exception:
        return Response("invalid OCSP request", status=400)

    # DB lookup
    serial_hex = format(req.serial_number, "x")
    session = NxSQLSession()
    status, rev_time, rev_reason = NxPKIOCSPStatus.lookup_ocsp_status(
        session,
        serial_hex,
    )

    # Load certificate + issuer (for now: same cert, self-signed)
    with open(env_root / "python-flask-cert.pem", "rb") as f:
        cert_being_checked = x509.load_pem_x509_certificate(f.read())

    issuer_cert = cert_being_checked  # self-signed; later: real issuer resolution

    # Delegate OCSPResponse construction to nx_pki
    response_der = NxPKIOCSPService.build_response_der(
        der_request=der,
        status=status,
        rev_time=rev_time,
        rev_reason=rev_reason,
        certificate=cert_being_checked,
        issuer_certificate=issuer_cert,
        responder_cert=RESPONDER_CERT,
        responder_key=RESPONDER_KEY,
    )

    return Response(
        response_der,
        status=200,
        mimetype="application/ocsp-response",
    )


