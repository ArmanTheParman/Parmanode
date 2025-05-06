#!/bin/bash
echo "Content-Type: text/plain"
echo ""

source "/opt/parmanode/version.conf"
source "/opt/parmanode/src/ParmaView/sendtosocket.sh"
echo "$version" | sendtosocket 
echo "$version test"

