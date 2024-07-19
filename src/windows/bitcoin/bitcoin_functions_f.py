from parmanode.dirty_shitcoiner import *
from config.variables_f import *
from tools.screen_f import *
from tools.files_f import *
from tools.system_f import *
from tools.drive_f import *

def download_bitcoin():
    try:
        url = "https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1-win64.zip"
        please_wait(f"{green}Downloading Bitcoin{orange}")
        download(url, str(bitcoinpath))
        zippath = bitcoinpath / "bitcoin-27.1-win64.zip"
        please_wait(f"{green}Unzipping Bitcoin{orange}")
        unzip_file(str(zippath), directory_destination=str(bitcoinpath)) 
        return True
    except:
        return False


def choose_drive():
    set_terminal()
    while True:
        print(f"""{orange}
########################################################################################


    You have the option to use an{green} external{orange} or {cyan}internal{orange} hard drive for the 
    data.


    Please choose an option:



{green}                (e){orange}     Use an EXTERNAL drive (choice to format) 

{cyan}                (i){orange}     Use an INTERNAL drive 



########################################################################################""")

        choice = choose("xpmq")
        if choice in {"q", "Q", "Quit", "exit", "EXIT"}: 
            quit()
        elif choice in {"p", "P"}:
            return False
        elif choice in {"m", "M"}:
            if not back2main(): return False
        elif choice in {"e", "E"}:
            drive_bitcoin = "external" #global var
            if not format_choice("bitcoin"): return False
            pco.add("drive_bitcoin='external'")
            input("check pco add drive bitcoin = ext")
            return True
        elif choice in {"i", "I"}:
            drive_bitcoin = "internal" #global var
            pco.add("drive_bitcoin='internal'")
            pco.remove("format_disk=True") #redundant
            if not choose_drive2(): return False 
            else: return True
        else:
            invalid()

def choose_drive2():
    while True:
        set_terminal()
        print(f"""
######################################################################################## 

    You have chosen to use the{green} Internal drive{orange} for the Bitcoin Timechain. 
    
    The data will be kept at{cyan} 

        {default_bitcoin_data_dir}{orange}

    Hit{green} <enter>{orange} to continue
    
    or
    
    Type {red}x{orange} to choose a custom path to where you want the data to go, and Parmanode 
    will create a symlink from the above folder to your preferred target folder. 
    This will "trick" Bitcoin to download to your preferred location even though it 
    thinks it's downloading to the above default location. It's ok, it's ethical and 
    no coins will be harmed. 
   
    Most people will just keep it at the default location.
    Hit{green} <enter>{orange} alone for that.
    
########################################################################################
""")
        choice = input()
        set_terminal()
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            if not back2main(): return False
        elif choice == "":
            h = str(HOME)
            pco.add(f"bitcoin_dir='{h}\\Appdata\\Roaming\\Bitcoin'")
            del h
            return True
        elif choice.upper() == "X":
            if not (result := get_custom_directory("bitcoin")): return False
            if result == "try again": continue
            if type(result) == bool: return result
            else: return False
        else:
            invalid()

        
def get_custom_directory(app="bitcoin"):
    example_dir = Path.home() / "some_folder"
    while True:
        print(f"""{orange}
########################################################################################

    Please type in the path where you want the Bitcoin data to be stored. Be careful,
    and make sure you type the correct path EXACTLY. If the folder you type
    does not exist, it will be created. Don't mess this up.
    
    You can abort if you want, otherwise, type it in and hit{cyan} <enter>{orange}

    Example: 
    {cyan} 
        {example_dir}{orange}    

########################################################################################
""")
        choice = choose()
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            if not back2main(): return False
        elif choice == "":
            return True 
        elif choice.upper().startswith('C:\\'):
            if not (confirm := bitcoin_folder_choice_confirm(choice)): return False
            if confirm == "try again": continue
            return confirm #bool
        else:
            set_terminal()
            announce(r"    Drive C:\ expected in your path. Try again.", ec_text="try again")
            continue
            

def bitcoin_folder_choice_confirm(folder):
    while True:
        set_terminal()    
        print(f"""
########################################################################################

    You have chosen the following for the Bitcoin data folder. The Timechain will
    be downloaded inside this folder: 
{cyan}
        {folder} {orange}
    
    Is this correct?
   {green} 
                     y)        Yes, let's do this
        {red}             
                     n)        No, I'll try again.
{orange}
########################################################################################
""")
        choice = choose()  
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            if not back2main(): return False
        elif choice.upper() == "Y":
            pco.add(f"bitcoin_dir='{folder}'")
            try:
                if not Path(folder).exists(): Path(folder).mkdir(parents=True, exist_ok=True)
            except Exception as e:
                pco.remove("bitcoin_dir=")
                set_terminal()
                print("Unable to create directory. Please try again. Hit <enter> first.")
                input()
                return "try again"
            return True 
        elif choice.upper() == "N":
            return "try again"

