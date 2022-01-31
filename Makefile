
ifeq ($(OS),Windows_NT)
    YOUR_OS := Windows
    INSTALL_TARGET := install-windows
    OPEN_EDITORS_VERSION_TARGET := open-editors-version-windows
    OPEN_RELEASE_VERSION_TARGET := open-release-version-windows
else
    YOUR_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
    ifeq ($(YOUR_OS), Linux)
    INSTALL_TARGET := install-linux
    OPEN_EDITORS_VERSION_TARGET := open-editors-version-linux
    OPEN_RELEASE_VERSION_TARGET := open-release-version-linux
    endif
    ifeq ($(YOUR_OS), Darwin)
    INSTALL_TARGET := install-macos
    OPEN_EDITORS_VERSION_TARGET := open-editors-version-macos
    OPEN_RELEASE_VERSION_TARGET := open-release-version-macos
    endif
endif
CURRENT_BRANCH := $(shell git branch --show-current)
EKG_MM_VERSION := $(shell cat ekg-mm/VERSION)
PDF_FILE_NAME_SUFFIX := $(EKG_MM_VERSION)-$(USER)-$(CURRENT_BRANCH)
EKG_MM_EDITORS_VERSION := $(subst .,-,$(subst _,-,ekg-mm/ekgf-ekg-mm-editors-version-$(PDF_FILE_NAME_SUFFIX))).pdf
EKG_MM_RELEASE_VERSION := $(subst .,-,$(subst _,-,ekg-mm/ekgf-ekg-mm-$(PDF_FILE_NAME_SUFFIX))).pdf
MKDOCS = $(shell asdf where python)/bin/mkdocs

.PHONY: all
all: $(EKG_MM_EDITORS_VERSION) $(EKG_MM_RELEASE_VERSION)

.PHONY: info
info:
	@echo "VERSION: ${EKG_MM_VERSION}"
	@echo "Suffix: ${PDF_FILE_NAME_SUFFIX}"
	@echo "Release Version: ${EKG_MM_RELEASE_VERSION}"
	@echo "Editors Version: ${EKG_MM_EDITORS_VERSION}"

.PHONY: open-editors-version-windows
open-editors-version-windows:
	@echo "We did not implement this yet for Windows"

.PHONY: open-editors-version-linux
open-editors-version-linux:
	@echo "We did not implement this yet for Linux"

.PHONY: open-editors-version-macos
open-editors-version-macos: $(EKG_MM_EDITORS_VERSION)
	skim $(EKG_MM_EDITORS_VERSION)

.PHONY: open-release-version-windows
open-release-version-windows:
	@echo "We did not implement this yet for Windows"

.PHONY: open-release-version-linux
open-release-version-linux:
	@echo "We did not implement this yet for Linux"

.PHONY: open-release-version-macos
open-release-version-macos: $(EKG_MM_RELEASE_VERSION)
	skim $(EKG_MM_RELEASE_VERSION)

.PHONY: open-editors-version
open-editors-version: $(OPEN_EDITORS_VERSION_TARGET)

.PHONY: open-release-version
open-release-version: $(OPEN_RELEASE_VERSION_TARGET)

.PHONY: install-macos
install-macos:
	#brew install mactex
	brew install --cask mactex-no-gui # see https://formulae.brew.sh/cask/mactex-no-gui
	sudo tlmgr texdoc # used by IntelliJ editor and other editors for documentation of packages
	sudo tlmgr update --self
	sudo tlmgr update --all

	brew install --cask skim
	./latex-lib/install-as-subtree.sh
	cp -R etc/fonts/*.ttf ~/Library/Fonts/
	@echo "Exit this terminal and open a new one because your PATH has changed"

.PHONY: install-linux
install-linux:
	./latex-lib/install-as-subtree.sh
	cp -R etc/fonts/*.ttf /usr/local/share/fonts

.PHONY: install
install: $(INSTALL_TARGET)

.PHONY: release-version
release-version:
	latex_document_mode=release-version latex_document_main=ekg-mm latex_customer_code=ekgf latexmk -gg -pvc

$(EKG_MM_RELEASE_VERSION): release-version

.PHONY: editors-version
editors-version:
	latex_document_mode=editors-version latex_document_main=ekg-mm latex_customer_code=ekgf latexmk -gg -pvc

$(EKG_MM_EDITORS_VERSION): editors-version

.PHONY: clean
clean:
	@echo "Removing all generated files"
	@cd ekg-mm && rm -f *.acn *.acr *.alg *.aux *.bbl *.bcf *.blg *.fdb* *.fls *.gl? *.idx *.ilg *.ind *.ist *.log *.odn *.ol? *.pdf *.run.xml *.sync* *.tdn *.tl? *.toc

.PHONY: docs-install
docs-install:
	brew upgrade asdf || brew install asdf
	asdf plugin add python || true
	asdf plugin add nodejs || true
	asdf local python latest
	asdf local nodejs 12.17.0
	asdf exec python -m pip install --upgrade pip
	pip install --upgrade mkdocs
	pip install --upgrade mkdocs-material
	pip install --upgrade mkdocs-localsearch
	pip install --upgrade mdx-spanner
	pip install --upgrade mkdocs-awesome-pages-plugin
	pip install --upgrade mkdocs-macros-plugin
	brew upgrade cairo || brew install cairo
	brew upgrade freetype || brew install freetype
	brew upgrade libffi || brew install libffi
	brew upgrade libjpeg || brew install libjpeg
	brew upgrade libpng || brew install libpng
	brew upgrade zlib || brew install zlib

.PHONY: docs-build
docs-build:
	${MKDOCS} build

.PHONY: docs-serve
docs-serve:
	${MKDOCS} serve --livereload --strict --theme material

.PHONY: docs-serve-debug
docs-serve-debug:
	${MKDOCS} serve --livereload --strict --theme material --verbose

.PHONY: docs-deploy
docs-deploy:
	${MKDOCS} gh-deploy --verbose

docs/index.html: $(wildcard docs/*.md) mkdocs.yml
	${MKDOCS} build
	open site/index.html