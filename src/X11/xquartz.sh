#To be kept at parmanode.com 
#!/bin/bash

if [[ $(uname) != "Darwin" ]] ; then 
    clear
    echo "Not required unless you're on a Mac. Aborting."
    exit
fi

local tmp=$(mktemp -d)
clear
echo "Downloading XQuartz 2.8.5...\n"
cd $tmp && curl -LO https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg || {
    clear 
    echo "Something went wrong. Aborting."
    rm -rf $tmp
    exit
    }
clear
echo "Checking valid hash...\n"
if [[ $(shasum -a 256 $tmp/XQuartz-2.8.5.pkg |  awk '{print $1}') != "e89538a134738dfa71d5b80f8e4658cb812e0803115a760629380b851b608782" ]] ; then 
    clear 
    echo "Something went wrong. Aborting."
    rm -rf $tmp
    exit
fi

clear
echo "Installing pkg file...\n"
sudo installer -pkg XQuartz.pkg -target / \
  && { 
      clear 
      echo "XQuartz has been installed. Hit <enter>." 
      rm -rf $tmp >/dev/null 2>&1
      exit 
     }
clear 
echo "Something went wrong. Aborting."
rm -rf $tmp
exit



