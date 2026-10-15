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

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd) || exit 1

shopt -s nullglob
library_args=()

for src_dir in "$script_dir"/*/src; do
    [ -d "$src_dir" ] || continue
    library_args+=(-y "$src_dir")
done

cd -- "$1" || exit 1

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
    test_name="${base_name%.sv}"
    module_name="${test_name#tb_}"
    src_file="src/$module_name.sv"
    out_file="build/$test_name.out"
    log_file="build/$test_name.log"

    echo "▶▶▶ Running Test: $module_name.sv"

    if [ ! -f "$src_file" ]; then
        echo "Error: $src_file not found." >&2
        failed=$((failed + 1))
    elif ! iverilog -g2012 \
        -Y .sv \
        -y src \
        "${library_args[@]}" \
        -s "$test_name" \
        -o "$out_file" \
        "$src_file" "$tb_file"; then
        echo "FAIL: $module_name.sv (compilation)"
        failed=$((failed + 1))
    elif ! vvp "$out_file" 2>&1 | tee "$log_file"; then
        echo "FAIL: $module_name.sv (simulation)"
        failed=$((failed + 1))
    else
        grep -Eq '^[[:space:]]*(ERROR|FATAL):' "$log_file"
        diagnostic_status=$?

        if [ "$diagnostic_status" -eq 0 ]; then
            echo "FAIL: $module_name.sv (test assertion)"
            failed=$((failed + 1))
        elif [ "$diagnostic_status" -ne 1 ]; then
            echo "FAIL: $module_name.sv (log inspection)"
            failed=$((failed + 1))
        else
            echo "PASS: $module_name.sv"
            passed=$((passed + 1))
        fi
    fi

    echo "----------------------------------------"
done

echo "Results: $passed passed, $failed failed"
[ "$failed" -eq 0 ]