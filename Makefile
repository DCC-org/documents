SUBDIRS = fsd-en fsd-de prd-en prd-de

all:
	for dir in $(SUBDIRS); do cd $$dir; latexmk; cp $$dir.pdf ..; cd ..; done

clean:
	for dir in $(SUBDIRS); do cd $$dir; latexmk -C; cd ..; done
	rm *.pdf

