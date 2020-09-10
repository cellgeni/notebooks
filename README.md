# CellGen Programme Template Notebooks

Jupyter allows you to run your analysis in multiple environments (R, Python, Julia, etc.) and also to create and share notebooks containing your analysis, code, equations and visualizations. This repository provides example notebooks that help users start using JupyterHub and perform different kinds of analysis.

## Python notebooks

- **[scanpy notebook for analysis of 10X data](https://github.com/cellgeni/notebooks/blob/master/notebooks/10X-scanpy.ipynb)** Allows to reproduce most of Seurat's standard clustering tutorial on python.
- **[Batch correction using Python (scanpy) tools](https://github.com/cellgeni/notebooks/blob/master/notebooks/10X-batch-correction-bbknn-scanorama.ipynb)** Template notebook for batch correction of 10X data using BBKNN and scanorama tools.

## R notebooks

- **[Seurat notebook for analysis of 10X data](https://github.com/cellgeni/notebooks/blob/master/notebooks/10X-Seurat.Rmd)** Shows how to perform analysis using Seurat v3.
- **[Batch correction using R tools](https://github.com/cellgeni/notebooks/blob/master/notebooks/10X-batch-correction-harmony-mnn-cca-other.Rmd)** Template notebook for batch correction of 10X data using Harmony, mnnCorrect, multiCCA, Combat and limma tools.
- **[monocle3 example](https://github.com/cellgeni/notebooks/blob/master/notebooks/monocle3%20example.Rmd)**

## Environment

We support a Jupyter Hub server running on Sanger Cloud. All programme notebooks can run on the [Cellular Genetics Informatics JupyterHub](https://cellgeni.readthedocs.io/en/latest/jupyterhub.html)

Alternatively, you can run them using the our [docker image](https://github.com/cellgeni/docker-jupyter).
