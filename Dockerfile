FROM quay.io/cellgeni/notebooks-base:29.04-4

USER root

RUN echo "auth-minimum-user-id=0" > /etc/rstudio/rserver.conf
ENV USER=jovyan
# install all the new non-base packages here


COPY poststart.sh /
