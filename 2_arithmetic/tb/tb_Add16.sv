`timescale 1ns / 1ps

module tb_Add16;
  logic [15:0] a, b, out;

  Add16 dut (
      .a  (a),
      .b  (b),
      .out(out)
  );

  initial begin
    a = 16'h0000;
    b = 16'h0000;
    #10;
    if (out !== 16'h0000) $error("Test Failed");

    a = 16'h1234;
    b = 16'h1111;
    #10;
    if (out !== 16'h2345) $error("Test Failed");

    a = 16'hFFFF;
    b = 16'h0001;
    #10;
    if (out !== 16'h0000) $error("Test Failed");

    $finish;
  end
endmodule
