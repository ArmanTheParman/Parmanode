from config.variables_f import *
from tools.debugging_f import *
from tools.files_f import *
from tools.system_f import *
from tools.screen_f import *
from menus.menu_add_f import menu_add
from menus.menu_use_f import menu_use
from menus.menu_remove_f import menu_remove
from bitcoin.menu_bitcoin_f import *
def menu_main():
    import config.variables_f 
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
#{cyan}    (b)  {orange}                Bitcoin menu                                                 #
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
#{cyan}    (update)  {orange}           Update Parmanode                                             #
#                                                                                      #
#{cyan}    (uninstall)     {orange}     Uninstall Parmanode                                          #
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
        if choice.lower() in {"a", "add"}:
            menu_add() 
        elif choice.lower() in {"use", "u"}: 
            menu_use()
        elif choice.lower() in {"b", "bitcoin"}:
            menu_bitcoin()
        elif choice.lower() in {"remove"}: 
            menu_remove()
        elif choice.lower() in {"q", "quit", "exit"}:
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