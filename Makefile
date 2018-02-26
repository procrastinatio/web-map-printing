

CURRENT_DATE := $(shell date +%Y-%m-%d%n)
PANDOC_VERSION := $(shell pandoc --version | head -1)

.PHONY: doc
doc: web-map-printing.pdf

web-map-printing.pdf: README.md
	pandoc  -f markdown   --pdf-engine=xelatex  \
	-o "web-map-printing.pdf"  -V pandocversion="$(PANDOC_VERSION)" -V current_date="$(CURRENT_DATE)" -M date="$(CURRENT_DATE)" \
	  -V fontsize=10pt  -V geometry:a4paper --variable classoption=onecolumn --variable papersize=a4paper  -V papersize:a4 --variable mainfont="Noto Serif"  "web-map-printing.md" 

.PHONE: clean
clean:
	rm -f web-map-printing.pdf
