#!/bin/bash

# Configuration variables (Modify these paths according to your system environment)
FOLDX_PATH="./foldx"
INPUT_DIR="./input_pdbs"
OUTPUT_DIR="./repaired_pdbs" 

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Check if input directory exists
if [ ! -d "$INPUT_DIR" ]; then
    echo "Error: Input directory '$INPUT_DIR' does not exist."
    exit 1
fi

# Process PDB files
files_found=false
for pdb_file in "$INPUT_DIR"/*.pdb; do
    if [ -f "$pdb_file" ]; then
        files_found=true
        break
    fi
done

if [ "$files_found" = false ]; then
    echo "No PDB files found in $INPUT_DIR. Exiting."
    exit 0
fi

for pdb_file in "$INPUT_DIR"/*.pdb; do
    if [ -f "$pdb_file" ]; then
        pdb_name=$(basename "$pdb_file")
        
        (
        cd "$INPUT_DIR" || exit
        "$FOLDX_PATH" --command=RepairPDB --pdb="$pdb_name"
        mv "RepairPDB_$pdb_name" "$OUTPUT_DIR/"
        echo "Repaired $pdb_name and saved to $OUTPUT_DIR"
        )
    fi
done

echo "All PDB files repaired successfully!"
