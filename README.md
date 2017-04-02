# documents

## how to cite

\cite{HorgasAnalyse}
'Hadoop ist sacklahm(siehe benchmarks aus \cite{Horgasanalyse}'

## stuff for the appendix

We have a few files that place content in the appendix section

### figures.tex

this is for all figures (pictures, pdf, svg)

### tables.tex

tables, obvious?

### listings.tex

source code, text

## Embed svg

this is a bit tricky. embedding a svg, in general, is pretty easy:

```
\begin{figure}[tbp]
  \centering
  \includesvg[svgpath=../figures/,path=../figures/,width=1.0\textwidth]{ssduserstory}
  \caption{Wireframe für SSD Userstory}
\label{figure:ssduserstory}
\end{figure}
```

this expects a file at: .../figures/ssduserstory.svg. inkscape will be called to convert it to tex. Also you need:

```
\usepackage{svg}
```

somewhere.

Sad news: most of the tools for drawing svg files are totally fucked up.
https://validator.w3.org/ can be used to validate the svg. I've tested draw.io,
yED and gliffy. All of them suck because the svg is broken. How can we fix that?
We can convert the svg to pdf with inkscape and use the pdf in latex (also we
use pdfcrop to pruge useless surrounding whitespace):

```
inkscape -A ssduserstory.pdf ssduserstory.svg
pdfcrop ssduserstory.pdf
```

and the corresponding latex code:

```
\begin{figure}[tbp]
  \centering
  \includegraphics[width=1.0\textwidth]{../figures/ssduserstory-crop.pdf}
  \caption{Wireframe für SSD Userstory}
\label{figure:ssduserstory}
\end{figure}
```
