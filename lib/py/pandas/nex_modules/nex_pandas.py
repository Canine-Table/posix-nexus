from rich.console import Console
from rich.table import Table
from pathlib import Path
import pandas as pd
import os
from typing import (
    Optional, Union, Sequence, List, Any, Dict, TypedDict, Literal, Iterable
)

console = Console()
table = Table(show_header=True, header_style="bold magenta")
IndexLike = Union[str, Sequence[str], None]
AggFunc = Union[str, Sequence[str], Dict[str, Any]]
ExcelPath = Union[str, Path]

class PivotValueSpec(TypedDict, total=False):
    data: str
    function: str  # e.g., "sum", "average", "count"

class PivotOptions(TypedDict, total=False):
    index: Optional[Sequence[str]]
    columns: Optional[Sequence[str]]
    values: Optional[Sequence[str]]
    aggfunc: Union[str, Sequence[str], Dict[str, Any]]
    fill_value: Any
    dropna: bool

class PivotPipeline:
    """
    Fluent pipeline to load data, compute pivot-like summaries, and export results.
    """

    def __init__(self, df: Optional[pd.DataFrame] = None) -> None:
        self.df: pd.DataFrame = pd.DataFrame() if df is None else df.copy()
        self._pivot: Optional[pd.DataFrame] = None

    # --- loaders -----------------------------------------------------------
    def read_csv(self, path: ExcelPath, **kwargs: Any) -> "PivotPipeline":
        """Load CSV into pipeline."""
        self.df = pd.read_csv(path, **kwargs)
        return self

    def read_excel(self, path: ExcelPath, sheet_name: Union[int, str] = 0, **kwargs: Any) -> "PivotPipeline":
        """Load Excel sheet into pipeline."""
        path_obj = Path(path)
        if not path_obj.exists():
            # create an empty DataFrame and write it out
            empty_df = pd.DataFrame()
            with pd.ExcelWriter(path_obj, engine="xlsxwriter") as writer:
                empty_df.to_excel(writer, sheet_name="Sheet1", index=False)
        self.df = pd.read_excel(path_obj, sheet_name=sheet_name, **kwargs)
        return self

    def from_dataframe(self, df: pd.DataFrame) -> "PivotPipeline":
        """Use an existing DataFrame."""
        self.df = df.copy()
        return self

    # --- transforms --------------------------------------------------------
    def cast_categories(self, cols: Sequence[str]) -> "PivotPipeline":
        for c in cols:
            self.df[c] = self.df[c].astype("category")
        return self

    def filter(self, expr_or_mask: Union[str, pd.Series]) -> "PivotPipeline":
        if isinstance(expr_or_mask, str):
            self.df = self.df.query(expr_or_mask)
        else:
            # assume boolean mask Series aligned to df
            self.df = self.df[expr_or_mask]
        return self

    def rename(self, **cols: str) -> "PivotPipeline":
        self.df = self.df.rename(columns=cols)
        return self

    # --- pivot builders ---------------------------------------------------
    def pivot(self,
              *,
              index: Optional[Sequence[str]],
              columns: Optional[Sequence[str]] = None,
              values: Optional[Sequence[str]] = None,
              aggfunc: AggFunc = "sum",
              fill_value: Any = None,
              dropna: bool = True) -> "PivotPipeline":
        """
        Compute pivot table. All pivot-related args are keyword-only to avoid positional mistakes.
        """
        # mypy-friendly call: pass typed args directly
        self._pivot = pd.pivot_table(
            self.df,
            values=list(values) if values is not None else None,
            index=list(index) if index is not None else None,
            columns=list(columns) if columns is not None else None,
            aggfunc=aggfunc,
            fill_value=fill_value,
            dropna=dropna
        )
        return self

    def crosstab(self,
                 rows: str,
                 cols: str,
                 values: Optional[str] = None,
                 aggfunc: str = "sum",
                 normalize: bool = False) -> "PivotPipeline":
        result = pd.crosstab(
            self.df[rows],
            self.df[cols],
            values=self.df.get(values) if values is not None else None,
            aggfunc=aggfunc,
            normalize=normalize
        )
        self._pivot = result
        return self

    # --- post-process -----------------------------------------------------
    def flatten_columns(self, sep: str = "_") -> "PivotPipeline":
        if self._pivot is None:
            return self
        if isinstance(self._pivot.columns, pd.MultiIndex):
            self._pivot.columns = [sep.join(map(str, col)).strip() for col in self._pivot.columns.values]
        return self

    def reset_index(self) -> "PivotPipeline":
        if self._pivot is not None:
            self._pivot = self._pivot.reset_index()
        return self

    def sort(self, by: Union[str, Sequence[str]], ascending: bool = False) -> "PivotPipeline":
        if self._pivot is not None:
            self._pivot = self._pivot.sort_values(by=by, ascending=ascending)
        return self

    # --- exporters --------------------------------------------------------
    def to_latex(self,
                 path: ExcelPath,
                 index: bool = False,
                 caption: Optional[str] = None,
                 label: Optional[str] = None,
                 float_format: str = "%.2f") -> "PivotPipeline":
        path_obj = Path(path)
        if self._pivot is None:
            raise ValueError("No pivot computed; call .pivot(...) first.")
        tex = self._pivot.to_latex(index=index, caption=caption, label=label, float_format=float_format)
        path_obj.write_text(tex)
        return self

    def to_csv(self, path: ExcelPath, index: bool = False) -> "PivotPipeline":
        path_obj = Path(path)
        if self._pivot is None:
            raise ValueError("No pivot computed; call .pivot(...) first.")
        self._pivot.to_csv(path_obj, index=index)
        return self

    def to_xlsx_with_pivot(self,
                           path: ExcelPath,
                           *,
                           data_sheet: str = "Data",
                           pivot_sheet: str = "Pivot",
                           options: Optional[PivotOptions] = None) -> "PivotPipeline":
        """
        Write raw data and a native Excel pivot table using XlsxWriter.
        `options` is a TypedDict describing index/columns/values/aggfunc.
        """
        if options is None:
            raise ValueError("options must be provided for Excel pivot creation.")
        path_obj = Path(path)

        with pd.ExcelWriter(path_obj, engine="xlsxwriter") as writer:
            self.df.to_excel(writer, sheet_name=data_sheet, index=False)
            workbook = writer.book
            # create pivot sheet
            workbook.add_worksheet(pivot_sheet)

            nrows, ncols = self.df.shape
            last_row = nrows + 1

            def excel_col(col_idx: int) -> str:
                # 0-based index to Excel column letters
                result = ""
                col_idx += 1
                while col_idx:
                    col_idx, rem = divmod(col_idx - 1, 26)
                    result = chr(65 + rem) + result
                return result

            last_col_letter = excel_col(ncols - 1)
            data_range = f"'{data_sheet}'!$A$1:${last_col_letter}${last_row}"

            idx = options.get("index")
            cols = options.get("columns")
            vals = options.get("values")
            agg = options.get("aggfunc", "sum")

            rows_spec: List[Dict[str, str]] = [{"data": c} for c in (list(idx) if idx else [])]
            cols_spec: List[Dict[str, str]] = [{"data": c} for c in (list(cols) if cols else [])]
            vals_spec: List[PivotValueSpec] = [{"data": v, "function": str(agg)} for v in (list(vals) if vals else [])]

            try:
                workbook.add_pivot_table({
                    "data": data_range,
                    "destination": f"'{pivot_sheet}'!A3",
                    "rows": rows_spec,
                    "columns": cols_spec,
                    "values": vals_spec
                })
            except AttributeError:
                ws = writer.sheets[pivot_sheet]
                ws.add_pivot_table({
                    "data": data_range,
                    "destination": "A3",
                    "rows": rows_spec,
                    "columns": cols_spec,
                    "values": vals_spec
                })
        return self

    # --- info -----------------------------------------------------------

    # --- access -----------------------------------------------------------
    def result(self) -> Optional[pd.DataFrame]:
        return None if self._pivot is None else self._pivot.copy()

