FROM debian:latest

RUN apt-get update -y 
RUN apt-get install -f
RUN apt-get install -y curl
RUN apt-get install -y vim 
RUN apt-get install -y nano
RUN apt-get install -y ssh 
RUN apt-get install -y sudo 
RUN apt-get install -y net-tools 
RUN apt-get install -y wget
RUN apt-get install -y git 
RUN apt-get install -y procps 
RUN apt-get install -y gnupg 
RUN apt-get install -y tree
RUN apt-get install -y htop 
RUN apt-get install -y tmux
RUN apt-get install -y ca-certificates
RUN apt-get install -y python3
RUN apt-get install -y python3-cryptography
RUN apt-get install -y python3-setuptools
RUN apt-get install -y python3-pip 
RUN apt-get install -y python3-pyqt5 
RUN apt-get install -y libsecp256k1-dev
RUN apt-get install -y x11-apps

RUN groupadd -r parman && useradd -m -g parman parman 
RUN chown -R parman:parman /home/parman 
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman
USER parman
RUN mkdir -p /home/parman/electrum_pip
WORKDIR /home/parman/electrum_pip
RUN curl -LO https://download.electrum.org/4.5.5/Electrum-4.5.5.tar.gz
RUN curl -LO https://download.electrum.org/4.5.5/Electrum-4.5.5.tar.gz.asc
RUN curl -LO https://raw.githubusercontent.com/spesmilo/electrum/master/pubkeys/ThomasV.asc 
RUN gpg --import ThomasV.asc
RUN if ! gpg --verify Electrum-4.5.5.tar.gz.asc 2>&1 | grep -qi good ; then \
         echo "gpg verification failed" ; \
         exit 1 ; \
    fi
RUN python3 -m pip install --user Electrum-4.5.5.tar.gz || \
    python3 -m pip install --user Electrum-4.5.5.tar.gz --break-system-packages || { \
    echo "Something went wrong with PIP installation of Electrum." ; \
    exit 1 ; \
    }
WORKDIR /home/parman/

