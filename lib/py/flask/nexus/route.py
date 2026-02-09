from flask import render_template, current_app
from nexus.modules.nx_flask import NxFlaskBlueprint

main_bp = NxFlaskBlueprint(__file__)
@main_bp.route('/')
def main_index():
    print(">>> TEMPLATE SEARCH PATHS:", current_app.jinja_loader.searchpath)
    print(">>> REGISTERED BLUEPRINTS:", current_app.blueprints)
    return render_template('index.html')

