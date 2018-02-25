
.PHONY: doc
doc: web-map-printing.pdf

web-map-printing.pdf: README.md
	pandoc  -f markdown   --pdf-engine=xelatex  \
	-o "web-map-printing.pdf"   \
	  -V fontsize=10pt  -V geometry:a4paper --variable classoption=onecolumn --variable papersize=a4paper  -V papersize:a4 --variable mainfont="Noto Serif"  "web-map-printing.md" 

.PHONE: clean
clean:
	rm -f web-map-printing.pdf
