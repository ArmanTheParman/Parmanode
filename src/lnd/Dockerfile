FROM debian 
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       wget gnupg sudo procps curl git vim nano ca-certificates iproute2 \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN usermod -aG sudo parman 
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/.lnd
RUN mkdir -p /home/parman/.parmanode
RUN mkdir -p /home/parman/parmanode/lnd
RUN mkdir -p /home/parman/parman_programs
RUN echo "bitcoin-end" | tee -a /home/parman/.parmanode/installed.conf
RUN echo "OS=Linux" | tee -a /home/parman/.parmanode/parmanode.conf
RUN echo "computer_type=LinuxPC" | tee -a /home/parman/.parmanode/parmanode.conf
WORKDIR /home/parman/parman_programs/
#need to keep this updated
RUN git clone --depth 1 https://github.com/armantheparman/parmanode
WORKDIR /home/parman/

CMD tail -f /dev/null 

# Volumes
# $HOME/.bitcoin/bitcoin.conf
# $HOME/.lnd
