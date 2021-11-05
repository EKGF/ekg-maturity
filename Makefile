
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


