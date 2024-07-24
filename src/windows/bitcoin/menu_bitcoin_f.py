from tools.screen_f import *
from bitcoin.bitcoin_functions_f import *

def menu_bitcoin():

while True:

#get drive info
    try:
        drive = pco.grep("drive_bitcoin=", returnline=True).strip().split("=")[1]
    except:
        pass

    if drive == None: drive = " ---- "
#get running info


    #isbitcoinrunning
        output1=f"                   Bitcoin is{green} RUNNING{orange}
        output2=f"                   Sync'ing to the {drive} drive"
        stop=f"{red}"
        output1=f"                   Bitcoin is{red} NOT running{orange} -- choose \"start\" to run"
        output2=f"                   Will sync to the {drive} drive"
        start=f"{green}"

    #    output4=f"""                   Bitcoin Data Usage: {red}$(du -shL $HOME/.bitcoin | cut -f1)"{orange}"""

        print(f"""{orange}
########################################################################################
                                {cyan}Bitcoin Core Menu{orange}                               
########################################################################################

{output1}

{output2}"

{start}
      (start){orange}    Start Bitcoind............................................(Do it)

      (stop)     Use your mouse to close the Bitcoin window
{cyan}
   More options coming soon...

{orange}
########################################################################################
""")

        choice = choose("xpmq")
        set_terminal()

        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return True
        elif choice.upper() == "M":
            return True
        elif choice.lower() == "start":
            start_bitcoind()
            continue
        else:
            invalid()







# {orange}
#       (n)        Access Bitcoin node information ....................(bitcoin-cli)

#       (bc)       Inspect and edit bitcoin.conf file 

#       (up)       Set, remove, or change RPC user/pass
# {bright_blue}
#       (tor){orange}      Tor menu options for Bitcoin...

#       (mm)       Migrate/Revert an external drive...

#       (delete)   Delete blockchain data and start over (eg if data corrupted)

#       (update)   Update Bitcoin wizard
# {output3}
#       (o)        OTHER...


# ########################################################################################
# "
