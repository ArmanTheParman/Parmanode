import sys

if len(sys.argv) == 1:
    sys.argv.append("no_debug")
    D=False
elif sys.argv[1] in {"d", "debug", "D", "DEBUG", "Debug"}:
    D=True
else:
    D=False

def debug(text=None, some_function=None):
    if D == True:
        if some_function is not None:
            some_function()
            return True
        if text is None:
            print("Pausing for debugging")
            print(text)
            print("\n    Hit <enter> to contiue.") 
            return input()
        else:
            print("DEBUG point")
            print(text)
            print("\n    Hit <enter> to contiue.") 
            return input()
    else:
        return True