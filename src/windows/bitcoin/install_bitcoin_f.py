from config.variables_f import *
from tools.files_f import download 
from tools.files_f import * 
from tools.debugging_f import *
from tools.screen_f import *
from bitcoin.bitcoin_functions_f import *
from datetime import date
import subprocess



def install_bitcoin():


    if choose_drive():
        pass
    else:
        thedate = date.today().strftime("%d-%m-%y")
        dbo.write(f"{thedate}: Bitcoin choose_drive exited.")
        return False

    detect_drive()
        
#    if format_drive():
#        pass

    else:
        dbo.write(f"{thedate}: Bitcoin format_external drive exited.")
        return False

    if download_bitcoin():
        pass
    else:
        return False

def format_drive(drive_letter=None, file_system='NFTS', label="parmanode"):
    try:
        drive = f"{drive_letter}:" if not drive_letter.endswith(':') else drive_letter
        command = ['format', drive, '/fs:' + file_system, '/v:', label, '/q' ]
        return True
    except:
        return False

def detect_drive():
    
    set_terminal()
    input(f"""{orange}    Please make sure the drive you want to use with Parmanode
    is{cyan} DISCONNECTED{orange}. Then hit <enter>.""")
    #before_disks = set(get_all_disks)
    input(f"""{orange}    Now go ahead and connect the drive, wait a few seconds, then
    hit <enter>""")
    after_disks = set(get_all_disks())

    new_disk = after_disks.pop()
    input("""Your new drive is :
          {new_disk}
          """)
    return new_disk
    
def get_all_disks():
    command = 'powershell "Get-Disk"'
    result = subprocess.run(command, capture_output=True, text=True, shell=True) 
    disk_info = result.stdout.strip().split('\n')
    return disk_info

