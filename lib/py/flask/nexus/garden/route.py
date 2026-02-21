from flask import render_template, current_app
from nexus.modules.nx_flask import NxFlaskBlueprint

garden_bp = NxFlaskBlueprint(__file__, '/garden')
@garden_bp.route('/')
def garden_index():
    print(">>> TEMPLATE SEARCH PATHS:", current_app.jinja_loader.searchpath)
    print(">>> REGISTERED BLUEPRINTS:", current_app.blueprints)
    return render_template('garden_index.html')

@garden_bp.route('/sandbox')
def sandbox_index():
    print(">>> TEMPLATE SEARCH PATHS:", current_app.jinja_loader.searchpath)
    print(">>> REGISTERED BLUEPRINTS:", current_app.blueprints)
    return render_template('garden_sandbox.html')

@garden_bp.route('/00')
def sandbox_00():
    return render_template('garden_00.html')

@garden_bp.route('/01')
def sandbox_01():
    return render_template('garden_01.html')

@garden_bp.route('/02')
def sandbox_02():
    return render_template('garden_02.html')
