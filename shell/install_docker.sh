#! /bin/bash

# install docker if not exists
if ! [ -x "$(command -v docker)" ]; then
  apt-get update
  apt-get install -y \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  add-apt-repository \
     "deb https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
     $(lsb_release -cs) \
     stable"
  apt-get update && apt-get install -y docker-ce

  # add group
  sudo usermod -a -G docker vagrant

  docker --version
fi

# install docker-compose if not exists
if ! [ -x "$(command -v docker-compose)" ]; then
  sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

  sudo chmod +x /usr/local/bin/docker-compose

  docker-compose --version
fi
