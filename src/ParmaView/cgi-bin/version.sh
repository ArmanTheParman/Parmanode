#!/bin/bash
echo "Content-Type: text/plain"
echo ""

source "$HOME/parman_programs/parmanode/version.conf"
source "$HOME/parman_programs/parmanode/src/ParmaView/sendtosocket.sh"
sendtosocket "$version"
