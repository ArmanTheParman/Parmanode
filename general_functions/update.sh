function update_computer {
#update computer

set_terminal
echo "
########################################################################################

          It is recommended that you update your operating system first.

########################################################################################

Do that now? y or n :" ; read choice

if [[ $choice == "y" || $choice == "Y" || $choice == "yes" ]]
then
    sudo apt-get update -y 2>/dev/null
    sudo apt-get upgrade -y 2>/dev/null

    #if user is running as root, above command may not work. Repeat without "sudo"
    apt-get update -y 2>/dev/null
    apt-get upgrade -y 2>/dev/null
echo "
"
enter_continue
fi
return 0
}
