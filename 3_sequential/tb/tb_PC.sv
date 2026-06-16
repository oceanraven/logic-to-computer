`timescale 1ns / 1ps

module tb_PC;
  logic        clk;
  logic        reset;
  logic        load;
  logic        inc;
  logic [15:0] in;
  logic [15:0] out;

  PC dut (
      .clk  (clk),
      .reset(reset),
      .load (load),
      .inc  (inc),
      .in   (in),
      .out  (out)
  );

  always #5 clk = ~clk;

  initial begin
    clk   = 0;
    reset = 1;
    load  = 0;
    inc   = 0;
    in    = 16'h0000;

    @(negedge clk);
    reset = 0;
    if (out !== 16'h0000) $error("Test Failed");

    @(negedge clk);
    inc = 1;

    @(negedge clk);
    if (out !== 16'h0001) $error("Test Failed");

    @(negedge clk);
    load = 1;
    in   = 16'hFFFF;

    @(negedge clk);
    if (out !== 16'hFFFF) $error("Test Failed");

    @(negedge clk);
    load = 0;
    inc  = 1;

    @(negedge clk);
    if (out !== 16'h0000) $error("Test Failed");

    @(negedge clk);
    reset = 1;
    load  = 1;
    inc   = 1;
    in    = 16'h1234;

    @(negedge clk);
    if (out !== 16'h0000) $error("Test Failed");

    $finish;
  end
endmodule
