#!/usr/bin/expect -f

#This is executed by the Dockerfile

set timeout -1
spawn createuser --pwprompt --interactive

expect "Enter name of role to add: "
send "parmanode\r"

expect "Enter password for new role: "
send "NietShitcoin\r"

expect "Enter it again: "
send "NietShitcoin\r"

expect "Shall the new role be a superuser? (y/n) "
send "n\r"

expect "Shall the new role be allowed to create databases? (y/n) "
send "y\r"

expect "Shall the new role be allowed to create more new roles? (y/n) "
send "n\r"

expect eof

