FROM debian:bullseye-slim
ENV DEBIAN_FRONTEND=noninteractive

#Joinmarket
RUN mkdir -p /jm/clientserver
WORKDIR /jm/clientserver
COPY . .

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
                   wget gnupg sudo procps vim nano curl git ca-certificates \
                   python3-venv curl python3-dev python3-pip build-essential automake \
                   pkg-config libtool libgmp-dev libltdl-dev libssl-dev libatlas3-base libopenjp2-7 \
    && pip3 install 'wheel>=0.35.1' \
    && ./install.sh --docker-install \
    && rm -rf /var/lib/apt/lists/*

CMD ["tail" , "-f", "/dev/null"]
