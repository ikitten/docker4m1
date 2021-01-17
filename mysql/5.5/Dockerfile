FROM ubuntu:14.04

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r mysql && useradd -r -g mysql mysql

RUN mkdir /docker-entrypoint-initdb.d

# FATAL ERROR: please install the following Perl modules before executing /usr/local/mysql/scripts/mysql_install_db:
# File::Basename
# File::Copy
# Sys::Hostname
# Data::Dumper
RUN apt-get update && apt-get install -y perl --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y mysql-server mysql-client
ENV PATH $PATH:/usr/local/mysql/bin:/usr/local/mysql/scripts

RUN sed -i '0,/key_buffer/s/key_buffer/key_buffer_size/' /etc/mysql/my.cnf && \
	sed -i 's/myisam-recover/myisam-recover-options/' /etc/mysql/my.cnf && \
	rm -rf /var/lib/mysql/mysql

# replicate some of the way the APT package configuration works
# this is only for 5.5 since it doesn't have an APT repo, and will go away when 5.5 does
RUN mkdir -p /etc/mysql/conf.d \
	&& { \
		echo '[mysqld]'; \
		echo 'user = mysql'; \
		echo 'skip-host-cache'; \
		echo 'skip-name-resolve'; \
		echo 'skip-grant-tables'; \
		echo 'bind-address = 0.0.0.0'; \
		echo 'datadir = /var/lib/mysql'; \
	} > /etc/mysql/conf.d/my.cnf

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
