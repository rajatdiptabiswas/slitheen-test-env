FROM ubuntu:18.04

ARG USER_ID
ARG GROUP_ID

RUN apt-get update && apt-get install -y wget gnupg lsb-release

# Add repository to install nodejs
RUN wget -qO- https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - && \
echo "deb https://deb.nodesource.com/node_10.x $(lsb_release -c -s) main" > /etc/apt/sources.list.d/nodesource.list && \
echo "deb-src https://deb.nodesource.com/node_10.x $(lsb_release -c -s) main" >> /etc/apt/sources.list.d/nodesource.list

# Install Go v1.15
RUN wget https://golang.org/dl/go1.15.3.linux-amd64.tar.gz --no-check-certificate && \
tar -C /usr/local -xzf go1.15.3.linux-amd64.tar.gz && \
rm go1.15.3.linux-amd64.tar.gz

# Install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
# packages needed for Firefox
python3 python3-numpy python3-selenium dpkg-dev libstartup-notification0-dev libjpeg-dev libbz2-dev libreadline-dev python-ply libvpx-dev libhunspell-dev libffi-dev libevent-dev libjsoncpp-dev locales ttf-bitstream-vera fonts-freefont-ttf fonts-dejima-mincho iso-codes software-properties-common clang-tools-6.0 llvm-6.0 llvm-6.0-tools nodejs cargo libpulse-dev libpangomm-1.4-dev nasm unzip zip yasm autoconf2.13 libgtk-3-dev libgtk2.0-dev libdbus-glib-1-dev libxt-dev \
# packages needed for livestream
libavcodec-extra libavcodec-extra57 \
# packages needed for relay station
openssl libssl-dev sudo libpcap0.8-dev ethtool \
# packages needed for dev work
x11vnc net-tools xvfb tcpdump iptables telnet less vim

# Clean up
RUN apt-get remove --purge -y gnupg wget && apt-get autoremove -y && apt-get clean

# Set up a slitheen user
RUN groupadd -g $GROUP_ID slitheen && \
useradd -u $USER_ID -g slitheen -ms /bin/bash slitheen && \
adduser slitheen sudo && \
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER slitheen
WORKDIR /home/slitheen
ENV SHELL=/bin/bash

# Set up rust dependecies
RUN sudo cargo install cbindgen

# Install and start X to get VNC working
ENV DISPLAY=:1.0
COPY start_x /home/slitheen/start_x
RUN sudo chown slitheen:slitheen /home/slitheen/start_x && \
chmod 755 /home/slitheen/start_x

