module FullAdder (
    input  a,
    input  b,
    input  c,
    output carry,
    output sum
);
  assign {carry, sum} = a + b + c;
endmodule
