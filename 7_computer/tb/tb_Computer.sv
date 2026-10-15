`timescale 1ns / 1ps
module tb_Computer;
  logic clk = 0;
  logic reset = 1;
  logic [15:0] keyboard = 0;

  Computer #(
      .ROM_FILE("tb/Add.hack"),
      .PROGRAM_WORDS(8)
  ) dut (.*);

  always #5 clk = ~clk;

  task automatic boot;
    @(negedge clk);
    reset = 1;
    @(posedge clk);
    #1;
    if (dut.pc !== 0) $fatal(1, "Reset failed");
    @(negedge clk);
    reset = 0;
  endtask

  task automatic check_program;
    for (int i = 0; i < 6; i++) begin
      @(posedge clk);
      #1;
      if (dut.pc !== i + 1)
        $fatal(1, "Unexpected PC after instruction %0d: %h", i, dut.pc);
    end

    if (dut.data_memory.ram.memory[0] !== 16'd5)
      $fatal(1, "RAM[0] expected=5 actual=%h", dut.data_memory.ram.memory[0]);

    for (int i = 0; i < 6; i++) begin
      @(posedge clk);
      #1;
      if (dut.pc !== ((i % 2 == 0) ? 15'd7 : 15'd6))
        $fatal(1, "End loop failed: pc=%h", dut.pc);
      if (dut.writeM !== 0) $fatal(1, "Unexpected write in end loop");
    end
  endtask

  initial begin
    boot();
    check_program();
    boot();
    check_program();
    $display("PASS: Computer");
    $finish;
  end

  initial begin
    #2000;
    $fatal(1, "TIMEOUT");
  end
endmodule
