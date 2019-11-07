FROM ubuntu:16.04
RUN apt-get update && apt-get install -y wget python python3-pip sudo inetutils-ping libpcap0.8-dev ethtool dpkg-dev lsb-release libstartup-notification0-dev libjpeg-dev libbz2-dev libreadline-dev python-ply libvpx-dev libhunspell-dev libffi-dev libevent-dev libjsoncpp-dev locales ttf-bitstream-vera fonts-freefont-ttf fonts-dejima-mincho iso-codes software-properties-common npm clang clang-tools-6.0 llvm-6.0 llvm-6.0-tools
RUN pip3 install selenium
RUN pip3 install numpy
RUN npm install -g n
RUN n stable

# Set up a slitheen user. 1000 and 1000 will be automatically
# replaced by build-slitheen
RUN groupadd -g 1000 slitheen
RUN useradd -u 1000 -g slitheen -ms /bin/bash slitheen
RUN adduser slitheen sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER slitheen
WORKDIR /home/slitheen
ENV SHELL=/bin/bash

# Firefox bootstrap: first pull web boostrap script, then run
# ./mach bootstrap from mozilla-central
RUN wget https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py
RUN sudo python bootstrap.py --vcs=git --application-choice=browser --no-interactive; exit 0;
RUN rm bootstrap.py
RUN hg clone https://hg.mozilla.org/releases/mozilla-esr60
WORKDIR mozilla-esr60
RUN sudo ./mach bootstrap --application-choice=browser --no-interactive; exit 0;
WORKDIR /home/slitheen
RUN rm -rf mozilla-esr60

#Set up rust dependecies (need to use v 1.26 to build esr 60
RUN sudo ./.cargo/bin/cargo install cbindgen
RUN sudo ./.cargo/bin/rustup install 1.26.0
RUN sudo ./.cargo/bin/rustup default 1.26.0

# We need openssl version 1.1.0f for the elliptic curves Firefox uses
WORKDIR /tmp/
RUN wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz
RUN tar xzvf openssl-1.1.0f.tar.gz
WORKDIR /tmp/openssl-1.1.0f
RUN ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'
RUN make
RUN sudo make install
RUN make clean
WORKDIR /tmp/
RUN rm openssl-1.1.0f.tar.gz && rm -rf openssl-1.1.0f
ENV LD_LIBRARY_PATH=/usr/local/lib
RUN sudo ldconfig

# Install packages useful for dev work
RUN sudo apt-get install -y tcpdump valgrind iptables telnet less vim

#  Note: these were to get livestreaming working in youtube 
# TODO: figure out what we need for 18.04
RUN sudo apt-get install -y gstreamer1.0-fluendo-mp3 gstreamer1.0-libav \
  gstreamer1.0-plugins-bad gstreamer1.0-plugins-bad-faad \
  gstreamer1.0-plugins-bad-videoparsers gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-ugly gstreamer1.0-plugins-ugly-amr i965-va-driver \
  liba52-0.7.4 libaacs0 libasound2-plugins libass5 libavcodec-extra \
  libavcodec-ffmpeg-extra56 libavfilter-ffmpeg5 libavformat-ffmpeg56 \
  libavresample-ffmpeg2 libavutil-ffmpeg54 libbdplus0 libbluray1 libbs2b0 \
  libcdio13 libcdparanoia0 libchromaprint0 libcrystalhd3 libdc1394-22 libdca0 \
  libde265-0 libdvdnav4 libdvdread4 libfaad2 libfftw3-double3 libflite1 \
  libfluidsynth1 libfribidi0 libglu1-mesa libgme0 libgsm1 \
  libgstreamer-plugins-bad1.0-0 libgstreamer-plugins-base1.0-0 \
  libgstreamer-plugins-good1.0-0 libgstreamer1.0-0

# Install packages and start X to get VNC working
RUN DEBIAN_FRONTEND=noninteractive sudo -E apt-get install -y --no-install-recommends x11vnc net-tools
ENV DISPLAY=:1.0
COPY start_x /home/slitheen/start_x
RUN sudo chown slitheen:slitheen /home/slitheen/start_x
RUN chmod 755 /home/slitheen/start_x

# Clean up
RUN sudo apt-get clean
WORKDIR /home/slitheen
