import os
import ekglib
from pathlib import Path

ekglib.maturity_model_parser.mkdocs_gen_files2(
    model_root=Path('../ekg-mm').resolve(), 
    output_root=Path("./docs").resolve(),
    docs_root=Path(os.getcwd()) / "docs",
    fragments_root=Path(os.getcwd()) / "docs-fragments"
)
