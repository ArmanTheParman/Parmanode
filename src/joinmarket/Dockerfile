FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND=noninteractive

#Joinmarket
RUN mkdir -p /jm/clientserver
WORKDIR /jm/clientserver
COPY . .

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
                   wget gnupg sudo procps vim nano curl git ca-certificates
RUN apt-get install -y --no-install-recommends \
                   python3-venv curl python3-dev python3-pip build-essential automake
RUN apt-get install -y --no-install-recommends \
                   pkg-config libtool libgmp-dev libltdl-dev libssl-dev libatlas3-base libopenjp2-7


RUN pip3 install 'wheel>=0.35.1' 
RUN ./install.sh --docker-install
RUN rm -rf /var/lib/apt/lists/*

CMD ["tail" , "-f", "/dev/null"]
