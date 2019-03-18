FROM quay.io/cellgeni/notebooks-base:master
RUN pip install nbresuse
ENV MEM_LIMIT=100000000000
USER root

# install all the new non-base packages here


COPY poststart.sh /

USER $NB_UID
