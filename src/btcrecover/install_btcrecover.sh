function install_btcrecover {

# remove later...
docker stop btcrecover && docker rm btcrecover

########################################################################################

docker build -t btcrecover .

# docker network create --internal no-internet

# docker run -d --network no-internet --name btcrecover btcrecover  

docker run -d --name btcrecover btcrecover


}