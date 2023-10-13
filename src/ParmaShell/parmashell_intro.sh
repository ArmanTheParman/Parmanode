function parmashell_intro {

set_terminal ; echo -e "
########################################################################################
$green
                               Install ParmaShell
$orange 
     ParmaShell is the silly name I gave a collection of time-saving and terminal
     beautifying functions that will always be available whenever you open terminal.

     It will work on Linux and Mac.

     Once installed, check out the Tools menu to find info about what it can do. 
     It's easy to uninstall if you don't like it (you'll install it and like it).

########################################################################################
"
choose "epq" ; read choice ; set_terminal
case $choice in 
q|Q) exit ;;
p|P) return 1 ;;
esac

return 0
}