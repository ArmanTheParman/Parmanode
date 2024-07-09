########################################################################################
#DEBUG AND TESTING SECTION:
########################################################################################
#ensures sys.argv[1] exists for debug checks later in script, otherwise need to ensure position exists every time.

#debug(some_function=colour_check)

########################################################################################
#Imports
########################################################################################
from parmanode.intro_f import *
from config.variables import *
from pathlib import Path
from functions.text_functions import *
from config.functions import *
########################################################################################
#Begin
########################################################################################


counter()
if check_updates((0, 0, 1)) == "outdated":    #pass compiling version as int list argument
    suggestupdate()

#motd()

intro()

#print("intro done, exiting")