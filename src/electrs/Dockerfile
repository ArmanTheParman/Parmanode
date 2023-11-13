FROM rust:1.67

RUN apt-get update -y
RUN apt-get install -y sudo vim curl git

#Make users and groups and directories
RUN groupadd -r parman && useradd -m -g parman -u 1000 parman 
RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd

USER parman

RUN mkdir -p /home/parman/parmanode
RUN cd $HOME/parmanode/ && git clone --depth 1 https://github.com/romanz/electrs
RUN cd $HOME/parmanode/electrs && cargo build --locked --release

CMD tail -f /dev/null