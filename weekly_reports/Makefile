SUBDIRS = 2016_37
AUTHORS = hrnz bastelfreak
all: 
	for dir in $(SUBDIRS); do \
		cd $$dir; \
		for document in $(AUTHORS); do \
			sed --in-place 's/###author###/$$document/' content.tex; \
			latexmk; \
			sed --in-place 's/$$document/###author###/' content.tex; \
			cp main.pdf ../$$dir_$$document.pdf; \
		done; \
		cd ..; \
	done

clean:
	for dir in $(SUBDIRS); do cd $$dir; latexmk -C; cd ..; done
	rm *.pdf
