`timescale 1ns / 1ps

module tb_CPU;

  logic        clk;
  logic [15:0] inM;
  logic [15:0] instruction;
  logic        reset;

  logic [15:0] outM;
  logic        writeM;
  logic [14:0] addressM;
  logic [14:0] pc;

  int          checks = 0;

  CPU dut (
      .clk        (clk),
      .inM        (inM),
      .instruction(instruction),
      .reset      (reset),
      .outM       (outM),
      .writeM     (writeM),
      .addressM   (addressM),
      .pc         (pc)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  localparam logic [5:0]
      COMP_ZERO = 6'b101010,
      COMP_ONE  = 6'b111111,
      COMP_NEG1 = 6'b111010,
      COMP_D    = 6'b001100,
      COMP_Y    = 6'b110000,
      COMP_DPY  = 6'b000010,
      COMP_DP1  = 6'b011111;

  localparam logic [2:0]
      DEST_NONE = 3'b000,
      DEST_M    = 3'b001,
      DEST_D    = 3'b010,
      DEST_A    = 3'b100,
      DEST_AM   = 3'b101;

  function automatic logic [15:0] c_inst(input logic a, input logic [5:0] comp,
                                         input logic [2:0] dest, input logic [2:0] jump);
    return {3'b111, a, comp, dest, jump};
  endfunction

  task automatic step(input string label, input logic [15:0] inst, input logic [15:0] mem_value,
                      input logic rst, input logic expected_write, input logic check_out,
                      input logic [15:0] expected_out, input logic [14:0] expected_a,
                      input logic [14:0] expected_pc);
    logic [14:0] old_a;
    logic [14:0] old_pc;

    @(negedge clk);

    old_a       = addressM;
    old_pc      = pc;
    instruction = inst;
    inM         = mem_value;
    reset       = rst;

    #1;

    if (writeM !== expected_write)
      $fatal(1, "%s: writeM expected=%b actual=%b", label, expected_write, writeM);

    if (check_out && outM !== expected_out)
      $fatal(1, "%s: outM expected=%h actual=%h", label, expected_out, outM);

    if (addressM !== old_a) $fatal(1, "%s: addressM changed before clock edge", label);

    if (pc !== old_pc) $fatal(1, "%s: pc changed before clock edge", label);

    @(posedge clk);
    #1;

    if (addressM !== expected_a)
      $fatal(1, "%s: addressM expected=%h actual=%h", label, expected_a, addressM);

    if (pc !== expected_pc) $fatal(1, "%s: pc expected=%h actual=%h", label, expected_pc, pc);

    checks++;
  endtask

  task automatic start_case;
    step("reset and @0", 16'h0000, 16'h0000, 1, 0, 0, 16'h0000, 15'd0, 15'd0);
  endtask

  function automatic bit jump_expected(input int jump_code, input int signed value);
    case (jump_code)
      0: return 0;
      1: return value > 0;
      2: return value == 0;
      3: return value >= 0;
      4: return value < 0;
      5: return value != 0;
      6: return value <= 0;
      7: return 1;
      default: return 0;
    endcase
  endfunction

  initial begin : tests
    int signed value;
    logic [5:0] constant_comp;
    logic [14:0] next_pc;
    logic [14:0] next_a;
    logic [15:0] next_d;

    instruction = 16'h0000;
    inM         = 16'h0000;
    reset       = 1;

    start_case();

    step("@21", 16'd21, 0, 0, 0, 0, 0, 21, 1);

    step("D=A", c_inst(0, COMP_Y, DEST_D, 0), 0, 0, 0, 0, 0, 21, 2);

    step("@8 must not write memory", 16'd8, 0, 0, 0, 0, 0, 8, 3);

    step("M=D, D must still be 21", c_inst(0, COMP_D, DEST_M, 0), 0, 0, 1, 1, 16'd21, 8, 4);

    step("@3", 16'd3, 0, 0, 0, 0, 0, 3, 5);

    step("D=D+A", c_inst(0, COMP_DPY, DEST_D, 0), 0, 0, 0, 0, 0, 3, 6);

    step("M=D, expected 24", c_inst(0, COMP_D, DEST_M, 0), 0, 0, 1, 1, 16'd24, 3, 7);

    step("D=M", c_inst(1, COMP_Y, DEST_D, 0), 16'h1234, 0, 0, 0, 0, 3, 8);

    step("M=D, expected value read from inM", c_inst(0, COMP_D, DEST_M, 0), 0, 0, 1, 1, 16'h1234, 3,
         9);

    step("D=D+M", c_inst(1, COMP_DPY, DEST_D, 0), 16'h0002, 0, 0, 0, 0, 3, 10);

    step("M=D, expected 0x1236", c_inst(0, COMP_D, DEST_M, 0), 0, 0, 1, 1, 16'h1236, 3, 11);

    for (int dest = 0; dest < 8; dest++) begin
      start_case();

      step("@7", 16'd7, 0, 0, 0, 0, 0, 7, 1);

      step("D=A", c_inst(0, COMP_Y, DEST_D, 0), 0, 0, 0, 0, 0, 7, 2);

      step("@100", 16'd100, 0, 0, 0, 0, 0, 100, 3);

      next_a = (dest & 4) ? 15'd8 : 15'd100;
      next_d = (dest & 2) ? 16'd8 : 16'd7;

      step($sformatf("destination %03b", dest[2:0]), c_inst(0, COMP_DP1, dest[2:0], 0), 0, 0,
           dest[0], dest[0], 16'd8, next_a, 4);

      step("probe D through M=D", c_inst(0, COMP_D, DEST_M, 0), 0, 0, 1, 1, next_d, next_a, 5);
    end

    for (int sign_case = 0; sign_case < 3; sign_case++) begin
      unique case (sign_case)
        0: begin
          value = -1;
          constant_comp = COMP_NEG1;
        end
        1: begin
          value = 0;
          constant_comp = COMP_ZERO;
        end
        2: begin
          value = 1;
          constant_comp = COMP_ONE;
        end
      endcase

      for (int jump_code = 0; jump_code < 8; jump_code++) begin
        start_case();

        step("initialize D", c_inst(0, constant_comp, DEST_D, 0), 0, 0, 0, 0, 0, 0, 1);

        step("@123", 16'd123, 0, 0, 0, 0, 0, 123, 2);

        next_pc = jump_expected(jump_code, value) ? 15'd123 : 15'd3;

        step($sformatf("jump=%03b, D=%0d", jump_code[2:0], value), c_inst(
             0, COMP_D, DEST_NONE, jump_code[2:0]), 0, 0, 0, 0, 0, 123, next_pc);
      end
    end

    start_case();

    step("@7", 16'd7, 0, 0, 0, 0, 0, 7, 1);

    step("D=A", c_inst(0, COMP_Y, DEST_D, 0), 0, 0, 0, 0, 0, 7, 2);

    step("@100", 16'd100, 0, 0, 0, 0, 0, 100, 3);

    step("A=D;JMP must jump to old A", c_inst(0, COMP_D, DEST_A, 3'b111), 0, 0, 0, 0, 0, 7, 100);

    step("reset overrides jump, but AM=D still executes", c_inst(0, COMP_D, DEST_AM, 3'b111), 0, 1,
         1, 1, 16'd7, 7, 0);

    start_case();

    step("A=-1 exposes address 0x7fff", c_inst(0, COMP_NEG1, DEST_A, 0), 0, 0, 0, 0, 0, 15'h7fff,
         1);

    step("0;JMP to 32767", c_inst(0, COMP_ZERO, DEST_NONE, 3'b111), 0, 0, 0, 0, 0, 15'h7fff,
         15'h7fff);

    step("@0 at PC=32767, next pc must be 0", 16'd0, 0, 0, 0, 0, 0, 0, 0);

    $display("PASS: CPU completed %0d instruction checks", checks);
    $finish;
  end

  initial begin
    #10000;
    $fatal(1, "TIMEOUT: CPU testbench did not finish");
  end

endmodule
