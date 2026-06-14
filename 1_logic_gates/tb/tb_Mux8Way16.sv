`timescale 1ns / 1ps

module tb_Mux8Way16;
  logic [15:0] a, b, c, d, e, f, g, h, out;
  logic [2:0] sel;

  Mux8Way16 dut (
      .a  (a),
      .b  (b),
      .c  (c),
      .d  (d),
      .e  (e),
      .f  (f),
      .g  (g),
      .h  (h),
      .sel(sel),
      .out(out)
  );

  initial begin
    a   = 16'h1111;
    b   = 16'h2222;
    c   = 16'h3333;
    d   = 16'h4444;
    e   = 16'h5555;
    f   = 16'h6666;
    g   = 16'h7777;
    h   = 16'h8888;

    sel = 3'b000;
    #10;
    if (out !== 16'h1111) $error("Test Failed");

    sel = 3'b011;
    #10;
    if (out !== 16'h4444) $error("Test Failed");

    sel = 3'b111;
    #10;
    if (out !== 16'h8888) $error("Test Failed");

    $finish;
  end
endmodule
