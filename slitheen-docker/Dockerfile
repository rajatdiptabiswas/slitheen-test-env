FROM ubuntu:18.04

ARG USER_ID
ARG GROUP_ID

RUN apt-get update && apt-get install -y wget python3 python3-numpy python3-selenium sudo libpcap0.8-dev ethtool dpkg-dev lsb-release libstartup-notification0-dev libjpeg-dev libbz2-dev libreadline-dev python-ply libvpx-dev libhunspell-dev libffi-dev libevent-dev libjsoncpp-dev locales ttf-bitstream-vera fonts-freefont-ttf fonts-dejima-mincho iso-codes software-properties-common npm clang-tools-6.0 llvm-6.0 llvm-6.0-tools cargo libpulse-dev libpangomm-1.4-dev nasm unzip zip yasm autoconf2.13 libgtk-3-dev libgtk2.0-dev libdbus-glib-1-dev libxt-dev
RUN npm install -g n
RUN n stable

# Set up a slitheen user. 1000 and 1000 will be automatically
# replaced by build-slitheen
RUN groupadd -g $GROUP_ID slitheen
RUN useradd -u $USER_ID -g slitheen -ms /bin/bash slitheen
RUN adduser slitheen sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER slitheen
WORKDIR /home/slitheen
ENV SHELL=/bin/bash

# Set up rust dependecies
RUN sudo cargo install cbindgen

# Install openssl for the relay station
RUN sudo apt-get install -y openssl libssl-dev

# Install Go v1.15
RUN wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz --no-check-certificate
RUN sudo tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz
RUN rm go1.15.3.linux-amd64.tar.gz

# Install packages to enable livestreaming
# Note: we probably don't need all of these
RUN sudo apt-get install -y \
  libavcodec-extra libavcodec-extra57 libavfilter6 libavformat57 libavresample3 libavutil55 libmpeg2-4

# Install packages useful for dev work
RUN sudo apt-get install -y tcpdump iptables telnet less vim

# Install packages and start X to get VNC working
RUN DEBIAN_FRONTEND=noninteractive sudo -E apt-get install -y --no-install-recommends x11vnc net-tools xvfb
ENV DISPLAY=:1.0
COPY start_x /home/slitheen/start_x
RUN sudo chown slitheen:slitheen /home/slitheen/start_x
RUN chmod 755 /home/slitheen/start_x

# Clean up
RUN sudo apt-get clean
WORKDIR /home/slitheen
