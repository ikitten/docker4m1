FROM ubuntu:20.04

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# RUN groupadd -r hadoop && useradd -r -m -g hadoop hadoop -s /bin/bash

RUN mkdir /docker-entrypoint-initdb.d

RUN apt-get update && apt-get install -y openssh-server 
#RUN apt-get install -y vim

RUN mkdir /root/.ssh 							\
	&& ssh-keygen -t rsa -N '' -f /root/.ssh/id_rsa			\
	&& cat /root/.ssh/id_rsa.pub > /root/.ssh/authorized_keys	\
	&& echo "StrictHostKeyChecking no" > /etc/ssh/ssh_config.d/hadoop.conf

COPY jdk-8u271-linux-aarch64.tar.gz hadoop-3.3.0-aarch64.tar.gz /root

RUN for tar in /root/*.tar.gz; do tar -zxvf $tar -C /usr/local; done &&	\
	cd /usr/local && mv hadoop-3.3.0 hadoop && 			\
	mkdir -p /usr/local/hadoop/dfs &&				\
	mkdir -p /usr/local/hadoop/logs &&				\
	rm -rf /root/*

# config java and hadoop
RUN { \
	echo ''; 						\
	echo 'export JAVA_HOME=/usr/local/jdk1.8.0_271'; 	\
	echo 'export JRE_HOME=$JAVA_HOME/jre'; 			\
	echo 'export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib'; \
	echo 'export PATH=$JAVA_HOME/bin:$PATH'; 		\
	echo ''; 						\
	echo 'export HADOOP_PATH=/usr/local/hadoop';		\
	echo 'export PATH=$PATH:$HADOOP_PATH/bin:$HADOOP_PATH/sbin';\
} >> /etc/bash.bashrc 

RUN sed -i '1 i\
export HDFS_NAMENODE_USER=root;			\n\
export HDFS_DATANODE_USER=root;			\n\
export HDFS_SECONDARYNAMENODE_USER=root;	\n\
export YARN_NODEMANAGER_USER=root;		\n\
export YARN_RESOURCEMANAGER_USER=root;		\n\
export JAVA_HOME=/usr/local/jdk1.8.0_271;	\n\
' /usr/local/hadoop/etc/hadoop/hadoop-env.sh

COPY etc/hadoop/* /usr/local/hadoop/etc/hadoop/ 

VOLUME /usr/local/hadoop/dfs

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

# EXPOSE 3306
CMD ["slave"]
