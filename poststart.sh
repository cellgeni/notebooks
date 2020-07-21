#!/usr/bin/env bash

# copy notebooks
if [ ! -d .condarc ]; then
    git clone https://github.com/cellgeni/notebooks /tmp/git-notebooks
    cp -Rf /tmp/git-notebooks/files/. .
    rm -rf /tmp/git-notebooks
fi

# create default environment 'myenv'
if [ ! -d my-conda-envs/myenv ]; then
    conda create --clone base --name myenv
    source activate myenv
    python -m ipykernel install --user --name=myenv
fi

# create .Rprofile to use binary packages
if [ ! -d .Rprofile ]; then
    UBUNTU_CODENAME=$(lsb_release -c | awk '{print $2}')
    REPO_NAME="https://packagemanager.rstudio.com/all/__linux__/$UBUNTU_CODENAME/latest"
    echo "options(repos = c(REPO_NAME = \"$REPO_NAME\"))" > .Rprofile
fi

Rscript -e 'dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)'
Rscript -e '.libPaths( c( Sys.getenv("R_LIBS_USER"), .libPaths() ) )'
Rscript -e 'IRkernel::installspec()'

# create matching folders to mount the farm
if [ ! -d /nfs ] || [ ! -d /lustre ] || [ ! -d /warehouse ]; then
    sudo mkdir -p /nfs
    sudo mkdir -p /lustre
    sudo mkdir -p /warehouse
    sudo chown -R jovyan /lustre /nfs /warehouse
fi

# make login shells source .bashrc
if [ ! -d .bash_profile ]; then
    source ~/.bashrc
fi

export MEM_LIMIT=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
CPU_NANOLIMIT=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
export CPU_LIMIT=$(($CPU_NANOLIMIT/100000))

export USER=jovyan
