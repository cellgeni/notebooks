FROM quay.io/cellgeni/notebooks-base:master

USER root

# install all the new non-base packages here
#
RUN sudo update-alternatives --set libblas.so.3 /usr/lib/openblas-base/libblas.so.3
COPY poststart.sh /

USER $NB_UID
