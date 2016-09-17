SUBDIRS = fsd-en fsd-de prd-en

all:
	for dir in $(SUBDIRS); do cd $$dir; latexmk; cp $$dir.pdf ..; cd ..; done

clean:
	for dir in $(SUBDIRS); do cd $$dir; latexmk -C; cd ..; done
	rm *.pdf

