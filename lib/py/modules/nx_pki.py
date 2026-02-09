from typing import Optional, Dict, Any, Union
from cryptography import (
        x509
)

from cryptography.hazmat.primitives import (
        serialization, hashes
)

from cryptography.x509 import (
    Certificate,
    ocsp
)

from cryptography.hazmat.primitives.asymmetric import (
        ec, rsa
)

from cryptography.x509.oid import (
        NameOID, ExtensionOID,
        ObjectIdentifier, ExtendedKeyUsageOID
)

from datetime import (
        datetime, timedelta, timezone
)

from cryptography.x509.ocsp import (
        OCSPRequest, OCSPResponse
)

import ipaddress

class NxPKIBase:
    """
    Base PKI grammar engine.
    Algorithm‑agnostic.
    Provides typed vocabularies for:
      - subject
      - issuer
      - key usage
      - extended key usage
      - basic constraints
      - CSR options
    """

    # -------------------------
    #  SUBJECT / ISSUER GRAMMAR
    # -------------------------

    @staticmethod
    def subject(
        common_name: str,
        country_name: str = "CA",
        state_or_province_name: str = "Ontario",
        locality_name: str = "Ottawa",
        organization_name: str = "Posix-Nexus",
        emailAddress: Optional[str] = 'zero@empty.set',
    ) -> Dict[str, Any]:
        return {
            "common_name": common_name,
            "country_name": country_name,
            "state_or_province_name": state_or_province_name,
            "locality_name": locality_name,
            "organization_name": organization_name,
            "emailAddress": emailAddress,
        }

    issuer = subject  # same grammar, different semantic role

    # -------------------------
    #  KEY USAGE GRAMMAR
    # -------------------------

    @staticmethod
    def key_usage(
        *,
        critical: bool = True,
        digital_signature: bool = True,
        key_encipherment: bool = False,
        key_agreement: bool = False,
        content_commitment: bool = False,
        data_encipherment: bool = False,
        key_cert_sign: bool = False,
        crl_sign: bool = False,
        encipher_only: bool = False,
        decipher_only: bool = False,
    ) -> Dict[str, Any]:
        return {
            "critical": critical,
            "digital_signature": digital_signature,
            "key_encipherment": key_encipherment,
            "key_agreement": key_agreement,
            "content_commitment": content_commitment,
            "data_encipherment": data_encipherment,
            "key_cert_sign": key_cert_sign,
            "crl_sign": crl_sign,
            "encipher_only": encipher_only,
            "decipher_only": decipher_only,
        }

    # -------------------------
    #  EXTENDED KEY USAGE
    # -------------------------

    @staticmethod
    def extended_key_usage(
        *,
        critical: bool = False,
        server_auth: bool = True,
        client_auth: bool = False,
        code_signing: bool = False,
        email_protection: bool = False,
        time_stamping: bool = False,
        ocsp_signing: bool = False,
    ) -> Dict[str, Any]:
        return {
            "critical": critical,
            "server_auth": server_auth,
            "client_auth": client_auth,
            "code_signing": code_signing,
            "email_protection": email_protection,
            "time_stamping": time_stamping,
            "ocsp_signing": ocsp_signing,
        }

    # -------------------------
    #  BASIC CONSTRAINTS
    # -------------------------

    @staticmethod
    def basic_constraints(
        *,
        critical: bool = True,
        ca: bool = False,
        path_length: Optional[int] = None,
    ) -> Dict[str, Any]:
        return {
            "critical": critical,
            "ca": ca,
            "path_length": path_length,
        }

    # -------------------------
    #  CSR OPTIONS
    # -------------------------

    @staticmethod
    def csr_options(
        *,
        hash_algorithm: str = "sha256",
        csr_type: str = "pkcs10",
        csr_value: Optional[str] = None,
    ) -> Dict[str, Any]:
        return {
            "hash_algorithm": hash_algorithm,
            "csr_type": csr_type,
            "csr_value": csr_value,
        }

    # -------------------------
    #  INITIALIZER
    # -------------------------

    def __init__(
        self,
        common_name: str,
        *,
        subject: Optional[Dict[str, Any]] = None,
        issuer: Optional[Dict[str, Any]] = None,
        key_usage: Optional[Dict[str, Any]] = None,
        extended_key_usage: Optional[Dict[str, Any]] = None,
        basic_constraints: Optional[Dict[str, Any]] = None,
        csr_options: Optional[Dict[str, Any]] = None,
    ):
        # Identity
        self.subject = subject or self.subject(common_name)
        self.issuer_info = issuer or self.issuer(common_name)

        # Extensions
        self.key_usage = key_usage or self.key_usage()
        self.extended_key_usage = extended_key_usage or self.extended_key_usage()
        self.basic_constraints = basic_constraints or self.basic_constraints()
        self.csr_options = csr_options or self.csr_options()

        # Placeholder for extension objects (SAN, policies, etc.)
        self.extensions = None

        # Unified profile dictionary
        self.profile: Dict[str, Any] = {
            "subject": self.subject,
            "issuer": self.issuer_info,
            "key_usage": self.key_usage,
            "extended_key_usage": self.extended_key_usage,
            "basic_constraints": self.basic_constraints,
            "csr_options": self.csr_options,
            "extensions": self.extensions,
        }


