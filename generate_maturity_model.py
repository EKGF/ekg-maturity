import os
import ekg_lib
from pathlib import Path

import option

config = ekg_lib.maturity_model_parser.Config(
    verbose=False,
    mkdocs=False,
    model_name="EKG Maturity",
    model_root=Path("./metadata").resolve(),
    output_root=Path("./docs").resolve(),
    docs_root=Path(os.getcwd()) / "docs",
    fragments_root=Path(os.getcwd()) / "docs-fragments",
    pillar_dir_name=option.Some("pillar")
)
ekg_lib.maturity_model_parser.run_with_config(config)
