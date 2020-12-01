# sudo docker image build --tag editors:latest --file editors.Dockerfile `pwd`       
# BEGIN ------------ BUILD TIME ------------

FROM ubuntu:20.04

# set accounts
# update root password 
RUN echo root:root | chpasswd

# set environment variable do not permit interaction
ENV DEBIAN_FRONTEND=noninteractive

# install sudo
RUN apt-get update \
    && apt-get install --assume-yes --no-install-recommends \
       `# for installation from non default repositories` \
       software-properties-common \
       gdebi-core \
       `# administration and no apt installation` \
       sudo \
       wget \
       bzip2 \
       curl \
       xz-utils \
       ca-certificates \
       `# pulling from repositories` \
       git \
       mercurial \
       subversion \
       `# for viewing help and documentation` \
       man \
       less \
       `# for connecting` \
       openssh-client \
       openssh-server \
       `# process monitoring` \
       htop \
       `# for bash` \
       libtinfo-dev \
    && `# clean up` \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# create user ubuntu and set password
RUN useradd --create-home ubuntu \
    && echo ubuntu:ubuntu | chpasswd \
    && echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers

# install vim
RUN add-apt-repository --yes ppa:jonathonf/vim \
    && apt-get update \
    && apt-get install --assume-yes --no-install-recommends vim-nox \
    && `# clean up` \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# install emacs 27
RUN add-apt-repository --yes ppa:kelleyk/emacs \
    && apt-get update \
    && apt-get install --assume-yes --no-install-recommends emacs27-nox \
    && `# clean up` \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# install libvterm for vterm in emacs27
RUN apt-get update \
    && apt install --assume-yes \
	   cmake \
	   libtool \
	   libtool-bin \
    && `# clean up` \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# set working directory and user
# WORKDIR /home/ubuntu # taken care of with CMD 
USER ubuntu

# END   ------------ BUILD TIME ------------

# BEGIN ------------ RUN TIME   ------------

# ENTRYPOINT is by default /bin/sh -c "$@"
# CMD is passed to ENTRYPOINT, but may be overriden
# e.g. sudo docker container run /bin/sh will start in sh rather than bash
CMD cd && /bin/bash

# END   ------------ RUN TIME   ------------
