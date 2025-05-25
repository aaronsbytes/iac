#!/bin/bash

echo "#::::::::::::::#"
echo "#:::Playbook:::#"
echo "#::::::::::::::#"

echo "~ by github.com/aaronsbytes"

ansible-playbook -i inventory.yml playbook.yml --diff
echo "Playbook > Done."
