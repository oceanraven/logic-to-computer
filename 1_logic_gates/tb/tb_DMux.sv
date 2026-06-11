`timescale 1ns / 1ps

module tb_DMux;
  logic in, sel, a, b;

  DMux dut (
      .in (in),
      .sel(sel),
      .a  (a),
      .b  (b)
  );

  initial begin
    in  = 0;
    sel = 0;
    #10;
    if ({a, b} !== 2'b00) $error("Test Failed");

    in  = 1;
    sel = 0;
    #10;
    if ({a, b} !== 2'b10) $error("Test Failed");

    in  = 0;
    sel = 1;
    #10;
    if ({a, b} !== 2'b00) $error("Test Failed");

    in  = 1;
    sel = 1;
    #10;
    if ({a, b} !== 2'b01) $error("Test Failed");

    $finish;
  end
endmodule
