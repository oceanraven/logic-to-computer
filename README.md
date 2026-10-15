# Logic to Computer

A SystemVerilog implementation of the Hack computer from [Nand to Tetris](https://www.nand2tetris.org/).

Built from logic gates up to a working CPU and computer.

## Structure

- `1_logic_gates` — Basic gates and multiplexers
- `2_arithmetic` — Adders and ALU
- `3_sequential` — Register, RAM16K, and program counter
- `4_cpu` — Hack CPU
- `5_memory` — RAM, screen memory, and keyboard input
- `6_instruction_memory` — ROM32K with `.hack` file loading
- `7_computer` — CPU, memory, and ROM connected together

## Testing

Requires Icarus Verilog (`iverilog` and `vvp`).

Run a stage:

```bash
./run_tests.sh 4_cpu
```

Run all stages:

```bash
for dir in [1-7]_*/; do
    ./run_tests.sh "$dir" || break
done
```

Each stage includes a testbench.