class NxPKISAN:
    dns: List[str]
    uri: List[str]
    email: List[str]
    rid: List[str]
    ip: List[ipaddress.IPv4Address | ipaddress.IPv6Address]

    def __init__(
        self,
        dns: Optional[List[str]] = None,
        uri: Optional[List[str]] = None,
        email: Optional[List[str]] = None,
        rid: Optional[List[str]] = None,
        ip: Optional[List[str]] = None,
    ):
        self.dns = dns or []
        self.uri = uri or []
        self.email = email or []
        self.rid = rid or []
        self.ip = [ipaddress.ip_address(x) for x in (ip or [])]


class NxPKIUserNotice:
    organization: Optional[str]
    number: Optional[int]
    explicit_text: Optional[NxPKIExplicitText]

    def __init__(
        self,
        organization: Optional[str] = None,
        number: Optional[int] = None,
        explicit_text: Optional[NxPKIExplicitText] = None,
    ):
        self.organization = organization
        self.number = number
        self.explicit_text = explicit_text


class NxPKICPS:
    uri: str

    def __init__(self, uri: str):
        self.uri = uri


class NxPKIPolicy:
    policy_identifier: str
    cps_uris: List[NxPKICPS]
    user_notices: List[NxPKIUserNotice]

    def __init__(
        self,
        policy_identifier: str,
        cps_uris: Optional[List[NxPKICPS]] = None,
        user_notices: Optional[List[NxPKIUserNotice]] = None,
    ):
        self.policy_identifier = policy_identifier
        self.cps_uris = cps_uris or []
        self.user_notices = user_notices or []


class NxPKISigner:
    """
    Signs a CertificateBuilder using the appropriate algorithm.
    Currently supports ECDSA; RSA can be added later.
    """

    def sign(
        self,
        builder: x509.CertificateBuilder,
        private_key: Union[ec.EllipticCurvePrivateKey, rsa.RSAPrivateKey],
        hash_algorithm: hashes.HashAlgorithm = hashes.SHA256(),
    ) -> x509.Certificate:
        """
        Sign the certificate builder with the provided private key.
        Returns a cryptography.x509.Certificate object.
        """

        return builder.sign(
            private_key=private_key,
            algorithm=hash_algorithm,
        )


