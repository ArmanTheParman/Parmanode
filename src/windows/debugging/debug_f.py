import sys
#ensures sys.argv[1] exists for debug checks later in script, otherwise need to ensure position exists every time.
if len(sys.argv) == 1:
    sys.argv.append("no_debug")

def debug(text="", some_function=None):
    if sys.argv[1] == "d":
        if some_function is not None:
            some_function()
        print("Pausing for debugging")
        print(text)
        input("<enter> to continue")
    else:
        return 0