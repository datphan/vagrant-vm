#! /bin/bash

RESTART_POLICY=${RESTART_POLICY:-no}
NAME=${NAME:-'vagrant-proxy'}

# docker is excutable
if [ -x "$(command -v docker)" ]; then
  # docker with $NAME is not running
  if [ -z "$(docker container ls | grep $NAME)" ]; then
    docker run --name $NAME $PORT $VOLUMES --restart=$RESTART_POLICY -d $IMAGE
  else
    docker stop $NAME && docker rm -f $NAME
  fi
fi
