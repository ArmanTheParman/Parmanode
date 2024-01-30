function make_mempool_docker_compose {
source $bc >/dev/null 2>&1
file="/tmp/docker-compose.yml"

if [[ $OS == Linux ]] ; then
  mariadb_data="./data"
  mysql_data="./mysql_data"
elif [[ $OS == Mac ]] ; then
  mariadb_data="mariadb_data"
  mysql_data="mysql_data"
fi

cat << EOF | tee $file >/dev/null 2>&1
version: "3.7"

networks:
    PM_network:
      driver: bridge

services:
  mempool_web:
    environment:
      FRONTEND_HTTP_PORT: "8180"
      BACKEND_MAINNET_HTTP_HOST: "api"
    image: mempool/frontend:latest
    user: "0:0"
    restart: on-failure
    stop_grace_period: 1m
    command: "./wait-for db:3306 --timeout=720 -- nginx -g 'daemon off;'"
    ports:
      - 8180:8180
    networks:
      - PM_network
  api:
    environment:
      MEMPOOL_BACKEND: "none" #or "electrum"
      CORE_RPC_HOST: "$IP"
      CORE_RPC_PORT: "8332"
      ELECTRUM_HOST: "$IP"
      ELECTRUM_PORT: "50006"
      ELECTRUM_TLS_ENABLED: "true"
EOF
echo "      CORE_RPC_USERNAME: \"$rpcuser\"" | tee -a $file >/dev/null 2>&1
echo "      CORE_RPC_PASSWORD: \"$rpcpassword\"" | tee -a $file >/dev/null 2>&1

cat << EOF | tee -a $file >/dev/null 2>&1
      DATABASE_ENABLED: "true"
      DATABASE_HOST: "db"
      DATABASE_DATABASE: "mempool"
      DATABASE_USERNAME: "mempool"
      DATABASE_PASSWORD: "mempool"
      STATISTICS_ENABLED: "true"
      SECOND_CORE_RPC_HOST: ""
      SECOND_CORE_RPC_PORT: ""
      SECOND_CORE_RPC_USERNAME: ""
      SECOND_CORE_RPC_PASSWORD: ""
      SECOND_CORE_RPC_TIMEOUT: ""
      SECOND_CORE_RPC_COOKIE: "false"
      SECOND_CORE_RPC_COOKIE_PATH: ""
      SOCKS5PROXY_ENABLED: "false"
      SOCKS5PROXY_HOST: "127.0.0.1"
      SOCKS5PROXY_PORT: "9050"
      SOCKS5PROXY_USERNAME: "" #leave blank
      SOCKS5PROXY_PASSWORD: "" #leave blank
      LIGHTNING_ENABLED: "false"
      LIGHTNING_BACKEND: "lnd"
      LIGHTNING_TOPOLOGY_FOLDER: ""
      LIGHTNING_STATS_REFRESH_INTERVAL: 600
      LIGHTNING_GRAPH_REFRESH_INTERVAL: 600
      LIGHTNING_LOGGER_UPDATE_INTERVAL: 30
EOF

echo "      LND_TLS_CERT_PATH: \"$HOME/.lnd\"" | tee -a $file >/dev/null 2>&1
echo "      LND_MACAROON_PATH: \"$HOME/.lnd/data/chain/bitcoin/mainnet\"" | tee -a $file >/dev/null 2>&1

cat << EOF | tee -a $file >/dev/null 2>&1
      LND_REST_API_URL: "https://localhost:8080"
      LND_TIMEOUT: 10000

    image: mempool/backend:latest
    user: "0:0"
    restart: on-failure
    stop_grace_period: 1m
    command: "./wait-for-it.sh db:3306 --timeout=720 --strict -- ./start.sh"
    volumes:
      - $mariadb_data:/backend/cache
    networks:
      - PM_network
  db:
    environment:
      MYSQL_DATABASE: "mempool"
      MYSQL_USER: "mempool"
      MYSQL_PASSWORD: "mempool"
      MYSQL_ROOT_PASSWORD: "admin"
    image: mariadb:10.5.21
    user: "0:0"
    restart: on-failure
    stop_grace_period: 1m
    volumes:
      - $mysql_data:/var/lib/mysql
    networks:
      - PM_network
EOF

}