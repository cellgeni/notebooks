# CellGen programme notebooks

[![Docker Repository on Quay](https://quay.io/repository/cellgeni/cellgeni-jupyter/status "Docker Repository on Quay")](https://quay.io/repository/cellgeni/cellgeni-jupyter)

## Developer instructions

A Docker image for Cellgeni JupyterHub installation
Based on [docker-stacks](https://github.com/jupyter/docker-stacks) and used with [Zero to JupyterHub with Kubernetes](https://zero-to-jupyterhub.readthedocs.io/en/latest/) and template notebooks for scientific analysis.

This Docker image is used as default for every user of Cellgeni JupyterHub installation. The installation contains R packages from [jupyter/r-notebook](https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile) and Python packages [jupyter/scipy-notebook](https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile).

`/files` folder contains files that will be copyied into each user's home directory by default.

`/environments` folder contains conda yaml specifications for custom environments that will be created in the Docker image. To add a new custom environment to the image, add your `environments/env-name.yaml` file. `nb_conda_kernels` must be in `dependencies` field to make the environment work as a kernel.


## User instructions

1. In your browser go to [http://jupyter.cellgeni.sanger.ac.uk/](http://jupyter.cellgeni.sanger.ac.uk/).
2. Use your Sanger credentials for authentication (HTTPS coming soon!). It may take some time to load first time.
3. Now you are ready to run your notebooks!

### Resources

At the moment by default every user is given the quota defined [here](https://github.com/cellgeni/kubespray/blob/6bb6601d44b4213da148dfbbd564a30e0f510f84/sanger/jupyter/jupyter-config.yaml#L24).

Default volume is 10G.

If you need more resources please contact CellGenIT team.

### Important notes

1. Do not modify files from `data` and `notebooks` folder directly - make a copy and work with a copy. Changes to the original files will not survive the notebook's restart.
2. Do not install software into the environments that are provided by default. Changes to those environments are gone with the server restart. Instead, make a copy of a default environment and install software there. See below for more details.
3. Currently JupyterHub can't work on Sanger VPN (NetScaler) due to web sockets not working through the Sanger VPN. This should be solved in the future.
4. You can switch to a classic Jupyter interface by change the word `lab` in your adress bar to the word `tree`:
```
http://jupyter.cellgeni.sanger.ac.uk/user/\<your-username\>/tree
```

### Notebook templates

We provide some notebook templates for your which you can use for your standard analysis. These are located in the `notebooks` folder. Corresponding example data is located in the `data` folder. Before running your analysis, please make a copy of a notebook template and work with the copy. When you open a template notebook (or its copy) it will load a corresponding software environment, so that you won't need to install any software that is used in the notebook.

### Uploading your data

1. You can copy files to and from Jupyter directly in a web interface (look in the menu and buttons in the interface).
2. You can also copy data from and to the farm using a terminal (click on the `Terminal` icon in the Launcher). To copy from the farm (e.g. for `ak27` user):

```
rsync -avzh ak27@farm4-login:/nfs/users/nfs_a/ak27/<some-file-name> /tmp
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

**The first time you login** to JupyterHub please make sure you add a local folder to your `.libPath()`. To do this, start a new Terminal from the Launcher, then start an R session and run the following commands:
```
# create a folder for your local R libraries
dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)
# add the folder to the libPaths
.libPaths( c( Sys.getenv("R_LIBS_USER"), .libPaths() ) )
```
This will make sure your installed packages will be saved and ready to be used when you login next time.

To install packages - start a new Terminal from the Launcher, then start an R session and then run your installation scripts.

Installation of packages doesn't yet work from within the RStudio. However, all the packages installed in the Terminal will also be available in RStudio.
