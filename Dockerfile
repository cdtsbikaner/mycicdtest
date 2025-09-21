FROM centos:7

MAINTAINER "harman@gmail.com"

RUN sed -i  's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*  &&  \
    sed -i  's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g'  /etc/yum.repos.d/CentOS-*

RUN yum install java-devel net-tool netstat vim bind-utils procps -y

COPY Dockerfile  /root/

ADD apache-tomcat-8.5.89.tar.gz  /opt

WORKDIR /opt/apache-tomcat-8.5.89/bin/

EXPOSE 8080 8085 8081 443

CMD ["/opt/apache-tomcat-8.5.89/bin/catalina.sh","run"]
