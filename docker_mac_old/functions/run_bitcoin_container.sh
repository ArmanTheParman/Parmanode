function run_bitcoin_container {
clear
echo "
The Parmanode Bitcoin Docker container is about to be created from the downloaded image with
the "run" command. Running a container and Restarting are different things. Run creates
the container, Restart takes an existing container and starts it again. The terminolgy is
confusing, not my fault, blame Docker devs.

The container will be called:  \"parmanode_bitcoin_container\". 

Do not create more than one container mounting to the same directory, it may corrupt all 
the bitcoin data.

If you already have a container called "parmanode_bitcoin_container" you can \"restart\"
it from the terminal like this:

    sudo docker restart parmanode_bitcoin_container

If you want to start from scratch, you'll need to stop the container, delete it, and then
download/load/run it again.

To check if you have an existing container active or stopped, you can type this in
your Mac terminal:

        sudo docker ps -a

you can stop, then delete the container like this:

        sudo docker stop parmanode_bitcoin_container

        sudo docker rm parmanode_bitcoin_container

###############################################################################################

"

echo " 
If you have prepared an external drive, attach it now and hit <enter> to proceed.

Otherwise, if you want to use an internal drive, disconnect any external drive labelled 
\"parmanode\", and hit enter to proceed.

"
read
clear
if [[ -d /Volumes/parmanode/bitcoin_data ]]
then
echo "

Running parmanode_bitcoin_container mounted to external drive at /Volumes/parmanode/bitcoin_data/ 

Access bitcoin via port 8332 once blochain is synced; It will take several days to sync.

Remember, to check if you have an existing container active or stopped, you can type this in
your Mac terminal:

        sudo docker ps -a

Hit <enter> to continue, control-c to quit.
"
read

sudo nohup docker run -d --name parmanode_bitcoin_container -p 8332:8332 -v /Volumes/parmanode/bitcoin_data:/home/parman/.bitcoin parmanode_bitcoin_container >/dev/null &
sleep 3

else
    echo "
    No external drive detected, or correct directories not prepared. Switching to run on internal drive. 
    Hit <enter> to accept this or control-c to quit."
    read
    
    if [[ -d $HOME/parmanode/bitcoin_data ]]
    then
    sudo nohup docker run -d --name parmanode_bitcoin_container -p 8332:8332 -v $HOME/parmanode/bitcoin_data:/home/parman/.bitcoin parmanode_bitcoin_container >/dev/null &
    sleep 3
    
    else
    echo "The container has not been run because the correct directories were not found. Has the drive been prepared?"
    sleep 7
    fi
    
fi
}