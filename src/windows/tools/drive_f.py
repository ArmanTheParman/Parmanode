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

    get_all_disks("after")
    input("make changes to after here")
    try:
        with before.open('r') as bb, after.open('r') as aa:
            input("6b")
            bblines = tuple(bb.readlines())
            aalines = tuple(aa.readlines()) 
            unique_lines = [line for line in aalines if line not in bblines]
    except Exception as e:
        print(f"{e}")

    with difference.open('w') as f:
        for line in unique_lines:
            f.write(line)

    if len(unique_lines) != 1:
        set_terminal()
        print("Somthing went wrong with drive detection.")
        return False
    
    try:
        disk_number = unique_lines[0].split()[1]
        pco.add(disk_nunber=f"{disk_number}")
    except Exception as e:
        print(f'{e}')
        
    return True

def get_all_disks(when):
    tmpo.truncate()
    diskpart_commands = """list disk"""
    tmpo.add(diskpart_commands)
    diskpart_script_path = tmpo.file
    result = subprocess.run(['diskpart', '/s', diskpart_script_path], capture_output=True, text=True, shell=True).stdout.strip().split('\n')
    #print("len  ", len(result), "  type  ", type(result))
    # for line in result:
    #     if "Disk 1" in line:
    #         print(line)
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
        
        subprocess.run(command, check=True)
        return True
    except subprocess.CalledProcessError:
        return False


def get_connected_disks():
       import subprocess
       result = subprocess.run(['diskpart', '/c', 'list volume'], capture_output=True, text=True, check=True)
       existing_drive_letters = {line.split()[0] for line in result.stdout.splitlines() if line and line[0].isalpha() and line[1] == ':'}
       return existing_drive_letters