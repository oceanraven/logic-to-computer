`timescale 1ns / 1ps

module tb_Inc16;
  logic [15:0] in, out;

  Inc16 dut (
      .in (in),
      .out(out)
  );

  initial begin
    in = 16'h0000;
    #10;
    if (out !== 16'h0001) $error("Test Failed");

    in = 16'h1234;
    #10;
    if (out !== 16'h1235) $error("Test Failed");

    in = 16'hFFFF;
    #10;
    if (out !== 16'h0000) $error("Test Failed");  // Overflow 무시 확인

    $finish;
  end
endmodule
