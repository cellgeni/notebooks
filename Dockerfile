FROM quay.io/cellgeni/notebooks-base

USER root

# install all the new non-base packages here
#

COPY poststart.sh /

USER $NB_UID