class NxPKIOCSPEmitter:
    """
    Converts an NxPKIOCSP model into an OCSP request or response builder.
    """

    def emit_request(self, model: NxPKIOCSP):
        builder = ocsp.OCSPRequestBuilder()

        builder = builder.add_certificate(
            cert=model.certificate,
            issuer=model.issuer_certificate,
            algorithm=model.hash_algorithm,
        )

        return builder.build()

    def emit_response(self, model: NxPKIOCSP, responder_cert, responder_key):
        builder = ocsp.OCSPResponseBuilder()

        # Map cert_status string → cryptography enum
        if model.cert_status == "good":
            status = ocsp.OCSPCertStatus.GOOD
        elif model.cert_status == "revoked":
            status = ocsp.OCSPCertStatus.REVOKED
        else:
            status = ocsp.OCSPCertStatus.UNKNOWN

        builder = builder.add_response(
            cert=model.certificate,
            issuer=model.issuer_certificate,
            algorithm=model.hash_algorithm,
            cert_status=status,
            this_update=datetime.now(timezone.utc),
            next_update=datetime.now(timezone.utc) + timedelta(days=1),
            revocation_time=model.revocation_time,
            revocation_reason=model.revocation_reason,
        )

        builder = builder.responder_id(
            ocsp.OCSPResponderEncoding.HASH,
            responder_cert
        )

        return builder.sign(
            private_key=responder_key,
            algorithm=hashes.SHA256(),
        )

class NxPKIExtensions:
    san: NxPKISAN
    policies: List[NxPKIPolicy]
    explicit_text: Optional[NxPKIExplicitText]

    def __init__(
        self,
        san: Optional[NxPKISAN] = None,
        policies: Optional[List[NxPKIPolicy]] = None,
        explicit_text: Optional[NxPKIExplicitText] = None,
    ):
        self.san = san or NxPKISAN()
        self.policies = policies or []
        self.explicit_text = explicit_text


class NxPKIECDSA(NxPKIBase):
    """
    ECDSA specialization of the PKI grammar.
    Adds curve, signature algorithm, and ECDSA‑specific defaults.
    """

    def __init__(
        self,
        common_name: str,
        *,
        curve: str = "prime256v1",
        extensions: Optional["NxPKIExtensions"] = None,
        **kwds
    ):
        super().__init__(common_name, **kwds)

        # Algorithm metadata
        self.curve: str = curve
        self.algorithm: str = "ecdsa-with-SHA256"

        # Attach extension vocabulary
        self.extensions: NxPKIExtensions = extensions or NxPKIExtensions()

        # Update profile
        self.profile.update({
            "algorithm": self.algorithm,
            "curve": self.curve,
            "extensions": self.extensions,
        })


class NxPKIOCSP:
    """
    Typed OCSP grammar container.
    Represents the data needed to build an OCSP request or response.
    """

class NxPKIOCSP:
    def __init__(
        self,
        certificate,
        issuer_certificate,
        serial_number,
        issuer_name_hash,
        issuer_key_hash,
        hash_algorithm,
        cert_status,
        revocation_time=None,
        revocation_reason=None,
    ):
        self.certificate = certificate
        self.issuer_certificate = issuer_certificate
        self.serial_number = serial_number
        self.issuer_name_hash = issuer_name_hash
        self.issuer_key_hash = issuer_key_hash
        self.hash_algorithm = hash_algorithm
        self.cert_status = cert_status
        self.revocation_time = revocation_time
        self.revocation_reason = revocation_reason

    @classmethod
    def from_request(
        cls,
        req,
        certificate,
        issuer_certificate,
        status,
        rev_time,
        rev_reason
    ):
        return cls(
            certificate=certificate,
            issuer_certificate=issuer_certificate,
            serial_number=req.serial_number,
            issuer_name_hash=req.issuer_name_hash,
            issuer_key_hash=req.issuer_key_hash,
            hash_algorithm=req.hash_algorithm,
            cert_status=status,
            revocation_time=rev_time,
            revocation_reason=rev_reason,
        )


