#!/bin/bash
[[ $(uname) == "Darwin" ]] && exit 1
pn=$HOME/parman_programs/parmanode
dn=/dev/null

if grep -q a1dc45b634ebdf04f7766678c0d48f05f6ca586d4b9bd241fa50653e8d00da58 \
     <(shasum -a 256 $pn/restricted/scripts/compile_dependency_script.sh) ; then
     sudo cp -r $pn/restricted/scripts/compile_dependency_script.sh /usr/local/parmanode >$dn 2>&1
fi