FROM openjdk:7

MAINTAINER vpimpinella

ENV ZOOKEEPER_VERSION 3.4.14

RUN apt-get update; apt-get install -y supervisor openssh-server
RUN echo 'root:enzo' | chpasswd
RUN mkdir /var/run/sshd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config


#Download Zookeeper
RUN wget -q http://mirror.vorboss.net/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz

#Install
RUN tar -xzf zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C /opt

#Configure
RUN mv /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo_sample.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg

#ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-armhf
ENV ZK_HOME /opt/zookeeper-${ZOOKEEPER_VERSION}
RUN sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data

ADD start-zk.sh /usr/bin/start-zk.sh 
EXPOSE 2181 2888 3888 22

WORKDIR /opt/zookeeper-${ZOOKEEPER_VERSION}
VOLUME ["/opt/zookeeper-${ZOOKEEPER_VERSION}/conf", "/opt/zookeeper-${ZOOKEEPER_VERSION}/data"]

CMD /usr/sbin/sshd && bash /usr/bin/start-zk.sh
