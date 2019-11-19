#!/usr/bin/env bash

# copy default templates
if [ -d git-notebooks ]; then
    rm -rf git-notebooks
fi
git clone https://github.com/cellgeni/notebooks git-notebooks
cp -Rf git-notebooks/files/. .
rm -rf git-notebooks
if [ ! -d my-conda-envs/myenv ]; then
    conda create --clone base --name myenv
fi

Rscript -e 'dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)'
Rscript -e '.libPaths( c( Sys.getenv("R_LIBS_USER"), .libPaths() ) )'

sudo mkdir -p /nfs
sudo mkdir -p /lustre
sudo mkdir -p /warehouse

export USER=jovyan
