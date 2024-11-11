#Fork of Public-Pool's Dockerfile for Parmanode.

############################
# Docker build environment #
############################

FROM node:18.16.1-bookworm-slim AS build

# Upgrade all packages and install dependencies
RUN apt-get update \
    && apt-get upgrade -y

# extra installs necessary for ARM computers to be able to compile
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        python3 \
        build-essential \
        cmake \
        ca-certificates \
        curl \
        procps \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /build

# Copies all files in Dockerfile's directory to /build
COPY . .

# Build Public Pool using NPM
RUN npm i && npm run build

############################
# Docker final environment #
############################

FROM node:18.16.1-bookworm-slim


# Expose ports for Stratum and Bitcoin RPC
EXPOSE 3333 3334 8332

WORKDIR /public-pool

# Copy built binaries into the final image, including the files copied from the Dockerfile's directory
# Given that the file should be mounted when the container is run, 
# the copying of .env into the container won't do anything.

COPY --from=build /build .

 # Install Tor
 RUN apt-get update \
     && apt-get install -y --no-install-recommends \
         tor \
     && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/local/bin/node", "dist/main", "tor"]
