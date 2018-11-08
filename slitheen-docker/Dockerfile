FROM ubuntu:16.04
RUN apt-get update && apt-get install -y wget python clang clang-tools-6.0 sudo
#user stuff
RUN useradd -ms /bin/bash slitheen
RUN adduser slitheen sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER slitheen
WORKDIR /home/slitheen
ENV SHELL=/bin/bash
#firefox bootstrap
RUN wget https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py
RUN python bootstrap.py --application-choice=browser --no-interactive; exit 0
RUN rm bootstrap.py
RUN sudo apt-get install -y inetutils-ping libpcap0.8-dev ethtool dpkg-dev lsb-release libstartup-notification0-dev libjpeg-dev libbz2-dev libreadline-dev python-ply libvpx-dev libhunspell-dev libffi-dev libevent-dev libjsoncpp-dev locales ttf-bitstream-vera fonts-freefont-ttf fonts-dejima-mincho iso-codes software-properties-common
#openssl
WORKDIR /tmp/
RUN wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz
RUN tar xzvf openssl-1.1.0f.tar.gz
WORKDIR /tmp/openssl-1.1.0f
RUN ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'
RUN make
RUN sudo make install
#This might work
RUN make clean
WORKDIR /tmp/
RUN rm openssl-1.1.0f.tar.gz && rm -rf openssl-1.1.0f
ENV LD_LIBRARY_PATH=/usr/local/lib
RUN sudo ldconfig
#Only for dev work...
#RUN apt-get install -y tcpdump valgrind iptables telnet less
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
RUN sudo apt-get install -y x11vnc net-tools
RUN sudo apt-get clean
ENV DISPLAY=:1.0
COPY start_x /home/slitheen/start_x
RUN sudo chown slitheen:slitheen /home/slitheen/start_x
RUN chmod 755 /home/slitheen/start_x
WORKDIR /home/slitheen
