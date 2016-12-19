all: slides.pdf

title.pdf: %.pdf: %.tex beamerthemeD3S.sty CUNI.png D3S.png D3SWM.png Head.png Item.png SubItem.png SubSubItem.png
	@pdflatex $<

%.pdf: %.mp title.pdf
	@mpost $<
	@mptopdf *.mps
	@pdfunite title.pdf *-mps.pdf $@
