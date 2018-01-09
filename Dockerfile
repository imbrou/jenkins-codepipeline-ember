FROM jenkins:latest

USER root
RUN apt-get update && apt-get install -y build-essential maven ruby rake nodejs bzip2

#
# Make jenkins user a no password sudoer
#

RUN apt-get update && \
      apt-get -y install sudo
RUN echo "jenkins:jenkins" | chpasswd && \
      adduser jenkins sudo
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/jenkins

#
# Install node & npm with nvm
#

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# make sure apt is up to date
RUN apt-get update --fix-missing
RUN apt-get install -y curl
RUN sudo apt-get install -y build-essential libssl-dev

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.11.5

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install -g node-sass bower ember-cli@2.12.3 phantomjs-prebuilt phantomjs-polyfill-includes
#RUN npm rebuild node-sass --force


USER jenkins

#RUN sudo ln -s /usr/bin/nodejs /usr/bin/node
#RUN sudo ln -s /usr/lib/node_modules/npm/bin/npm-cli.js /usr/bin/npm
RUN npm rebuild node-sass --force

COPY plugins.txt /usr/share/jenkins/ref/
ADD sbt-0.13.8.tgz /usr/local/lib/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt

RUN node -v
RUN npm -v
RUN bower -v
RUN ember -v
RUN phantomjs -v
