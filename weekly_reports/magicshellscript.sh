#!/bin/bash
AUTHORS=(bastelfreak skarf marcellii monatsbericht)
WEEKS=(2016_37 2016_38 2016_39 2016_40 2016_41 2016_42 2016_43 2016_44 2016_45 2016_46 2016_47 2016_48 2016_49 2016_50 2016_51 2016_52 2017_01 2017_02 2017_03 2017_04 2017_05 2017_06 2017_07 2017_08 2017_09 2017_10 2017_11 2017_12 2017_13 2017_14 2017_15 2017_16 2017_17 2017_18 2017_19 2017_20 2017_21)

# iterate at all weeky directories
for directory in ${WEEKS[*]}; do
  cd "$directory" || exit 1;
  # iterate at each author
  for author in ${AUTHORS[*]}; do
    if [ -f "${author}.tex" ]; then
      sed --in-place "s|###author###|$author|" main.tex
      sed --in-place "s|###author###|$author|" ../content.tex
      if [ "${author}.tex" == "monatsbericht.tex" ]; then
        sed --in-place "s|berichtsdatum,~\\\KW|berichtsdatummonat|" ../content.tex
        sed --in-place "s|Wochenbericht|Monatsbericht|" ../common.tex
        sed --in-place "s|\\\titel~\\\KW|\\\titel|" ../common.tex
      fi
      #latexmk -C
      #rm "${directory}_${author}.pdf"
      latexmk -jobname="${directory}_${author}" -r ../latexmkrc
      sed --in-place "s|$author|###author###|" main.tex
      sed --in-place "s|$author|###author###|" ../content.tex
      if [ "${author}.tex" == "monatsbericht.tex" ]; then
        sed --in-place "s|berichtsdatummonat|berichtsdatum,~\\\KW|" ../content.tex
        sed --in-place "s|Monatsbericht|Wochenbericht|" ../common.tex
        sed --in-place "s|l{\\\titel|l{\\\titel~\\\KW|" ../common.tex
      fi
    fi
  done
  cd ..
done

## create unified pdf for each person
pdfunite */*_bastelfreak.pdf wochenbericht_meusel.pdf
pdfunite */*_marcellii.pdf wochenbericht_reuter.pdf
pdfunite */*_skarf.pdf wochenbericht_luis.pdf
pdfunite */*_monatsbericht.pdf monatsbericht_meusel.pdf
