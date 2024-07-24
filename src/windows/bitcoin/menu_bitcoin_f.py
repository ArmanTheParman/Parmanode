from tools.screen_f import *
from bitcoin.bitcoin_functions_f import *

def menu_bitcoin():

    while True:

        #get drive info

        try:
            drive = pco.grep("drive_bitcoin=", returnline=True).strip().split("=")[1]
        except:
            pass

        if drive == None: drive = f" ---- "

        #get running info

        isbitcoinrunning = is_process_running("bitcoind.exe")

        if isbitcoinrunning == True:
            output1=f"""                                Bitcoin is{green} RUNNING{orange}"""
        else:
            output1=f"""                                Bitcoin is{red} NOT running{orange}""" 

        output2=f"""                                Sync'ing to the {drive} drive"""
        stop=f"{red}"
        output2=f"""                                Will sync to the {drive} drive"""
        start=f"{green}"

        #    output4=f"""                   Bitcoin Data Usage: {red}$(du -shL $HOME/.bitcoin | cut -f1)"{orange}"""
        set_terminal()
        print(f"""{orange}
########################################################################################{cyan}
                                Bitcoin Core Menu{orange}                   
########################################################################################


{output1}

{output2}

{green}
      (start){orange}    Start Bitcoind
{red}
      (stop){orange}     Just use your mouse to close the Bitcoin window


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
            if isbitcoinrunning == True: continue
            start_bitcoind()
            continue
        elif choice.lower() == "stop":
            set_terminal()
            announce(f"""Use your mouse to stop Bitcoin from its window.""")
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
