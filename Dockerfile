FROM eclipse/ubuntu_jdk8
MAINTAINER Carl Janzen <carl.janzen@gmail.com>
LABEL description="Generic runtime for use with Eclipse Che"

SHELL ["/bin/bash", "--login", "-c"]
ENV HOME /home/user

RUN sudo apt-get update -q && sudo apt-get install -qy \
    autoconf \
    build-essential \
    ca-certificates \
    curl \
    git \
    make \
    python-dev \
    python-pip \
    python-virtualenv \
    python3-dev \
    python3-pip \
    unzip \
    && sudo rm -rf /var/lib/apt/lists/*

ENV NVM_CLONE_DIR ${HOME}/.nvm
RUN git clone https://github.com/creationix/nvm.git /home/user/.nvm \
    && cd /home/user/.nvm \
    && git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" origin` \
    && source /home/user/.nvm/nvm.sh \
    && nvm install node \
    && nvm use node \
    && npm install -g \
        bower \
        generator-angular \
        generator-karma \
        generator-webapp \
        grunt \ 
        grunt-cli \
        gulp \
        gulp-cli \
        yeoman-generator \
        yo 

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
    && curl -L https://get.rvm.io | bash -s stable \
    && source "${HOME}/.rvm/scripts/rvm" \
    && rvm install ruby \
    && sudo rm -rf /var/lib/apt/lists/* \
    && rvm use ruby \
    && gem install \
        bundler \
        compass

SHELL ["/bin/sh", "-c"]

EXPOSE 22 3000 5000 8000 8080 9000

VOLUME ["/projects"]
WORKDIR /projects

