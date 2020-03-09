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
RUN apt-get update && apt-get upgrade -y && apt-get install --assume-yes apt-utils -y apt-transport-https ca-certificates curl zsh git gnupg2 locales build-essential software-properties-common python-dev libxml2-dev libxslt1-dev libssl-dev libffi-dev \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
#RUN rm -rf /var/lib/apt/lists/* 

ARG INSTALL_BASE_LIB=true
ENV INSTALL_BASE_LIB ${INSTALL_BASE_LIB}
RUN if [ ${INSTALL_BASE_LIB} = true ]; then \
  apt-get install --assume-yes apt-utils -y libbz2-dev libexpat1-dev libghc-gnutls-dev libsecret-1-dev libgconf2-4 libdb-dev libgmp3-dev zlib1g-dev linux-libc-dev libcurl4-gnutls-dev libgudev-1.0-dev uuid-dev libpng-dev libjpeg-dev libfreetype6-dev libssh-dev libssh2-1-dev libpcre3-dev libpcre++-dev libmhash-dev libmcrypt-dev libltdl7-dev mcrypt libiconv-hook-dev libsqlite-dev libgettextpo0 libwrap0-dev libreadline-dev \
  ;fi

ARG INSTALL_ZSH=true
ENV INSTALL_ZSH ${INSTALL_ZSH}
RUN if [ ${INSTALL_ZSH} = true ]; then \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
  ;fi
RUN if [ ${INSTALL_ZSH} = true ]; then \
  chsh -s $(which zsh) \
  ;fi

COPY home/ /root/

ARG INSTALL_PYTHON3=true
ENV INSTALL_PYTHON3 ${INSTALL_PYTHON3}
RUN if [ ${INSTALL_PYTHON3} = true ]; then \
    apt-get install --assume-yes apt-utils -y python3 python3-dev python3-pip python3-setuptools python3-lxml python3-venv \
  ;fi

RUN if [ ${INSTALL_PYTHON3} = true && ${MIRROR_CN} = true ]; then \
  pip3 install -i https://mirrors.aliyun.com/pypi/simple/ --upgrade pip && \
  pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/ \
  ;fi

RUN if [ ${INSTALL_PYTHON3} = true && ${MIRROR_CN} = false ]; then \
  pip3 install --upgrade pip \
  ;fi
