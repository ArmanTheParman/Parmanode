import os, subprocess
from text_functions.terminal import *
from text_functions.colours import *

def intro():
    #later; hide messages option
    set_terminal()
    if subprocess.run("""grep -q "hide_messages=1" < $HOME/.parmanode/hide_messages.conf""", shell=True, capture_output=True).returncode == 0:
        return 0
    while True:
        print(f"""{orange}
########################################################################################

           {cyan}                  P  A  R  M  A  N  O  D  E    {orange}

########################################################################################
        
    Welcome to PARMANODE, an easy AF way to install and run Bitcoin on your desktop
    computer. Parmanode is Free Open Source Software (FOSS).


    Requirements:

            1) This version is for{green} Windows{orange}, tested on version 10 and above.
            
            2) An external OR internal drive (1 Tb SSD recommended)

            3) Users must not hold ANY shitcoins! (Honesty system)


    To report bugs:
                   - armantheparman@protonmail.com

                   - Telegram chat: https:/t.me/parmanode

########################################################################################

    Hit{cyan} <enter>{orange} to continue, or{cyan} (q){orange} to quit, then <enter>.

    If you hold shitcoins, please hit$cyan (s)$orange - be honest!

    To hide this screen next time, type{pink} \"Free Ross\"{orange} then <enter>.
""")
        choice = input()
        set_terminal()

        if choice == 's' or "S" :
            continue
        elif choice == "q" or "Q":
            exit(0)
        elif choice == "Free Ross" or "free ross":
            os.system("""echo 'hide_messages=1' | tee -a $HOME/.parmanode/hide_messages.conf""") 
        else:
            break

    set_terminal() 
    return 0

