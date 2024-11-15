FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND=noninteractive

#Joinmarket
RUN mkdir -p /jm/clientserver
WORKDIR /jm/clientserver

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
                   wget gnupg sudo procps vim nano curl git ca-certificates
RUN apt-get install -y --no-install-recommends \
                   python3-venv curl python3-dev python3-pip=* build-essential automake python3=* 
RUN apt-get install -y --no-install-recommends \
                   pkg-config libtool libgmp-dev libltdl-dev libssl-dev libatlas3-base libopenjp2-7 libgl1-mesa-glx
RUN apt-get install -y --no-install-recommends \
                   less tmux socat net-tools 

COPY . .
RUN pip3 install 'wheel>=0.35.1' 
#RUN pip3 install matplotlib PySide2
RUN ./install.sh --docker-install 
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /jm/clientserver/scripts
CMD [ "python3" , "/jm/clientserver/scripts/joinmarketd.py" ]
