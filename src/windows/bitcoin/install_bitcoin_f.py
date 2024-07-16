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


    if choose_drive():
        pass
    else:
        thedate = date.today().strftime("%d-%m-%y")
        dbo.write(f"{thedate}: Bitcoin choose_drive exited.")
        return False

    if detect_drive():
        print(pco.read())
        input("pause")
        pass
    else:
        thedate = date.today().strftime("%d-%m-%y")
        dbo.write(f"{thedate}: Bitcoin detect_drive exited.")
        input("error")
        return False

    disk_number = pco.grep("disk_number", returnline=True)
    print(disk_number)
    input("after grep")
    disk_number = disk_number.split('=')[1].strip()
    input("disk number split and strip success")

    if format_disk(disk_number):
        input("disk formatted")
        pass
    else:
        thedate = date.today().strftime("%d-%m-%y")
        dbo.write(f"{thedate}: Bitcoin format_disk exited.")
        input("format failed")
        return False 


        
#    if format_drive():
#        pass

    # else:
    #     dbo.write(f"{thedate}: Bitcoin format_external drive exited.")
    #     return False

    # if download_bitcoin():
    #     pass
    # else:
    #     return False
