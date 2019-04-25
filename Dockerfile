FROM quay.io/cellgeni/notebooks-base:master

USER root

RUN echo "auth-minimum-user-id=0" > /etc/rstudio/rsession.conf
# install all the new non-base packages here


COPY poststart.sh /
