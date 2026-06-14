`timescale 1ns / 1ps

module tb_Mux4Way16;
  logic [15:0] a, b, c, d, out;
  logic [1:0] sel;

  Mux4Way16 dut (
      .a  (a),
      .b  (b),
      .c  (c),
      .d  (d),
      .sel(sel),
      .out(out)
  );

  initial begin
    a   = 16'h1111;
    b   = 16'h2222;
    c   = 16'h3333;
    d   = 16'h4444;

    sel = 2'b00;
    #10;
    if (out !== 16'h1111) $error("Test Failed");

    sel = 2'b01;
    #10;
    if (out !== 16'h2222) $error("Test Failed");

    sel = 2'b10;
    #10;
    if (out !== 16'h3333) $error("Test Failed");

    sel = 2'b11;
    #10;
    if (out !== 16'h4444) $error("Test Failed");

    $finish;
  end
endmodule
