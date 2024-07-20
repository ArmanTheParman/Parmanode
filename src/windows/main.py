########################################################################################
#check preliminaries with minimal overhead before restarting
########################################################################################

import platform, ctypes, sys, os

if platform.system() == "Windows":
    if sys.getwindowsversion().major < 10:
        print(f"{red}You need at least Windows 10 to run Parmanode. Exiting.")
        input("Hit enter") 
        quit()

    if not ctypes.windll.shell32.IsUserAnAdmin(): #is admin?
        # Re-launch the script with admin privileges
        script = os.path.abspath(sys.argv[0])
        params = ' '.join([script] + sys.argv[1:])
        try:
            ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, params, None, 1)
            sys.exit(0)
        except Exception as e:
            print(f"Failed to elevate: {e}")
            sys.exit(1)
            run_as_admin()

    from dependencies.chocolatey_f import *
    dependency_check()
########################################################################################
#DEBUG AND TESTING SECTION:
########################################################################################
#ensures sys.argv[1] exists for debug checks later in script, otherwise need to ensure position exists every time.

#debug(some_function=colour_check)

########################################################################################
#Imports
########################################################################################
from pathlib import Path
from config.variables_f import *
from parmanode.intro_f import * 
from parmanode.motd_f import motd 
from parmanode.menu_main_f import *
from tools.system_f import *
from bitcoin.bitcoin_functions_f import *
from tools.drive_f import *
from bitcoin.uninstall_bitcoin_f import *
########################################################################################
#The "need_restart" flag is removed here, just in case.
if pco.grep("need_restart"):
    pco.remove("need_restart")
########################################################################################

counter("rp")

if check_updates((0, 0, 1)) == "outdated":    #pass compiling version as int list argument
    suggestupdate()

#intro()
#instructions()
#motd()
make_symlinks()
exit()
menu_main()

#print("intro done, exiting")