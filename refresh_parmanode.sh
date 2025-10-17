#!/usr/bin/env bash
if ! git config --global user.email ; then git config --global user.email sample@parmanode.com ; fi
if ! git config --global user.name ; then git config --global user.name Parman ; fi
cd $HOME/parman_programs
rm -rf $HOME/parman_programs/parmanode
git clone https://github.com/armantheparman/parmanode.git 
echo "A new Parmanode directory has been cloned. Hit <enter>"
read
