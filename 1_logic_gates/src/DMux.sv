module DMux (
    input  in,
    input  sel,
    output a,
    output b
);
  assign a = ~sel ? in : 0;
  assign b = sel ? in : 0;
endmodule
