import os
import ekglib
from pathlib import Path

config = ekglib.maturity_model_parser.Config(
    verbose=False,
    mkdocs=False,
    model_name="EKG/MM",
    model_root=Path('../ekg-mm').resolve(),
    output_root=Path("./docs").resolve(),
    docs_root=Path(os.getcwd()) / "docs",
    fragments_root=Path(os.getcwd()) / "docs-fragments"    
)
ekglib.maturity_model_parser.run_with_config(config)
