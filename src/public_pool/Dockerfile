# Fork of Public-Pool's Dockerfile for Parmanode.

############################
# Docker build environment #
############################

FROM node:18.19.1-bullseye-slim AS build

# Upgrade all packages and install dependencies
RUN apt-get update \
    && apt-get upgrade -y

# Extra installs necessary for ARM computers to be able to compile
RUN apt-get install -y --no-install-recommends python3
RUN apt-get install -y --no-install-recommends build-essential 
RUN apt-get install -y --no-install-recommends cmake g++ make
RUN apt-get install -y --no-install-recommends ca-certificates 
RUN apt-get install -y --no-install-recommends curl 
RUN apt-get install -y --no-install-recommends procps

WORKDIR /build

# Copies all files in Dockerfile's directory to /build
COPY . .

# Build Public Pool using NPM
RUN npm i && npm run build

############################
# Docker final environment #
############################

FROM node:18.19.1-bullseye-slim

# Expose ports for Stratum and Bitcoin RPC
EXPOSE 3333 3334 8332

WORKDIR /public-pool

# Copy built binaries into the final image, including the files copied from the Dockerfile's directory
# Given that the file should be mounted when the container is run,
# the copying of .env into the container won't do anything.

COPY --from=build /build .

# Install Tor
RUN apt-get update -y \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y tor \
    && apt clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/local/bin/node", "dist/main", "tor"]
