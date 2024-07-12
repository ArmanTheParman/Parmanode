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
from parmanode.motd_f import *
from menus.menu_main_f import *

########################################################################################

if os_is() == "Windows":
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

#clean up variables
del motd_text

#print("intro done, exiting")