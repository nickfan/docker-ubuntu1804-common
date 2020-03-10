FROM ubuntu:18.04

MAINTAINER Nick Fan "nickfan81@gmail.com"

ARG MIRROR_CN=true
ENV MIRROR_CN ${MIRROR_CN}
RUN if [ ${MIRROR_CN} = true ]; then \
  echo "Change Source to China Mirror Site." \
  ;fi

RUN echo ${MIRROR_CN}

RUN if [ ${MIRROR_CN} = true ]; then \
  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list \
  ;fi

#####################################
# Set Timezone
#####################################

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#RUN dpkg --add-architecture i386
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && apt-get install --assume-yes apt-utils -y apt-utils sudo apt-transport-https ca-certificates curl wget zsh bzip2 unzip p7zip unrar-free git-core mercurial gnupg2 locales build-essential software-properties-common python-dev linuxbrew-wrapper wget nano fonts-powerline ntp ntpdate libxml2-dev libxslt1-dev libssl-dev libffi-dev gcc g++ make cmake autoconf automake patch gdb libtool cpp pkg-config libc6-dev libncurses-dev sqlite sqlite3 openssl unixodbc pkg-config re2c \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
#RUN rm -rf /var/lib/apt/lists/* 

RUN mkdir -p ~/setup

ARG INSTALL_BASE_KIT=true
ENV INSTALL_BASE_KIT ${INSTALL_BASE_KIT}
RUN if [ ${INSTALL_BASE_KIT} = true ]; then \
  apt-get install --assume-yes apt-utils -y wget curl nano autojump vim lsof ctags vim-doc vim-scripts ed gawk screen tmux valgrind graphviz graphviz-dev xsel xclip mc urlview tree tofrodos proxychains socat zhcon lrzsz mc htop iftop iotop nethogs dstat multitail tig jq ncdu glances ranger silversearcher-ag \
  ;fi

ARG INSTALL_BASE_LIB=true
ENV INSTALL_BASE_LIB ${INSTALL_BASE_LIB}
RUN if [ ${INSTALL_BASE_LIB} = true ]; then \
  apt-get install --assume-yes apt-utils -y libbz2-dev libexpat1-dev libghc-gnutls-dev libsecret-1-dev libgconf2-4 libdb-dev libgmp3-dev zlib1g-dev linux-libc-dev libcurl4-gnutls-dev libgudev-1.0-dev uuid-dev libpng-dev libjpeg-dev libfreetype6-dev libssh-dev libssh2-1-dev libpcre3-dev libpcre++-dev libmhash-dev libmcrypt-dev libltdl7-dev mcrypt libiconv-hook-dev libsqlite-dev libgettextpo0 libwrap0-dev libreadline-dev \
  ;fi

RUN if [ ${INSTALL_BASE_KIT} = true ]; then \
  wget https://github.com/sharkdp/fd/releases/download/v7.4.0/fd_7.4.0_amd64.deb && \
  dpkg -i fd_7.4.0_amd64.deb && \
  rm -rf fd_7.4.0_amd64.deb \
  ;fi

RUN if [ ${INSTALL_BASE_KIT} = true ]; then \
  wget https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb && \
  dpkg -i ripgrep_11.0.2_amd64.deb && \
  rm -rf ripgrep_11.0.2_amd64.deb \
  ;fi

RUN if [ ${INSTALL_BASE_KIT} = true ]; then \
  wget https://github.com/sharkdp/bat/releases/download/v0.12.1/bat_0.12.1_amd64.deb && \
  dpkg -i bat_0.12.1_amd64.deb && \
  rm -rf bat_0.12.1_amd64.deb \
  ;fi

ARG INSTALL_ZSH=true
ENV INSTALL_ZSH ${INSTALL_ZSH}
ENV TERM xterm-256color
ENV ZSH_THEME ys
RUN if [ ${INSTALL_ZSH} = true ]; then \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
  ;fi

RUN if [ ${INSTALL_ZSH} = true ]; then \
  chsh -s $(which zsh) \
  ;fi

ARG INSTALL_PYTHON3=true
ENV INSTALL_PYTHON3 ${INSTALL_PYTHON3}
RUN if [ ${INSTALL_PYTHON3} = true ]; then \
    apt-get install --assume-yes apt-utils -y python3 python3-dev python3-pip python3-setuptools python3-lxml python3-venv python3-wheel python3-cffi \
  ;fi

RUN if [ ${INSTALL_PYTHON3} = true ] && [ ${MIRROR_CN} != true ]; then \
  pip3 install --upgrade pip setuptools \
  ;fi

RUN if [ ${INSTALL_PYTHON3} = true ] && [ ${MIRROR_CN} = true ]; then \
  pip3 install -i https://mirrors.aliyun.com/pypi/simple/ --upgrade pip setuptools; \
  pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
  ;fi

RUN if [ ${INSTALL_PYTHON3} = true ]; then \
  pip3 install --upgrade pqi \
  ;fi

RUN if [ ${INSTALL_PYTHON3} = true ]; then \
  pip3 install --upgrade pipreqs virtualenv autoenv pipenv requests requests-html \
  ;fi


ARG INSTALL_NODEJS=true
ENV INSTALL_NODEJS ${INSTALL_NODEJS}
RUN if [ ${INSTALL_NODEJS} = true ]; then \
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - ; \
    apt-get install --assume-yes apt-utils -y nodejs; \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - ; \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list ; \
    apt update && apt install --assume-yes apt-utils -y yarn \
  ;fi

RUN if [ ${INSTALL_NODEJS} = true ] && [ ${MIRROR_CN} = true ]; then \
  npm config set registry https://registry.npm.taobao.org ; \
  yarn config set registry https://registry.npm.taobao.org; \
  npm install -g cnpm cyarn nrm yrm n --registry=https://registry.npm.taobao.org \
  ;fi

RUN if [ ${INSTALL_NODEJS} = true ]; then \
    npm install -g typescript \
  ;fi

ARG INSTALL_VIM=true
ENV INSTALL_VIM ${INSTALL_VIM}
RUN if [ ${INSTALL_VIM} = true ]; then \
  add-apt-repository ppa:neovim-ppa/stable && apt-get update && apt-get install --assume-yes apt-utils -y vim-nox neovim python3-neovim xxd && \
  apt-get install --assume-yes apt-utils -y --reinstall wamerican && \
  pip3 install jedi; \
  update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60; \
  update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60; \
  update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60 \
  ; fi

ARG INSTALL_FONTS=true
ENV INSTALL_FONTS ${INSTALL_FONTS}
RUN if [ ${INSTALL_FONTS} = true ]; then \
  apt-get install --assume-yes apt-utils -y fonts-powerline && \
  mkdir -p ~/.local/share/fonts && \
  cd ~/.local/share/fonts && \
  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.0.0/Hack.zip && \
  unzip Hack.zip; \
  fc-cache -vf \
  ; fi

RUN if [ ${INSTALL_VIM} = true ]; then \
  curl -sLf https://spacevim.org/install.sh | bash \
  ; fi

RUN touch ~/.z

COPY home/ /root/

CMD [ "zsh" ]
