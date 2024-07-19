import subprocess
from config.variables_f import *
from tools.system_f import *
from tools.screen_f import *


def detect_drive():
    
    set_terminal()
    beforeo.truncate() ; aftero.truncate() ; differenceo.truncate()
    input(f"""{orange}    Please make sure the drive you want to use with Parmanode
    is{cyan} DISCONNECTED{orange}. Then hit <enter>.
    
    """)

    get_all_disks("before")

    input(f"""{orange}    Now go ahead and{cyan} CONNECT{orange} The drive, wait a few seconds. Then
    hit <enter>""")
    
    for count in range(5):
        get_all_disks("after")
        try:
            with before.open('r') as bb, after.open('r') as aa:
                bblines = tuple(bb.readlines())
                aalines = tuple(aa.readlines()) 
                unique_lines = [line for line in aalines if line not in bblines]
        except Exception as e:
            print(f"{e}")

        with difference.open('w') as f:
            for line in unique_lines:
                f.write(line)
        if len(unique_lines) > 1: input("Something went wrong with drive detection") ; return False
        if len(unique_lines) == 0:
            set_terminal()
            time.sleep(0.86)
            if count == 4: input("Something went wrong with drive detection") ; return False
            continue
        elif len(unique_lines) == 1:
            break
        else:
            input("Something went wrong with drive detection") ; return False

    try:
        disk_number = unique_lines[0].split()[1]
        pco.add(f"disk_number={disk_number}")
    except Exception as e:
        print(f'{e}')
        input("get disk number failed")
        
    return True

def get_all_disks(when):
    tmpo.truncate()
    diskpart_commands = """list disk"""
    tmpo.add(diskpart_commands)
    diskpart_script_path = tmpo.file
    result = subprocess.run(['diskpart', '/s', diskpart_script_path], capture_output=True, text=True, shell=True).stdout.strip().split('\n')
    
    if when == "before":
        for line in result:
            beforeo.add(line)
    if when == "after":
        for line in result:
            aftero.add(line)

    return True


def format_disk(disk_number, file_system='NTFS', label="parmanode"):
    if disk_number is None:
        return False
    
    # Create the diskpart script
    script = f"""
    select disk {disk_number}
    clean
    create partition primary
    select partition 1
    format fs={file_system} label={label} quick
    """

    # Save the script to a temporary file
    script_path = dp / 'diskpart_script.txt'
    with open(script_path, 'w') as file:
        file.write(script)
    
    # Run the diskpart command with the script
    command = ['diskpart', '/s', script_path]
    
    try:
        # Check for existing drive letters
        existing_drive_letters = get_connected_disks()

        # Find an unused drive letter
        for letter in "PARMANSAYSGFYJKQTUVWXZBCDEHILNO":
            if f"{letter}:" not in existing_drive_letters:
                assign_letter = letter
                break
  
        # Add the assign letter command to the script
        with open(script_path, 'a') as file:
            file.write(f"assign letter={assign_letter}\n")
       
        #make bitcoin directory  
        bitcoin_dir = Path(f"{assign_letter}:\\bitcoin")
        bitcoin_dir.mkdir(parents=True, exist_ok=True)
        bitcoin_dir = str(bitcoin_dir)
        pco.add(f"bitcoin_dir={bitcoin_dir}")

        subprocess.run(command, check=True)
        return True
    except Exception as e:
        print(f"{e}")
        input()
        return False


def get_connected_disks():
    try:
       diskpart_command = "list volume"
       diskpart_script_path = tmpo.file
       tmpo.truncate()
       tmpo.add(diskpart_command)
       result = subprocess.run(['diskpart', '/s', diskpart_script_path], capture_output=True, text=True, check=True)
       existing_drive_letters = {line.split()[0] for line in result.stdout.splitlines() if line and line[0].isalpha() and line[1] == ':'}
       return existing_drive_letters
    except Exception as e:
        print(f"{e}")

def check_drive_is_c():
    import os
    if os.getenv('SystemDrive').upper() == 'C:':
        return True
    else:
        return False

def get_system_drive_letter():
    return os.getenv('SystemDrive') 

