module ROM32K #(
    parameter ROM_FILE = "",
    parameter integer PROGRAM_WORDS = 32768
) (
    input  logic [14:0] address,
    output logic [15:0] out
);
  logic [15:0] memory [0:32767];

  initial begin
    if (PROGRAM_WORDS < 1 || PROGRAM_WORDS > 32768)
      $fatal(1, "PROGRAM_WORDS must be between 1 and 32768");
    if (ROM_FILE != "")
      $readmemb(ROM_FILE, memory, 0, PROGRAM_WORDS - 1);
  end

  assign out = memory[address];
endmodule
