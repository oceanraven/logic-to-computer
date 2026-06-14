module ALU (
    input  [15:0] x,
    y,
    input         zx,
    nx,
    zy,
    ny,
    f,
    no,
    output [15:0] out,
    output        ng,
    zr
);
  logic [15:0] xz, xn, yz, yn, o;
  assign xz  = zx ? 0 : x;
  assign xn  = nx ? ~xz : xz;
  assign yz  = zy ? 0 : y;
  assign yn  = ny ? ~yz : yz;

  assign o   = f ? xn + yn : xn & yn;
  assign out = no ? ~o : o;

  assign ng  = out[15];
  assign zr  = (out == 16'h0) ? 1'b1 : 1'b0;

endmodule
