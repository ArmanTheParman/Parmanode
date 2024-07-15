import subprocess
from config.variables_f import *
from tools.system_f import *
from tools.screen_f import *

def format_drive(drive_letter=None, file_system='NFTS', label="parmanode"):
    try:
        drive = f"{drive_letter}:" if not drive_letter.endswith(':') else drive_letter
        command = ['format', drive, '/fs:' + file_system, '/v:', label, '/q' ]
        return True
    except:
        return False

def detect_drive():
    set_terminal()
    input(f"""{orange}    Please make sure the drive you want to use with Parmanode
    is{cyan} DISCONNECTED{orange}. Then hit <enter>.
    
    """)
    try:
        get_all_disks("before")
    except Exception as e:
        print(f"{a}")
        input("error. exiting. before")
    #The sequence is to ensure the last added drive is numbered last
    input(f"""{orange}    Now go ahead and{cyan} CONNECT{orange} The drive, wait a few seconds. Then
    hit <enter>""")
    try:
        get_all_disks("after")
    except Exception as e:
        print(f"{a}")
        input("error. exiting. after")

    input("6") 
    print(type(beforeo))
    beforeo.truncate()
    aftero.truncate()
    input("6a")
    with before.open('r') as bb, after.open('r') as aa:
        input("6b")
        bblines = tuple(bb.readlines())
        aalines = tuple(aa.readlines()) # type: ignore
        unique_lines = aalines - bblines
        
    input("7") 
    print(unique_lines)
    input("look at unique lines above")


    return True

# def get_all_disks():
#     command = 'powershell -Command "Get-Disk | Format-List -Property FriendlyName,Size,Path"'
#     result = subprocess.run(command, capture_output=True, text=True, shell=True) 
#     disk_info = result.stdout.strip().splitlines()
#     tmpo = config(tmp)
#     for line in disk_info: 
#         tmpo.add(line)
#         print("...", line)
#     input("end get all disks")

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