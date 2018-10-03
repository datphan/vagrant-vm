#! /bin/bash
HOST=$1
USERNAME=$2
PASSWORD=$3
FORCE_LOGIN=$4

if ! [ -f /home/vagrant/.docker/config.json ] || [ $FORCE_LOGIN = "true" ]; then
	echo "force login"
    docker login $HOST -u $USERNAME -p $PASSWORD ; true
else
	if ! [ -n "$(cat /home/vagrant/.docker/config.json | grep $HOST)" ]; then
		docker login $HOST -u $USERNAME -p $PASSWORD ; true
	else
		echo "$HOST exists"
	fi
fi