all: slides.pdf

%.pdf: %.mp
	@mpost $<
	@mptopdf *.mps
	@pdfunite *-mps.pdf $@
