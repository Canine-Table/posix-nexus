from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives.asymmetric import rsa
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.x509 import (
    Name,
    NameOID,
    NameAttribute,
    CertificateBuilder,
    random_serial_number,
)

import datetime
from M2Crypto import EVP, RSA, X509

def rsa_func():
    # Generate private key
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )

    # Create the subject and issuer names
    subject = issuer = Name([
        NameAttribute(NameOID.COUNTRY_NAME, "US"),
        NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, "California"),
        NameAttribute(NameOID.LOCALITY_NAME, "San Francisco"),
        NameAttribute(NameOID.ORGANIZATION_NAME, "My Company"),
        NameAttribute(NameOID.COMMON_NAME, "mycompany.com"),
    ])

    # Define certificate parameters
    valid_from = datetime.datetime.utcnow()
    valid_until = valid_from + datetime.timedelta(days=365)

    # Build the certificate
    certificate = (
        CertificateBuilder()
        .subject_name(subject)
        .issuer_name(issuer)
        .public_key(private_key.public_key())
        .serial_number(random_serial_number())
        .not_valid_before(valid_from)
        .not_valid_after(valid_until)
        .sign(private_key, hashes.SHA256(), default_backend())
    )

    # Save private key and certificate
    with open("private_key.pem", "wb") as f:
        f.write(private_key.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.TraditionalOpenSSL,
            encryption_algorithm=serialization.NoEncryption()
        ))

    with open("certificate.pem", "wb") as f:
        f.write(certificate.public_bytes(serialization.Encoding.PEM))

    print("Self-signed X.509 Version 1 certificate generated.")


from M2Crypto import RSA, X509

def create_x509_v1_cert():
    # Generate RSA key pair
    key = RSA.gen_key(2048, 65537)

    # Save the private key
    with open('private_key.pem', 'wb') as key_file:
        key_file.write(key.as_pem(cipher=None))  # Set cipher as None

    # Create a new X.509 certificate
    cert = X509.X509()
    cert.set_version(1)  # Set to Version 1
    cert.set_serial_number(1)

    # Set the validity period using ASN1_TIME
    not_before = X509.ASN1_UTCTIME(b"20231005000000Z")
    not_after = X509.ASN1_UTCTIME(b"20241005000000Z")

    cert.set_not_before(not_before)  # Not before
    cert.set_not_after(not_after)     # Not after

    # Set the subject and issuer names
    subject = cert.get_subject()
    subject.C = "US"
    subject.ST = "California"
    subject.L = "San Francisco"
    subject.O = "My Company"
    subject.CN = "mycompany.com"

    # Set the public key
    cert.set_pubkey(key)

    # Sign the certificate
    cert.sign(key, 'sha256')

    # Save the certificate
    with open("certificate.pem", "wb") as cert_file:
        cert_file.write(cert.as_pem())  # Save the certificate in PEM format

    print("Self-signed X.509 Version 1 certificate generated.")

create_x509_v1_cert()

