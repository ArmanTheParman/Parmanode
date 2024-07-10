########################################################################################
#DEBUG AND TESTING SECTION:
########################################################################################
#ensures sys.argv[1] exists for debug checks later in script, otherwise need to ensure position exists every time.

#debug(some_function=colour_check)

########################################################################################
#Imports
########################################################################################
from pathlib import Path
from config.variables import *
from config.functions import *
from parmanodeconf import *
from functions.text_functions import *

from parmanode.intro_f import *
from parmanode.motd_f import *
print(x)
input()
########################################################################################
#Begin
########################################################################################


counter("rp")
if check_updates((0, 0, 1)) == "outdated":    #pass compiling version as int list argument
    suggestupdate()

intro()
instructions()
motd()

#clean up variables
del motd_text

#print("intro done, exiting")