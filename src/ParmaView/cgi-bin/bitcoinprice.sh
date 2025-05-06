#!/bin/bash
echo "Content-Type: application/json"
echo ""
curl -s "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd"
