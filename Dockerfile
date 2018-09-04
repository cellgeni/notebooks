FROM quay.io/cellgeni/notebooks-base

# bloody install of igraph required by scanpy...
RUN sudo -H /opt/conda/bin/pip install python-igraph

COPY environments /environments
USER root
RUN for environ in /environments/*; do echo $environ; conda env create --file $environ; done
COPY poststart.sh /
