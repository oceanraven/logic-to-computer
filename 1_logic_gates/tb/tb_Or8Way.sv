`timescale 1ns / 1ps

module tb_Or8Way;
  logic a, b, c, d, e, f, g, h, out;

  Or8Way dut (
      .a  (a),
      .b  (b),
      .c  (c),
      .d  (d),
      .e  (e),
      .f  (f),
      .g  (g),
      .h  (h),
      .out(out)
  );

  initial begin
    {a, b, c, d, e, f, g, h} = 8'b00000000;
    #10;
    if (out !== 0) $error("Test Failed");

    {a, b, c, d, e, f, g, h} = 8'b00000001;
    #10;
    if (out !== 1) $error("Test Failed");

    {a, b, c, d, e, f, g, h} = 8'b10000000;
    #10;
    if (out !== 1) $error("Test Failed");

    {a, b, c, d, e, f, g, h} = 8'b01010101;
    #10;
    if (out !== 1) $error("Test Failed");

    $finish;
  end
endmodule
