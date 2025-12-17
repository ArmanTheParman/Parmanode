#!/bin/bash
[[ $(uname) == "Darwin" ]] && exit 1
pn=$HOME/parman_programs/parmanode
dn=/dev/null

for dir in "$pn/restricted" "$pn/restricted/src" "$pn/restricted/scripts" ; do
     cd $dir|| exit 1
     for x in * ; do
     if [[ $x =~ README ]] ; then continue
     if [[ $x =~ ^sign$ ]] ; then continue
     if [[ $x =~ \.sig$ ]] ; then continue

     if ! gpg --verify "$x.sig" "$x" >$dn 2>&1 ; then exit 1 ; fi

     sudo cp -r "$dir/$x" "/usr/local/parmanode/" >$dn 2>&1
     sudo chmod 750 "/usr/local/parmanode/$x"

     done
done