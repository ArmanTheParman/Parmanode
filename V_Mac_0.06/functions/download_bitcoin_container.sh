function download_bitcoin_container {
clear

echo "
The Bitcoin Docker Container will be dowloaded (if the file doesn't exist), \"loaded\" to Docker,
and then initialised (\"run\").

This only needs to be done once.

"
if [[ $HOME/parmanode/parmanode_bitcoin_container.tar ]]
then
echo "File exists. Download skpping...
"
else
echo "file does not exist. Downloading...
"
cd $HOME/parmanode/ && wget http://parman.org/downloadable/parmanode_bitcoin_container.tar
fi

echo "
done"

sleep 2
clear

}

