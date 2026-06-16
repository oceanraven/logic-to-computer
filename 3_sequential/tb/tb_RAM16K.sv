`timescale 1ns / 1ps

module tb_RAM16K;
  logic        clk;
  logic        load;
  logic [13:0] address;
  logic [15:0] in;
  logic [15:0] out;

  RAM16K dut (
      .clk    (clk),
      .load   (load),
      .address(address),
      .in     (in),
      .out    (out)
  );

  always #5 clk = ~clk;

  initial begin
    clk     = 0;
    load    = 0;
    address = 14'h0000;
    in      = 16'h0000;

    @(negedge clk);
    address = 14'h1234;
    in      = 16'hABCD;
    load    = 1;

    @(negedge clk);
    address = 14'h3FFF;
    in      = 16'h9876;
    load    = 1;

    @(negedge clk);
    load    = 0;
    address = 14'h1234;
    #1;
    if (out !== 16'hABCD) $error("Test Failed");

    @(negedge clk);
    address = 14'h3FFF;
    #1;
    if (out !== 16'h9876) $error("Test Failed");

    $finish;
  end
endmodule
