FROM eclipse/ubuntu_jdk8
MAINTAINER Carl Janzen <carl.janzen@gmail.com>
LABEL description="Generic runtime for use with Eclipse Che"

SHELL ["/bin/bash", "--login", "-c"]
ENV HOME /home/user

RUN sudo apt-get update -q && sudo apt-get install -qy \
    autoconf \
    build-essential \
    ca-certificates \
    cadaver \
    curl \
    exiftool \
    exuberant-ctags \
    g++ \
    gcc \ 
    gdb \
    gdbserver \
    git \
    gv \
    imagemagick \
    lftp \
    libssl-dev \
    libtool \
    make \
    mysql-client \
    openssh-server \
    pdftk \
    poppler-utils \
    postgresql-client \
    python-dev \
    python-pip \
    python-virtualenv \
    python3-dev \
    python3-pip \
    qpdf \
    rubber \
    ruby \
    sqlite3 \
    texlive-full \
    unzip \
    && sudo rm -rf /var/lib/apt/lists/*

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
    && curl -L https://get.rvm.io | bash -s stable \
    && source "${HOME}/.rvm/scripts/rvm" \
    && rvm install ruby \
    && sudo rm -rf /var/lib/apt/lists/* \
    && rvm use ruby \
    && gem install \
        awestruct \
        bundler \
        compass

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
        generator-webapp
        grunt \ 
        grunt-cli \
        gulp \
        gulp-cli \
        yeoman-generator \
        yo 

# Indulge a little...
# adapted from: https://github.com/neovim/neovim/wiki/Installing-Neovim
sudo apt-get update \
    && apt-get install -y software-properties-common \
    && sudo add-apt-repository -y ppa:neovim-ppa/unstable \
    && sudo apt-get update \
    && sudo apt-get install -y \
        neovim  \
        tmux \
    && sudo rm -rf /var/lib/apt/lists/* \
    && sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 \
    && sudo update-alternatives --auto vi \
    && sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60 \
    && sudo update-alternatives --auto vim \
    && sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60 \
    && sudo update-alternatives --auto editor 

# set shell back to /bin/sh to reduce surprise
SHELL ["/bin/sh", "-c"]

EXPOSE 22 3000 5000 8000 8080 9000

VOLUME ["/projects"]
WORKDIR /projects

# start sshd and hang
CMD ["sudo", "/usr/sbin/sshd", "-D", "&&", "tail", "-f", "/dev/null"]
