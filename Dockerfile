FROM openjdk:8-jdk-alpine

LABEL maintainer="hartwig.bertrand@gmail.com"
LABEL description="Tomcat 8 jdk 8 root less"

# Upgrade base image
RUN apk update
RUN apk upgrade
RUN apk cache clean

# Create a tomcat group and user 
RUN addgroup -S tomcat && adduser -S tomcat -G tomcat -h /home/tomcat
USER tomcat

# download tomcat 8
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.98/bin/apache-tomcat-8.5.98.zip -P /home/tomcat/ \
    && unzip /home/tomcat/apache-tomcat-8.5.98.zip -d /home/tomcat/ \
    && rm /home/tomcat/apache-tomcat-8.5.98.zip \
    && mv /home/tomcat/apache-tomcat-8.5.98 /home/tomcat/apache-tomcat

# remove all default webapps
RUN rm -rf /home/tomcat/apache-tomcat/webapps/*

# todo : remove tomcat version on http errors

RUN chmod +x /home/tomcat/apache-tomcat/bin/*.sh
RUN export CATALINA_BASE=/home/tomcat/apache-tomcat
RUN export CATALINA_HOME=/home/tomcat/apache-tomcat

EXPOSE 8080:8080

CMD /home/tomcat/apache-tomcat/bin/catalina.sh run
