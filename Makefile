
VIRTUAL_ENV := ./.venv
LANG := en

ifeq ($(OS),Windows_NT)
	YOUR_OS := Windows
	INSTALL_TARGET := install-windows
	SYSTEM_PYTHON := python3
else
	YOUR_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
ifeq ($(YOUR_OS), Linux)
	INSTALL_TARGET := install-linux
	ifneq ($(wildcard /home/runner/.*),) # this means we're running in Github Actions
		SYSTEM_PYTHON := $(shell command -v python3 || echo python3)
	else
		SYSTEM_PYTHON := $(shell command -v python3 || echo python3)
	endif
endif
ifeq ($(YOUR_OS), Darwin)
	INSTALL_TARGET := install-macos
	SYSTEM_PYTHON := $(shell command -v python3 || echo python3)
endif
endif

#
# Since we do not have asdf for Windows, we need to install these tools
# on windows in a different way. Here we assume you did that yourself in
# the local project's virtualenv directory (./.venv).
#
VENV_PYTHON := $(VIRTUAL_ENV)/bin/python3
UV := uv
PYTHON_VERSION := 3.13

PIPENV_DEFAULT_PYTHON_VERSION := 3.13
PIPENV_VENV_IN_PROJECT := 1

CURRENT_BRANCH := $(shell git branch --show-current)
MKDOCS_CONFIG_FILE := mkdocs.yml

.PHONY: all
all: docs-build

.PHONY: info
info:
	@echo "Git Branch        : ${CURRENT_BRANCH}"
	@echo "Operating System  : ${YOUR_OS}"
	@echo "MkDocs            : $$($(UV) run mkdocs --version)"
	@echo "MkDocs config file: ${MKDOCS_CONFIG_FILE}"
	@echo "System Python     : ${SYSTEM_PYTHON} version: $$($(SYSTEM_PYTHON) --version)" 
	@echo "Virtual Env Python: ${VENV_PYTHON} version: $$($(VENV_PYTHON) --version)"
	@echo "uv                : $$($(UV) --version)"
	@echo "install target    : ${INSTALL_TARGET}"

.PHONY: clean
clean:
	@echo Cleaning
	@rm -rf site 2>/dev/null || true
	@rm -rf .venv 2>/dev/null || true
	@rm -rf *.lock 2>/dev/null || true

.PHONY: install
install: docs-install

.PHONY: docs-install
# Run env setup first so info shows correct versions
docs-install: docs-install-brew docs-install-brew-packages docs-install-python-packages info

.PHONY: docs-install-github-actions
docs-install-github-actions: docs-install-brew-packages docs-install-python-packages info

.PHONY: docs-install-brew-packages
docs-install-brew-packages:
	@echo "Install packages via HomeBrew:"
	@brew upgrade cairo 2>/dev/null || brew install cairo
	@brew upgrade freetype 2>/dev/null || brew install freetype
	@brew upgrade libffi 2>/dev/null || brew install libffi
	@brew upgrade pango 2>/dev/null || brew install pango
	@brew upgrade libjpeg 2>/dev/null || brew install libjpeg
	@brew upgrade libpng 2>/dev/null || brew install libpng
	@brew upgrade zlib 2>/dev/null || brew install zlib
	@brew upgrade graphviz 2>/dev/null || brew install graphviz
	@brew upgrade uv 2>/dev/null || brew install uv

.PHONY: docs-install-brew
ifeq ($(YOUR_OS), Linux)
docs-install-brew: docs-install-brew-linux
endif
ifeq ($(YOUR_OS), Windows)
docs-install-brew: docs-install-brew-windows
endif
ifeq ($(YOUR_OS), Darwin)
docs-install-brew: docs-install-brew-macos
endif

.PHONY: docs-install-brew-linux
docs-install-brew-linux:
	@if ! command -v brew >/dev/null 2>&1 ; then echo "Install HomeBrew" ; exit 1 ; fi
	brew --version

#
# not sure if HomeBrew can be installed on Windows, this part has not been tested yet!
#
.PHONY: docs-install-brew-windows
docs-install-brew-windows:
	@if ! command -v brew >/dev/null 2>&1 ; then echo "Install HomeBrew" ; exit 1 ; fi
	brew --version

