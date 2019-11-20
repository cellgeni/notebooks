# Distributed under the terms of the Modified BSD License.
FROM jupyter/base-notebook

USER root

# GENERAL PACKAGES

RUN apt-get update && apt-get install -yq --no-install-recommends \
    python3-software-properties \
    software-properties-common \
    apt-utils \
    gnupg2 \
    fonts-dejavu \
    tzdata \
    gfortran \
    curl \
    less \
    gcc \
    g++ \
    clang-6.0 \
    openssh-client \
    openssh-server \
    cmake \
    python-dev \
    libgsl-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libxml2 \
    libxml2-dev \
    libapparmor1 \
    libedit2 \
    libhdf5-dev \
    libclang-dev \
    lsb-release \
    psmisc \
    rsync \
    vim \
    default-jdk \
    libbz2-dev \
    libpcre3-dev \
    liblzma-dev \
    zlib1g-dev \
    xz-utils \
    liblapack-dev \
    libopenblas-dev \
    libigraph0-dev \
    libreadline-dev \
    libblas-dev \
    libtiff5-dev \
    fftw3-dev \
    git \
    texlive-xetex \
    hdf5-tools \
    libffi-dev \
    gettext \
    libpng-dev \
    libpixman-1-0 \ 
    fuse libfuse2 sshfs \
    libxkbcommon-x11-0 \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Select the right versio of libblas to be used
# there was a problem running R in python and vice versa
RUN pip install simplegeneric
RUN update-alternatives --install /etc/alternatives/libblas.so.3-x86_64-linux-gnu libblas /usr/lib/x86_64-linux-gnu/blas/libblas.so.3 5

# RStudio
ENV RSTUDIO_PKG=rstudio-server-1.2.5019-amd64.deb
RUN wget -q https://download2.rstudio.org/server/bionic/amd64/${RSTUDIO_PKG}
RUN dpkg -i ${RSTUDIO_PKG}
RUN rm ${RSTUDIO_PKG}
# The desktop package uses /usr/lib/rstudio/bin
ENV PATH="${PATH}:/usr/lib/rstudio-server/bin"
ENV LD_LIBRARY_PATH="/usr/lib/R/lib:/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/server:/opt/conda/lib/R/lib"

# Shine Server
RUN wget -q "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb" -O shiny-server-latest.deb
RUN dpkg -i shiny-server-latest.deb
RUN rm -f shiny-server-latest.deb

# jupyter-server-proxy extension
RUN pip install jupyter-server-proxy
# use yuvipanda verion of jupyter-rsession-procy (nbrsessionproxy)
RUN pip install https://github.com/yuvipanda/nbrsessionproxy/archive/rserver-again.zip
RUN jupyter serverextension enable --sys-prefix jupyter_server_proxy

# R PACKAGES

