`timescale 1ns / 1ps
module tb_Memory;
  logic clk = 0;
  logic load = 0;
  logic [14:0] address = 0;
  logic [15:0] in = 0;
  logic [15:0] keyboard = 0;
  logic [15:0] out;

  Memory dut (.*);
  always #5 clk = ~clk;

  task automatic write_word(input logic [14:0] addr,
                            input logic [15:0] value);
    @(negedge clk);
    address = addr;
    in = value;
    load = 1;
    @(posedge clk);
    #1;
    load = 0;
  endtask

  task automatic check_word(input logic [14:0] addr,
                            input logic [15:0] expected);
    @(negedge clk);
    address = addr;
    load = 0;
    #1;
    if (out !== expected)
      $fatal(1, "address=%h expected=%h actual=%h", addr, expected, out);
  endtask

  initial begin
    write_word(15'h0000, 16'h1111);
    write_word(15'h1fff, 16'h2222);
    write_word(15'h2000, 16'h3333);
    write_word(15'h3fff, 16'h4444);
    write_word(15'h4000, 16'haaaa);
    write_word(15'h5fff, 16'hbbbb);

    check_word(15'h0000, 16'h1111);
    check_word(15'h1fff, 16'h2222);
    check_word(15'h2000, 16'h3333);
    check_word(15'h3fff, 16'h4444);
    check_word(15'h4000, 16'haaaa);
    check_word(15'h5fff, 16'hbbbb);

    @(negedge clk);
    address = 15'h4000;
    in = 16'hcccc;
    load = 1;
    #1;
    if (out !== 16'haaaa) $fatal(1, "Write occurred before clock edge");
    @(posedge clk);
    #1;
    if (out !== 16'hcccc) $fatal(1, "Write missing after clock edge");
    load = 0;
    in = 16'hdddd;
    @(posedge clk);
    #1;
    if (out !== 16'hcccc) $fatal(1, "Write occurred with load=0");

    keyboard = 16'd65;
    check_word(15'h6000, 16'd65);
    write_word(15'h6000, 16'hffff);
    check_word(15'h6000, 16'd65);
    keyboard = 16'd130;
    #1;
    if (out !== 16'd130) $fatal(1, "Keyboard read is not combinational");

    write_word(15'h6001, 16'hffff);
    check_word(15'h6001, 16'h0000);
    check_word(15'h7fff, 16'h0000);
    check_word(15'h2000, 16'h3333);
    check_word(15'h4000, 16'hcccc);
    check_word(15'h5fff, 16'hbbbb);

    $display("PASS: Memory");
    $finish;
  end

  initial begin
    #2000;
    $fatal(1, "TIMEOUT");
  end
endmodule