class NxPKICertificateBuilder:
    """
    Consumes an NxPKIECDSA profile and produces a structured
    certificate model ready for emission by a backend.
    """

    def __init__(self, profile: NxPKIECDSA):
        self.profile = profile

    def build(self) -> Dict[str, Any]:
        """
        Produce a structured certificate model.
        This is NOT an X.509 certificate yet — just the typed model.
        """

        return {
            "subject": self.profile.subject,
            "issuer": self.profile.issuer_info,
            "algorithm": self.profile.algorithm,
            "curve": self.profile.curve,
            "key_usage": self.profile.key_usage,
            "extended_key_usage": self.profile.extended_key_usage,
            "basic_constraints": self.profile.basic_constraints,
            "csr_options": self.profile.csr_options,
            "extensions": {
                "san": {
                    "dns": self.profile.extensions.san.dns,
                    "ip": self.profile.extensions.san.ip,
                    "uri": self.profile.extensions.san.uri,
                    "email": self.profile.extensions.san.email,
                    "rid": self.profile.extensions.san.rid,
                },
                "policies": [
                    {
                        "policy_identifier": p.policy_identifier,
                        "cps_uris": [c.uri for c in p.cps_uris],
                        "user_notices": [
                            {
                                "organization": n.organization,
                                "number": n.number,
                                "explicit_text": (
                                    n.explicit_text.text if n.explicit_text else None
                                ),
                            }
                            for n in p.user_notices
                        ],
                    }
                    for p in self.profile.extensions.policies
                ],
                "explicit_text": (
                    self.profile.extensions.explicit_text.text
                    if self.profile.extensions.explicit_text
                    else None
                ),
            },
        }


class NxPKICertificateEmitter:
    """
    Converts an NxPKI certificate model into a cryptography.x509.CertificateBuilder.
    This class does NOT sign the certificate — it only constructs the builder.
    """

    def emit(self, model: Dict[str, Any]) -> x509.CertificateBuilder:
        # -------------------------
        # SUBJECT
        # -------------------------
        subject = x509.Name([
            x509.NameAttribute(NameOID.COUNTRY_NAME, model["subject"]["country_name"]),
            x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, model["subject"]["state_or_province_name"]),
            x509.NameAttribute(NameOID.LOCALITY_NAME, model["subject"]["locality_name"]),
            x509.NameAttribute(NameOID.ORGANIZATION_NAME, model["subject"]["organization_name"]),
            x509.NameAttribute(NameOID.COMMON_NAME, model["subject"]["common_name"]),
        ])

        # -------------------------
        # ISSUER
        # -------------------------
        issuer = x509.Name([
            x509.NameAttribute(NameOID.COUNTRY_NAME, model["issuer"]["country_name"]),
            x509.NameAttribute(NameOID.STATE_OR_PROVINCE_NAME, model["issuer"]["state_or_province_name"]),
            x509.NameAttribute(NameOID.LOCALITY_NAME, model["issuer"]["locality_name"]),
            x509.NameAttribute(NameOID.ORGANIZATION_NAME, model["issuer"]["organization_name"]),
            x509.NameAttribute(NameOID.COMMON_NAME, model["issuer"]["common_name"]),
        ])

        # -------------------------
        # BASE CERTIFICATE BUILDER
        # -------------------------
        builder = (
            x509.CertificateBuilder()
            .subject_name(subject)
            .issuer_name(issuer)
            .serial_number(x509.random_serial_number())
            .not_valid_before(datetime.now(timezone.utc))
            .not_valid_after(datetime.now(timezone.utc) + timedelta(days=18250))
        )

        # -------------------------
        # EXTENSIONS
        # -------------------------
        builder = self._apply_key_usage(builder, model["key_usage"])
        builder = self._apply_extended_key_usage(builder, model["extended_key_usage"])
        builder = self._apply_basic_constraints(builder, model["basic_constraints"])
        builder = self._apply_extensions(builder, model["extensions"])

        return builder

    # ============================================================
    # EXTENSION HELPERS
    # ============================================================

    def _apply_key_usage(self, builder, ku):
        return builder.add_extension(
            x509.KeyUsage(
                digital_signature=ku["digital_signature"],
                content_commitment=ku["content_commitment"],
                key_encipherment=ku["key_encipherment"],
                data_encipherment=ku["data_encipherment"],
                key_agreement=ku["key_agreement"],
                key_cert_sign=ku["key_cert_sign"],
                crl_sign=ku["crl_sign"],
                encipher_only=ku["encipher_only"],
                decipher_only=ku["decipher_only"],
            ),
            critical=ku["critical"]
        )

    def _apply_extended_key_usage(self, builder, eku):
        eku_list = []
        if eku["server_auth"]:
            eku_list.append(ExtendedKeyUsageOID.SERVER_AUTH)
        if eku["client_auth"]:
            eku_list.append(ExtensionOID.CLIENT_AUTH)
        if eku["code_signing"]:
            eku_list.append(ExtensionOID.CODE_SIGNING)
        if eku["email_protection"]:
            eku_list.append(ExtensionOID.EMAIL_PROTECTION)
        if eku["time_stamping"]:
            eku_list.append(ExtensionOID.TIME_STAMPING)
        if eku["ocsp_signing"]:
            eku_list.append(ExtensionOID.OCSP_SIGNING)

        if eku_list:
            builder = builder.add_extension(
                x509.ExtendedKeyUsage(eku_list),
                critical=eku["critical"]
            )
        return builder

    def _apply_basic_constraints(self, builder, bc):
        return builder.add_extension(
            x509.BasicConstraints(
                ca=bc["ca"],
                path_length=bc["path_length"]
            ),
            critical=bc["critical"]
        )

    def _apply_extensions(self, builder, ext):
        # -------------------------
        # SAN
        # -------------------------
        san = ext["san"]
        san_list = []

        for dns in san["dns"]:
            san_list.append(x509.DNSName(dns))
        for uri in san["uri"]:
            san_list.append(x509.UniformResourceIdentifier(uri))
        for ip in san["ip"]:
            san_list.append(x509.IPAddress(ip))
        for email in san["email"]:
            san_list.append(x509.RFC822Name(email))

        if san_list:
            builder = builder.add_extension(
                x509.SubjectAlternativeName(san_list),
                critical=False
            )

        # -------------------------
        # CERTIFICATE POLICIES
        # -------------------------
        policies = []
        for p in ext["policies"]:
            qualifiers = []

            # CPS URIs
            for cps in p["cps_uris"]:
                qualifiers.append(x509.PolicyInformation(
                    policy_identifier=ObjectIdentifier(p["policy_identifier"]),
                    policy_qualifiers=[x509.CPSURI(cps)]
                ))

            # User Notices
            for notice in p["user_notices"]:
                qualifiers.append(
                    x509.UserNotice(
                        notice_reference=None,
                        explicit_text=notice["explicit_text"]
                    )
                )

            policies.append(
                x509.PolicyInformation(
                    policy_identifier=ObjectIdentifier(p["policy_identifier"]),
                    policy_qualifiers=qualifiers
                )
            )

        if policies:
            builder = builder.add_extension(
                x509.CertificatePolicies(policies),
                critical=False
            )

        return builder

