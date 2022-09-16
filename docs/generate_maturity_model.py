import option as option
import os
import ekglib
from pathlib import Path

config = ekglib.maturity_model_parser.Config(
    verbose=False,
    mkdocs=False,
    model_name="EKG/Maturity",
    model_root=Path('../ekg-maturity').resolve(),
    output_root=Path("./docs").resolve(),
    docs_root=Path(os.getcwd()) / "docs",
    fragments_root=Path(os.getcwd()) / "docs-fragments",
    pillar_dir_name=option.NONE
)
ekglib.maturity_model_parser.run_with_config(config)
