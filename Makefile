TEX = #insert your source's name
PDF = $(TEX_EN:.tex=.pdf)
PDFLATEX = pdflatex
PDFVIEW = evince
CLEAN_FILES = *.aux *.log *.out *.dvi

.PHONY: clean all

all: $(PDF)
	$(PDFVIEW) $(PDF) &

$(PDF): $(TEX) $(PDF)
	$(PDFLATEX) $<
	$(PDFLATEX) $<	# Twice, so TOC is also updated

clean:
	-rm -f $(CLEAN_FILES) *~
