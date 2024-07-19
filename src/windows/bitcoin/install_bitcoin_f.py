from config.variables_f import *
from tools.files_f import download 
from tools.files_f import * 
from tools.debugging_f import *
from tools.screen_f import *
from bitcoin.bitcoin_functions_f import *
from datetime import date
import subprocess
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

    if not prune_choice(): return False

    if not choose_drive(): input("choose drive fail") ; return False 
    
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
    #else:
        #input("format not true")
   
    if not download_bitcoin(): return False
    
    ico.add("bitcoin-end") 
    success("Bitcoin has finished being installed")
    return True

