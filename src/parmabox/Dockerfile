FROM ubuntu:latest

RUN apt-get update -y 
RUN apt-get install -y vim nano ssh sudo net-tools curl wget git procps gnupg tree htop --fix-missing
RUN apt-get install -y python3 python3-cryptography python3-setuptools python3-pip  --fix-missing
RUN apt-get install -y python3-pyqt5 libsecp256k1-dev  --fix-missing
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

