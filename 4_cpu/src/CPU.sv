module CPU (
    input logic        clk,
    input logic [15:0] inM,
    input logic [15:0] instruction,
    input logic        reset,

    output logic [15:0] outM,
    output logic        writeM,
    output logic [14:0] addressM,
    output logic [14:0] pc
);

  logic        is_c;

  logic [15:0] a_in;
  logic [15:0] a_value;
  logic [15:0] d_value;
  logic        a_load;
  logic        d_load;

  logic [15:0] alu_y;
  logic [15:0] alu_out;
  logic        zr;
  logic        ng;

  logic        positive;
  logic        jump;
  logic [15:0] pc_value;

  assign is_c   = instruction[15];

  assign a_in   = is_c ? alu_out : instruction;
  assign a_load = !is_c | (is_c & instruction[5]);

  Register a_register (
      .clk (clk),
      .load(a_load),
      .in  (a_in),
      .out (a_value)
  );

  assign d_load = is_c & instruction[4];

  Register d_register (
      .clk (clk),
      .load(d_load),
      .in  (alu_out),
      .out (d_value)
  );

  assign alu_y = instruction[12] ? inM : a_value;

  ALU alu (
      .x  (d_value),
      .y  (alu_y),
      .zx (instruction[11]),
      .nx (instruction[10]),
      .zy (instruction[9]),
      .ny (instruction[8]),
      .f  (instruction[7]),
      .no (instruction[6]),
      .out(alu_out),
      .ng (ng),
      .zr (zr)
  );

  assign outM = alu_out;
  assign writeM = is_c & instruction[3];
  assign addressM = a_value[14:0];

  assign positive = !ng & !zr;

  assign jump = is_c & (
      (instruction[2] & ng) |
      (instruction[1] & zr) |
      (instruction[0] & positive)
  );

  PC program_counter (
      .clk  (clk),
      .reset(reset),
      .load (jump),
      .inc  (1'b1),
      .in   (a_value),
      .out  (pc_value)
  );

  assign pc = pc_value[14:0];

endmodule
