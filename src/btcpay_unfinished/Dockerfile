FROM mcr.microsoft.com/dotnet/sdk:6.0

RUN apt-get update
RUN apt-get install -y wget gpg sudo procps vim nano systemd curl git

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/parmanode/btcpay
RUN mkdir -p /home/parman/Downloads

#BTCpay download
RUN cd /home/parman/Downloads && wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb

USER root
RUN apt-get update -y && apt-get install apt-transport-https -y && apt-get update -y 
RUN apt install postgresql postgresql-contrib -y 


USER parman

# install NBX
RUN cd ~/parmanode && git clone https://github.com/dgarage/NBXplorer
RUN cd ~/parmanode/NBXplorer && ./build.sh
RUN mkdir -p ~/.nbxplorer/Main
RUN touch ~/.nbxplorer/Main/settings.config
#RUN cd ~/.nbxplorer/Main

#test - take this out of dockerfile later
#cd ~/source/NBXplorer
#./run.sh



#install BTCpayserver
RUN cd ~/source && git clone https://github.com/btcpayserver/btcpayserver.git && cd btcpayserver && ./build.sh
RUN mkdir -p ~/.btcpayserver/Main 
RUN touch ~/.btcpayserver/Main/settings.config


CMD tail -f /dev/null
