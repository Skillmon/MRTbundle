# User defined variables {{{
##########################################
TEX     = pdflatex
TEXFOT  = texfot --quiet $(TEX)
FLAGS   = -halt-on-error
# relative path to included TeX-files
TEXF    = ./tex
# relative path to included TeX-files containing preamble stuff
PREF    = ./preamble
# relative path to images
IMGF    = ./img
# command (with flags) to be used for make in subdirectories
SUBMAKE = make -j4
##########################################
# }}}
# Automatically defined variables {{{
##########################################
FILE   = $(wildcard ./*.tex)
SFILES = $(wildcard $(TEXF)/*.tex)
PREAMB = $(wildcard $(PREF)/*.tex)
PREAMB += $(wildcard $(PREF)/*.sty)
PREAMB += $(wildcard ./*.sty)
NAME   = $(FILE:%.tex=%)
OUT    = $(NAME).pdf
FMT    = $(NAME).fmt
##########################################
# }}}
# default target {{{
## the name 'quick' maybe misleading! 'all' might be faster if $(FILE) hasn't
## changed. 'quick' is for quickly running TeX assuming that you know what
## you're doing
quick: img $(FMT)
	$(TEX) $(FLAGS) -fmt="$(NAME)" $(FILE)
	#$(TEX) $(FLAGS) $(FILE);
# }}}
quiet: img $(FMT)# {{{
	$(TEXFOT) $(FLAGS) -fmt="$(NAME)" $(FILE)
# }}}
all: $(OUT) #bib
$(OUT): $(FILE) $(SFILES) $(PREAMB)# {{{
	$(TEX) $(FLAGS) $(FILE);
	$(TEX) $(FLAGS) $(NAME).tex > /dev/null;
	$(TEX) $(FLAGS) $(NAME).tex > /dev/null;
# }}}
$(FMT): $(FILE) $(PREAMB)# {{{
	$(TEX) -ini -enc -jobname="$(NAME)" "&$(TEX)" mylatexformat.ltx """$(FILE)"""
# }}}
img:
	cd $(IMGF); $(SUBMAKE)
.PHONY: clean cleantex cleansubfoldertex cleanimg quick all img
clean: cleantex cleansubfoldertex cleanimg
cleantex: # {{{
	-rm $(shell find $(NAME)\.* | grep -Ev '\.tex$$' | grep -Ev '\.sty$$' | grep -Ev '\.bib$$')
# }}}
cleansubfoldertex: # {{{
	-cd $(TEXF); rm $(shell cd $(TEXF); find * | grep -v tex);
# }}}
cleanimg:
	cd $(IMGF); make clean
