module Register (
    input  logic        clk,
    input  logic        load,
    input  logic [15:0] in,
    output logic [15:0] out
);
  always_ff @(posedge clk) begin
    if (load) begin
      out <= in;
    end
  end
endmodule
