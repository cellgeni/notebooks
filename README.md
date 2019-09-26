# CellGen programme notebooks

[![Docker Repository on Quay](https://quay.io/repository/cellgeni/cellgeni-jupyter/status "Docker Repository on Quay")](https://quay.io/repository/cellgeni/cellgeni-jupyter)

## Developer instructions

A Docker image for Cellgeni JupyterHub installation
Based on [docker-stacks](https://github.com/jupyter/docker-stacks) and used with [Zero to JupyterHub with Kubernetes](https://zero-to-jupyterhub.readthedocs.io/en/latest/) and template notebooks for scientific analysis.

This Docker image is used as default for every user of Cellgeni JupyterHub installation. The installation contains R packages from [jupyter/r-notebook](https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile) and Python packages [jupyter/scipy-notebook](https://github.com/jupyter/docker-stacks/blob/master/scipy-notebook/Dockerfile).

`/files` folder contains files that will be copied into each user's home directory by default.

### Updating JupyterHub

1. Clone the private repository with Cellgeni JupyterHub settings:
```
git clone  https://gitlab.internal.sanger.ac.uk/cellgeni/kubespray/
cd kubespray/sanger/sites
```
2. Add the new user's Github username to `auth.whitelist.users` or change Docker image at `singleuser.image.tag` in `jupyter-github-auth.yaml` (`jupyter-large-config.yaml` for jupyter-large)

3. Commit and push your changes so that your colleagues do not override your changes in the following upgrades
```
git add jupyter-github-auth.yaml jupyter-large-config.yaml && git commit -m "Add new users" && git push
```
3. Upgrade Jupyter with 
```
helm upgrade jpt jupyterhub/jupyterhub --namespace jpt --version 0.8.0 --values jupyter-github-auth.yaml
```
or jupyter-large with 
```
helm upgrade jptl jupyterhub/jupyterhub --namespace jptl --version 0.8.0 --values jupyter-large-config.yaml
```
4. Wait until the hub's state switches into `Running`. Monitor through `kubectl get pods -n jpt` or `kubectl get pods -n jptl`.

## User instructions

1. In your browser go to [https://jupyter-large.cellgeni.sanger.ac.uk](https://jupyter-large.cellgeni.sanger.ac.uk).
2. Use your Github credentials for authentication. It may take some time to load first time.
3. Now you are ready to run your notebooks!

### Resources

At the moment by default every user is given 50GB (guaranteed) to 200GB (maximum, if available) of RAM and 1 (guaranteed) to 16 (maximum, if available) CPUs. Default storage volume is 100G.

~~For special cases, we have https://jupyter-xl.cellgeni.sanger.ac.uk with 150 Gb of RAM, 150 Gb of storage and 4 to 16 CPU, this one is available upon request. ~~

### Important notes

1. **JupyterHub environment and storage are not backed up!!!** Please only use for computations and download your results (and notebooks) afterwards. If you store your data there you can easily lose it. You've been warned!
2. Do not modify files from `data` and `notebooks` folder directly - make a copy, put it in a separate folder and work with a copy. Changes to the original files in the `data` and `notebooks` folders will not survive the server updates.
3. Please read the instructions on package installations below.
4. JupyterHub website is public, so you don't need to turn on VPN to use it. However, it is only available to users who messaged us their Github usernames and have been whitelisted. 
5. You can switch to a classic Jupyter interface by change the word `lab` in your adress bar to the word `tree`:
```
https://jupyter-large.cellgeni.sanger.ac.uk/user/<your-username>/tree
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
### Downloading data

By default, JupyterHub does not provide an ability to download folders, but you can create an archive
```
tar cvfz <some-archive-name.tar> <target-directory>/
```
and download the resulting file with the right click "Download" option.

### Exporting notebooks

To export a notebook as PDF, install the following pre-requisite software:
```
sudo apt update && sudo apt-get install -y texlive-generic-recommended texlive-generic-recommended
```
Now you can export a notebook through "File > Export notebook as..." menu.

### Installing packages (python)

Default conda environments are not persistent across Jupyter sessions - you can install an additional package, but it will not be there next time you start Jupyter. To have a persistent conda environment, you can create one inside your `/home` folder:

1. Open a new terminal (click on the `Terminal` icon in the Launcher)
2. Run the following commands (replace `myenv` with your environment name):

```
conda create --name myenv
source activate myenv

# you must install nb_conda package if you want to use this environment as a Kernel inside your notebook
conda install nb_conda

# conda install all packages you need
# ...
```

(3). Instead of creating a new environment, you can also clone an existing one, e.g.:

```
conda create --clone old_name --name new_name
```

This will eliminate the need to install repeated packages.

4. Reload the main page. Now you will see your new environment in the Launcher.

#### Using pip
pip defaults to installing Python packages to a system directory. To make sure that your packages persist they need to be installed in your home directory use the `--user` option to do this.
```
pip install --user package_name
```

### R and RStudio

R and RStudio are also available on JupyterHub:
- A new R session can be started from the Launcher
- To switch to RStudio interface, change the word `lab` in your adress bar to the word `rstudio`:
```
https://jupyter-large.cellgeni.sanger.ac.uk/user/<your-username>/rstudio
```

### Troubleshooting

Sometimes, a server restart might solve an issue. For that, go to `/hub/home` inside JupyterHub, hit "Stop my server" and reload the page.

* If RStudio displays "[Errno 111] Connection refused", try restarting the server.
* If RStudio displays an error "Rsession did not start in time", go to the `lab` interface, start terminal, and delete the last R session:
  ```
  ls -a .rstudio/sessions/active  # see all active sessions
  rm -r ./rstudio/sessions/active/<session-name>  # note the name of the last active session and delete it
  ```
  and reload RStudio
* If RStudio displays an error "Could not start RStudio in time", it might be because you ran out of disk space. Check your disk usage with `du -ha -d 1 ~`, if the home directory size is close to the limit, you need to delete some files or move to/request a JupyterHub with more space.
