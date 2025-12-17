#!/bin/bash
[[ $(uname) == "Darwin" ]] && exit 1
pn=$HOME/parman_programs/parmanode
dn=/dev/null

if grep -q 4d969c714ae0027a4d29952b8c69bd28958abc9ba29eb2d457fdde0db4b7e72b \
     <(shasum -a 256 $pn/restricted/scripts/compile_dependency_script.sh) ; then
     sudo cp -r $pn/restricted/scripts/compile_dependency_script.sh /usr/local/parmanode >$dn 2>&1
     sudo chmod 750 /usr/local/parmanode/compile_dependency_script.sh
fi

if grep -q 9ed45c79e22e499fba1a2cf7d7ab237d31ce701be0f2f00c455d46f0c71fb323 \
     <(shasum -a 256 $pn/restricted/scripts/compile_bitcoin.sh) ; then
     sudo cp -r $pn/restricted/scripts/compile_bitcoin.sh /usr/local/parmanode >$dn 2>&1
     sudo chmod 750 /usr/local/parmanode/compile_bitcoin.sh
fi


