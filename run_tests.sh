#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' not found."
    exit 1
fi

cd "$1" || exit 1

mkdir -p build

for tb_file in tb/tb_*.sv; do
    [ -e "$tb_file" ] || continue

    base_name=$(basename "$tb_file")
    module_name="${base_name#tb_}"
    src_file="src/$module_name"
    out_file="build/${base_name%.sv}.out"

    echo "▶▶▶ Running Test: $module_name"

    if [ -f "$src_file" ]; then
        iverilog -g2012 -o "$out_file" "$src_file" "$tb_file"
        
        if [ $? -eq 0 ]; then
            vvp "$out_file"
        fi
    else
        echo "Error: $src_file not found."
    fi
    echo "----------------------------------------"
done