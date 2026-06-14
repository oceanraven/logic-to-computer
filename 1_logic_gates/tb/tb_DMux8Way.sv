`timescale 1ns / 1ps

module tb_DMux8Way;
  logic in;
  logic [2:0] sel;
  logic a, b, c, d, e, f, g, h;

  DMux8Way dut (
      .in (in),
      .sel(sel),
      .a  (a),
      .b  (b),
      .c  (c),
      .d  (d),
      .e  (e),
      .f  (f),
      .g  (g),
      .h  (h)
  );

  initial begin
    in  = 1;
    sel = 3'b000;
    #10;
    if (a !== 1) $error("Test Failed");

    in  = 1;
    sel = 3'b011;
    #10;
    if (d !== 1) $error("Test Failed");

    in  = 1;
    sel = 3'b111;
    #10;
    if (h !== 1) $error("Test Failed");

    in  = 0;
    sel = 3'b000;
    #10;
    if (a !== 0) $error("Test Failed");

    $finish;
  end
endmodule
