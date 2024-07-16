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
try:
    import subprocess
    result = subprocess.run(['diskpart', '/c', 'list volume'], capture_output=True, text=True, check=True)
    existing_drive_letters = {line.split()[-1] for line in result.stdout.splitlines() if line and line[0].isalpha() and line[1] == ':'}
    print(type(existing_drive_letters))
    print(existing_drive_letters)
    #return existing_drive_letters
    input()
    quit()
except Exception as e:
    input()
    print(f"{e}")

counter("rp")

if check_updates((0, 0, 1)) == "outdated":    #pass compiling version as int list argument
    suggestupdate()
input("pause")
intro()
instructions()
motd()
menu_main()

#print("intro done, exiting")