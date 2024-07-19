from config.variables_f import *
from tools.screen_f import *    
import os, shutil

def uninstall_bitcoin():
    shutil.rmtree(str(bitcoinpath))
    try:
        pco.remove("bitcoin_dir")
    except:
        pass
    try:
        pco.remove("drive_bitcoin")
    except:
        pass
    try:
        ico.remove("bitcoin-start")
    except:
        pass
    try:
        ico.remove("bitcoin-end")
    except:
        pass