#!/bin/sh
#
# Typeset the complete Unix Programmer's Manual
#
# Diomidis Spinellis, November 2017
#

# Create table of contents and permuted index
(cd man0 && ./tocrc)

{
  # Typeset the front matter creating the ToC and permuted index
  # Keep the original files afterwards
  (cd man0 && ./x)

  # Typeset the individual manual pages
  for s in man[1-8] ; do
    for f in $s/* ; do
      groff -Tps man0/taa $f
    done
  done
} |
# Convert all the postscript into PDF
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -sOutputFile=v4man.pdf -

# Restore original contents
(cd man0 && git checkout -- .)
