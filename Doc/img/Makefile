# User defined variables {{{
##########################################
TEX   = pdflatex
FLAG  = -halt-on-error
AINP  = .alone.tex
AOUT  = -alone.pdf
##########################################
# }}}
# Automatically defined variables {{{
##########################################
ALONE = $(wildcard ./*$(AINP))
AOUTP = $(ALONE:%$(AINP)=%$(AOUT))
##########################################
# }}}

all: alone
alone: $(AOUTP)
%-alone.pdf: %.alone.tex
	#if [ "$(head -n1 $<)" = "% make twice" ];then $(TEX) $(FLAGS) -jobname="$<" "\input{$<}";fi
	$(TEX) $(FLAGS) -jobname="$<" "\input{$<}"
	$(TEX) $(FLAGS) -jobname="$<" "\input{$<}"
	-rm $<.aux
	-rm $<.log
	mv $<.pdf $@

.PHONY: all alone clean clean_alone

clean: clean_alone
clean_alone:
	-rm $(AOUTP)
