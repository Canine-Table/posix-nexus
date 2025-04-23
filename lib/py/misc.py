#!/usr/bin/env python3
from typing import *

nx_Number = NewType("nx_Number", Union[int, float, complex])

def nx_primitive(arg: object) -> Optional[int]:
    if isinstance(arg, type(None)):
        return 0
    if isinstance(arg, float):
        return 1
    if isinstance(arg, int):
        return 2
    if isinstance(arg, complex):
        return 3
    if isinstance(arg, bool):
        return 4
    if isinstance(arg, str):
        return 5
    return None

def nx_complex(arg: object) -> Optional[int]:
    if isinstance(arg, list):
        return 6
    if isinstance(arg, tuple):
        return 7
    if isinstance(arg, dict):
        return 8
    if isinstance(arg, set):
        return 9
    if isinstance(arg, frozenset):
        return 10
    if isinstance(arg, bytes):
        return 11
    if isinstance(arg, bytearray):
        return 12
    return None

def nx_number_type(arg: nx_Number) -> Optional[int]:
    if (t := nx_primitive(arg)) not in (1, 2, 3):
        return None
    if arg > 0:
        n = 5
    elif arg < 0:
        n = 7
    else:
        n = 11
    return n * t

