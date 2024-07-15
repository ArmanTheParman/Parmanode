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

    with before.open('r') as bb, after.open('r') as aa:
        input("6b")
        bblines = tuple(bb.readlines())
        aalines = tuple(aa.readlines()) 
        unique_lines = [line for line in aalines if line not in bblines]

    with difference.open('w') as f:
        for line in unique_lines:
            f.write(line)

    if len(unique_lines) != 1:
        set_terminal()
        print("Somthing went wrong with drive detection.")
        return False

    return True

def get_all_disks(when):
    import subprocess
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


def format_drive(drive_letter=None, file_system='NFTS', label="parmanode"):
    try:
        drive = f"{drive_letter}:" if not drive_letter.endswith(':') else drive_letter
        command = ['format', drive, '/fs:' + file_system, '/v:', label, '/q' ]
        return True
    except:
        return False
