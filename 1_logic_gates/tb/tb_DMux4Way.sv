`timescale 1ns / 1ps

module tb_DMux4Way;
  logic in;
  logic [1:0] sel;
  logic a, b, c, d;

  DMux4Way dut (
      .in (in),
      .sel(sel),
      .a  (a),
      .b  (b),
      .c  (c),
      .d  (d)
  );

  initial begin
    in  = 1;
    sel = 2'b00;
    #10;
    if ({a, b, c, d} !== 4'b1000) $error("Test Failed");

    in  = 1;
    sel = 2'b01;
    #10;
    if ({a, b, c, d} !== 4'b0100) $error("Test Failed");

    in  = 1;
    sel = 2'b10;
    #10;
    if ({a, b, c, d} !== 4'b0010) $error("Test Failed");

    in  = 1;
    sel = 2'b11;
    #10;
    if ({a, b, c, d} !== 4'b0001) $error("Test Failed");

    in  = 0;
    sel = 2'b00;
    #10;
    if ({a, b, c, d} !== 4'b0000) $error("Test Failed");

    $finish;
  end
endmodule
