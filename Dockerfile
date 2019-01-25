FROM quay.io/cellgeni/notebooks-base:master

USER root

# install all the new non-base packages here
#
RUN apt update && apt-get install -y libblas-dev
RUN pip install simplegeneric
RUN update-alternatives --install /etc/alternatives/libblas.so.3-x86_64-linux-gnu libblas /usr/lib/x86_64-linux-gnu/blas/libblas.so.3 5
COPY poststart.sh /

USER $NB_UID
