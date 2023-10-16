FROM ubuntu

RUN apt update -y 
RUN apt install -y vim nano ssh sudo net-tools curl wget git procps gnupg tree htop
RUN groupadd -r parman && useradd -m -g parman parman 
RUN chown -R parman:parman /home/parman 
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman