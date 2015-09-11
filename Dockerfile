FROM ubuntu:trusty
# Install Oracle Java 7
ENV JAVA_VER 7
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main' >> /etc/apt/sources.list && \
apt-get update && \
echo oracle-java${JAVA_VER}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
apt-get install -y --force-yes --no-install-recommends oracle-java${JAVA_VER}-installer oracle-java${JAVA_VER}-set-default && \
apt-get clean && \
rm -rf /var/lib/apt/lists && \
rm -rf /var/cache/oracle-jdk${JAVA_VER}-installer
RUN apt-get update && \
apt-get install -yq --no-install-recommends wget pwgen ca-certificates && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.63
ENV CATALINA_HOME /tomcat

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
tar zxf apache-tomcat-*.tar.gz && \
rm apache-tomcat-*.tar.gz && \
mv apache-tomcat* tomcat
#RUN chown -R tomcat webapps temp logs work conf
RUN chmod -R 777 tomcat/webapps tomcat/temp tomcat/logs tomcat/work tomcat/conf
#RUN chmod +x tomcat/conf/server.xml

#ADD war file in tomcat webapps
ADD petclinic.war /tomcat/webapps/petclinic.war
ADD run.sh /run.sh
RUN chmod +x /*.sh
EXPOSE 8080
CMD ["/run.sh"]
