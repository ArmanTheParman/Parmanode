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
        pass
    else:
        thedate = date.today().strftime("%d-%m-%y")
        dbo.write(f"{thedate}: Bitcoin detect_drive exited.")
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
