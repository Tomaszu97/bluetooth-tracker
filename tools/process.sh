#!/bin/sh -axe

#$1 notes file
awk -f replace-with-dict.awk dict.notes "$1" | tr -d ' ' | grep -o '^[^#]*' > notes.hex
./patch.sh $(cat notes.hex |tr -d '\n')

