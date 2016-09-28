#!/bin/bash
AUTHORS=(bastelfreak hrnz somedude)
WEEKS=(2016_37)

# iterate at all weeky directories
for directory in ${WEEKS[*]}; do
  cd "$directory" || exit 1;
  # iterate at each author
  for author in ${AUTHORS[*]}; do
    if [ -f "${author}.tex" ]; then
      sed --in-place "s/###author###/$author/" content.tex;
      latexmk -jobname="${directory}_${author}" -r ../latexmkrc
      sed --in-place "s/$author/###author###/" content.tex;
    fi
  done
done
