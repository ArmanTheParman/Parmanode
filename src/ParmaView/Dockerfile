FROM debian:latest

RUN apt-get update -y 
RUN apt-get install -f
RUN apt-get install -y curl
RUN apt-get install -y vim 
RUN apt-get install -y nano
RUN apt-get install -y ssh 
RUN apt-get install -y sudo 
RUN apt-get install -y net-tools 
RUN apt-get install -y git 
RUN apt-get install -y procps 
RUN apt-get install -y gnupg 
RUN apt-get install -y tmux
RUN apt-get install -y ca-certificates
RUN apt-get install -y python3
RUN apt-get install -y python3-cryptography
RUN apt-get install -y python3-setuptools
RUN apt-get install -y python3-pip 
RUN apt-get install -y x11-apps

RUN pip3 install websockets --break-system-packages

RUN groupadd -r parman && useradd -m -g parman parman 
RUN chown -R parman:parman /home/parman 
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman
USER parman

RUN mkdir -p /home/parman/parman_programs/
RUN mkdir -p /home/parman/parmanode/
WORKDIR /home/parman/parman_programs/
RUN git clone --depth 1 https://github.com/armantheparman/parmanode
RUN touch /home/parman/.parmanode.com/installed.conf

WORKDIR /home/parman/

