#!/usr/bin/env bash
if ! git config --global user.email >/dev/null ; then git config --global user.email sample@parmanode.com >/dev/null ; fi
if ! git config --global user.name >/dev/null  ; then git config --global user.name Parman >/dev/null  ; fi
cd $HOME/parman_programs >/dev/null
rm -rf $HOME/parman_programs/parmanode
git clone https://github.com/armantheparman/parmanode.git 
echo -e "\n\nA new Parmanode directory has been cloned. Hit <enter>"
read
