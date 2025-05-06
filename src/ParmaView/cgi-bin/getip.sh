#!/bin/bash
echo "Content-Type: application/json"
echo ""

ip a | grep "inet " | grep -v 127.0.0.1 | grep -v 172.1 | awk '{print $2}' | cut -d '/' -f 1 | head -n1 