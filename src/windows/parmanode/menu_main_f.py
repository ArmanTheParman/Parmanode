from config.variables_f import *
from tools.debugging_f import *
from tools.files_f import *
from tools.system_f import *
from tools.screen_f import *
from menus.menu_add_f import menu_add
from menus.menu_use_f import menu_use
from menus.menu_remove_f import menu_remove
def menu_main():
    input("mainmenu")
    while True:
        set_terminal(50, 88)
        print(f"""{orange}        
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> {bright_blue}Main Menu{orange}                                                   #
#                                                                                      #
#    Version: {bright_blue} {version}{orange}                                                                   #
#                                                                                      #
########################################################################################
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
        input("1.5") 
        if not pco.grep("announcements_off"):
            print(f"""
 Tip: combine u with the next menu options. eg, try ub for bitcoin menu

{blinkon}{red}                   WARNING!! YOU DON'T HAVE ENOUGH BITCOIN {orange}{blinkoff}""")
        input("main menu 2")
        choice = input()  
        set_terminal()

        if "aa" in choice:
            if pco.grep("announcements_off"):
                pco.remove("announcements_off")
            else:
                pco.add("announcements_off")
        elif choice in {"a", "add", "Add", "ADD"}:
            menu_add() 
        elif choice in {"use", "USE", "Use", "u", "U"}: 
            menu_use()
        elif choice in {"remove", "Remove", "remove"}: 
            menu_remove()
        elif choice in {"L", "l"}: 
            menu_log_config()
        
        elif choice in {"mm", "MM"}:
            mentorship()
        elif choice in {"e", "E"}: 
            menu_education()
        elif choice in {"t", "T"}: 
            menu_tools()
        elif choice in {"s" , "S"}: 
            menu_settings()
        elif choice in {"d", "D"}:
            donations() 
        elif choice in {"un", "uninstall", "UNINSTALL", "Uninstall"}: 
            uninstall_parmanode()
        elif choice in {"up", "update", "UPDATE", "Update"}: 
            update_parmanode()
        elif choice in {"ap", "AP", "Ap", "aP"}: 
            about_parmanode()                      
        elif choice in {"q", "Q", "Quit", "exit", "EXIT"}: 
            quit()
        else:
            invalid()

        continue 
        #end of menu loop 

def menu_log_config():
    pass

def mentorship():
    pass

def menu_education():
    pass

def menu_tools():
    pass

def menu_settings():
    pass

def donations():
    pass

def uninstall_parmanode():
    pass

def update_parmanode():
    pass

def about_parmanode():
    pass