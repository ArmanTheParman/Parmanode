FROM mcr.microsoft.com/dotnet/sdk:6.0

RUN apt-get update
RUN apt-get install -y wget gnupg sudo procps vim nano systemd curl git expect

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 999 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/parmanode
RUN mkdir -p /home/parman/Downloads

#BTCpay download
RUN cd /home/parman/Downloads && wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

USER root
RUN apt-get update -y && apt-get install apt-transport-https -y && apt-get update -y 

# Install postgres and make databases
RUN apt install postgresql-13 postgresql-contrib -y 
USER postgres
USER root
RUN usermod -aG parman postgres 
USER parman
COPY postgres_script.sh /home/parman/parmanode

# install NBX
RUN cd ~/parmanode && git clone https://github.com/dgarage/NBXplorer
RUN cd ~/parmanode/NBXplorer && ./build.sh
RUN mkdir -p ~/.nbxplorer/Main

#install BTCpayserver
RUN cd ~/parmanode && git clone https://github.com/btcpayserver/btcpayserver.git && cd btcpayserver && ./build.sh
RUN mkdir -p ~/.btcpayserver/Main 

EXPOSE 49392
EXPOSE 8080
EXPOSE 23001

#Make users and groups and directories
USER parman 
RUN mkdir /home/parman/parmanode/bitcoin ; mkdir /home/parman/.bitcoin 

# Bitcoin Core 24.0.1 download
WORKDIR /home/parman/Downloads
RUN wget https://bitcoincore.org/bin/bitcoin-core-24.0.1/bitcoin-24.0.1-x86_64-linux-gnu.tar.gz
RUN wget https://bitcoincore.org/bin/bitcoin-core-24.0.1/SHA256SUMS
Run wget https://bitcoincore.org/bin/bitcoin-core-24.0.1/SHA256SUMS.asc
Run sha256sum --ignore-missing --check SHA256SUMS

#check gpg sig
USER root
RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A
RUN if { gpg --verify SHA256SUMS.asc 2>&1 | grep -q Good ; } ; then true ; else exit ; fi

#unpack Bitcoin core:
USER parman
RUN tar -xvf bitcoin*

#move bitcoin program files to new directory.
RUN mv /home/parman/Downloads/bit*/* /home/parman/parmanode/bitcoin/

#remove the downloaded files
RUN rm -rf /home/parman/Doanloads/*

EXPOSE 8332

CMD tail -f /dev/null
