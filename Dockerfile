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
# (do not install anything in the home directory, it will be wiped out when a volume is mounted to the docker container)
RUN apt-get update && apt-get install -yq --no-install-recommends r-cran-withr
RUN Rscript -e 'withr::with_libpaths(new = "/usr/lib/R/site-library/", devtools::install_github("GreenleafLab/motifmatchr"))'

USER $NB_UID
