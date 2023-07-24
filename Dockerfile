FROM alpine:3.18.2

LABEL maintainer="hartwig.bertrand@gmail.com"
LABEL description="Tomcat 8 jdk 8 root less"

# install jdk17
RUN apk update
RUN apk upgrade
RUN apk add --no-cache openjdk8
RUN apk cache clean

# Create a tomcat group and user 
RUN addgroup -S tomcat && adduser -S tomcat -G tomcat -h /home/tomcat
USER tomcat

# download tomcat 8
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.91/bin/apache-tomcat-8.5.91.zip -P /home/tomcat/
RUN unzip /home/tomcat/apache-tomcat-8.5.91.zip -d /home/tomcat/
RUN rm /home/tomcat/apache-tomcat-8.5.91.zip
RUN mv /home/tomcat/apache-tomcat-8.5.91 /home/tomcat/apache-tomcat

# remove all default webapps
RUN rm -rf /home/tomcat/apache-tomcat/webapps/*

# todo : remove tomcat version on http errors

RUN chmod +x /home/tomcat/apache-tomcat/bin/*.sh
RUN export CATALINA_BASE=/home/tomcat/apache-tomcat
RUN export CATALINA_HOME=/home/tomcat/apache-tomcat

EXPOSE 8080:8080

CMD /home/tomcat/apache-tomcat/bin/catalina.sh run