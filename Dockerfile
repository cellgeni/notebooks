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
    libxkbcommon-x11-0 \
    tmux \
    # sshfs dependencies
    fuse libfuse2 sshfs \
    # singularity dependencies
    build-essential libssl-dev uuid-dev libgpgme11-dev squashfs-tools libseccomp-dev pkg-config cryptsetup && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Select the right versio of libblas to be used. 
# There was a problem running R in python and vice versa
RUN pip install --no-cache-dir simplegeneric &&\
    update-alternatives --install /etc/alternatives/libblas.so.3-x86_64-linux-gnu libblas /usr/lib/x86_64-linux-gnu/blas/libblas.so.3 5


# Install RStudio
RUN RSTUDIO_PKG=rstudio-server-1.2.5019-amd64.deb && \
    wget -q https://download2.rstudio.org/server/bionic/amd64/${RSTUDIO_PKG} && \
    dpkg -i ${RSTUDIO_PKG} && \
    rm ${RSTUDIO_PKG}
# Add RStudio to PATH and R and java and conda to LD_LIBRARY_PATH
ENV PATH="${PATH}:/usr/lib/rstudio-server/bin"
ENV LD_LIBRARY_PATH="/usr/lib/R/lib:/lib:/usr/lib/x86_64-linux-gnu:/usr/lib/jvm/default-java/lib/server:/opt/conda/lib/R/lib"


# Install jupyter-server-proxy extension and jupyter-rsession-proxy (nbrsessionproxy from yuvipanda)
RUN pip install --no-cache-dir \
        jupyter-server-proxy \
        https://github.com/yuvipanda/nbrsessionproxy/archive/rserver-again.zip && \
    jupyter serverextension enable --sys-prefix jupyter_server_proxy


# R
# https://cran.r-project.org/bin/linux/ubuntu/README.html
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    echo "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -c | awk '{print $2}')-cran40/" | sudo tee -a /etc/apt/sources.list && \
    add-apt-repository ppa:c2d4u.team/c2d4u4.0+ && \
    apt-get update && apt-get install -yq --no-install-recommends \
        r-base \
        r-base-dev \
    && apt-get clean \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
    rm -rf /var/lib/apt/lists/*
# Install hdf5r for Seurat and IRkernel to run R code in jupyetr lab
RUN Rscript -e "install.packages('hdf5r',configure.args='--with-hdf5=/usr/bin/h5cc')" && \
    Rscript -e "install.packages('IRkernel')"

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


# PYTHON
# Install mostly used python packages
RUN pip --no-cache install --upgrade \
        scanpy \
        python-igraph \
        louvain \
        bbknn \
        rpy2 \
        pandas \
        tzlocal \
        scvelo \
        leidenalg \
        ipykernel \
        ipywidgets \
        nbresuse
# Install scanorama
RUN cd /tmp && \
    git clone https://github.com/brianhie/scanorama.git && \
    cd scanorama/ && \
    python setup.py install && \
    rm -rf /tmp/scanorama


# JULIA
ENV JULIA_VERSION=1.4.2
ENV JULIA_PKGDIR=/opt/julia
# Install Julia packages in /opt/julia instead of $HOME
ENV JULIA_DEPOT_PATH=/opt/julia
RUN mkdir /opt/julia-${JULIA_VERSION} && \
    cd /tmp && \
    wget -q https://julialang-s3.julialang.org/bin/linux/x64/`echo ${JULIA_VERSION} | cut -d. -f 1,2`/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    wget -q https://julialang-s3.julialang.org/bin/checksums/julia-${JULIA_VERSION}.sha256 && \
    echo "$(cat julia-${JULIA_VERSION}.sha256 | grep linux-x86_64 | awk '{print $1}') *julia-${JULIA_VERSION}-linux-x86_64.tar.gz" | sha256sum --check --status && \
    tar xzf julia-${JULIA_VERSION}-linux-x86_64.tar.gz -C /opt/julia-${JULIA_VERSION} --strip-components=1 && \
    rm /tmp/julia-${JULIA_VERSION}.sha256 && \
    rm /tmp/julia-${JULIA_VERSION}-linux-x86_64.tar.gz && \
    ln -fs /opt/julia-*/bin/julia /usr/local/bin/julia && \
    # show Julia where conda libraries are \
    mkdir /etc/julia && \
    echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" >> /etc/julia/juliarc.jl && \
    mkdir $JULIA_PKGDIR && \
    chown $NB_USER $JULIA_PKGDIR && \
    fix-permissions $JULIA_PKGDIR

# Fix permissions
RUN fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER 

USER $NB_UID

RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add("IJulia")' && \
    julia -e 'using IJulia'
    
# Add Julia packages. Only add HDF5 if this is not a test-only build since
# it takes roughly half the entire build time of all of the images on Travis
# to add this one package and often causes Travis to timeout.
#
# Install IJulia as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
    # (test $TEST_ONLY_BUILD || julia -e 'import Pkg; Pkg.add("HDF5")') && \
    # julia -e 'import Pkg; Pkg.add("Gadfly")' && \
    # julia -e 'import Pkg; Pkg.add("RDatasets")' && \
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

USER root

# Move kernelspec out of home
RUN mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local && \
    fix-permissions $JULIA_PKGDIR $CONDA_DIR/share/jupyter

# Install GO
RUN VERSION=1.14 OS=linux ARCH=amd64 && \
    cd /tmp && wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz && \
    tar -C /usr/local -xzf go$VERSION.$OS-$ARCH.tar.gz && \
    rm go$VERSION.$OS-$ARCH.tar.gz
ENV GOPATH=/home/jovyan/.go
ENV PATH=/usr/local/go/bin:$PATH:$GOPATH/bin

# Install singularity
RUN VERSION=3.6.0 && \
    cd /tmp && \
    wget https://github.com/sylabs/singularity/releases/download/v$VERSION/singularity-$VERSION.tar.gz && \
    tar -xzf singularity-$VERSION.tar.gz && \
    rm singularity-$VERSION.tar.gz && \
    cd singularity && \
    ./mconfig && \
    make -C builddir && \
    make -C builddir install && \
    rm -rf /tmp/singularity

# Install rclone
RUN cd /tmp && \
    wget https://downloads.rclone.org/rclone-current-linux-amd64.deb && \
    apt-get install -y /tmp/rclone-current-linux-amd64.deb && \
    rm /tmp/rclone-current-linux-amd64.deb


# Give jovyan sudo permissions
RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
    echo "jovyan ALL= (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/jovyan

# Copy template notebooks to the image
COPY files/data /home/jovyan/data
COPY files/notebooks /home/jovyan/notebooks

# Copy mount script
COPY mount-farm /usr/local/bin/mount-farm
RUN chmod +x /usr/local/bin/mount-farm

# Copy poststart script
COPY poststart.sh /
