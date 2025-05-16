FROM mcr.microsoft.com/dotnet/sdk:8.0

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
ARG parmanID=1000
ARG btcpay_version="v2.0.3"

RUN apt-get update -y
RUN apt-get install -y wget gnupg sudo procps vim nano curl git expect iproute2 less ca-certificates

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u $parmanID parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman
RUN echo "Defaults !fqdn" | tee -a /etc/sudoers

USER parman

RUN mkdir -p /home/parman/parmanode
RUN mkdir -p /home/parman/Downloads
RUN mkdir -p /home/parman/parman_programs
RUN cd /home/parman/parman_programs && git clone https://github.com/armantheparman/parmanode.git
RUN cd /home/parman/ && mkdir .parmanode && cd .parmanode && touch installed.conf && touch parmanode.conf

#BTCpay download
RUN cd /home/parman/Downloads && wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

USER root
RUN apt-get update -y && apt-get install apt-transport-https -y && apt-get update -y 

# Install postgres and make databases
RUN apt-get install postgresql postgresql-contrib -y 
USER postgres
USER root
RUN usermod -aG parman postgres 
USER parman

# install NBX
RUN cd ~/parmanode && git clone https://github.com/dgarage/NBXplorer
RUN cd ~/parmanode/NBXplorer && git checkout v2.5.26 && chown -R parman ./* ; ./build.sh
RUN mkdir -p ~/.nbxplorer/Main

#install BTCpayserver
RUN cd ~/parmanode && git clone https://github.com/btcpayserver/btcpayserver.git && cd btcpayserver && git checkout $btcpay_version && ./build.sh
RUN mkdir -p ~/.btcpayserver/Main 

CMD ["tail" , "-f", "/dev/null"]
