#!/usr/bin/env bash
clear
# Ensuring git user/email settings exist
if ! git config --global user.email >/dev/null ; then git config --global user.email sample@parmanode.com >/dev/null ; fi
if ! git config --global user.name >/dev/null  ; then git config --global user.name Parman >/dev/null  ; fi

cd $HOME/parman_programs >/dev/null
mv $HOME/parman_programs/parmanode $HOME/parman_programs/parmanode_temp
git clone https://github.com/armantheparman/parmanode.git && rm -rf $HOME/parman_programs/parmanode
echo -e "\n\nA new Parmanode directory has been cloned.
You must exit this directory and re-enter it to refresh its contents.\n"

