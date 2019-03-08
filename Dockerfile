FROM quay.io/cellgeni/notebooks-base:master

USER root

# install all the new non-base packages here
RUN pip install nbzip && \
    jupyter serverextension enable --py nbzip --sys-prefix && \
    jupyter nbextension install --py nbzip && \
    jupyter nbextension enable --py nbzip


COPY poststart.sh /

USER $NB_UID
