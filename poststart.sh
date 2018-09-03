#!/usr/bin/env bash

git clone https://github.com/cellgeni/notebooks git-notebooks
cp -Rf git-notebooks/files/* .
rm -rf git-notebooks