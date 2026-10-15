#!/bin/bash

set -o pipefail

if [ "$#" -ne 1 ] || [ -z "$1" ]; then
    echo "Usage: $0 <directory>" >&2
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' not found." >&2
    exit 1
fi

for tool in iverilog vvp tee grep; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        echo "Error: Required command '$tool' not found." >&2
        exit 1
    fi
done

cd -- "$1" || exit 1
shopt -s nullglob
testbenches=(tb/tb_*.sv)
if [ "${#testbenches[@]}" -eq 0 ]; then
    echo "Error: No testbenches found in tb/." >&2
    exit 1
fi

mkdir -p build || exit 1
passed=0
failed=0

for tb_file in "${testbenches[@]}"; do
    base_name="${tb_file##*/}"
    module_name="${base_name#tb_}"
    src_file="src/$module_name"
    out_file="build/${base_name%.sv}.out"
    log_file="build/${base_name%.sv}.log"

    echo "▶▶▶ Running Test: $module_name"

    if [ ! -f "$src_file" ]; then
        echo "Error: $src_file not found." >&2
        failed=$((failed + 1))
    elif ! iverilog -g2012 -s "${base_name%.sv}" -o "$out_file" "$src_file" "$tb_file"; then
        echo "FAIL: $module_name (compilation)"
        failed=$((failed + 1))
    elif ! vvp "$out_file" 2>&1 | tee "$log_file"; then
        echo "FAIL: $module_name (simulation)"
        failed=$((failed + 1))
    # Icarus may return zero after $error; also inspect its diagnostics.
    elif grep -Eq '^(ERROR|FATAL):' "$log_file"; then
        echo "FAIL: $module_name (test assertion)"
        failed=$((failed + 1))
    else
        echo "PASS: $module_name"
        passed=$((passed + 1))
    fi
    echo "----------------------------------------"
done

echo "Results: $passed passed, $failed failed"
[ "$failed" -eq 0 ]

