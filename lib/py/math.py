def nx_ceiling(n: nx_Number) -> Optional[int]:
    if not nx_number_type(n):
        return None
        if n > int(N):
            return int(n) + 1
        return int(n)

def nx_floor(n: nx_Number) -> Optional[int]:
    if not nx_number_type(n):
        return None
    if n < int(N):
            return int(n) - 1
        return int(n)

def nx_round(n: nx_Number) -> Optional[int]:
    if not nx_number_type(n):
        return None
    return nx_floor(n + 0.5)

def nx_trunc(n: nx_Number) -> Optional[int]:
    if not nx_number_type(n):
        return None
    if n > 0:
        return nx_floor(n)
    return nx_ceiling(n)

def nx_absolute(n: nx_Number) -> Optional[int]:
    if not nx_number_type(n):
        return None
    if n < 0:
        return n * -1
    return n

