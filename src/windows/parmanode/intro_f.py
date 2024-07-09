########################################################################################
#intro()
#dirty_shitcoiner()
#suggestupdate()
########################################################################################

import time
from pathlib import Path
from functions.text_functions import *
from config.variables import * 

def intro():
    #later; hide messages option
    set_terminal()
    if searchin("hide_intro=1", hm): 
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

    If you hold shitcoins, please hit{cyan} (s){orange} - be honest!

    To hide this screen next time, type{pink} \"Free Ross\"{orange} then <enter>.
""")
        choice = input()
        set_terminal()

        if choice in {'s', 'S'}:
            dirty_shitcoiner() 
            break
        elif choice in {'q', 'Q'}:
            exit(0)
        elif choice in {'Free Ross', 'free ross'}:
            addline("hide_intro=1", hm)
            break
        else:
            break

    set_terminal() 
    return 0

def dirty_shitcoiner():
    while True: 
        set_terminal()
        print(f"""
########################################################################################
########################################################################################
{red}
             Shame on you.{orange} We're on the battle field, fighting tyranny, and
             you're using vital weapons to shoot ducks. Don't be a traitor to 
             your descendents and humanity. Stack bitcoin and help end tyranny.
		     
             Here's some reading material to help you understand...


     1) Why Bitcoin Only           {cyan}
                                    - http://www.armantheparman.com/why-bitcoin-only  {orange}
     2) Why money tends towards one {cyan}
                                    - http://www.armantheparman.com/onemoney {orange}

     3) We are separating money and state - Join us {cyan}
                                    -  http://www.armantheparman.com/joinus {orange}
     4) Debunking Bitcoin FUD {cyan}
                                    - http://www.armantheparman.com/fud {orange}

    
     Have a nice day.
    {green}
     To abort, type: (I'm sorry), then hit <enter>                 
{orange}
########################################################################################
######################################################################################## 
""") 
        repent = input()
        if "I'm sorry" in repent: 
            break 
        else:   
            set_terminal()
            print("Please wait patiently for computer to destroy itself, mwahaha!")
            time.sleep(3)
            input("Or, hit <enter> to have another go.") 
            set_terminal()
            continue 

    set_terminal()
    return 0

def suggestupdate():

    set_terminal()
    print(f"""
########################################################################################

    Parmanode has detected there is a newer version of itself. You could get that
    and replace the current executable you're using. All the installed programs and
    configuration won't be affected, jut the Parmanode wizard itself.
    
    Type{pink} 'Free Ross'{orange} to never be reminded of updates again. 

    Otherwise, just hit{green} <enter>{orange} to continue.

########################################################################################
""")
    choice = choose("xeq")
    if choice in {'free ross', 'Free Ross'}:
        addline("update_reminder=1", hm) #tested at the start of check_updates()
    elif choice == "q": quit()

    return 0 
