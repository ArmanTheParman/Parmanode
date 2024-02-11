search_string="cmake curl"
input_file="$hp/public_pool/Dockerfile"

with open("$input_file", 'r') as file:
    lines = file.readlines()

with open("$input_file", 'w') as file:
    for line in lines:
        if "$search_string" in line:
            line = line.rstrip() + '\\'
        file.write(line + '\n')