FROM quay.io/cellgeni/notebooks-base

COPY environments /environments
USER root
RUN for environ in /environments/*; do echo $environ; conda env create --file $environ; done
COPY poststart.sh /
