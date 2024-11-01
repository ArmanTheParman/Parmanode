FROM debian:latest 
ARG parmanID=1000
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       wget gnupg sudo procps curl git vim nano ca-certificates iproute2 tor nginx-full \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u $parmanID parman 
RUN chown -R parman:parman /home/parman/
RUN usermod -aG sudo parman 
RUN echo 'parman:parmanode' | chpasswd

#networking
USER root
RUN rm /etc/nginx/sites-available/*
RUN rm /etc/nginx/sites-enabled/*
# The dockerfile is moved, so any copy command must examine where the working directory is.
# Move needed files with the dockerfile for the copy command to work.
COPY ./stream_lnd.conf /etc/nginx/stream.conf
RUN echo "include stream.conf;" | tee -a /etc/nginx/nginx.conf

USER parman
RUN mkdir -p /home/parman/.lnd
RUN mkdir -p /home/parman/parmanode/lnd
RUN touch /home/parman/.lnd/password.txt

#Install LND
# chip_4lnd variable options -> amd64 (for x86_64), arm64, armv6 (for armv6l), armv7 (for armv7l)
# can be changed in install script...
ENV chip_4lnd='amd64'
ENV lndversion="v0.17.3-beta"

WORKDIR /home/parman/lnd/
RUN curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/manifest-${lndversion}.txt
RUN curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/manifest-roasbeef-${lndversion}.sig
RUN curl -LO https://github.com/lightningnetwork/lnd/releases/download/${lndversion}/lnd-linux-${chip_4lnd}-${lndversion}.tar.gz

#Verify zips...
RUN curl https://raw.githubusercontent.com/lightningnetwork/lnd/master/scripts/keys/roasbeef.asc | gpg --import
RUN if gpg --verify --status-fd 1 *.sig *.txt 2>&1 | grep -i GOOD ; then true ; else exit 1 ; fi
RUN if shasum -a 256 --ignore-missing --check man*txt 2>/dev/null | grep -q OK ; then true ; else exit 1 ; fi

#unpack
RUN tar -xvf *gz
USER root
RUN mv ./lnd*/* /usr/local/bin

USER parman
WORKDIR /home/parman/.lnd
CMD tail -f /dev/null 

# Volumes
# $HOME/.bitcoin/
# $HOME/.lnd
