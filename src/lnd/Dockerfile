FROM debian 
RUN apt-get update
RUN apt-get install -y wget gnupg sudo procps curl git vim nano

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN usermod -aG sudo parman 
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/.parmanode
RUN mkdir -p /home/parman/parmanode
RUN mkdir -p /home/parman/parman_programs
RUN touch /home/parman/.parmanode/installed.conf
WORKDIR /home/parman/parman_programs/
#need to keep this updated
RUN git clone --depth 1 https://github.com/armantheparman/parmanode
WORKDIR /home/parman/
#populates parmanode.conf
RUN /home/parman/parman_programs/parmanode/run_parmanode.sh

CMD tail -f /dev/null 