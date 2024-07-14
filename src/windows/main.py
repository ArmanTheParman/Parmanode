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
########################################################################################
#The "need_restart" flag is removed here, just in case.
if pco.grep("need_restart"):
    pco.remove("need_restart")
########################################################################################
if os_is() == "Windows":
    if windows_version() < 10:
        set_terminal()
        print(f"{red}You need at least Windows 10 to run Parmanode. Exiting.")
        enter_continue()
        quit()
    if not is_admin():
        run_as_admin()

    from dependencies.chocolatey_f import *
    dependency_check()
counter("rp")
if check_updates((0, 0, 1)) == "outdated":    #pass compiling version as int list argument
    suggestupdate()

intro()
instructions()
motd()
menu_main()

#print("intro done, exiting")