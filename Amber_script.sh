#!/bin/bash

# KEY:
# $1: input pdb file name

echo '============================================='
echo 'Script for interfacing Amber22'

echo 'Initilaizing environment'
conda activate AmberTools22

if ![[ -f "1esh.pdb" ]]
then
	echo "Input PDB file does not exists"
	exit 1
fi

filepath = "$1"
filename = $(basename "$filepath")
amber_filename = "${filename%.*}"
amber_filename = "$amber_filename.amber.pdb"
echo "$amber_filename"

