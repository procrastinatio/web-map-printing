
.PHONY: doc
doc: web-map-printing.pdf

web-map-printing.pdf: README.md
	pandoc  -f markdown   --pdf-engine=xelatex  \
	-o "web-map-printing.pdf"   \
	  -V fontsize=10pt  --variable classoption=twocolumn --variable papersize=a4paper  --variable mainfont="Noto Serif"  "README.md" 

.PHONE: clean
clean:
	rm -f web-map-printing.pdf
