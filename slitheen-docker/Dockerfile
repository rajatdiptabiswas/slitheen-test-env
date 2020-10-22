FROM ubuntu:18.04

ARG USER_ID
ARG GROUP_ID

RUN apt-get update && apt-get install -y wget python3 python3-numpy python3-selenium sudo inetutils-ping libpcap0.8-dev ethtool dpkg-dev lsb-release libstartup-notification0-dev libjpeg-dev libbz2-dev libreadline-dev python-ply libvpx-dev libhunspell-dev libffi-dev libevent-dev libjsoncpp-dev locales ttf-bitstream-vera fonts-freefont-ttf fonts-dejima-mincho iso-codes software-properties-common npm clang-tools-6.0 llvm-6.0 llvm-6.0-tools cargo libpulse-dev libpangomm-1.4-dev nasm unzip zip yasm autoconf2.13 libgtk-3-dev libgtk2.0-dev libdbus-glib-1-dev libxt-dev
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
RUN sudo apt-get install -y gstreamer1.0-fluendo-mp3 gstreamer1.0-libav \
  gstreamer1.0-plugins-base gstreamer1.0-vaapi \
  gstreamer1.0-plugins-ugly i965-va-driver \
  liba52-0.7.4 libaacs0 libass9 libavcodec-extra \
  libavcodec-extra57 libavfilter6 libavformat57 libavresample3 libavutil55 \
  libbdplus0 libbluray2 libbs2b0 libcap2-bin\
  libcdio17 libcdparanoia0 libchromaprint1 libcrystalhd3 \
  libdvdnav4 libdvdread4 libfftw3-double3 libflite1 \
  libfribidi0 libgme0 libgsm1 \
  libgstreamer-plugins-bad1.0-0 libgstreamer-plugins-base1.0-0 \
  libgstreamer-plugins-good1.0-0 libgstreamer1.0-0 \
  libgudev-1.0-0 \
  libmp3lame0 libmpeg2-4 libmpg123-0 libmspack0 libnorm1 libnuma1 libopencore-amrnb0 libopencore-amrwb0 libopenjp2-7 \
  libopenmpt0 libopus0 liborc-0.4-0 libpam-cap libpgm-5.2-0 libpostproc54 librubberband2 libsamplerate0 libshine3 libsidplay1v5 \
  libsnappy1v5 libsodium23 libsoxr0 libspeex1 libswresample2 libswscale4 libtheora0 libtwolame0 libva-drm2 \
  libva-wayland2 libva-x11-2 libva2 libvdpau1 libvisual-0.4-0 libvo-amrwbenc0 libvorbisfile3 libwavpack1 libwebp6 libwebpmux3 \
  libx264-152 libx265-146 libxvidcore4 libzmq5 libzvbi-common libzvbi0 mesa-va-drivers mesa-vdpau-drivers

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
