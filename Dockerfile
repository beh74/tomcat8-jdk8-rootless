FROM alpine:3.19

LABEL maintainer="hartwig.bertrand@gmail.com"
LABEL description="Tomcat 8 jdk 8 root less"

# Update Alpine and install openjdk8
RUN apk update && apk upgrade && apk add --no-cache openjdk8 && apk cache clean && rm -rf /var/cache/apk/*

# Create a tomcat group and user 
RUN addgroup -S tomcat && adduser -S tomcat -G tomcat -h /home/tomcat
USER tomcat

# download and install tomcat 8
RUN wget https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.99/bin/apache-tomcat-8.5.99.zip -P /home/tomcat/ \
    && unzip /home/tomcat/apache-tomcat-8.5.99.zip -d /home/tomcat/ \
    && rm /home/tomcat/apache-tomcat-8.5.99.zip \
    && mv /home/tomcat/apache-tomcat-8.5.99 /home/tomcat/apache-tomcat \
    && rm -rf /home/tomcat/apache-tomcat/webapps/* \
    && chmod +x /home/tomcat/apache-tomcat/bin/*.sh

RUN export CATALINA_BASE=/home/tomcat/apache-tomcat
RUN export CATALINA_HOME=/home/tomcat/apache-tomcat

EXPOSE 8080:8080

CMD /home/tomcat/apache-tomcat/bin/catalina.sh run
