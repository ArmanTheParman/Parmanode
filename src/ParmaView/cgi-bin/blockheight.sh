#!/bin/bash
echo "Content-Type: text/plain"
echo ""

bitcoin-cli getblockchaininfo | jq ".blocks"