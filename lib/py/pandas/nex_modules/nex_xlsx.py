from rich.console import Console
from rich.table import Table
from pathlib import Path
import pandas as pd
import os
from typing import (
    Optional, Union, Sequence, List, Any, Dict, TypedDict, Literal, Iterable
)

class NxXlsx:

    @staticmethod
    def xlookup(*args, **kwds: Dict) -> pd.DataFrame:
        """
        Simulate Excel's XLOOKUP between two sheets in an Excel file.

        Parameters (can be passed as keywords or positionals):
        - file: str → path to the Excel workbook
        - name1: str → sheet name containing the lookup table
        - name2: str → sheet name containing the decoder table
        - on: str → column name to join on (default "Hex")
        - how: str → type of join (default "left")

        Returns:
        - pd.DataFrame → merged DataFrame preview (head)
        """
        # Copy positional args into a mutable stack
        stk = list(args)

        # Prefer keyword args, fall back to positional stack
        fn: Optional[str]  = kwds.get("file")  or (stk.pop(0) if stk else None)
        sn1: Optional[str] = kwds.get("name1") or (stk.pop(0) if stk else None)
        sn2: Optional[str] = kwds.get("name2") or (stk.pop(0) if stk else None)
        on: str            = kwds.get("on")    or (stk.pop(0) if stk else "Hex")
        how: str           = kwds.get("how")   or (stk.pop(0) if stk else "left")

        # Validate required inputs
        if not fn or not sn1 or not sn2:
            raise ValueError("Must provide file, name1, and name2")

        # Load both sheets in one call
        sheets = pd.read_excel(fn, sheet_name=[sn1, sn2])
        lookup, decoder = sheets[sn1], sheets[sn2]

        # Merge to simulate XLOOKUP
        merged = decoder.merge(lookup, on=on, how=how)
        return merged.head()

