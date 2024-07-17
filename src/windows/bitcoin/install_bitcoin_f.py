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


    if not choose_drive(): input("choose drive fail") ; return False
    
    if pco.grep("format_drive=True"):

        if not detect_drive(): input("detect drive failed") ; return False

        disk_number = pco.grep("disk_number", returnline=True)
        disk_number = disk_number.split('=')[1].strip()
        input("before format") 
        if format_disk(disk_number):
            input("disk formatted")
            pass
        else:
            thedate = date.today().strftime("%d-%m-%y")
            dbo.write(f"{thedate}: Bitcoin format_disk exited.")
            input("format failed")
            return False 

    success("Bitcoin has finished being installed")
    return True