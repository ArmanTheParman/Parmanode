from config.variables_f import *
from tools.files_f import download 
from tools.files_f import * 
from tools.debugging_f import *
from tools.screen_f import *
from bitcoin.bitcoin_functions_f import *
from datetime import date
from tools.drive_f import *

def install_bitcoin():

    if ico.grep("bitcoin-end") or ico.grep("bitcoin-start"):
        announce("Please uninstall Bitcoin first")
        return False

    try:
        pco.remove("bitcoin_dir")
        pco.remove("drive_bitcoin")
    except:
        pass

    #pre start cleanup, possibly redundant
    pco.remove("check_bitcoin_dir_flag")
    ico.add("bitcoin-start")
    
    if not choose_drive(): return False 

    if pco.grep("check_bitcoin_dir_flag"):
        if not check_default_directory_exists(): return False
        pco.remove("check_bitcoin_dir_flag")

    if pco.grep("format_disk=True"):
        if not detect_drive(): input("detect drive failed") ; return False

        disk_number = pco.grep("disk_number", returnline=True)
        disk_number = disk_number.split('=')[1].strip()
        #input("before format") 
        if format_disk(disk_number):
            pco.add(r"bitcoin_dir=P:\bitcoin")
            if not Path(r"P:\bitcoin").exists(): Path(r"P:\bitcoin").mkdir(parents=True, exist_ok=True)
            #input("disk formatted")
        else:
            thedate = date.today().strftime("%d-%m-%y")
            dbo.write(f"{thedate}: Bitcoin format_disk exited.")
            input("format failed")
            return False 

    if not download_bitcoin(): return False

    if not verify_bitcoin(): return False
    if not make_symlinks(): return False

    try:
        if not prune_choice(): return False
    except Exception as e:
        input(e)

    try:
        if not make_bitcoin_conf(): return False
    except Exception as e:
        input(e)
    
    
    ico.add("bitcoin-end") 
    bitcoin_installed_success()
    return True

def bitcoin_installed_success():
    set_terminal() 
    print(f"""
########################################################################################
   {cyan} 
                                    SUCCESS !!!
{orange}
    Bitcoin Core should have started syncing. Note, it should also continue to sync 
    after a reboot, or you can start Bitcoin Core from the Parmanode Bitcoin menu at
    any time.

    You can also access Bitcoin functions from the Parmanode menu.

{green}
    TIP:

    Make sure you turn off power saving features, particularly features that put
    the drive to sleep; Power saving is usually on by default for laptops.
{orange}

########################################################################################
""")
    enter_continue()

