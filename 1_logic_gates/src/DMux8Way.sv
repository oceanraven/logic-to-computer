module DMux8Way (
    input              in,
    input        [2:0] sel,
    output logic       a,
    b,
    c,
    d,
    e,
    f,
    g,
    h
);
  always_comb begin
    {a, b, c, d, e, f, g, h} = 8'b0;
    unique case (sel)
      3'b000: a = in;
      3'b001: b = in;
      3'b010: c = in;
      3'b011: d = in;
      3'b100: e = in;
      3'b101: f = in;
      3'b110: g = in;
      3'b111: h = in;
    endcase
  end
endmodule
