function load_bitcoin_container {
clear
echo " 
Loading parmanode_bitcoin_container into Docker:

"

sudo docker load -i $HOME/parmanode/parmanode_bitcoin_container.tar

echo "done
"
sleep 2
clear
return 0
}
