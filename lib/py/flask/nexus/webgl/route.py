from flask import render_template, current_app
from nexus.modules.nx_flask import NxFlaskBlueprint

webgl_bp = NxFlaskBlueprint(__file__, '/webgl')

@webgl_bp.route('/')
def webgl_index():
    print(">>> TEMPLATE SEARCH PATHS:", current_app.jinja_loader.searchpath)
    print(">>> REGISTERED BLUEPRINTS:", current_app.blueprints)
    return render_template('webgl_index.html')

