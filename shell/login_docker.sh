#! /bin/bash

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