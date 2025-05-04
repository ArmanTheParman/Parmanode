#!/bin/bash

#    source $HOME/parman_programs/parmanode/src/config/parmanode_variables.sh 2>/dev/null
#    export cgi="true" && parmanode_variables 

    source $HOME/parman_programs/parmanode/version.conf

echo "Content-Type: application/javascript"
echo ""

cat <<EOF
let version;
version = "$version";
EOF