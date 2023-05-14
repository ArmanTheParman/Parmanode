FROM node

RUN apt-get update
RUN apt-get install -y wget gnupg sudo procps vim curl git

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 9998 parman
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd

USER parman

WORKDIR /home/parman/
RUN git clone https://github.com/Ride-The-Lightning/RTL.git
RUN cd RTL && npm install --omit=dev --legacy-peer-deps
CMD tail -f /dev/null