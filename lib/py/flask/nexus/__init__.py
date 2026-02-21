from .modules.nx_flask import NxFlaskBase

def app_factory():
    from .route import main_bp
    from .ocsp.route import ocsp_bp
    from .garden.route import garden_bp
    return NxFlaskBase(__name__, debug = True)


