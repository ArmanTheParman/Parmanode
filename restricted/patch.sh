#!/bin/bash
[[ $(uname) == "Darwin" ]] && exit 1
pn=$HOME/parman_programs/parmanode
dn=/dev/null

if grep -q b53bf7815b1369640fb98a522f136f93a726939f9ae39a93a4ecafbd42143327 \
     <(shasum -a 256 $pn/restricted/scripts/compile_dependency_script.sh) ; then
     sudo cp -r $pn/restricted/scripts/compile_dependency_script.sh /usr/local/parmanode >$dn 2>&1
     sudo chmod 750 /usr/local/parmanode/compile_dependency_script.sh
fi