FROM jenkins:latest

USER root
RUN apt-get update && apt-get install -y docker.io maven ruby rake nodejs
USER jenkins

COPY plugins.txt /usr/share/jenkins/ref/
ADD sbt-0.13.8.tgz /usr/local/lib/
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/ref/plugins.txt
#RUN npm install -g ember-cli@2.12.3