class NxPKISerializer:
    """
    Handles serialization of private keys and certificates to PEM files.
    """

    @staticmethod
    def save_private_key(
        private_key: Union[ec.EllipticCurvePrivateKey, rsa.RSAPrivateKey],
        path: str,
        password: bytes = None,
    ):
        if password:
            encryption = serialization.BestAvailableEncryption(password)
        else:
            encryption = serialization.NoEncryption()

        pem = private_key.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.TraditionalOpenSSL,
            encryption_algorithm=encryption,
        )

        with open(path, "wb") as f:
            f.write(pem)

    @staticmethod
    def save_certificate(
        certificate: Certificate,
        path: str,
    ):
        pem = certificate.public_bytes(
            encoding=serialization.Encoding.PEM
        )

        with open(path, "wb") as f:
            f.write(pem)

    @staticmethod
    def save_as(certificate, private_key, cert_path: Path, key_path: Path):
        NxPKISerializer.save_certificate(certificate, cert_path)
        NxPKISerializer.save_private_key(private_key, key_path)
        return cert_path, key_path

    @staticmethod
    def load_certificate(path: Path):
        with open(path, "rb") as f:
            return x509.load_pem_x509_certificate(f.read())

    @staticmethod
    def load_private_key(path: Path, password: bytes | None = None):
        with open(path, "rb") as f:
            return serialization.load_pem_private_key(f.read(), password=password)

    @staticmethod
    def load_cert_and_key(cert_path: Path, key_path: Path, password=None):
        cert = NxPKISerializer.load_certificate(cert_path)
        key  = NxPKISerializer.load_private_key(key_path, password)
        return cert, key

    @staticmethod
    def generate_self_signed(common_name: str):
        profile = NxPKIECDSA(common_name)
        model = NxPKICertificateBuilder(profile).build()
        emitter = NxPKICertificateEmitter()

        builder = emitter.emit(model)

        private_key = ec.generate_private_key(ec.SECP256R1())
        builder = builder.public_key(private_key.public_key())

        certificate = NxPKISigner().sign(builder, private_key)

        return certificate, private_key


