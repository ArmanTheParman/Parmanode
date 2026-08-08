FROM mcr.microsoft.com/dotnet/sdk:10.0

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

ARG parmanID=1000
ARG btcpay_version="v2.0.3"

RUN apt-get update -y
RUN apt-get install -y \
    wget gnupg sudo procps vim nano curl git expect \
    iproute2 less ca-certificates jq file tor tmux \
    postgresql postgresql-contrib

# Remove whichever built-in user owns the UID so Parmanode can use it.
RUN existing_user="$(getent passwd ${parmanID} | cut -d: -f1)" && \
    if [ -n "$existing_user" ]; then userdel -r "$existing_user" || true; fi && \
    groupadd -r parman && \
    useradd -m -g parman -u ${parmanID} parman

RUN chown -R parman:parman /home/parman/
RUN echo 'parman:parmanode' | chpasswd
RUN usermod -aG sudo parman
RUN echo "Defaults !fqdn" >> /etc/sudoers

# PostgreSQL access
RUN usermod -aG parman postgres

USER parman

RUN mkdir -p /home/parman/parmanode
RUN mkdir -p /home/parman/Downloads
RUN mkdir -p /home/parman/parman_programs
RUN mkdir -p /home/parman/.parmanode && \
    touch /home/parman/.parmanode/installed.conf && \
    touch /home/parman/.parmanode/parmanode.conf

RUN cd /home/parman/parman_programs && \
    git clone https://github.com/armantheparman/parmanode.git

# Install NBXplorer
RUN cd /home/parman/parmanode && \
    git clone https://github.com/dgarage/NBXplorer && \
    cd NBXplorer && \
    git checkout v2.5.26 && \
    ./build.sh

RUN mkdir -p /home/parman/.nbxplorer/Main

# Install BTCPay Server
RUN cd /home/parman/parmanode && \
    git clone https://github.com/btcpayserver/btcpayserver.git && \
    cd btcpayserver && \
    git checkout ${btcpay_version} && \
    ./build.sh

RUN mkdir -p /home/parman/.btcpayserver/Main

CMD ["tail", "-f", "/dev/null"]