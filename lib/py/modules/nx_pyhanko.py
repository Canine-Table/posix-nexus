from typing import Optional, Any, Dict, List
from pathlib import Path
from io import BytesIO

# pyhanko imports
from pyhanko.sign import signers, timestamps
from pyhanko.sign import sign_pdf as pyhanko_sign_pdf
from pyhanko.sign.validation import validate_pdf_signature
from pyhanko.pdf_utils.incremental_writer import IncrementalPdfFileWriter
from pyhanko.sign.general import PdfSignatureMetadata
from pyhanko_certvalidator import ValidationContext

class NxPyhanko:
    """
    Layered helper for signing and verifying PDFs with pyhanko.
    Usage:
      nx = NxPyhanko()
      signer = nx.load_signer_from_p12(Path("mycert.p12"), "pwd")
      signed_bytes = nx.sign_pdf_bytes(orig_bytes, signer, field_name="Sig1")
      result = nx.verify_pdf_bytes(signed_bytes)
    """

    # ---------------------------
    # Signer loaders
    # ---------------------------
    def load_signer_from_p12(self, p12_path: Path, password: Optional[str] = None) -> signers.SimpleSigner:
        if not p12_path or not p12_path.exists():
            raise FileNotFoundError(f"PKCS#12 file not found: {p12_path}")
        p12_bytes = p12_path.read_bytes()
        pwd = password.encode() if password is not None else None
        return signers.SimpleSigner.load_pkcs12(p12_bytes, pwd)

    def load_signer_from_pkcs11(self,
                                lib_path: str,
                                slot: Optional[int],
                                pin: str,
                                key_label: Optional[str] = None
                            ) -> signers.PKCS11Signer:
        """
        Load a PKCS#11 signer. Requires 'pyhanko[pkcs11]' extras and a working PKCS#11 library.
        lib_path: path to the PKCS#11 library (.so/.dll)
        slot: slot index or None to use first
        pin: token PIN
        key_label: label of key on token (optional)
        """
        from pyhanko.sign import pkcs11
        pkcs11_ctx = pkcs11.PKCS11Backend(lib_path)
        token = pkcs11_ctx.get_token(slot=slot)
        return pkcs11.PKCS11Signer(token, pin=pin, key_label=key_label)

    # ---------------------------
    # Signing
    # ---------------------------
    def sign_pdf_bytes(
        self,
        pdf_bytes: bytes,
        signer: signers.BaseSigner,
        field_name: str = "Signature1",
        reason: Optional[str] = None,
        location: Optional[str] = None,
        md_algorithm: str = "sha256",
        timestamp_url: Optional[str] = None,
    ) -> bytes:
        """
        Sign PDF bytes and return signed PDF bytes.
        If timestamp_url is provided, adds an RFC3161 timestamp.
        """
        # writer (incremental) supports signing in-place
        w = IncrementalPdfFileWriter(BytesIO(pdf_bytes))
        meta = PdfSignatureMetadata(field_name=field_name, reason=reason, location=location)
        ts_client = None
        if timestamp_url:
            ts_client = timestamps.HTTPTimeStamper(timestamp_url, insecure=False)

        out = pyhanko_sign_pdf.sign_pdf(
            w,
            signature_meta=meta,
            signer=signer,
            timestamper=ts_client,
            md_algorithm=md_algorithm,
            append_mode=True,
        )
        # out is an io.BytesIO
        return out.getvalue()

    def sign_pdf_path(
        self,
        src_path: Path,
        dst_path: Path,
        signer: signers.BaseSigner,
        field_name: str = "Signature1",
        reason: Optional[str] = None,
        location: Optional[str] = None,
        md_algorithm: str = "sha256",
        timestamp_url: Optional[str] = None,
    ) -> Path:
        pdf_bytes = src_path.read_bytes()
        signed = self.sign_pdf_bytes(pdf_bytes, signer, field_name, reason, location, md_algorithm, timestamp_url)
        dst_path.write_bytes(signed)
        return dst_path

    # ---------------------------
    # Verification
    # ---------------------------
    def verify_pdf_bytes(self, pdf_bytes: bytes, trust_roots: Optional[List[bytes]] = None) -> Dict[str, Any]:
        """
        Validate signatures in PDF bytes.
        trust_roots: optional list of DER/PEM bytes for trust anchors.
        Returns a JSON-serializable dict summarizing results.
        """
        stream = BytesIO(pdf_bytes)
        # If caller provided trust anchors, create ValidationContext with them
        vctx = ValidationContext(trust_roots=trust_roots) if trust_roots else ValidationContext()
        verify_res = validate_pdf_signature(stream, validation_context=vctx)

        # Build simplified serializable structure
        res: Dict[str, Any] = {
            "modification_level": str(verify_res.modification_level),
            "signatures_count": len(verify_res.signatures),
            "signatures": []
        }

        for sig in verify_res.signatures:
            # Each sig has attributes exposing status
            sig_info = {
                "field_name": getattr(sig, "field_name", None),
                "signer_name": getattr(sig, "signer_name", None),
                "md_algorithm": getattr(sig, "md_algorithm", None),
                "modified": sig.status.modified,
                "trusted": sig.status.trusted,
                "revoked": getattr(sig.status, "revoked", None),
                "detail": repr(sig.status)
            }
            res["signatures"].append(sig_info)
        return res

    def verify_pdf_path(self, path: Path, trust_roots: Optional[List[bytes]] = None) -> Dict[str, Any]:
        return self.verify_pdf_bytes(path.read_bytes(), trust_roots=trust_roots)


