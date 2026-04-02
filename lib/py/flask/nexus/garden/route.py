from flask import render_template, current_app
from nexus.modules.nx_flask import NxFlaskBlueprint

garden_bp = NxFlaskBlueprint(__file__, '/garden')
@garden_bp.route('/')
def garden_index():
    print(">>> TEMPLATE SEARCH PATHS:", current_app.jinja_loader.searchpath)
    print(">>> REGISTERED BLUEPRINTS:", current_app.blueprints)
    return render_template('garden_index.html')

