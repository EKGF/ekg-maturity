
EKG_MM_VERSION := $(shell cat ekg-mm/VERSION)
EKG_MM_PDF := $(subst .,-,$(subst _,-,ekg-mm/ekgf-ekg-mm-editors-version-${EKG_MM_VERSION}-jacobus.pdf))

.PHONY: all info open

all: ${EKG_MM_PDF}

info:
	@echo "VERSION: ${EKG_MM_VERSION}"
	@echo "PDF: ${EKG_MM_PDF}"

${EKG_MM_PDF}:
	latex_document_mode=editors-version latex_document_main=ekg-mm latex_customer_code=ekgf latexmk -gg -pvc

open: ${EKG_MM_PDF}

install-macos:
	brew install mactex
	brew install --cask skim
	./latex-lib/install-as-subtree.sh
	cp -R etc/fonts/*.ttf ~/Library/Fonts/

install-linux:
	./latex-lib/install-as-subtree.sh
	cp -R etc/fonts/*.ttf /usr/local/share/fonts

release-version:
	latex_document_mode=release-version latex_document_main=ekg-mm latex_customer_code=ekgf latexmk -gg -pvc

editors-version:
	latex_document_mode=editors-version latex_document_main=ekg-mm latex_customer_code=ekgf latexmk -gg -pvc

