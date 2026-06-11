`timescale 1ns / 1ps

module tb_Mux;
  logic a, b, sel, out;

  Mux dut (
      .a  (a),
      .b  (b),
      .sel(sel),
      .out(out)
  );

  initial begin
    a   = 0;
    b   = 0;
    sel = 0;
    #10;
    if (out !== 0) $error("Test Failed");

    a   = 0;
    b   = 1;
    sel = 0;
    #10;
    if (out !== 0) $error("Test Failed");

    a   = 1;
    b   = 0;
    sel = 0;
    #10;
    if (out !== 1) $error("Test Failed");

    a   = 0;
    b   = 0;
    sel = 1;
    #10;
    if (out !== 0) $error("Test Failed");

    a   = 0;
    b   = 1;
    sel = 1;
    #10;
    if (out !== 1) $error("Test Failed");

    a   = 1;
    b   = 0;
    sel = 1;
    #10;
    if (out !== 0) $error("Test Failed");

    $finish;
  end
endmodule
