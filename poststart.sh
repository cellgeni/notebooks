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

# create matching folders to mount the farm
sudo mkdir -p /nfs
sudo mkdir -p /lustre
sudo mkdir -p /warehouse

# copy mount-farm so its avaiable on the user's path
sudo chmod +x /mount-farm.sh
sudo cp /mount-farm.sh /usr/local/bin/mount-farm

# start docker service
sudo service docker start

export USER=jovyan
