`timescale 1ns / 1ps

module tb_Not;
  logic in, out;

  Not dut (
      .in (in),
      .out(out)
  );

  initial begin
    in = 0;
    #10;
    if (out !== 1) $error("Test Failed");

    in = 1;
    #10;
    if (out !== 0) $error("Test Failed");

    $finish;
  end
endmodule
