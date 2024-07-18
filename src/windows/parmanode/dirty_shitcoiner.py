from tools.screen_f import *

def dirty_shitcoiner():
    while True:
        print(f"""
########################################################################################
########################################################################################
{red}
             Shame on you.{orange} We're on the battle field, fighting tyranny, and
             you're using vital weapons to shoot ducks. Don't be a traitor to 
             your descendents and humanity. Stack bitcoin and help end tyranny.
		     
             Here's some reading material to help you understand...


     1) Why Bitcoin Only           {cyan}
                                    - http://www.armantheparman.com/why-bitcoin-only  {orange}
     2) Why money tends towards one {cyan}
                                    - http://www.armantheparman.com/onemoney {orange}

     3) We are separating money and state - Join us {cyan}
                                    -  http://www.armantheparman.com/joinus {orange}
     4) Debunking Bitcoin FUD {cyan}
                                    - http://www.armantheparman.com/fud {orange}

    
     Have a nice day.
    {green}
     To abort, type: (I'm sorry), then hit <enter>                 
{orange}
########################################################################################
######################################################################################## 
""")
        choice = choose().upper()    
        if choice == "I'M SORRY": return True
        invalid()