function bash_check {
if which brew >/dev/null 2>&1 ; then
if [[ $bashV_major -lt 5 ]] ; then

while true ; do
set_terminal
echo -e "
########################################################################################

    Parmanode has detected your computer is using an old version of Bash, the
    program that runs your Terminal. Upgrading will give you unspeakable benefits.

    But it can take several minutes. Shall Parmanode upgrade it for you?
    

            y)    Oooooh, yes please     

            n)    Nah, but I might do it later, who knows? (If so, choose \"Update
                  computer\" from Parmanode Tools menu when you're ready.)


    If you forget, Parmanode will ask you again at random and annoying times. 

########################################################################################            

Hit y or n, then <enter>
"
read choice
case $choice in
y|Y)
brew install bash
;;
n|N)
break
;;
esac
done
fi 
fi
}