# CellGen programme notebooks

[![Docker Repository on Quay](https://quay.io/repository/cellgeni/cellgeni-jupyter/status "Docker Repository on Quay")](https://quay.io/repository/cellgeni/cellgeni-jupyter)

## Developer instructions

A Docker image for Cellgeni JupyterHub installation
Based on [docker-stacks](https://github.com/jupyter/docker-stacks) and used with [Zero to JupyterHub with Kubernetes](https://zero-to-jupyterhub.readthedocs.io/en/latest/) and template notebooks for scientific analysis.

This Docker image is used as default for every user of Cellgeni JupyterHub installation. The installation contains R packages from [jupyter/r-notebook](https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile) and Python packages [jupyter/scipy-notebook](https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile).

`/files` folder contains files that will be copied into each user's home directory by default.

## User instructions

1. In your browser go to [https://jupyter.cellgeni.sanger.ac.uk/](https://jupyter.cellgeni.sanger.ac.uk/).
2. Use your Github credentials for authentication. It may take some time to load first time.
3. Now you are ready to run your notebooks!

### Resources

At the moment by default every user is given 16 to 20 Gb of RAM and 2 to 4 cpus. Default storage volume is 30G.

If you need more resources please contact CellGenIT team.

### Important notes

1. **JupyterHub environment and storage are not backed up!!!** Please only use for computations and download your results (and notebooks) afterwards. If you store your data there you can easily lose it. You've been warned!
2. Do not modify files from `data` and `notebooks` folder directly - make a copy, put it in a separate folder and work with a copy. Changes to the original files in the `data` and `notebooks` folders will not survive the server updates.
3. Please read the instructions on package installations below.
4. JupyterHub website is public, so you don't need to turn on VPN to use it. However, it is only available to users who messaged us their Github usernames and have been whitelisted. 
5. You can switch to a classic Jupyter interface by change the word `lab` in your adress bar to the word `tree`:
```
http://jupyter.cellgeni.sanger.ac.uk/user/\<your-username\>/tree
```

### Notebook templates

We provide some notebook templates with the pre-installed software. These are located in the `notebooks` folder. Corresponding example data is located in the `data` folder. Before running your analysis, please make a copy of a notebook template and work with the copy.

### Uploading your data

1. You can copy files to and from Jupyter directly in a web interface (Menu and a button in the interface).
2. You can also copy data from and to the farm using a terminal (click on the `Terminal` icon in the Launcher). To copy from the farm (e.g. for `ak27` user):

```
mkdir farm
rsync -avzh ak27@farm4-login:/nfs/users/nfs_a/ak27/<some-file-name> farm/
```

To copy from the local environment to the farm:

```
rsync -avzh <some-file-name> ak27@farm4-login:/nfs/users/nfs_a/ak27/
```

### Installing packages (python)

Default conda environments are not persistent across Jupyter sessions - you can install an additional package, but it will not be there next time you start Jupyter. To have a persistent conda environment, you can create one inside your `/home` folder:

1. Open a new terminal (click on the `Terminal` icon in the Launcher)
2. Run the following commands (replace `myenv` with your environment name):

```
conda create --name myenv
source activate myenv
# IMPORTANT! it allows the environment to appear in kernels list
conda install nb_conda_kernels  
# conda install all other packages you need
# ...
```

(3). Instead of creating a new environment, you can also clone an existing one, e.g.:

```
conda create --clone old_name --name new_name
```

This will eliminate the need to install repeated packages.

4. Reload the main page. Now you will see your new environment in the Launcher.

### R and RStudio

R and RStudio are also available on JupyterHub:
- A new R session can be started from the Launcher
- To switch to RStudio interface, change the word `lab` in your adress bar to the word `rstudio`:
```
http://jupyter.cellgeni.sanger.ac.uk/user/\<your-username\>/rstudio
```
