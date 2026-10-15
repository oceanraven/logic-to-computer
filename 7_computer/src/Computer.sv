module Computer #(
    parameter ROM_FILE = "",
    parameter integer PROGRAM_WORDS = 32768
) (
    input logic        clk,
    input logic        reset,
    input logic [15:0] keyboard
);
  logic [15:0] instruction;
  logic [15:0] inM;
  logic [15:0] outM;
  logic        writeM;
  logic [14:0] addressM;
  logic [14:0] pc;

  CPU cpu (
      .clk(clk),
      .reset(reset),
      .instruction(instruction),
      .inM(inM),
      .outM(outM),
      .writeM(writeM),
      .addressM(addressM),
      .pc(pc)
  );

  ROM32K #(
      .ROM_FILE(ROM_FILE),
      .PROGRAM_WORDS(PROGRAM_WORDS)
  ) rom (
      .address(pc),
      .out(instruction)
  );

  Memory data_memory (
      .clk(clk),
      .load(writeM),
      .address(addressM),
      .in(outM),
      .keyboard(keyboard),
      .out(inM)
  );
endmodule
