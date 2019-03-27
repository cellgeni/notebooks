#!/usr/bin/env bash

# copy default templates
if [ -d git-notebooks ]
    rm -rf git-notebooks
fi
git clone https://github.com/cellgeni/notebooks git-notebooks
cp -Rf git-notebooks/files/. .
rm -rf git-notebooks
if [ ! -d my-conda-envs/myenv ]; then
    conda create --clone base --name myenv
fi
