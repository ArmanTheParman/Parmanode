FROM debian:latest

RUN apt-get update -y 
RUN apt-get install -f
RUN apt-get install -y curl socat vim nano ssh sudo 
RUN apt-get install -y net-tools git procps gnupg tmux x11-apps ca-certificates netcat-traditional jq
RUN apt-get install -y curl socat vim nano ssh sudo net-tools gi procps gnupg tmux x11-apps ca-certificates netcat-traditional jq
RUN apt-get install -y curl socat vim nano ssh sudo net-tools gi procps gnupg tmux x11-apps ca-certificates netcat-traditional jq
RUN apt-get install -y python3 python3-cryptography python3-setuptools python3-pip 

RUN pip3 install websockets --break-system-packages

RUN groupadd -r parman && useradd -m -g parman parman 
RUN chown -R parman:parman /home/parman 
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman
USER parman

RUN mkdir -p /home/parman/parman_programs/
RUN mkdir -p /home/parman/parmanode/
RUN mkdir -p /home/parman/.parmanode/
WORKDIR /home/parman/parman_programs/
RUN git clone --depth 1 https://github.com/armantheparman/parmanode
RUN touch /home/parman/.parmanode.com/installed.conf

WORKDIR /home/parman/