def format_choice(app="bitcoin"):
    while True:
        set_terminal()
        print(f"""
########################################################################################

    You have chosen to use an{cyan} external drive{orange}.
              
    You have more choices:
{green}    
              1)    Set up a new drive{orange} (Will be formatted and initialised)
{red}
              2)    Bring in a used drive{orange} 
                          ... Parmanode will need to change the label to 'parmanode'
                          ... You can select a directory with a pre-existing copy
                              of the timechain.

########################################################################################
""")
        choice = choose()  
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            if not back2main(): return False
        elif choice == "1":
            pco.add("format_disk=True")
            #input("chec pco add format_disk=True")
            return True 
        elif choice == "2":
            pco.remove("format_disk=True")
            if used_disk(): 
                return True 
            return False
        else:
            invalid()

def used_disk():
    while True:
        set_terminal()
        print(f"""
########################################################################################

    You have chosen to sync Bitcoin to a previously used disk.
    
    Please type the path to the folder on the drive exactly, including the drive
    letter. If the directory does not exist, Parmanode will create it. Eg:
    {cyan} 
        D:\\bitcoin {orange}
    
########################################################################################
""")    
        choice = choose()  
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            if not back2main(): return False
        elif choice[1] == ":":
            if not (confirm := bitcoin_folder_choice_confirm(choice)): return False #directory will be created
            if confirm == "try again": continue
            if confirm == False: return False
            drive_letter = choice[0].upper()
            if label_disk(drive_letter): return True
            else: return False
        else:
            invalid()

def label_disk(drive_letter, new_label="parmanode"):

    try:
        subprocess.run(['label', f'{drive_letter}:', new_label], check=True)
        return True

    except subprocess.CalledProcessError as e:
        print(f"Failed to label the disk: {e}")
        enter_continue()
        return False

def prune_choice():
    while True:
        set_terminal()
        print(f"""
########################################################################################
      {cyan}                               
                                     PRUNING
{orange}
    Bitcoin core needs about 1Tb of free data, either on an external drive or 
    internal drive (500 Gb approx for the current blockchain, plus another 500 Gb for 
    future blocks).

    If space is an issue, you can run a pruned node, but be aware it's unlikely you'll
    have an enjoyable experience. I recommend a pruned node only if it's your only
    option, and you can start over with an "unpruned" node as soon as you reasonably 
    can. Pruned nodes still download the entire chain, but then discard the data to 
    save space. You won't be able to use wallets with old coins very easily and 
    rescanning the wallet may be required without you realising - and that is SLOW.
{cyan}
    Would you like to run Bitcoin as a pruned node (not recommended generally)? {orange} 
    This will require about 4 Gb of space for the minimum prune value.


                  {red}            prune)     I want to prune

{orange}                              s)         I enjoy shitcoining

{green}                              n)         No pruning

{orange}
########################################################################################
""") 
        choice = choose().upper()
        if choice == "N": return True
        if choice == "S": dirty_shitcoiner() ; continue
        if choice == "PRUNE": 
            if set_the_prune(): return True
            else: return False

def set_the_prune():
    while True:
        set_terminal()
        print(f"""
########################################################################################

    Enter a{cyan} pruning value{orange} in megabytes (MB) between{yellow} 550{orange} and {yellow}50000{orange}.
    No commas, and no units (zero turns pruning off, and numbers under the 550 
    minimum will set to 550 anyway).

########################################################################################
""")
        
        prunevalue = choose("xpmq")
        choice = prunevalue
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            back2main()
        elif not prunevalue.isnumeric():
            invalid()
            continue
        elif int(prunevalue) == 0:
            return True
        elif int(prunevalue) < 550 or int(prunevalue) > 50000:
            invalid()
            continue
        else:
            pco.add(f"prune_value={prunevalue}")
            return True

def make_bitcoin_conf():

    bitcoin_conf = bitcoin_diro / "bitcoin.conf"
    if bitcoin_conf.exists():
        result = bitcoin_conf_exists()
        if result == False: return False
        if result == "YOLO": return True
        if result == "O": bitcoin_conf.unlink() #delete 

    contents = f"""
server=1
txindex=1
daemon=1
blockfilterindex=1
rpcport=8332
rpcuser=parman
rpcpassword=parman
zmqpubrawblock=tcp://*:28332
zmqpubrawtx=tcp://*:28333

whitelist=127.0.0.1
rpcbind=0.0.0.0
rpcallowip=127.0.0.1
rpcallowip=10.0.0.0/8
rpcallowip=192.168.0.0/16
rpcallowip=172.0.0.0/8
rpcallowip={IP1}.{IP2}.0.0/16
rpcservertimeout=120"""

    bitcoin_confo = config(bitcoin_conf)
    bitcoin_confo.add(contents)
    del contents

def bitcoin_conf_exists():

    print(f"""
########################################################################################

    A{cyan} bitcoin.conf{orange} file already exists. You can keep the one you have, but be
    aware if this file was not originally birthed by Parmanode, it may cause conflicts
    if there are unexpected settings. Your prune choice will still be added to it if
    you made one.

    It's probably safest to discard the old copy, but the choice is yours...
{green}
                           o)           overwrite
{orange}
                           yolo)        keep the one you have
{red}
                           a)           abort installation
{orange}
########################################################################################
""")
    choice = choose("xmq")

    if choice.upper() in {"Q", "EXIT"}: 
        quit()
    elif choice.upper() in {"M", "A"}:
        back2main()
    elif choice.upper() == "O":
        return "O"
    elif choice.upper() == "YOLO":
        return "YOLO"
    else:
        invalid()