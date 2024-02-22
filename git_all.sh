#!/bin/bash

echo "Extra Folder"
extraFolders=("b-test-project" "f-test-project")
for t in ${extraFolders[@]}; do
    echo "----------------------------------------------------"
    echo "$t"
    echo "----------------------------------------------------"
    echo "START"
    cd $t
    echo "$*"
    eval "$*"
    echo "END"
    echo ""
    cd ..
done

