function make_docker_compose {

source $HOME/.bitcoin/bitcoin.conf

 echo "services:
  web:
    environment:
      FRONTEND_HTTP_PORT: \"8080\"
      BACKEND_MAINNET_HTTP_HOST: \"api\"
    image: mempool/frontend:latest
    user: \"1000:1000\"
    restart: always 
    stop_grace_period: 1m
    command: \"./wait-for db:3306 --timeout=720 -- nginx -g 'daemon off;'\"
    ports:
      - 4080:8080
  api:
    environment:
      ELECTRUM_HOST: \"192.168.0.206\"
      ELECTRUM_PORT: \"50002\"
      ELECTRUM_TLS_ENABLED: \"true\"
      MEMPOOL_BACKEND: \"electrum\"
      CORE_RPC_HOST: \"192.168.0.206\"
      CORE_RPC_PORT: \"8332\"
      CORE_RPC_USERNAME: \"$rpcuser\"
      CORE_RPC_PASSWORD: \"$rpcpassword\"
      DATABASE_ENABLED: \"true\"
      DATABASE_HOST: \"db\"
      DATABASE_DATABASE: \"mempool\"
      DATABASE_USERNAME: \"mempool\"
      DATABASE_PASSWORD: \"mempool\"
      STATISTICS_ENABLED: \"true\"
    image: mempool/backend:latest
    user: \"1000:1000\"
    restart: unless-stopped 
    stop_grace_period: 1m
    command: \"./wait-for-it.sh db:3306 --timeout=720 --strict -- ./start.sh\"
    volumes:
      - ./data:/backend/cache
  db:
    environment:
      MYSQL_DATABASE: \"mempool\"
      MYSQL_USER: \"mempool\"
      MYSQL_PASSWORD: \"mempool\"
      MYSQL_ROOT_PASSWORD: \"admin\"
    image: mariadb:10.5.8
    user: \"1000:1000\"
    restart: always
    stop_grace_period: 1m
    volumes:
      - ./mysql/data:/var/lib/mysql" | tee $HOME/parmanode/mempool/docker/docker-compose.yml >(tee \
      $HOME/parmanode/mempool/mempool-config.json)
}