# R
# https://askubuntu.com/questions/610449/w-gpg-error-the-following-signatures-couldnt-be-verified-because-the-public-k
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
# https://cran.r-project.org/bin/linux/ubuntu/README.html
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/" | sudo tee -a /etc/apt/sources.list
# https://launchpad.net/~marutter/+archive/ubuntu/c2d4u3.5
RUN add-apt-repository ppa:marutter/c2d4u3.5
# Install CRAN binaries from ubuntu
RUN apt-get update && apt-get install -yq --no-install-recommends \
    r-base \
    # r-cran-httpuv \
    && apt-get clean \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    rm -rf /var/lib/apt/lists/*
# Install hdf5r for Seurat
RUN Rscript -e 'install.packages("hdf5r",configure.args="--with-hdf5=/usr/bin/h5cc")'
# Install other CRAN
# RUN Rscript -e 'install.packages(c("devtools", "ggplot2", "BiocManager", "Seurat", "rJava"))'
# Install Bioconductor packages
# RUN Rscript -e 'BiocManager::install(c("SingleCellExperiment",  "Rhdf5lib", "scater", "scran", "monocle", "DESeq2"))'
# Install Vennerable for Venn diagrams
# RUN Rscript -e 'install.packages("Vennerable", repos="http://R-Forge.R-project.org")'
# install github packages
# see here for with_libpaths description:
# https://stackoverflow.com/questions/24646065/how-to-specify-lib-directory-when-installing-development-version-r-packages-from
# (do not install anything in the home directory, it will be wiped out when a volume is mounted to the docker container)
# RUN Rscript -e 'withr::with_libpaths(new = "/usr/lib/R/site-library/", devtools::install_github(c("immunogenomics/harmony", "LTLA/beachmat", "MarioniLab/DropletUtils")))'
# create local R library

# PYTHON PACKAGES

# Install scanpy and other python packages
RUN pip install scanpy python-igraph louvain bbknn rpy2 tzlocal scvelo leidenalg
# Try to fix rpy2 problems
# https://stackoverflow.com/questions/54904223/importing-rds-files-in-python-to-be-read-as-a-dataframe
RUN pip install --upgrade rpy2 pandas
# scanorama
RUN git clone https://github.com/brianhie/scanorama.git
RUN cd scanorama/ && python setup.py install
# necessary for creating user environments 
RUN conda install --quiet --yes nb_conda_kernels

# JULIA PACKAGES

# Julia dependencies
# install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia
ENV JULIA_PKGDIR=/opt/julia
ENV JULIA_VERSION=1.0.0

RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    echo "bea4570d7358016d8ed29d2c15787dbefaea3e746c570763e7ad6040f17831f3 *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum -c - && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz
RUN ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia

# Show Julia where conda libraries are \
RUN mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    # Create JULIA_PKGDIR \
    mkdir $JULIA_PKGDIR && \
    chown $NB_USER $JULIA_PKGDIR && \
    fix-permissions $JULIA_PKGDIR

# Fix permissions
RUN conda clean -tipsy && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

USER $NB_UID

# Add Julia packages. Only add HDF5 if this is not a test-only build since
# it takes roughly half the entire build time of all of the images on Travis
# to add this one package and often causes Travis to timeout.
#
# Install IJulia as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'import Pkg; Pkg.update()' && \
    # (test $TEST_ONLY_BUILD || julia -e 'import Pkg; Pkg.add("HDF5")') && \
    # julia -e 'import Pkg; Pkg.add("Gadfly")' && \
    # julia -e 'import Pkg; Pkg.add("RDatasets")' && \
    julia -e 'import Pkg; Pkg.add("IJulia")' && \
    # julia -e 'import Pkg; Pkg.add("Distances")' && \
    # julia -e 'import Pkg; Pkg.add("StatsBase")' && \
    # julia -e 'import Pkg; Pkg.add("Hadamard")' && \
    # julia -e 'import Pkg; Pkg.add("JLD")' && \
    # julia -e 'import Pkg; Pkg.add("StatsBase")' && \
    # julia -e 'import Pkg; Pkg.add("Statistics")' && \
    # julia -e 'import Pkg; Pkg.add("Embeddings")' && \
    # julia -e 'import Pkg; Pkg.add("DataFrames")' && \
    # julia -e 'import Pkg; Pkg.add("GLM")' && \
    # julia -e 'import Pkg; Pkg.add("LsqFit")' && \
    # julia -e 'import Pkg; Pkg.add("Combinatorics")' && \
    # julia -e 'import Pkg; Pkg.add("Cairo")' && \
    # Precompile Julia packages \
    julia -e 'using IJulia'

USER root

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt update
RUN apt install -y docker-ce

# move kernelspec out of home
RUN mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter

# MAKE DEFAULT USER SUDO

# give jovyan sudo permissions
RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers
RUN echo "jovyan ALL= (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/jovyan

# copy template notebooks to the image
COPY files/data /home/jovyan/data
COPY files/notebooks /home/jovyan/notebooks

# copy mount script
COPY mount-farm.sh /

# copy poststart script
COPY poststart.sh /
