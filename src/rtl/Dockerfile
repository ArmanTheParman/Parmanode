FROM node

RUN apt-get update
RUN apt-get install -y wget gnupg sudo procps vim curl git

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman parman
RUN chown -R parman:parman /home/parman

WORKDIR /home/parman/
RUN mkdir .lnd rtl_db RTL2
RUN git clone https://github.com/Ride-The-Lightning/RTL.git
RUN cd RTL && npm install --omit=dev --legacy-peer-deps
RUN cd /home/parman/RTL && ln -s /home/parman/RTL2/RTL-Config.json RTL-Config.json
CMD tail -f /dev/null