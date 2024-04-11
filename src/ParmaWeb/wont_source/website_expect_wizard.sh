#!/usr/bin/expect

spawn sudo mysql_secure_installation

expect "Enter current password"
send "\r"

expect "unix_socket"
send "n\r"

expect "root password?"
send "n\r"

expect "Remove anonymous"
send "y\r"

expect "Disallow root login"
send "y\r"

expect "Remove test database"
send "y\r"

expect "Reload privilege tables"
send "y\r"

expect eof