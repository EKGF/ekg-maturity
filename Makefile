
VIRTUAL_ENV := ./.venv

ifeq ($(OS),Windows_NT)
    YOUR_OS := Windows
    INSTALL_TARGET := install-windows
    SYSTEM_PYTHON := python3
else
    YOUR_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
ifeq ($(YOUR_OS), Linux)
    INSTALL_TARGET := install-linux
ifneq ($(wildcard /home/runner/.*),) # this means we're running in Github Actions
		SYSTEM_PYTHON := python3
else
		SYSTEM_PYTHON := $(shell asdf where python)/bin/python3
endif
endif
ifeq ($(YOUR_OS), Darwin)
    INSTALL_TARGET := install-macos
		SYSTEM_PYTHON := $(shell asdf where python)/bin/python3
endif
endif

VENV_MKDOCS := $(VIRTUAL_ENV)/bin/mkdocs
VENV_PYTHON := $(VIRTUAL_ENV)/bin/python3
VENV_PIP := $(VIRTUAL_ENV)/bin/pip3

CURRENT_BRANCH := $(shell git branch --show-current)
PAT_MKDOCS_INSIDERS := $(shell cat $(HOME)/.secrets/PAT_MKDOCS_INSIDERS.txt 2>/dev/null)
ifeq ($(PAT_MKDOCS_INSIDERS),)
MKDOCS_CONFIG_FILE := 'mkdocs.outsiders.yml'
$(info You don't have the $(HOME)/.secrets/PAT_MKDOCS_INSIDERS.txt file so we are using the open source version of MkDocs)
else
MKDOCS_CONFIG_FILE := 'mkdocs.yml'
endif

.PHONY: all
all: docs-build

.PHONY: info
info: python-venv
	@echo "Git Branch: ${CURRENT_BRANCH}"
	@echo "Operating System: ${YOUR_OS}"
	@echo "MkDocs: ${VENV_MKDOCS}"
	@echo "MkDocs config file: ${MKDOCS_CONFIG_FILE}"
	@echo "System Python: ${SYSTEM_PYTHON} version: $$($(SYSTEM_PYTHON) --version)" 
	@echo "Virtual Env Python: ${VENV_PYTHON} version: $$($(VENV_PYTHON) --version)"
	@echo "Python pip: ${VENV_PIP}"
	@echo "install target: ${INSTALL_TARGET}"

.PHONY: clean
clean:
	@echo Cleaning
	@rm -rf site 2>/dev/null || true
	@rm -rf .venv/lib/python3.10/site-packages 2>/dev/null || true

.PHONY: install
install: docs-install

.PHONY: docs-install
docs-install: info docs-install-brew docs-install-brew-packages docs-install-python-packages

.PHONY: docs-install-github-actions
docs-install-github-actions: info docs-install-brew-packages docs-install-python-packages

.PHONY: docs-install-brew-packages
docs-install-brew-packages:
	@echo "Install packages via HomeBrew:"
	brew upgrade cairo || brew install cairo
	brew upgrade freetype || brew install freetype
	brew upgrade libffi || brew install libffi
	brew upgrade pango || brew install pango
	brew upgrade libjpeg || brew install libjpeg
	brew upgrade libpng || brew install libpng
	brew upgrade zlib || brew install zlib
	brew upgrade plantuml || brew install plantuml
	brew upgrade graphviz || brew install graphviz

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
	brew --version

.PHONY: docs-install-asdf
ifneq ($(wildcard /home/runner/.*),)
docs-install-asdf: docs-install-brew
	@echo "Install the asdf package manager:"
	brew upgrade asdf || brew install asdf
	asdf plugin add python || true
	asdf plugin add nodejs || true
	asdf plugin add java || true
else
docs-install-asdf:
endif

.PHONY: docs-install-asdf-packages
docs-install-asdf-packages: docs-install-asdf
	@echo "Install packages via asdf:"
	asdf install

.PHONY: docs-install-python-packages
docs-install-python-packages: docs-install-asdf-packages docs-install-standard-python-packages docs-install-special-python-packages

.PHONY: docs-install-standard-python-packages
docs-install-standard-python-packages: python-venv
	@echo "Install standard python packages via pip:"
	$(VENV_PIP) install --upgrade pip
	$(VENV_PIP) install --upgrade wheel
	$(VENV_PIP) install --upgrade setuptools
	$(VENV_PIP) install --upgrade pipenv
#	$(VENV_PIP) install --upgrade plantuml-markdown
	$(VENV_PIP) install --upgrade mkdocs-build-plantuml-plugin
	$(VENV_PIP) install --upgrade mdutils
	$(VENV_PIP) install --upgrade option
	$(VENV_PIP) install --upgrade mkdocs
	$(VENV_PIP) install --upgrade mkdocs-awesome-pages-plugin
	$(VENV_PIP) install --upgrade mkdocs-awesome-pages-plugin
	$(VENV_PIP) install --upgrade mkdocs-exclude
	$(VENV_PIP) install --upgrade mkdocs-exclude-search
	$(VENV_PIP) install --upgrade mkdocs-gen-files
	$(VENV_PIP) install --upgrade mkdocs-git-revision-date-localized-plugin
	$(VENV_PIP) install --upgrade mkdocs-graphviz
	$(VENV_PIP) install --upgrade mkdocs-include-markdown-plugin
	$(VENV_PIP) install --upgrade mkdocs-localsearch
	$(VENV_PIP) install --upgrade mkdocs-macros-plugin
	$(VENV_PIP) install --upgrade mkdocs-mermaid2-plugin
	$(VENV_PIP) install --upgrade mkdocs-minify-plugin
	$(VENV_PIP) install --upgrade mkdocs-redirects
	$(VENV_PIP) install --upgrade mkdocs-kroki-plugin
# $(VENV_PIP) install --upgrade --no-cache-dir "git+https://github.com/EKGF/ekglib.git"
# $(VENV_PIP) install --upgrade mdx-spanner
#	$(VENV_PIP) install --upgrade markdown-emdash
	$(VENV_PIP) freeze > requirements.txt

.PHONY: docs-install-python-packages-via-requirements-txt
docs-install-python-packages-via-requirements-txt:
ifeq ($(PAT_MKDOCS_INSIDERS),)
	@echo "ERROR: Can only run this when PAT_MKDOCS_INSIDERS is known"
else
	@echo "Install standard python packages according to requirements.txt:"
	@PAT_MKDOCS_INSIDERS=$(PAT_MKDOCS_INSIDERS) $(VENV_PIP) install -r requirements.txt
endif

.PHONY: docs-install-special-python-packages
docs-install-special-python-packages: docs-install-pdf-python-packages docs-install-mkdocs-insider-version-packages

.PHONY: docs-install-pdf-python-packages
docs-install-pdf-python-packages:
	@#echo "Install PDF python packages via pip:"
	@#$(VENV_PIP) install --upgrade weasyprint
	@#cd ../mkdocs-with-pdf && $(VENV_PIP) install -e .
	@#$(VENV_PIP) install --upgrade mkdocs-with-pdf
	@#$(VENV_PIP) install --upgrade weasyprint==52
	@#$(VENV_PIP) install --upgrade mkpdfs-mkdocs

.PHONY: docs-install-mkdocs-insider-version-packages
docs-install-mkdocs-insider-version-packages:
ifeq ($(PAT_MKDOCS_INSIDERS),)
	@echo "Install standard mkdocs python package via pip:"
	$(VENV_PIP) install --upgrade --force-reinstall mkdocs-material
else
	@echo "Install special insiders version of mkdocs python package via pip:"
	@$(VENV_PIP) install --upgrade --force-reinstall git+https://$(PAT_MKDOCS_INSIDERS)@github.com/squidfunk/mkdocs-material-insiders.git
endif

.PHONY: python-venv
python-venv:
	$(SYSTEM_PYTHON) -m venv --upgrade --upgrade-deps $(VIRTUAL_ENV)

.PHONY: docs-build
docs-build:
	$(VENV_MKDOCS) build --config-file $(MKDOCS_CONFIG_FILE)

.PHONY: docs-build-clean
docs-build-clean:
	$(VENV_MKDOCS) build --config-file $(MKDOCS_CONFIG_FILE) --clean

.PHONY: docs-serve
docs-serve:
	$(VENV_MKDOCS) serve --config-file $(MKDOCS_CONFIG_FILE) --livereload --strict

.PHONY: docs-serve-debug
docs-serve-debug:
	$(VENV_MKDOCS) serve --config-file $(MKDOCS_CONFIG_FILE) --livereload --verbose

.PHONY: docs-deploy
docs-deploy:
	$(VENV_MKDOCS) gh-deploy --config-file $(MKDOCS_CONFIG_FILE) --verbose

.PHONY: docs-sync-from
docs-sync-from: docs-sync-from-ekg-maturity docs-sync-from-ekg-principles

.PHONY: docs-sync-to
docs-sync-to: docs-sync-to-ekg-maturity docs-sync-to-ekg-principles

.PHONY: docs-sync
docs-sync: docs-sync-from docs-sync-to

.PHONY: docs-assets
docs-assets:
