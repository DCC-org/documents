SUBDIRS = 2016_37

all: 
	for dir in $(SUBDIRS); do cd $$dir; latexmk; cp main.pdf ../$$dir.pdf; cd ..; done

clean:
	for dir in $(SUBDIRS); do cd $$dir; latexmk -C; cd ..; done
	rm *.pdf
