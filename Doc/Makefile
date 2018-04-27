# User defined variables {{{
##########################################
TEX    = pdflatex
FLAGS  = -halt-on-error
# relative path to included TeX-files
TEXF   = ./tex
# relative path to included TeX-files containing preamble stuff
PREF   = ./preamble
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
quick: $(FMT)
	$(TEX) $(FLAGS) -fmt="$(NAME)" $(FILE)
	#$(TEX) $(FLAGS) $(FILE);
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
.PHONY: clean cleantex cleansubfoldertex quick all
clean: cleantex cleansubfoldertex
cleantex: # {{{
	-rm $(shell find $(NAME)\.* | grep -Ev '\.tex$$' | grep -Ev '\.sty$$' | grep -Ev '\.bib$$')
# }}}
cleansubfoldertex: # {{{
	-cd $(TEXF); rm $(shell cd $(TEXF); find * | grep -v tex);
# }}}
