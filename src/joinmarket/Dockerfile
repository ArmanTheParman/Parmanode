FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND=noninteractive

#Joinmarket
RUN mkdir -p /jm/clientserver
WORKDIR /jm/clientserver

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
                   wget gnupg sudo procps vim nano curl git ca-certificates
RUN apt-get install -y --no-install-recommends \
                   python3-venv curl python3-dev python3-pip build-essential automake
RUN apt-get install -y --no-install-recommends \
                   pkg-config libtool libgmp-dev libltdl-dev libssl-dev libatlas3-base libopenjp2-7
RUN apt-get install -y --no-install-recommands \
                   less tmux

COPY . .

RUN pip3 install 'wheel>=0.35.1' 
RUN ./install.sh --docker-install --without-qt 
RUN rm -rf /var/lib/apt/lists/*

WORKDIR /jm/clientserver/scripts
CMD ["tail" , "-f", "/dev/null"]
