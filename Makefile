SUBDIRS = fsd-en fsd-de prd-en prd-de

all: reports FORCE
	for dir in $(SUBDIRS); do cd $$dir; latexmk; cp $$dir.pdf ..; cd ..; done

reports:
	$(MAKE) -C weekly_reports 

clean:
	for dir in $(SUBDIRS); do cd $$dir; latexmk -C; cd ..; done
	$(MAKE) -C weekly_reports clean
	rm *.pdf

FORCE:
