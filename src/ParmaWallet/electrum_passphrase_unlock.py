import sys
import getpass

from electrum.storage import WalletStorage

##########
while True:
    path = input(f"""
########################################################################################      

    Please type the path of your wallet file. If it is in the current directory, just
    type the file name beginning with './' , eg:

        ./filename
        
    Otherwise type the full path.

########################################################################################
""")

    if path == "": 
        input("""Hit <enter> to try again""")
        continue
    elif path != '.' and path != '/':
        input("""Path must begin with a '.' or '/'. Hit <enter> to try again""")
        continue
    break

s = WalletStorage(path)

if not s.file_exists():
    input("No wallet file at path!")
    sys.exit(0)

if not s.is_encrypted():
    input("Good new, this wallet isn't encrypted.")
    sys.exit(0)

choice = input(f"""
######################################################################################## 

    Would you like to manually guess the password/decryption_key, or automate?
    
        m)    manual
        
        a)    automate

########################################################################################
""")

while choice == 'm':

    password = getpass.getpass("Enter your wallet password:", stream=None)
    try:
        s.decrypt(password) #exception thrown if password wrong
        with open("cracked_password.txt", 'w') as f:
            f.write(password + '\n')
        input("Wallet decrypted. Hit <enter> to exit.")
        sys.exit(0)

    except Exception as e:
        print("try again")
        continue

possibilities = input(f"""Please enter some words or characters you think might be in the
password separated with commas. If you think you might have commas in the
password, you can add them later.""")

p_list = []
for i in possibilities.split(','):
    p_list.append(i) 

##unfinished
