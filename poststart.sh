#!/usr/bin/env bash

# copy example notebooks
if [ ! -d notebooks ]; then
    git clone https://github.com/cellgeni/notebooks /tmp/git-notebooks
    cp -Rf /tmp/git-notebooks/files/. .
    rm -rf /tmp/git-notebooks
fi

# set .condarc to use deafult env path (~/my-conda-envs)
if [[ -d .condarc ]]; then
    mv .condarc .condarc.old
fi
cp /config/.condarc /home/jovyan/

# create default environment 'myenv'
if [ ! -d my-conda-envs/myenv ]; then
    conda create --clone base --name myenv
    source activate myenv
fi

# set .Rprofile to use binary packages
if [[ -d .Rprofile ]]; then
    mv .Rprofile .Rprofile.old
fi
cp /config/.Rprofile /home/jovyan/

Rscript -e 'dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)'
Rscript -e '.libPaths( c( Sys.getenv("R_LIBS_USER"), .libPaths() ) )'
Rscript -e 'IRkernel::installspec()'

# create matching folders to mount the farm
if [ ! -d /nfs ] || [ ! -d /lustre ] || [ ! -d /warehouse ]; then
    sudo mkdir -p /nfs
    sudo mkdir -p /lustre
    sudo mkdir -p /warehouse
fi

# make login shells source .bashrc
if [ ! -d .bash_profile ]; then
    echo "source ~/.bashrc" > .bash_profile
fi

if [ ! -d .bashrc ]; then
    echo "source activate myenv" > .bash_profile
fi

# set env vars for nbresuse limits
export MEM_LIMIT=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
CPU_NANOLIMIT=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
export CPU_LIMIT=$(($CPU_NANOLIMIT/100000))

export USER=jovyan

# download package information from all configured sources
sudo apt-get update