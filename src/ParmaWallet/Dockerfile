#Builds a container to run cryptography functions

FROM debian 
RUN apt-get update -y
RUN apt-get install -y vim nano libgmp-dev python3 pip openssl git
RUN pip3 install bitcoinlib base58 bech32 cryptography pycryptodome

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/
WORKDIR /home/parman/
RUN git clone -depth 1 https://github.com/armantheparman/parmanode
CMD tail -f /dev/null 