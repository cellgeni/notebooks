#!/usr/bin/env bash

# copy default templates
git clone https://github.com/cellgeni/notebooks git-notebooks
cp -Rf git-notebooks/files/ .
rm -rf git-notebooks

# create local R library
Rscript -e 'dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)'
Rscript -e '.libPaths( c( Sys.getenv("R_LIBS_USER"), .libPaths() ) )'
