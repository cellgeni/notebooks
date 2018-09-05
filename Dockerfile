FROM quay.io/cellgeni/notebooks-base

COPY environments /environments
USER root
RUN for environ in /environments/*; do echo $environ; conda env create --file $environ; done
RUN /usr/bin/env bash -c "source activate scanpy-env && pip install python-igraph louvain && source deactivate "; exit 0
COPY poststart.sh /
