`timescale 1ns / 1ps

module tb_ALU;
  logic [15:0] x, y, out;
  logic zx, nx, zy, ny, f, no, zr, ng;

  ALU dut (
      .x  (x),
      .y  (y),
      .zx (zx),
      .nx (nx),
      .zy (zy),
      .ny (ny),
      .f  (f),
      .no (no),
      .out(out),
      .zr (zr),
      .ng (ng)
  );

  initial begin
    x = 16'h1234;
    y = 16'h5678;

    {zx, nx, zy, ny, f, no} = 6'b101010;
    #10;
    if (out !== 16'h0000 || zr !== 1 || ng !== 0) $error("Test Failed: 0");

    {zx, nx, zy, ny, f, no} = 6'b000010;
    #10;
    if (out !== (16'h1234 + 16'h5678) || zr !== 0 || ng !== 0) $error("Test Failed: x+y");

    {zx, nx, zy, ny, f, no} = 6'b000000;
    #10;
    if (out !== (16'h1234 & 16'h5678) || zr !== 0 || ng !== 0) $error("Test Failed: x&y");

    {zx, nx, zy, ny, f, no} = 6'b111010;
    #10;
    if (out !== 16'hFFFF || zr !== 0 || ng !== 1) $error("Test Failed: -1");

    $finish;
  end
endmodule