class NxPKIOCSPEmitter:
    """
    Converts an NxPKIOCSP model into an OCSP request or response builder.
    """

    def emit_request(self, model: NxPKIOCSP):
        builder = ocsp.OCSPRequestBuilder()

        builder = builder.add_certificate(
            cert=model.certificate,
            issuer=model.issuer_certificate,
            algorithm=model.hash_algorithm,
        )

        return builder.build()

    def emit_response(self, model: NxPKIOCSP, responder_cert, responder_key):
        builder = ocsp.OCSPResponseBuilder()

        # Map cert_status string → cryptography enum
        if model.cert_status == "good":
            status = ocsp.OCSPCertStatus.GOOD
        elif model.cert_status == "revoked":
            status = ocsp.OCSPCertStatus.REVOKED
        else:
            status = ocsp.OCSPCertStatus.UNKNOWN

        builder = builder.add_response(
            cert=model.certificate,
            issuer=model.issuer_certificate,
            algorithm=model.hash_algorithm,
            cert_status=status,
            this_update=datetime.now(timezone.utc),
            next_update=datetime.now(timezone.utc) + timedelta(days=1),
            revocation_time=model.revocation_time,
            revocation_reason=model.revocation_reason,
        )

        builder = builder.responder_id(
            ocsp.OCSPResponderEncoding.HASH,
            responder_cert
        )

        return builder.sign(
            private_key=responder_key,
            algorithm=hashes.SHA256(),
        )


class NxPKIOCSPSerializer:
    """
    Handles serialization of OCSP requests and responses.
    """

    @staticmethod
    def save_request(request: OCSPRequest, path: str):
        data = request.public_bytes(serialization.Encoding.DER)
        with open(path, "wb") as f:
            f.write(data)

    @staticmethod
    def save_response(response: OCSPResponse, path: str):
        data = response.public_bytes(serialization.Encoding.DER)
        with open(path, "wb") as f:
            f.write(data)


class NxPKIOCSPService:
    @staticmethod
    def build_response_der(
        der_request: bytes,
        status: str,
        rev_time,
        rev_reason,
        certificate: x509.Certificate,
        issuer_certificate: x509.Certificate,
        responder_cert: x509.Certificate,
        responder_key,
    ) -> bytes:
        # Parse OCSPRequest
        req = ocsp.load_der_ocsp_request(der_request)

        # Build OCSP model
        model = NxPKIOCSP.from_request(
            req,
            certificate=certificate,
            issuer_certificate=issuer_certificate,
            status=status,
            rev_time=rev_time,
            rev_reason=rev_reason,
        )

        # Emit OCSPResponse
        emitter = NxPKIOCSPEmitter()
        response = emitter.emit_response(
            model,
            responder_cert,
            responder_key,
        )

        return response.public_bytes(serialization.Encoding.DER)

class NxPKIOCSPResolver:
    def __init__(self, env_root: Path):
        self.env_root = env_root

    def resolve_subject_and_issuer(self, cert_path: str):
        cert = resolver.load_certificate(self.env_root, cert_path)
        issuer = cert  # self-signed for now
        return cert, issuer

    def load_responder_credentials(self, cert_file: str, key_file: str):
        return NxPKISerializer.load_cert_and_key(
            self.env_root / cert_file,
            self.env_root / key_file
        )

