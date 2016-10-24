SUBDIRS = fsd-en fsd-de prd-en prd-de
THESIS = thesis-de thesis-en

all: documents thesis reports

documents:
	for dir in $(SUBDIRS); do cd $$dir; latexmk; cp $$dir.pdf ..; cd ..; done

thesis:
	for dir in $(THESIS); do cd $$dir; latexmk; cp $$dir.pdf ..; cd ..; done

reports:
	cd weekly_reports; ./magicshellscript.sh

clean:
	for dir in $(SUBDIRS); do cd $$dir; latexmk -C; cd ..; done
	rm *.pdf
