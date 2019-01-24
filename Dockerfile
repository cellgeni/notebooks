FROM quay.io/cellgeni/notebooks-base:master

USER root

# install all the new non-base packages here
#
# RUN sudo add-apt-repository universe && \
# sudo add-apt-repository main && \
# sudo apt update && apt-get install -y  libatlas-base-dev liblapack-dev libblas-dev
COPY poststart.sh /
