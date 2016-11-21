#!/bin/bash
AUTHORS=(bastelfreak skarf marcellii monatsbericht)
WEEKS=(2016_37 2016_38 2016_39 2016_40 2016_41 2016_42 2016_43 2016_44 2016_45)

# iterate at all weeky directories
for directory in ${WEEKS[*]}; do
  cd "$directory" || exit 1;
  # iterate at each author
  for author in ${AUTHORS[*]}; do
    if [ -f "${author}.tex" ]; then
      sed --in-place "s|###author###|$author|" main.tex
      sed --in-place "s|###author###|$author|" ../content.tex
      latexmk -C
      rm "${directory}_${author}.pdf"
      latexmk -jobname="${directory}_${author}" -r ../latexmkrc
      sed --in-place "s|$author|###author###|" main.tex
      sed --in-place "s|$author|###author###|" ../content.tex
    fi
  done
  cd ..
done
