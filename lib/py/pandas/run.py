from rich.console import Console
from rich.table import Table
from nex_modules.nex_xlsx import *
from nex_modules.nex_pandas import *
from nex_modules.nex_envfs import *
from pathlib import Path
import pandas as pd
import os

#df = pd.DataFrame({
#    "Region": ["North", "South"],
#    "Product": ["Widget", "Gadget"],
#    "Revenue": [100, 200]
#})

# Write to Excel
#df.to_excel("CST8118_7_303_Benjamin-Stroobach-Wilson_Lookup.xlsx", index=False)

console = Console()
table = Table(show_header=True, header_style="bold magenta")

#print(pd.ExcelFile(f2).sheet_names["Sheet1"])
#print(NxEnvFs.header(f2))
#print(NxEnvFs.csv2xlsx(f2))

print(pd.ExcelFile(f1).sheet_names)

#lookup = pd.DataFrame({
 #   "Hex": ["0041", "0042", "0043"],
 #   "Letter": ["A", "B", "C"]
#$})

# Example Unicode column
#df = pd.DataFrame({"Hex": ["0041", "0043"]})

# Merge to simulate XLOOKUP
#df = df.merge(lookup, on="Hex", how="left")
#print(df)


#pipeline = (
#    PivotPipeline()
#    .read_excel(file, sheet_name="Sheet1")
#    .pivot(index=["Region"], columns=["Product"], values=["Revenue"], aggfunc="sum")
#    .flatten_columns(sep="_")
#    .sort(by="Revenue_Widget", ascending=False)
#)


#df_result = pipeline.result()

#console.print(df_result.head())

