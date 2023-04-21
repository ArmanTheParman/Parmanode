function menu_install_parmanode {

clear
echo "
####################################################################################################
To make sure everything runs smoothly, go through each of the menu options sequentially. Before
Bitcoin Core can run, the drive needs to be prepared. It is done automatically but you may do
it manually yourself (not recommended).

Docker needs to be installed; the Bitcoin Docker image needs to be downloaded and loaded to Docker; 
and the correct Docker command needs to be exectued. All of the hard work has been automated, but
you do maintain some level of control and have choices as you proceed through the steps. 

Do not attept to skip steps, bad thins could happen.
####################################################################################################

Hit <enter> to continue.
"
read
clear

while true
do

echo "

1: Prepare the hard drive

2: Download & Install Docker

3: Preapare Bitcoin Docker-Container

4: Install additional programs (optional)

Choose 1 to 4, p for previous, or q to quit, then <enter>.

"

read choice
case $choice in

1)
clear
menu_drive
return 0
;;

2)
clear
echo "

For Parmanode to work, Docker must be installed on your computer. This wizard will
install it for you. If it fails for some reason, you can install it yourself manually and proceed 
through the other steps from the previous menu.

On a Mac, the user must manually accept Docker's terms and conditions before anything will work.
You can close any Docker windows using the mouse (click the red x button), but do not shut down the
Docker process, or "close" form Mac's dock, nor from the menu bar (icon near the clock). The Docker 
program needs to be running in the backgroud.

"

read -p "Hit <enter> to continue."

clear

download_docker
install_docker
start_docker
return 0
;;

3)
clear
download_bitcoin_container
load_bitcoin_container
run_bitcoin_container
return 0

;;

4)
#add programs
clear
echo "Extras available in future versions."
echo "Hit <enter> to return to previous menu."
read
return 0
;;
p)
return 0
;;
q | Q | quit)
exit 0
;;
*)
clear
echo "Invalid option. Please try again."
read -p "Hit enter to continue"
;;
esac
done
}