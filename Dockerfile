FROM quay.io/cellgeni/notebooks-base:master

USER root

# install all the new non-base packages here

RUN apt-get update && apt-get install -yq --no-install-recommends \
    r-cran-rmpi \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'source("https://bioconductor.org/biocLite.R")' > /opt/bioconductor.r && \
    echo 'biocLite()' >> /opt/bioconductor.r && \
    echo 'biocLite("ccfindR")' >> /opt/bioconductor.r && \
    Rscript /opt/bioconductor.r

COPY poststart.sh /

USER $NB_UID
