import os

home = os.environ['HOME']
input_file = os.path.join(home, 'parmanode', 'public_pool', 'Dockerfile')
print(input_file)
search_string="cmake curl"
with open(input_file, 'r') as file:
    lines = file.readlines()

with open(input_file, 'w') as file:
    for line in lines:
        if search_string in line:
            line = line.rstrip() + ' \\\n'
        file.write(line)

