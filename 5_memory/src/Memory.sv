module Memory (
    input  logic        clk,
    input  logic        load,
    input  logic [14:0] address,
    input  logic [15:0] in,
    input  logic [15:0] keyboard,
    output logic [15:0] out
);
  logic [15:0] ram_out;
  logic [15:0] screen [0:8191];
  logic ram_load;

  assign ram_load = load & !address[14];

  RAM16K ram (
      .clk(clk),
      .load(ram_load),
      .address(address[13:0]),
      .in(in),
      .out(ram_out)
  );

  always_ff @(posedge clk) begin
    if (load && address[14:13] == 2'b10)
      screen[address[12:0]] <= in;
  end

  always @* begin
    if (!address[14])
      out = ram_out;
    else if (address[14:13] == 2'b10)
      out = screen[address[12:0]];
    else if (address == 15'h6000)
      out = keyboard;
    else
      out = 16'h0000;
  end
endmodule
