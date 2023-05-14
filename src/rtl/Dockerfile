FROM node
ARG USERNAME
ARG USERID

RUN apt-get update
RUN apt-get install -y wget gnupg sudo procps vim curl git

#Make users and groups and directories
RUN groupadd -r $USERNAME && useradd -m -g $USERNAME $USERNAME 
RUN chown -R $USERID:$USERID /home/$USERNAME

WORKDIR /home/$USERNAME/
RUN mkdir .lnd rtl_db
RUN git clone https://github.com/Ride-The-Lightning/RTL.git
RUN cd RTL && npm install --omit=dev --legacy-peer-deps
RUN cp /home/$USERNAME/RTL /home/$USERNAME/RTL2

CMD tail -f /dev/null