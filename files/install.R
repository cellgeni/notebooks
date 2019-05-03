# CRAN packages
install.packages(c("devtools", "ggplot2", "BiocManager", "Seurat", "rJava"), dependencies = TRUE)
install.packages("Vennerable", repos="http://R-Forge.R-project.org", dependencies = TRUE)
# Bioconductor packages
BiocManager::install(c("SingleCellExperiment",  "Rhdf5lib", "scater", "scran", "monocle", "DESeq2"))
# GitHub packages
devtools::install_github(c("immunogenomics/harmony", "LTLA/beachmat", "MarioniLab/DropletUtils"))
