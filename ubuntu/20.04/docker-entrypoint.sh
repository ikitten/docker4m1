#!/bin/bash
set -e

/etc/init.d/ssh start

HADOOP_PATH=/usr/local/hadoop

if [ "$1" = 'master' ]; then
	sleep 10
	echo 'Running master'
	if [ ! -d "$HADOOP_PATH/dfs/name" ]; then
		echo 'Hadoop init process in progress...'

		$HADOOP_PATH/bin/hdfs namenode -format

		echo
		echo 'Hadoop init process done. Ready for start up.'
		echo
	fi

	for f in /docker-entrypoint-initdb.d/*; do
		case "$f" in
			*.sh)  echo "$0: running $f"; . "$f" ;;
			#*.sql) echo "$0: running $f"; "${mysql[@]}" < "$f" && echo ;;
			*)     echo "$0: ignoring $f" ;;
		esac
		echo
	done

	$HADOOP_PATH/sbin/start-all.sh
fi

while : ; do sleep 1; done