
.PHONY: doc
doc: web-map-printing.pdf

web-map-printing.pdf: README.md
	pandoc  -f markdown  --number-sections --pdf-engine=xelatex -o "web-map-printing.pdf" \
	  -V fontsize=10pt   --variable mainfont="Noto Serif"  --toc  "README.md" 

.PHONE: clean
clean:
	rm -r web-map-printing.pdf
