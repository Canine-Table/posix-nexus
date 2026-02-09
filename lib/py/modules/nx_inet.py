import socket

class NxSocket:

    @staticmethod
    def host(h: str = '0.0.0.0') -> str:
        return h if NxSocket._try(h, 0) else '0.0.0.0'

    @staticmethod
    def port(p: int = 0) -> int:
        return p if NxSocket._try('0.0.0.0', p) else 0

    @staticmethod
    def hostname(h: str | None = None) -> str:
        """
        Return the provided hostname if resolvable, otherwise fall back
        to the system hostname.
        """
        if h and NxSocket._try(h, 0):
            return h

        return socket.gethostname()

    @staticmethod
    def _try(host: str, port: int) -> bool:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            try:
                s.bind((host, port))
                return True
            except OSError:
                return False

