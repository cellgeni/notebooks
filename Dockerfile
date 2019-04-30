FROM quay.io/cellgeni/notebooks-base:29.04-4

USER root

# RUN echo "auth-minimum-user-id=0" > /etc/rstudio/rserver.conf
# install all the new non-base packages here
RUN sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers

RUN echo "jovyan ALL= (ALL) NOPASSWD: ALL" >> /etc/sudoers.d/jovyan

COPY poststart.sh /
