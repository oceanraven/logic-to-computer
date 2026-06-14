`timescale 1ns / 1ps

module tb_Or16;
  logic [15:0] a, b, out;

  Or16 dut (
      .a  (a),
      .b  (b),
      .out(out)
  );

  initial begin
    a = 16'h0000;
    b = 16'h0000;
    #10;
    if (out !== 16'h0000) $error("Test Failed");

    a = 16'hAAAA;
    b = 16'h5555;
    #10;
    if (out !== 16'hFFFF) $error("Test Failed");

    a = 16'h00FF;
    b = 16'h0F0F;
    #10;
    if (out !== 16'h0FFF) $error("Test Failed");

    $finish;
  end
endmodule
