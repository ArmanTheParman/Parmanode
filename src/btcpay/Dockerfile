FROM mcr.microsoft.com/dotnet/sdk:6.0

RUN apt-get update
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
EXPOSE 80

CMD tail -f /dev/null