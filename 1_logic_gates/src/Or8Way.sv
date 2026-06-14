module Or8Way (
    input  a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    output out
);
  assign out = a | b | c | d | e | f | g | h;
endmodule
