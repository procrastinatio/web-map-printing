SHELL := /bin/bash

TMPDIR := .build_artefacts
PANDOC ?= /home/ltmom/.local/bin/pandoc
STACK_VERSION := $(shell command -v stack 2> /dev/null)
CURRENT_DATE := $(shell date +%Y-%m-%d%n)
PANDOC_VERSION := $(shell $(PANDOC) --version | head -1)
PANDOC_ARCHIVE := pandoc-2.1.2


help:
	@echo "Usage: make <target>"
	@echo
	@echo "STACK_VERSION                       $(STACK_VERSION)"
	@echo "PANDOC                              $(PANDOC)"
	@echo "PANDOC_VERSION                      $(PANDOC_VERSION)"

doc: web-map-printing.pdf


stack:
ifdef STACK_VERSION
	    @echo "Found version $(STACK_VERSION)"
else
	curl -sSL https://get.haskellstack.org/ | sh
endif

data:
	curl -L  -o tmp.zip https://qgis.org/downloads/data/training_manual_exercise_data.zip  && unzip tmp.zip  && rm tmp.zip

packages:
	sudo apt-get install texlive-math-extra  texlive-xetex  texlive-luatex fonts-noto fonts-noto-mono lmodern

setup: stack packages
	mkdir -p $(TMPDIR) &&  \
	curl -o $(TMPDIR)/$(PANDOC_ARCHIVE).tar.gz  https://hackage.haskell.org/package/$(PANDOC_ARCHIVE)/$(PANDOC_ARCHIVE).tar.gz \
	&& cd $(TMPDIR) && tar xvzf $(PANDOC_ARCHIVE).tar.gz \
	&& cd $(PANDOC_ARCHIVE) && $(STACK_VERSION) setup && nice -n15 stack install --test

web-map-printing.pdf: web-map-printing.md
	$(PANDOC)  --from markdown \
	--listings \
	--pdf-engine=xelatex \
	--highlight-style espresso  \
	--table-of-contents \
	-o "web-map-printing.pdf"  \
	-V pandocversion="$(PANDOC_VERSION)" \
	-V current_date="$(CURRENT_DATE)" \
	-M date="$(CURRENT_DATE)" \
	-V fontsize=10pt  \
	-V geometry:a4paper \
	--variable classoption=onecolumn \
	--variable papersize=a4paper \
	-V papersize:a4 \
	--variable mainfont="Noto Serif" \
	"web-map-printing.md" 

clean:
	rm -f web-map-printing.pdf

.PHONY: help clean setup stack packages data
