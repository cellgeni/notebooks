FROM quay.io/cellgeni/notebooks-base:master

USER root

# install all the new non-base packages here
#
RUN apt update && apt-get install -y libblas-dev
RUN pip install simplegeneric
RUN update-alternatives --install /etc/alternatives/libblas.so.3-x86_64-linux-gnu libblas /usr/lib/x86_64-linux-gnu/blas/libblas.so.3 5
COPY poststart.sh /

# install some github packages
# see here for with_libpaths description:
# https://stackoverflow.com/questions/24646065/how-to-specify-lib-directory-when-installing-development-version-r-packages-from
RUN Rscript -e 'library(devtools); with_libpaths(new = "/usr/lib/R/site-library/", install_github("GreenleafLab/motifmatchr")'

USER $NB_UID
