# For Parmanode Version 2.2+
# install Fulcrum on Linux debian container, for Mac users.

FROM debian 
RUN apt-get update
RUN apt-get install -y wget gnupg sudo procps vim nano systemd curl git

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/parmanode/fulcrum
RUN mkdir -p /home/parman/parmanode/fulcrum_db
RUN mkdir -p /home/parman/Downloads

#Download Fulcrum:
WORKDIR /home/parman/Downloads
RUN wget https://github.com/cculianu/Fulcrum/releases/download/v1.9.1/Fulcrum-1.9.1-x86_64-linux.tar.gz && \
wget https://github.com/cculianu/Fulcrum/releases/download/v1.9.1/Fulcrum-1.9.1-x86_64-linux.tar.gz.sha256sum && \
wget https://github.com/cculianu/Fulcrum/releases/download/v1.9.1/Fulcrum-1.9.1-x86_64-linux.tar.gz.asc

RUN shasum -a 256 --ignore-missing --check Fulcrum-1.9.1-x86_64-linux.tar.gz.sha256sum

#Check gpg sig
USER root
RUN gpg --keyserver keyserver.ubuntu.com --recv-keys D465135F97D0047E18E99DC321810A542031C02C
RUN if { gpg --verify --status-fd 1 Fulcrum-1.9.1-x86_64-linux.tar.gz.asc 2>&1 | grep -q GOOD ; } ; then true; else exit 1 ; fi

#unpack fulcrum
USER parman
RUN tar -xvf Fulcrum-1.9.1-x86_64-linux.tar.gz -C /home/parman/parmanode/fulcrum
RUN mv /home/parman/parmanode/fulcrum/Fu*/* /home/parman/parmanode/fulcrum/ && rm -rf /home/parman/parmanode/fulcrum/Fulcrum-*

#make openssl key and cert
WORKDIR /home/parman/parmanode/fulcrum
RUN openssl genpkey -algorithm RSA -out key.pem -pkeyopt rsa_keygen_bits:2048
RUN openssl req -new -x509 -key key.pem -out cert.pem -days 36500 -subj "/C=/ST=/L=/O=/OU=/CN=/emailAddress=/" 

#make fulcrum config file
USER parman
WORKDIR /home/parman/parmanode/fulcrum/
RUN echo "datadir = /home/parman/parmanode/fulcrum_db" >> fulcrum.conf \
&& echo "bitcoind = host.docker.internal:8332" >> fulcrum.conf \
&& echo "ssl = 0.0.0.0:50002" >> fulcrum.conf \
&& echo "tcp = 0.0.0.0:50001" >> fulcrum.conf \
&& echo "cert = /home/parman/parmanode/fulcrum/cert.pem" >> fulcrum.conf \
&& echo "key = /home/parman/parmanode/fulcrum/key.pem" >> fulcrum.conf \
&& echo "fast-sync = 2000" >> fulcrum.conf \
&& echo "peering = false" >> fulcrum.conf
 
RUN mkdir /home/parman/parmanode/config
#will contain symlinks to be made after docker run

#make all functions available to "docker exec" without specifying user
USER parman
CMD tail -f /dev/null 