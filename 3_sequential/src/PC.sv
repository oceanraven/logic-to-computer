module PC (
    input  logic        clk,
    input  logic        reset,
    input  logic        load,
    input  logic        inc,
    input  logic [15:0] in,
    output logic [15:0] out
);

  always_ff @(posedge clk) begin
    if (reset) begin
      out <= 16'h0;
    end else begin
      if (load) begin
        out <= in;
      end else begin
        if (inc) begin
          out <= out + 16'h1;
        end
      end
    end
  end
endmodule
