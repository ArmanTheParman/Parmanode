from config.variables_f import *
from tools.debugging_f import *
from tools.system_f import os_is
#from parmanode.menu_main_f import * #this will cause a circular error. 
import os , ctypes 
import struct, sys
if os_is == "Windows":
    import fcntl, termios

def set_terminal_size(rows, cols):
    if os_is() != "Windows":
        set_terminal_size_unix (rows, cols)
        return True
    try:
        # Get handle to standard output
        std_out_handle = ctypes.windll.kernel32.GetStdHandle(-11)  # -11 is STD_OUTPUT_HANDLE

        # Define struct for setting console screen buffer size
        class COORD(ctypes.Structure):
            _fields_ = [("X", ctypes.c_short), ("Y", ctypes.c_short)]

        # Set console screen buffer size
        coords = COORD(cols, rows)
        ctypes.windll.kernel32.SetConsoleScreenBufferSize(std_out_handle, coords)

        # Set console window size
        rect = ctypes.wintypes.SMALL_RECT(0, 0, cols - 1, rows - 1)
        ctypes.windll.kernel32.SetConsoleWindowInfo(std_out_handle, True, ctypes.byref(rect))

    except Exception as e:
        print(f"Error setting terminal size: {e}")

def set_terminal_size_unix(rows, cols):
    # File descriptor for standard output (1)
    fd = sys.stdout.fileno()

    # Query terminal size
    size = struct.pack('HHHH', 0, 0, rows, cols)
    fcntl.ioctl(fd, termios.TIOCSWINSZ, size)

def set_terminal(h=40, w=88):
    os.system('cls' if os.name == 'nt' else 'clear')
    set_terminal_size(h, w)
    print(f"{orange}") #Orange colour setting.


def choose(message=None):
    if message == "xpmq":
        print(f"{yellow}Type your{cyan} choice{yellow} from above options, or:{pink} (p){yellow} for previous,{green} (m){yellow} for main,{red} (q){yellow} to quit.")
    if message == "xmpq":
        print(f"{yellow}Type your{cyan} choice{yellow} from above options, or:{pink} (p){yellow} for previous,{green} (m){yellow} for main,{red} (q){yellow} to quit.")
    if message == "xeq":
        print(f"{yellow}Type your{cyan} choice{yellow}, or{green} <enter>{yellow} to continue, or {red}(q){yellow} to quit.")
    if message == "xmq":
        print(f"{yellow}Type your{cyan} choice{yellow} from above options, or:{green} (m){yellow} for main,{red} (q){yellow} to quit.")

    choice = input()
    return choice 

def invalid():
    set_terminal()
    print(f"""Invalid choice. Hit{cyan} <enter>{orange} first, and then try again.""") 
    return input() 

def please_wait(text: str):
    set_terminal()
    print()
    print(text)
    print(f"{cyan}Please wait...{orange}")
    print()

def announce(text, ec_text=None):
    set_terminal()
    print("""########################################################################################
          """)
    print(f"    {text}")
    print("""
########################################################################################

          """)
    return enter_continue(ec_text)

def enter_continue(text=None):
    if text == None:
       print(f"{yellow}Hit{cyan} <enter>{yellow} to continue...{orange}") 
       return input()
    if text.upper() == "TRY AGAIN":
       print(f"{yellow}Hit{cyan} <enter>{yellow} to try again...{orange}") 
       return input()
    else:
       print(text)
       return input()

def success(text):
    set_terminal()
    print(f"""
########################################################################################
{cyan}
                                 S U C C E S S ! {orange}

    {text}

########################################################################################
""")
    enter_continue()


def colour_check():
    print(f"{black}black {reset}\"black\"")
    print(f"{red}red {reset}\"red\"")
    print(f"{green}green {reset}\"green\"")
    print(f"{orange}green {reset}\"green\"")
    print(f"{bright_blue}green {reset}\"green\"")
    

def proforma(choice): 
    return True
    """Just a template"""
    choice = choose()
    set_terminal()

    if choice.upper() in {"Q", "EXIT"}: 
        quit()
    elif choice.upper() == "P":
        return True
    elif choice.upper() == "M":
        menu_main()
    else:
        invalid()

def yesorno(message):
    while True:
        set_terminal()
        print(f"""{orange}
########################################################################################


    {message}

                

{cyan}                                y){orange}        yeah
                               

{cyan}                                n){orange}        nah    



########################################################################################   
""")
        choice = choose("xq")    
        set_terminal()

        if choice.upper() in {"Q", "EXIT"}: 
            quit()
        elif choice.upper() == "Y":
            return True
        elif choice.upper() == "N":
            return False
        else:
            invalid()
    

