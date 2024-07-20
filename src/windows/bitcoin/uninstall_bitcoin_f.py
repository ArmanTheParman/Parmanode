from config.variables_f import *
from tools.screen_f import *    
import os, shutil

def uninstall_bitcoin():
    try:
        shutil.rmtree(str(bitcoinpath))
    except:
        announce(r"""Unable to remove C:\....\parman_programs\bitcoin during Bitcoin uninstallation
    The directory may be in use, eg it might be open in a folder window, or in a 
    terminal.""")                 
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

    success("Bitcoin has been uninstalled")