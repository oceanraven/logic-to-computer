`timescale 1ns / 1ps

module tb_Not16;
  logic [15:0] in, out;

  Not16 dut (
      .in (in),
      .out(out)
  );

  initial begin
    in = 16'h0000;
    #10;
    if (out !== 16'hFFFF) $error("Test Failed");

    in = 16'hFFFF;
    #10;
    if (out !== 16'h0000) $error("Test Failed");

    in = 16'hAAAA;
    #10;
    if (out !== 16'h5555) $error("Test Failed");

    $finish;
  end
endmodule
