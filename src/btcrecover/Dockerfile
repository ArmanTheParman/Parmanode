FROM ubuntu:latest

RUN apt-get update -y && apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --fix-missing -y \
               sudo vim nano libgmp-dev python3-dev python3-pip openssl \
               procps gnupg tree htop
               
RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --fix-missing -y \
               git pip python3-cryptography python3-setuptools python3-bitcoinlib python3-base58 \
               python3-tk build-essential libssl-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --fix-missing -y \
               locales \
               python3-pyqt5 libsecp256k1-dev curl

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN pip3 install bech32 --break-system-packages
RUN pip3 install base58 --break-system-packages
RUN pip3 install bip-utils --break-system-packages
RUN pip3 install bitcoinlib --break-system-packages
RUN pip3 install cryptography --break-system-packages
RUN pip3 install pycryptodome --break-system-packages


#Make users and groups and directories
RUN userdel -r ubuntu
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN usermod -aG sudo parman 
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/parman_programs/
WORKDIR /home/parman/parman_programs/
RUN git clone --depth 1 https://github.com/armantheparman/parmanode

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

USER root
RUN sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen
RUN locale-gen 
#RUN locale-gen en_US.UTF-8

USER parman
WORKDIR /home/parman
RUN git clone --depth 1 https://github.com/3rdIteration/btcrecover.git

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

CMD tail -f /dev/null 
# Need to run fix_openssl_repemd160
#user should set number of cores to dedicate to docker container