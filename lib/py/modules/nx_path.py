from pathlib import Path
import os

class NxPath:

    _modules = None   # class-level storage

    def __init__(
            self,
            name,
            project
    ) -> None:

        root = Path(os.path.dirname(project))
        print(root)
        if NxPath._modules is None:
            if not (name == '__main__' and root):
                raise ValueError("__name__ must be '__main__' and __file__ must exist")
            NxPath._modules = NxPath._scan_modules(root)

        self.root = NxPath.resolve(root)

    # -------------------------
    # CLASSMETHOD: resolve
    # -------------------------
    @classmethod
    def resolve(cls, root: Path):
        rel = root.relative_to(cls._modules["root"])
        parts = rel.parts
        parent = cls._modules["tree"]
        node = None
        for p in parts:
            node = parent[p]
            parent = node["leaf"]
        return node

    # -------------------------
    # CLASSMETHOD: expand
    # -------------------------
    @classmethod
    def expand(cls, dotted: str):
        parts = dotted.split('.')
        parent = cls._modules["tree"]
        node = None
        for p in parts:
            node = parent[p]
            parent = node[p]["leaf"]
        return node

    @classmethod
    def _scan_modules(cls, root: Path):

        tree = {}
        print(root)
        modules = { "root": root, "tree": tree }
        for d in [ f for f in root.rglob("__init__.py") if 'site-packages' not in f.parts ]:
            rel = d.relative_to(root).parent
            parts = rel.parts

            parent = tree
            module_path = None

            for p in parts:
                module_path = f"{module_path}.{p}" if module_path else p
                if p not in parent:
                    parent[p] = {
                        'path': module_path,
                        'leaf': {},
                        'stem': parent,
                        'twig': {}
                    }
                parent = parent[p]["leaf"]

        return modules