.PHONY: docs-install-brew-macos
docs-install-brew-macos:
	@if ! command -v brew >/dev/null 2>&1 ; then echo "Install HomeBrew" ; exit 1 ; fi
	@brew --version

.PHONY: docs-install-python-packages
docs-install-python-packages: docs-install-standard-python-packages

.PHONY: docs-install-standard-python-packages
docs-install-standard-python-packages: docs-ensure-venv
	@echo "Install Python packages via uv:"
	$(UV) sync

.PHONY: docs-ensure-venv
docs-ensure-venv:
	@echo "Ensure venv (Python $(PYTHON_VERSION)) exists and matches version:"
	@if [ ! -d ".venv" ] || ! ./.venv/bin/python3 --version 2>/dev/null | grep -q "$(PYTHON_VERSION)"; then \
		echo "Creating/Recreating venv with Python $(PYTHON_VERSION)"; \
		UV_VENV_CLEAR=1 $(UV) venv --python $(PYTHON_VERSION) --quiet; \
	else \
		echo "Existing venv uses correct Python version"; \
	fi

.PHONY: docs-build
docs-build: docs-ensure-venv
	$(UV) run mkdocs build --config-file $(MKDOCS_CONFIG_FILE)

.PHONY: docs-build-clean
docs-build-clean: docs-ensure-venv
	$(UV) run mkdocs build --config-file $(MKDOCS_CONFIG_FILE) --clean

.PHONY: docs-serve
docs-serve: docs-ensure-venv
	$(UV) run mkdocs serve --config-file $(MKDOCS_CONFIG_FILE) --livereload --strict

.PHONY: docs-diagrams-clean
docs-diagrams-clean:
	@echo "Cleaning generated PlantUML diagrams"
	@rm -rf docs/diagrams/out 2>/dev/null || true

.PHONY: docs-serve-fresh
docs-serve-fresh: docs-diagrams-clean docs-serve

.PHONY: docs-serve-fast
docs-serve-fast: docs-ensure-venv
	$(UV) run mkdocs serve --config-file $(MKDOCS_CONFIG_FILE) --livereload --strict

.PHONY: docs-serve-non-strict
docs-serve-non-strict: docs-ensure-venv
	$(UV) run mkdocs serve --config-file $(MKDOCS_CONFIG_FILE) --livereload

.PHONY: docs-serve-debug
docs-serve-debug: docs-ensure-venv
	$(UV) run mkdocs serve --config-file $(MKDOCS_CONFIG_FILE) --livereload --verbose --strict

.PHONY: docs-serve-debug-non-strict
docs-serve-debug-non-strict: docs-ensure-venv
	$(UV) run mkdocs serve --config-file $(MKDOCS_CONFIG_FILE) --livereload --verbose

.PHONY: docs-deploy
docs-deploy: docs-ensure-venv
	$(UV) run mkdocs gh-deploy --config-file $(MKDOCS_CONFIG_FILE)

.PHONY: docs-sync-from
docs-sync-from: docs-sync-from-ekg-maturity docs-sync-from-ekg-principles

.PHONY: docs-sync-to
docs-sync-to: docs-sync-to-ekg-maturity docs-sync-to-ekg-principles

.PHONY: docs-sync
docs-sync: docs-sync-from docs-sync-to

.PHONY: docs-sync-from-ekg-maturity
docs-sync-from-ekg-maturity: $(wildcard ../ekg-maturity/docs-overrides/*)
	rsync --checksum --recursive --update --itemize-changes --verbose ../ekg-maturity/docs-overrides/ docs-overrides/

.PHONY: docs-sync-to-ekg-maturity
docs-sync-to-ekg-maturity: $(wildcard ../ekg-maturity/Makefile)
	cd ../ekg-maturity && make docs-sync-from

.PHONY: docs-sync-from-ekg-principles
docs-sync-from-ekg-principles: $(wildcard ../ekg-principles/docs-overrides/*)
	rsync --checksum --recursive --update --itemize-changes --verbose ../ekg-principles/docs-overrides/ docs-overrides/

.PHONY: docs-sync-to-ekg-principles
docs-sync-to-ekg-principles: $(wildcard ../ekg-principles/Makefile)
	cd ../ekg-principles && make docs-sync-from

