SHELL := /bin/bash

TMPDIR := .build_artefacts
PANDOC ?= ${HOME}/.local/bin/pandoc
STACK_VERSION := $(shell command -v stack 2> /dev/null)
CURRENT_DATE := $(shell date +%Y-%m-%d%n)
PANDOC_VERSION := $(shell $(PANDOC) --version | head -1)
PANDOC_ARCHIVE := pandoc-2.1.2
NODE_VERSION := $(shell nodejs -v)


help:
	@echo "Usage: make <target>"
	@echo
	@echo "STACK_VERSION                       $(STACK_VERSION)"
	@echo "PANDOC                              $(PANDOC)"
	@echo "PANDOC_VERSION                      $(PANDOC_VERSION)"
	@echo "NODE_VERSION                        $(NODE_VERSION)"

doc: web-map-printing.pdf


stack:
ifdef STACK_VERSION
	    @echo "Found version $(STACK_VERSION)"
else
	curl -sSL https://get.haskellstack.org/ | sh
endif


chrome:
	sudo apt-get install chromium-chromedriver  python-selenium

puppeteer:
	curl -sL https://deb.nodesource.com/setup_9.x -o nodesource_setup.sh &&
	sudo bash nodesource_setup.sh &&  npm i --save puppeteer



eisvogel:
	[ -d ${TMPDIR} ] || mkdir $(TMPDIR) && cd $(TMPDIR) && \
	[ -d pandoc-latex-template ] ||	git clone https://github.com/Wandmalfarbe/pandoc-latex-template.git && \
	mkdir -p ${HOME}/.pandoc/templates/ && \
	cp pandoc-latex-template/eisvogel.tex ${HOME}/.pandoc/templates/eisvogel.latex

data:
	curl -L  -o tmp.zip https://qgis.org/downloads/data/training_manual_exercise_data.zip  && unzip tmp.zip  && rm tmp.zip

packages:
	sudo apt-get install texlive-math-extra  texlive-fonts-extra texlive-xetex  texlive-luatex fonts-noto fonts-noto-mono lmodern

setup: stack packages
	mkdir -p $(TMPDIR) &&  \
	curl -o $(TMPDIR)/$(PANDOC_ARCHIVE).tar.gz  https://hackage.haskell.org/package/$(PANDOC_ARCHIVE)/$(PANDOC_ARCHIVE).tar.gz \
	&& cd $(TMPDIR) && tar xvzf $(PANDOC_ARCHIVE).tar.gz \
	&& cd $(PANDOC_ARCHIVE) && $(STACK_VERSION) setup && nice -n15 stack install --test

web-map-printing.pdf: web-map-printing.md
	$(PANDOC)  --from markdown \
	--listings \
	--pdf-engine=xelatex \
	--table-of-contents \
	-o "web-map-printing.pdf"  \
	-V pandocversion="$(PANDOC_VERSION)" \
	-V current_date="$(CURRENT_DATE)" \
	-M date="$(CURRENT_DATE)" \
	-V geometry:a4paper \
	-V papersize:a4 \
	--template eisvogel \
	"web-map-printing.md" 

clean:
	rm -f web-map-printing.pdf

.PHONY: help clean setup stack packages data
