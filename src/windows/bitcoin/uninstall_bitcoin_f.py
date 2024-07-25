from config.variables_f import *
from tools.screen_f import *    
from tools.files_f import *
import os, shutil

def uninstall_bitcoin():

    if not yesorno("Are you sure you want to uninstall Bitcoin?"): return False

    try:
        if not delete_directory(bitcoinpath):
            announce(fr"""Unable to remove {cyan} C:\....\parman_programs\bitcoin{orange} during Bitcoin uninstallation
    The directory may be in use, eg it might be open in a folder window, or in a 
    terminal.""")                 
            return False

    except Exception as e:
           announce(fr"""ERROR: Unable to remove {cyan} C:\....\parman_programs\bitcoin{orange} during Bitcoin uninstallation
    The directory may be in use, eg it might be open in a folder window, or in a 
    terminal.
                    
        bitcoinpath.mkdir()
    {e}                    """)                 
           return False 
    try:
        bitcoinpath.mkdir()
    except:
        pass

    try: 
        default_bitcoin_data_dir.unlink() # only deletes if it is a symlink
    except:
        pass
    try:
        pco.remove("bitcoin_dir") #string deletion from file
    except:
        pass
    try:
        pco.remove("drive_bitcoin") #string deletion from file
    except:
        pass
    try:
        pco.remove("prune_value=")
    except:
        pass
    try:
        ico.remove("bitcoin-start") #string deletion from file
    except:
        pass
    try:
        ico.remove("bitcoin-end") #string deletion from file
    except:
        pass
    try:
        pco.remove("check_bitcoin_dir_flag")
    except:
        pass
    
    success("Bitcoin has been uninstalled")