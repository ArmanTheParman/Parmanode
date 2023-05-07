#Make users and groups and directories
RUN groupadd -r bitcoin && useradd -r -g bitcoin -u 1000 bitcoin
RUN mkdir /home ; mkdir /home/bitcoin ; mkdir /home/bitcoin/.bitcoin ; mkdir /home/bitcoin/downloads
RUN chown -R bitcoin:bitcoin /home/bitcoin

# Bitcoin Core 24.0.1 download
USER bitcoin
WORKDIR /home/bitcoin/downloads
RUN wget https://bitcoincore.org/bin/bitcoin-core-24.0.1/bitcoin-24.0.1-x86_64-linux-gnu.tar.gz
RUN wget https://bitcoincore.org/bin/bitcoin-core-24.0.1/SHA256SUMS
Run wget https://bitcoincore.org/bin/bitcoin-core-24.0.1/SHA256SUMS.asc
Run sha256sum --ignore-missing --check SHA256SUMS

#check gpg sig
USER root
RUN gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys E777299FC265DD04793070EB944D35F9AC3DB76A
RUN if { gpg --verify SHA256SUMS.asc 2>&1 | grep -q Good ; } ; then true ; else exit ; fi

#unpack Bitcoin core:
USER bitcoin
RUN tar -xvf bitcoin*

#move bitcoin program files to new directory.
RUN mv /home/bitcoin/downloads/bit*/* /home/bitcoin/

#remove the downloaded files
RUN rm -rf /home/bitcoin/downloads/*

EXPOSE 8332


