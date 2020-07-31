#!/usr/bin/env bash

# copy example notebooks
if [ ! -d notebooks ]; then
    git clone https://github.com/cellgeni/notebooks /tmp/git-notebooks
    cp -Rf /tmp/git-notebooks/files/. .
    rm -rf /tmp/git-notebooks
fi

# copy default run commands but provide a way for users to keep their own config
if [ ! -f .keep-local-conf ]; then
    # .condarc: set env_prompt, channels, envs_dirs,create_default_packages
    cp /config/.condarc /home/jovyan/
    # .Rprofile: set binary package repo
    cp /config/.Rprofile /home/jovyan/
    # .bash_profile: make login shells source .bashrc
    echo "source ~/.bashrc" > .bash_profile
    # .bashrc: activate myenv by default
    echo "source activate myenv" > .bashrc
fi

# create default environment 'myenv'
if [ ! -d my-conda-envs/myenv ]; then
    conda create --clone base --name myenv
    source activate myenv
fi

Rscript -e 'dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)'
Rscript -e '.libPaths( c( Sys.getenv("R_LIBS_USER"), .libPaths() ) )'
Rscript -e 'IRkernel::installspec()'

# create matching folders to mount the farm
if [ ! -d /nfs ] || [ ! -d /lustre ] || [ ! -d /warehouse ]; then
    sudo mkdir -p /nfs
    sudo mkdir -p /lustre
    sudo mkdir -p /warehouse
fi

# set env vars for nbresuse limits
export MEM_LIMIT=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
CPU_NANOLIMIT=$(cat /sys/fs/cgroup/cpu/cpu.cfs_quota_us)
export CPU_LIMIT=$(($CPU_NANOLIMIT/100000))

export USER=jovyan
