FROM ff_build_bootstrapped
RUN sudo apt-get update
RUN sudo apt-get install -y inetutils-ping libpcap0.8-dev ethtool tcpdump valgrind iptables telnet less dpkg-dev lsb-release libstartup-notification0-dev libjpeg-dev libbz2-dev libreadline-dev python-ply libvpx-dev libhunspell-dev libffi-dev libevent-dev libjsoncpp-dev locales ttf-bitstream-vera fonts-freefont-ttf fonts-dejima-mincho iso-codes software-properties-common
WORKDIR /tmp/
RUN wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz
RUN tar xzvf openssl-1.1.0f.tar.gz
WORKDIR /tmp/openssl-1.1.0f
RUN ./config -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)'
RUN make
RUN sudo make install
ENV LD_LIBRARY_PATH=/usr/local/lib
RUN sudo ldconfig
WORKDIR /home/iang/
