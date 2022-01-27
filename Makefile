
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
