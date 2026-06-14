`timescale 1ns / 1ps

module tb_Mux16;
  logic [15:0] a, b, out;
  logic sel;

  Mux16 dut (
      .a  (a),
      .b  (b),
      .sel(sel),
      .out(out)
  );

  initial begin
    a   = 16'hAAAA;
    b   = 16'h5555;
    sel = 0;
    #10;
    if (out !== 16'hAAAA) $error("Test Failed");

    a   = 16'hAAAA;
    b   = 16'h5555;
    sel = 1;
    #10;
    if (out !== 16'h5555) $error("Test Failed");

    a   = 16'h1234;
    b   = 16'hABCD;
    sel = 0;
    #10;
    if (out !== 16'h1234) $error("Test Failed");

    $finish;
  end
endmodule
