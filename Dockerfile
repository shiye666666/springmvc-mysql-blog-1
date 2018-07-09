# Dockerfile to create hcpaas-web docker image
# Base image
FROM centos:latest

# install tools
RUN yum install git java-1.8.0-openjdk-devel maven -y

# install tomcat

ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV TOMCAT_VERSION 8.0.53
RUN mkdir -p "$CATALINA_HOME"
RUN cd /root && curl -o apache-tomcat.tar.gz http://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-8/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz && tar -zxvf apache-tomcat.tar.gz && mv /root/apache-tomcat-$TOMCAT_VERSION/* /usr/local/tomcat/ && rm -rf /usr/local/tomcat/webapps/* && rm -rf apache-tomcat*

# springmvc-mysql-blog
RUN mkdir /root/springmvc-mysql-blog
COPY pom.xml /root/springmvc-mysql-blog
COPY ./src /root/springmvc-mysql-blog/src

# mvn and move to tomcat
#RUN cd /root/springmvc-mysql-blog && mvn package -Dmaven.test.skip=true && cp target/blog.war /usr/local/tomcat/webapps/ROOT.war

COPY blog.war /usr/local/tomcat/webapps/ROOT.war
RUN chown -R 1001:0 /usr/local/tomcat && chmod -R ug+rw /usr/local/tomcat

USER 1001

#
WORKDIR $CATALINA_HOME
EXPOSE 8080
CMD ["catalina.sh", "run"]
