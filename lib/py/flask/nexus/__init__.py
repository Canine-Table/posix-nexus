from .base import NxFlaskBase
app1 = NxFlaskBase(debug = True)
from .route import main
app1.register("main")

