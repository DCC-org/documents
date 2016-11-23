#!/bin/bash
AUTHORS=(bastelfreak skarf marcellii monatsbericht)
WEEKS=(2016_37 2016_38 2016_39 2016_40 2016_41 2016_42 2016_43 2016_44 2016_45 2016_46 2016_47 2016_48 2016_49 2016_50 2016_51 2016_52)

# iterate at all weeky directories
for directory in ${WEEKS[*]}; do
  cd "$directory" || exit 1;
  # iterate at each author
  for author in ${AUTHORS[*]}; do
    if [ -f "${author}.tex" ]; then
      sed --in-place "s|###author###|$author|" main.tex
      sed --in-place "s|###author###|$author|" ../content.tex
      #latexmk -C
      #rm "${directory}_${author}.pdf"
      latexmk -jobname="${directory}_${author}" -r ../latexmkrc
      sed --in-place "s|$author|###author###|" main.tex
      sed --in-place "s|$author|###author###|" ../content.tex
    fi
  done
  cd ..
done

## create unified pdf for each person
pdfunite */*_bastelfreak.pdf wochenbericht_meusel.pdf
pdfunite */*_marcellii.pdf wochenbericht_reuter.pdf
pdfunite */*_skarf.pdf wochenbericht_luis.pdf
pdfunite */*_monatsbericht.pdf monatsbericht_meusel.pdf
