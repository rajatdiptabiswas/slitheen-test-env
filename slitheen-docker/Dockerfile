FROM ff_build_bootstrapped
RUN sudo apt-get update
RUN sudo apt-get install -y inetutils-ping libssl-dev libpcap0.8-dev ethtool tcpdump valgrind iptables telnet less
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
