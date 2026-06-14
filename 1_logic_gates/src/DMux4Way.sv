module DMux4Way (
    input              in,
    input        [1:0] sel,
    output logic       a,
    b,
    c,
    d
);
  always_comb begin
    {a, b, c, d} = 4'b0;
    unique case (sel)
      2'b00: a = in;
      2'b01: b = in;
      2'b10: c = in;
      2'b11: d = in;
    endcase
  end
endmodule
