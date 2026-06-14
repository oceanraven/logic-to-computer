module Mux4Way16 (
    input        [15:0] a,
    b,
    c,
    d,
    input        [ 1:0] sel,
    output logic [15:0] out
);
  always_comb begin
    unique case (sel)
      2'b00: out = a;
      2'b01: out = b;
      2'b10: out = c;
      2'b11: out = d;
    endcase
  end
endmodule
