FROM jenkins/jenkins
USER root
EXPOSE 8080
RUN apt-get update
USER jenkins