SHELL := /bin/bash

TMPDIR := .build_artefacts
STACK_VERSION := $(shell command -v stack 2> /dev/null)
CURRENT_DATE := $(shell date +%Y-%m-%d%n)
PANDOC_VERSION := $(shell pandoc --version | head -1)

doc: web-map-printing.pdf


stack:
ifdef STACK_VERSION
	    @echo "Found version $(STACK_VERSION)"
else
	curl -sSL https://get.haskellstack.org/ | sh
endif

setup: stack
	mkdir -p $(TMPDIR) &&  \
	curl -o $(TMPDIR)/pandoc-1.17.0.3.tar.gz  https://hackage.haskell.org/package/pandoc-1.17.0.3/pandoc-1.17.0.3.tar.gz \
	&& cd $(TMPDIR) && tar xvzf pandoc-1.17.0.3.tar.gz \
	&& cd pandoc-1.17.0.3 && $(STACK_VERSION) setup && nice -n15 stack install --test

web-map-printing.pdf: README.md
	pandoc  -f markdown   --pdf-engine=xelatex  \
	-o "web-map-printing.pdf"  -V pandocversion="$(PANDOC_VERSION)" -V current_date="$(CURRENT_DATE)" -M date="$(CURRENT_DATE)" \
	  -V fontsize=10pt  -V geometry:a4paper --variable classoption=onecolumn --variable papersize=a4paper  -V papersize:a4 --variable mainfont="Noto Serif"  "web-map-printing.md" 

clean:
	rm -f web-map-printing.pdf

.PHONY: doc clean setup stack
