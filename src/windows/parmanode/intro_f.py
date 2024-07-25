########################################################################################
#intro()
#dirty_shitcoiner()
#suggestupdate()
#instructions()
########################################################################################

import time
from pathlib import Path
from config.variables_f import * 
from tools.debugging_f import *
from tools.files_f import *
from tools.screen_f import *
from tools.system_f import *

def intro():
    #later; hide messages option
    set_terminal()
    if pco.grep("hide_intro"):
        return True

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

        if choice in {'s', 'S'}:
            dirty_shitcoiner() 
            set_terminal()
            return True
        elif choice in {'q', 'Q'}:
            exit()
        elif choice in {'Free Ross', 'free ross'}:
            pco.add("hide_intro=True")
            set_terminal()
            return True
        elif choice == "":
            return True
        else:
            set_terminal()
            continue

def dirty_shitcoiner():
    set_terminal()
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
    return True


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
        pco.add("update_reminders_off=True")#tested at the start of check_updates()
    elif choice == "q": quit()
    return True


def instructions():
    if pco.grep("hide_instructions"):
        return True

    set_terminal()
    print(f"""
########################################################################################

                               {cyan}     Instructions{orange}

    1. Add individual programs from then{green} \"add\"{orange} menu. You don't need to install them 
       all.

    2. Use programs from the{green} \"use\"{orange} menu. 

    3. Each program has its{green} own menu{orange} nested under the \"use\" menu; various 
       functions are available for you to make it easier to interact with the program.
       
    4. You should reguarly{green} update{orange} Parmanode (the best way is from the Parmanode
       menu). 

########################################################################################
    
To hide this message next time, type in{pink} \"Free Ross\"{orange} then <enter>.

To continue on, just hit{cyan} <enter>{orange}.
""")
    choice = input().strip()    
    if choice in {'free ross' , "Free Ross"}:   
        pco.add("hide_instructions=True")
    elif choice in {"q", "Q", "quit"}:
        exit()
    return True
