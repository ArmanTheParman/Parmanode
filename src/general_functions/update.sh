function update_computer {
#update computer

set_terminal
echo "
########################################################################################

          It is strongly recommended that you update your operating system first. 
          
          Especially if you have a Mac and have an old installation of \"Homebrew\",
          this really needs to be updated or you're likely to run into errors.

          Do look at the output, especially near the start; if there is a
          recommendation to run a command related to \"git unshallow\", then do that.
          This is a very recent change to Homebrew - I will make edits to Parmanode
          to take care of this for you in the future.

########################################################################################

Do that now? y or n :" ; read choice

if [[ $choice == "y" || $choice == "Y" || $choice == "yes" ]]
then

    if [[ $OS == "Linux" ]] ; then sudo apt-get update -y 
    sudo apt-get upgrade -y 
    fi
    
    if [[ $OS == "Mac" ]] ; then
        if ! command -v brew ; then return 0 ; fi
        brew update ; brew upgrade ; fi
echo "
"
enter_continue
fi
return 0
}
