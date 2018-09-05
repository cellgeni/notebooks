# notebooks
[![Docker Repository on Quay](https://quay.io/repository/cellgeni/cellgeni-jupyter/status "Docker Repository on Quay")](https://quay.io/repository/cellgeni/cellgeni-jupyter)


A Docker image for Cellgeni JupyterHub installation
Based on [docker-stacks](https://github.com/jupyter/docker-stacks) and used with [Zero to JupyterHub with Kubernetes](https://zero-to-jupyterhub.readthedocs.io/en/latest/) and template notebooks for scientific analysis.

This Docker image is used as default for every user of Cellgeni JupyterHub installation. The installation contains R packages from [jupyter/r-notebook](https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile) and Python packages [jupyter/scipy-notebook](https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile).

`/files` folder contains files that will be copyied into each user's home directory by default.
`/environments` folder contains conda yaml specifications for custom environments that will be created in the Docker image. To add a new custom environment to the image,
add your `environments/env-name.yaml` file. `nb_conda_kernels` must be in `dependencies` field to make the environment work as a kernel.


## Important notices

1. Use your Sanger credentials for authentication (HTTPS coming soon!)
2. Do not modify files from `data` and `notebooks` folder directly - make a copy and work with a copy. Changes to the original files will not survive the notebook restart.
3. Do not install software into the environments that are provided by default. Changes to those environments are gone with the server restart. Instead, make a copy of a default environment and install software there. See below for more details.
4. You can copy files to and from Jupyter both in a web interface and from a terminal. E.g., to copy from the farm locally
```
rsync -avzh ak27@farm4-login:/nfs/users/nfs_a/ak27/<some-file-name> /tmp
```
From the local environment to the farm
```
rsync -avzh <some-file-name> ak27@farm4-login:/nfs/users/nfs_a/ak27/
```
5. JupyterHub can't work in VPN at the moment due to web sockets not working through Sanger VPN.
6. You can switch to a classic Jupyter interface on jupyter.cellgeni.sanger.ac.uk/user/\<your-username\>/tree
7. You can use RStudio from JupyterHub. Go to jupyter.cellgeni.sanger.ac.uk/user/\<your-username\>/rstudio. It's also available through "New" -> "RStudio Session" in a classic interface.

## Creating your own conda environment

Default conda environments are not persistent across Jupyter sessions - you can install an additional package, but it will not be there next time you start Jupyter. To have a persistent conda environment, you can create one inside your home folder. 

1. Go to Jupyter terminal ("New" -> "Terminal")
2. Replace 'myenv' with your environment name
```bash
conda create --name myenv
source activate myenv
# IMPORTANT! it allows the environment to appear in kernels list
conda install nb_conda_kernels  
# conda install all other packages you need
```

Instead of creating a new environment, you can also clone an existing one via
```bash
conda create --clone old_name --name new_name
```
This will eliminate the need to install basic packages.


3. Reload the main page. Now in the "New" menu you see your new environment in the list of kernels, and you can create a notebook with this kernel. Also you can switch to this kernel in your existing notebooks from the "Kernel" -> "Change kernel" menu.
