FROM mcr.microsoft.com/dotnet/sdk:6.0

RUN apt-get update -y
RUN apt-get install -y wget gnupg sudo procps vim nano systemd curl git expect

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
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
RUN apt-get install postgresql-13 postgresql-contrib -y 
USER postgres
USER root
RUN usermod -aG parman postgres 
USER parman
COPY postgres_script.sh /home/parman/parmanode

# install NBX
RUN cd ~/parmanode && git clone https://github.com/dgarage/NBXplorer
RUN cd ~/parmanode/NBXplorer && git checkout v2.3.65 ./build.sh
RUN mkdir -p ~/.nbxplorer/Main

#install BTCpayserver
RUN cd ~/parmanode && git clone https://github.com/btcpayserver/btcpayserver.git && cd btcpayserver && git checkout v1.9.2 && ./build.sh
RUN mkdir -p ~/.btcpayserver/Main 

CMD tail -f /dev/null
