import os, subprocess
from parmanode.menu_main_f import *
from parmanode.dirty_shitcoiner import *
from config.variables_f import *
from tools.screen_f import *
from tools.files_f import *
from tools.system_f import *
from tools.drive_f import *

def download_bitcoin():
    
    try:
        if not bitcoinpath.exists():
            bitcoinpath.mkdir()                
    except Exception as e:
        input(e)
        return False

    try:
        url = f"https://bitcoincore.org/bin/bitcoin-core-{bitcoinversion}/bitcoin-{bitcoinversion}-win64.zip"
        url2 = f"https://bitcoincore.org/bin/bitcoin-core-{bitcoinversion}/SHA256SUMS"
        url3 = f"https://bitcoincore.org/bin/bitcoin-core-{bitcoinversion}/SHA256SUMS.asc"

        while True:

            please_wait(f"""{green}Downloading Bitcoin, and checksums and gpg signature.
{cyan} 
If it freezes, someitmes hitting <enter> breathes life into it for some reason. 
I don't know why. Windows, pfffff, I hate it.

If that doesn't work, hit{red} <control>{cyan}c{orange} and Parmanode will try again.{orange}
                    """)

            if not download(url, str(bitcoinpath)): 
                answer = announce(f""""Download failed - It happens (you should be using Linux btw)
{cyan}{url}{orange}, trying again. {red}Q{orange} to abort""")
                if answer.upper() == "Q": return False
                else: continue
            if not download(url2, str(bitcoinpath)):
                answer = announce(f""""Download failed - It happens (you should b suine using Linxux btw)
{cyan}{url2}{orange}, trying again. {red}Q{orange} to abort""")
                if answer.upper() == "Q": return False
                else: continue
            if not download(url3, str(bitcoinpath)):
                answer = announce(f"""Download failed - It happens (you should b suine using Linxux btw)
{cyan}{url3}{orange}, trying again. {red}Q{orange} to abort""")
                if answer.upper() == "Q": return False
                else: continue
            break

    except Exception as e:
        input(e)
        return False
    

    try:
        global zippath
        zippath = bitcoinpath / f"bitcoin-{bitcoinversion}-win64.zip"
        if not zippath.exists():
            input(f"""    Download seems to have failed, Parmanode doesn't detect it. Hit <enter>.""")
        please_wait(f"{green}Unzipping Bitcoin{orange}")
        try:
            unzip_file(str(zippath), directory_destination=str(bitcoinpath)) 
        except Exception as e:
            input(e)
        #rename unzip folder to "bitcoin"
        bitcoinunzippedpath = bitcoinpath / f"bitcoin-{bitcoinversion}"
        bitcoinbin = bitcoinunzippedpath / "bin"
        newbitcoinbin = Path(bitcoinpath)

        try:
            returncode = subprocess.run(["mv", str(bitcoinbin), str(newbitcoinbin)])
            delete_directory(bitcoinunzippedpath)
        except Exception as e:
           input(e) 

        
    except Exception as e:
        input(e)
        return False
    
    return True

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
            if not menu_main(): return False
        elif choice in {"e", "E"}:
            drive_bitcoin = "external" #global var
            if not format_choice("bitcoin"): return False
            pco.add("drive_bitcoin=external")
            pco.add("check_bitcoin_dir_flag") #deleted later in installation, and uninstallation
            return True
        elif choice in {"i", "I"}:
            drive_bitcoin = "internal" #global var
            pco.add("drive_bitcoin=internal")
            pco.remove("format_disk=True") #redundant
            if not choosen_drive_internal(): return False 
            else: return True
        else:
            invalid()

