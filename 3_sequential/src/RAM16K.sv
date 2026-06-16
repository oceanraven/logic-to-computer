module RAM16K (
    input logic clk,
    input logic load,
    input logic [13:0] address,
    input logic [15:0] in,
    output logic [15:0] out
);
  logic [15:0] memory[16384];

  always_ff @(posedge clk) begin
    if (load) begin
      memory[address] <= in;
    end
  end

  assign out = memory[address];
endmodule
