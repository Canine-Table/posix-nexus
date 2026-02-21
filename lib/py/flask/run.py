from dotenv import load_dotenv
from nexus.modules.nx_path import NxPath
from nexus import app_factory

structure = NxPath(__name__, __file__)
app1 = app_factory()


# Start server
if __name__ == '__main__':
    load_dotenv()
    app1.start()

