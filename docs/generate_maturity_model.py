import os
import ekglib
from pathlib import Path

import option

config = ekglib.maturity_model_parser.Config(
    verbose=False,
    mkdocs=False,
    model_name="EKG/Maturity",
    model_root=Path("./ekg-mm").resolve(),
    output_root=Path("./docs").resolve(),
    docs_root=Path(os.getcwd()) / "docs",
    fragments_root=Path(os.getcwd()) / "docs-fragments",
    pillar_dir_name=option.Some("pillar")
)
ekglib.maturity_model_parser.run_with_config(config)