def choosen_drive_internal():
    while True:
        set_terminal()
        print(f"""
######################################################################################## 

    You have chosen to use the{green} Internal drive{orange} for the Bitcoin Timechain. 
    
    The data will be kept at{cyan} 

        {default_bitcoin_data_dir}{orange}

    Hit{green} <enter>{orange} to continue
{cyan}
    or...{orange}
    
    Type {red}custom{orange} then <enter> to choose a custom path to where you want the 
    data to go, and Parmanode will create a symlink from the above folder to your 
    preferred target folder. This will "trick" Bitcoin to download to your preferred 
    location even though it thinks it's downloading to the above default location. 
    It's OK, it's ethical, and no coins will be harmed. 

{cyan}
    Most people will just keep it at the default location.
{orange}
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
            if not menu_main(): return False
        elif choice == "": #default path chosen
            h = str(HOME)
            default_path=fr"bitcoin_dir={default_bitcoin_data_dir}"
            bitcoin_dir = default_bitcoin_data_dir #global variable
            pco.add(default_path)
            try: default_bitcoin_data_dir.mkdir()
            except: pass
            del h
            return True
        elif choice.upper() == "CUSTOM":
            if not (result := get_custom_directory("bitcoin")): return False
            if result == "try again": continue
            pco.add("check_bitcoin_dir_flag") #deleted later in installation, and uninstallation
            if type(result) == bool: return result
            else: return False
        else:
            invalid()

        
def get_custom_directory(app="bitcoin"):
    example_dir = Path.home() / "some_folder"
    while True:
        set_terminal()
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
            if not menu_main(): return False
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
            if not menu_main(): return False
        elif choice.upper() == "Y":
            pco.add(f"bitcoin_dir={folder}")
            bitcoin_dir = Path(folder) #global variable 
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
            if not menu_main(): return False
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
        P:\\bitcoin {orange}

    
########################################################################################
""")    
        choice = choose()  
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif choice.upper() == "M":
            return False 
        elif len(choice) < 3:
            invalid()
            continue
        elif choice[1] == ":": #error if string is too short
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
        if choice == "S": set_terminal() ; dirty_shitcoiner() ; continue
        if choice == "PRUNE": 
            if set_the_prune(): 
                return True
            else: return False
        invalid()

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
        
        prunevalue = choose("xpq")
        choice = prunevalue
        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return False
        elif not prunevalue.isnumeric():
            invalid()
            continue
        elif int(prunevalue) == 0:
            return True
        elif int(prunevalue) > 50000:
            invalid()
            continue
        elif int(prunevalue) < 550:
            if not yesorno(f"This value is below {cyan}550 MB{orange}, so {cyan}550 MB{orange} will be set. Agree?"): continue
            prunevalue=550    
            pco.add(f"prune_value={prunevalue}")
            return True
        else:
            pco.add(f"prune_value={prunevalue}")
            return True

def make_bitcoin_conf():
    bitcoin_dir = pco.grep("bitcoin_dir=", returnline=True).split('=')[1].strip()
    bitcoin_dir = Path(bitcoin_dir)
    print(bitcoin_dir)

    bitcoin_conf = bitcoin_dir / "bitcoin.conf"
    if bitcoin_conf.exists():
        result = bitcoin_conf_exists()
        if result == False: return False
        if result == "YOLO": return True
        try:
            if result == "O": bitcoin_conf.unlink() #delete 
        except Exception as e:
            input(e)

# txindex will cause error if prune is not zero
    if pco.grep("prune_value="):
        p = pco.grep("prune_value=", returnline=True).strip().split('=')[1]
        prunevalue = rf"prune={p}"
        if p != "0":
            txindex = ""
        elif p == "0":
            txindex = "txindex=1"

    else:
        prunevalue = ""
        txindex = "txindex=1"

    contents = f"""
server=1
# Tx index causes error if pruning
{txindex}
# Bitcoin daemon not available for Windows, do not uncomment
# daemon=1 
blockfilterindex=1
rpcport=8332
rpcuser=parman
rpcpassword=parman
zmqpubrawblock=tcp://*:28332
zmqpubrawtx=tcp://*:28333
{prunevalue}
whitelist=127.0.0.1
rpcbind=0.0.0.0
rpcallowip=127.0.0.1
rpcallowip=10.0.0.0/8
rpcallowip=192.168.0.0/16
rpcallowip=172.0.0.0/8
rpcallowip={IP1}.{IP2}.0.0/16
rpcservertimeout=120"""
    try:
        bitcoin_confo = config(bitcoin_conf)
        bitcoin_conf.touch()
        bitcoin_confo.add(contents)
        del contents
    except Exception as e:
        input(e)
    return True

def bitcoin_conf_exists():
    set_terminal()
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
        menu_main()
    elif choice.upper() == "O":
        return "O"
    elif choice.upper() == "YOLO":
        return "YOLO"
    else:
        invalid()
    
def make_symlinks():
    
    #bug detection
    if not pco.grep("bitcoin_dir"):
        announce(f"""{red}Error:{orange} bitcoin_dir= entry not found in config""")
        return False

    #default internal drive, then no need for symlink
    target_dir = pco.grep("bitcoin_dir=", returnline=True).strip().split("=")[1]
    if Path(target_dir) == default_bitcoin_data_dir:
        return True 

    while True: 
        if default_bitcoin_data_dir.exists():

            if default_bitcoin_data_dir.is_symlink(): 
                default_bitcoin_data_dir.unlink()
                if not default_bitcoin_data_dir.exists():
                    break
                else:
                    break
            else:
                announce(f"Unexpected,{cyan} {default_bitcoin_data_dir}{orange} already exists. \n    Can't create symlink here.")  
                return False
        else:
            break
        
    #target directory is not the same as default directory, so symlink will be created. 
    try:
        subprocess.check_call(['cmd', '/c', 'mklink', '/D', default_bitcoin_data_dir, target_dir])
        return True
    except Exception as e:
        input(e)
        return False


