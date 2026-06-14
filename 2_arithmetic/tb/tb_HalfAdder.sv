`timescale 1ns / 1ps

module tb_HalfAdder;
  logic a, b, carry, sum;

  HalfAdder dut (
      .a(a),
      .b(b),
      .carry(carry),
      .sum(sum)
  );

  initial begin
    a = 0;
    b = 0;
    #10;
    if ({carry, sum} !== 2'b00) $error("Test Failed");

    a = 0;
    b = 1;
    #10;
    if ({carry, sum} !== 2'b01) $error("Test Failed");

    a = 1;
    b = 0;
    #10;
    if ({carry, sum} !== 2'b01) $error("Test Failed");

    a = 1;
    b = 1;
    #10;
    if ({carry, sum} !== 2'b10) $error("Test Failed");

    $finish;
  end
endmodule
