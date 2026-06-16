`timescale 1ns / 1ps

module tb_Register;
  logic        clk;
  logic        load;
  logic [15:0] in;
  logic [15:0] out;

  Register dut (
      .clk (clk),
      .load(load),
      .in  (in),
      .out (out)
  );

  always #5 clk = ~clk;

  initial begin
    clk  = 0;
    load = 0;
    in   = 16'h0000;

    @(negedge clk);
    in   = 16'hAAAA;
    load = 1;

    @(negedge clk);
    load = 0;
    in   = 16'h5555;

    @(negedge clk);
    if (out !== 16'hAAAA) $error("Test Failed");

    $finish;
  end
endmodule
