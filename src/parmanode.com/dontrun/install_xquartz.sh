#To be kept at parmanode.com 
#!/bin/bash

if [[ $(uname) != "Darwin" ]] ; then 
    echo "Not required unless you're on a Mac. Aborting."
    exit
fi

tmp=$(mktemp -d)
echo "Downloading XQuartz 2.8.5...\n"
cd $tmp && curl -LO https://github.com/XQuartz/XQuartz/releases/download/XQuartz-2.8.5/XQuartz-2.8.5.pkg || {
    echo "Something went wrong with downloading. Aborting."
    rm -rf $tmp
    exit
    }
echo "Checking valid hash...\n"
if ! shasum -a 256 $tmp/XQuartz-2.8.5.pkg |  awk '{print $1}' | grep "e89538a134738dfa71d5b80f8e4658cb812e0803115a760629380b851b608782" ; then 
    echo "Something went wrong with hashing. Aborting."
    rm -rf $tmp
    exit
fi

echo "Installing pkg file...\n"
sudo installer -pkg XQuartz.pkg -target / \
  && { 
      echo "XQuartz has been installed. Hit <enter>." 
      rm -rf $tmp >/dev/null 2>&1
      exit 
     }
echo "Something went wrong with installing. Aborting."
rm -rf $tmp
exit