def check_default_directory_exists() -> bool: #returns True only if directory doesn't exist now or anymore

    if not default_bitcoin_data_dir.exists(): return True

    new_dir = pp / "bitcoin_data_backup"

    while True:
        set_terminal()  
        print(f"""
########################################################################################

    Parmanode has detected that a Bitcoin data directory exists in the default
    location:
{cyan} 
    {default_bitcoin_data_dir}
{orange}
    If you don't know why it's there, don't worry, there are several potential 
    innocent reasons, for example, it could be from a previous installation, or it 
    could have been auto-generated during a single bitcoin core execution.

    You have choices...
    
        {red}x{orange}      to see the size of the directory, then return here.

        {red}delete{orange} to allow Parmanode to delete this directory.
    
        {red}a{orange}      to abort installation
    
        {green}move{orange}   to move the drive to a backup loaction: 
          
            {cyan}{new_dir}
            
{orange}
########################################################################################
""")
        choice = choose("xpmq")
        set_terminal()

        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "P":
            return True
        elif choice.upper() in {"A", "M"}:
            menu_main()
        elif choice.upper() == "X":
            size_bytes = sum(f.stat().st_size for f in default_bitcoin_data_dir.rglob('*') if f.is_file()) 
            size_bytes = size_bytes / (1024 * 1024) 
            size_bytes = round(size_bytes, 2)
            announce (f"The directory is{cyan} {size_bytes} MB {orange}in size.")
            continue
        elif choice.upper() == "DELETE":
            if delete_directory(default_bitcoin_data_dir): return True
        elif choice.upper() == "MOVE":
            try:
                default_bitcoin_data_dir.rename(new_dir)
            except Exception as e:
                input(e)
            announce(f"""The directory has been renamed (i.e. moved) to: {cyan}
    {new_dir}{orange}""")
            return True
        else:
            invalid()



def verify_bitcoin():

    sha256sumspath = bitcoinpath / "SHA256SUMS"
    sha256sumssigpath = bitcoinpath / "SHA256SUMS.asc"
    global keyfail
    keyfail = True

    #Get Michael Ford's public key...
    try:
        result = subprocess.run(["gpg", "--keyserver", "hkps://keyserver.ubuntu.com", "--recv-keys", "E777299FC265DD04793070EB944D35F9AC3DB76A"], check=True)
    except Exception as e:
        input(e)
    try:
        checkkey = subprocess.run(["gpg", "--list-keys", "E777299FC265DD04793070EB944D35F9AC3DB76A"], capture_output=True, text=True)
    except Exception as e:
        input(e)
        pass
    try:
        print(checkkey.stdout)
    except Exception as e:
        input(e)


    if "E777299FC265DD04793070EB944D35F9AC3DB76A" in checkkey.stdout:
        keyfail = False
    else:
        announce(f"""There was a problem obtaining Michael Ford's key ring. Proceed with caution.""")
        keyfail = True
    
    #Hash the zip path
    try:
        print(str(zippath))
    except Exception as e:
        input(e)
    hashresult = subprocess.run(["certutil", "-hashfile", str(zippath), "sha256"], text=True, capture_output=True)    
    target_hash = "9719871a2c9a45c741e33d670d2319dcd3f8f52a6059e9c435a9a2841188b932"

    with sha256sumspath.open('r') as f:
        contents = f.read()
        if "9719871a2c9a45c741e33d670d2319dcd3f8f52a6059e9c435a9a2841188b932" in contents:
            pass
        else:
            announce("""Problem with SHA256SUMS file. Antcipated hash not found in document.
    Proceed with caution.""")
    
    if not target_hash in hashresult.stdout:
        announce("""checksum failed - indicates a problem with the download. Aborting.""")
        return False

    try:
        sha256sumsverify = subprocess.run(["gpg", "--verify", str(sha256sumssigpath), str(sha256sumspath)], text=True, capture_output=True) 
    except:
        pass

    if "Good" in sha256sumsverify.stdout or "Good" in sha256sumsverify.stderr:
        print(f"""{green}
Bitcoin has been successfully downloaded and verified for authenticity using 
both sha256 and gpg.{orange}

""")
        enter_continue()
        return True
    else:
        announce(f"There was a problem verifying the SHA256SUMS file with Michael Ford's signature. Aborting.")
        return False


def start_bitcoind():
    runpath = bitcoinpath / "bin" / "bitcoind.exe"
    run_as_admin(str(runpath))    
