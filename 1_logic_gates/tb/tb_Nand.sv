`timescale 1ns / 1ps
module tb_Nand;
  logic a, b, out;
  Nand dut (
      .a  (a),
      .b  (b),
      .out(out)
  );
  initial begin
    a = 0;
    b = 0;
    #10;
    if (out !== 1) $error("Test Failed");

    a = 0;
    b = 1;
    #10;
    if (out !== 1) $error("Test Failed");

    a = 1;
    b = 0;
    #10;
    if (out !== 1) $error("Test Failed");

    a = 1;
    b = 1;
    #10;
    if (out !== 0) $error("Test Failed");

    $finish;
  end
endmodule
