# charles' docker project for CGADoxygen
- cheoljoo/ubuntu16:cgadoxygen

# Dockerfile
- [Dockerfile](./Dockerfile)

# How to build docker
- `docker build -t cgadoxygen1 ./`

# make image and push in dockerhub
- `docker login`
- `docker build -t cheoljoo/ubuntu16:cgadoxygen .`
- `docker push cheoljoo/ubuntu16:cgadoxygen`

# how to pull (download) and run
- `docker pull cheoljoo/ubuntu16:cgadoxygen`
- `docker run -it -v /home/cheoljoo.lee/docker:/docker --name NewCGA  cheoljoo/ubuntu16:cgadoxygen /bin/bash`
- `docker start NewCGA`
- `docker attach NewCGA`


# Dockerfile
```docker
# Ref: https://hub.docker.com/r/yoctocookbook2ndedition/docker-yocto-builder

FROM ubuntu:16.04

# Upgrade the system and install Yocto basic dependencies
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
                    apt-utils build-essential sudo git python-dev python-pip python-setuptools javacc java-common pandoc vim python3-pip python3-setuptools graphviz cmake flex bison


# Set up locales
RUN apt-get install -y locales apt-utils sudo && \
    dpkg-reconfigure locales && locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.utf8

# Install additional packages for dev
RUN apt-get install -y tig vim tree
RUN cpan Excel::Writer::XLSX

ENV TMP "/tmp"

# install hpp2plantuml
WORKDIR ${TMP}
RUN rm -rf  "/tmp/hpp2plantuml"
RUN git clone https://github.com/thibaultmarin/hpp2plantuml.git
WORKDIR "/tmp/hpp2plantuml"
RUN python3 setup.py install

# install markdown-pp
WORKDIR ${TMP}
RUN rm -rf "/tmp/markdown-pp"
RUN git clone https://github.com/jreese/markdown-pp.git
WORKDIR "/tmp/markdown-pp"
RUN python setup.py install

# install doxygen new version
WORKDIR ${TMP}
RUN rm -rf "/tmp/doxygen"
RUN git clone https://github.com/cheoljoo/doxygen.git
WORKDIR "/tmp/doxygen"
RUN mkdir /tmp/doxygen/build
WORKDIR "/tmp/doxygen/build"
RUN cmake -G "Unix Makefiles" ..
RUN make
RUN make install

# install CGADoxygen
RUN apt-get install -y ncurses-bin ncurses-term ncurses-doc
ENV TERM "xterm"
WORKDIR ${TMP}
RUN ls
RUN rm -rf  "/tmp/CGADoxygen"
RUN git clone https://github.com/1434cga/CGADoxygen.git
WORKDIR "/tmp/CGADoxygen/build_perlmod"
RUN cp -f makePNG_jar_plantuml_for_docker.sh makePNG_jar_plantuml.sh
WORKDIR "/tmp/CGADoxygen"
RUN sh run.sh clean
RUN sh run.sh example/A

```
