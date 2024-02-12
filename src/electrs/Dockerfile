FROM rust:1.67

RUN apt-get update -y
RUN apt-get install -y sudo vim curl git clang cmake build-essential

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/parmanode
RUN cd /home/parman/parmanode && git clone --depth 1 https://github.com/romanz/electrs
RUN cd /home/parman/parmanode/electrs && cargo build --locked --release

USER root
RUN apt-get install nginx -y
RUN apt-get update --fix-missing
RUN apt-get install tor -y
COPY Dockerfile_torrc /etc/tor/torrc
COPY Dockerfile_torsocks.conf /etc/tor/torsocks.conf
CMD tor