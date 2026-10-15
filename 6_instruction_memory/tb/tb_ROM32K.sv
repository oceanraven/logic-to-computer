`timescale 1ns / 1ps
module tb_ROM32K;
  logic [14:0] address;
  logic [15:0] out;
  logic [15:0] expected [0:7];

  ROM32K #(
      .ROM_FILE("tb/Add.hack"),
      .PROGRAM_WORDS(8)
  ) dut (.*);

  initial begin
    expected[0] = 16'h0002;
    expected[1] = 16'hec10;
    expected[2] = 16'h0003;
    expected[3] = 16'he090;
    expected[4] = 16'h0000;
    expected[5] = 16'he308;
    expected[6] = 16'h0006;
    expected[7] = 16'hea87;

    for (int i = 7; i >= 0; i--) begin
      address = i;
      #1;
      if (out !== expected[i])
        $fatal(1, "address=%0d expected=%h actual=%h", i, expected[i], out);
    end

    dut.memory[32767] = 16'habcd;
    address = 15'h7fff;
    #1;
    if (out !== 16'habcd) $fatal(1, "Highest ROM address failed");

    address = 0;
    #1;
    if (out !== 16'h0002) $fatal(1, "ROM address aliasing");

    $display("PASS: ROM32K");
    $finish;
  end
endmodule
