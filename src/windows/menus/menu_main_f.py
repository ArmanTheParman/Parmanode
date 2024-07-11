import sys
from config.functions import *
from config.variables import *
from parmanodeconf import *
def menu_main():
    while True:
        set_terminal()
        print(f"""{orange}        
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> {bright_blue}Main Menu{orange}                                                   #
#                                                                                      #
#    Version: {bright_blue} {version}{orange}                                                                              #
#                                                                                      #
########################################################################################
#                                                                                      #
#{cyan}    (o){orange}                  Overview/Status of Programs                                  #
#                                                                                      #
#{cyan}    (add)    {orange}            Add more Programs                                            #
#                                                                                      #
#{cyan}    (u)            {orange}      Use Programs                                                 #
#                                                                                      #
#{cyan}    (remove)     {orange}        Remove/Uninstall Programs                                    #
#                                                                                      #
#--------------------------------------------------------------------------------------#
#                                                                                      #
#{cyan}    (t)        {orange}          Tools                                                        #
#                                                                                      #
#{cyan}    (s)              {orange}    Settings                                                     #
#                                                                                      #
#{cyan}    (mm){orange}                 Mentorship with Parman - Info                                #
#                                                                                      #
#{cyan}    (e)       {orange}           Education                                                    #
#                                                                                      #
#{cyan}    (d)             {orange}     Donate                                                       #
#                                                                                      #
#{cyan}    (l) {orange}                 See logs and config files                                    #
#                                                                                      #
#{cyan}    (update)  {orange}           Update Parmanode                                             #
#                                                                                      #
#{cyan}    (uninstall)     {orange}     Uninstall Parmanode                                          #
#                                                                                      #
#{cyan}    (aa)      {orange}           Hide/Show Main Menu announcements                            #
#                                                                                      #
#{cyan}    (ap){orange}                 About Parmanode                                              #
#                                                                                      #
########################################################################################

 Type your{cyan} choice{orange} without the brackets, and hit{green} <enter>{orange} 
 Or to quit, either hit{green} <control>-c{orange}, or type{cyan} q{orange} then{green} <enter>{orange}.
""")
        
        if not pco.grep("announcements_off"):
            print(f"""
 Tip: combine u with the next menu options. eg, try ub for bitcoin menu

{blinkon}{red}                   WARNING!! YOU DON'T HAVE ENOUGH BITCOIN {orange}{blinkoff}""")

        choice = input()  
        set_terminal()

        if "aa" in choice:
            if pco.grep("announcements_off"):
                pco.remove("announcements_off")
            else:
                pco.add("announcements_off")
        elif {"o", "O"} in choice:
            menu_overview() 
        elif {"a", "add", "Add", "ADD"} in choice:
            menu_add() 
        elif {"use", "USE", "Use", "u", "U"} in choice:
            menu_use()
        elif {"remove", "Remove", "remove"} in choice:
            menu_remove()
        elif {"L", "l"} in choice:
            menu_log_config()
        
        elif {"mm", "MM"} in choice:
            mentorship()
        elif {"e", "E"} in choice: 
            menu_education()
        elif {"t", "T"} in choice:
            menu_tools()
        elif {"s" , "S"} in choice:
            menu_settings()
        elif {"d", "D"} in choice:
            donations() 
        elif {"un", "uninstall", "UNINSTALL", "Uninstall"} in choice:
            uninstall_parmanode():
        elif {"up", "update", "UPDATE", "Update"} in choice:
            update_parmanode()
        elif {"ap", "AP", "Ap", "aP"} in choice:
            about_parmanode()                      
        elif {"q", "Q", "Quit", "exit", "EXIT"} in choice
            quit()
        else:
            invalid()

        continue 
        #end of menu loop 

