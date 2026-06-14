`timescale 1ns / 1ps

module tb_FullAdder;
  logic a, b, c, carry, sum;

  FullAdder dut (
      .a(a),
      .b(b),
      .c(c),
      .carry(carry),
      .sum(sum)
  );

  initial begin
    a = 0;
    b = 0;
    c = 0;
    #10;
    if ({carry, sum} !== 2'b00) $error("Test Failed");

    a = 0;
    b = 1;
    c = 0;
    #10;
    if ({carry, sum} !== 2'b01) $error("Test Failed");

    a = 1;
    b = 1;
    c = 0;
    #10;
    if ({carry, sum} !== 2'b10) $error("Test Failed");

    a = 0;
    b = 1;
    c = 1;
    #10;
    if ({carry, sum} !== 2'b10) $error("Test Failed");

    a = 1;
    b = 1;
    c = 1;
    #10;
    if ({carry, sum} !== 2'b11) $error("Test Failed");

    $finish;
  end
endmodule
