`timescale 1ns/1ps
module tb_simple;
    reg [3:0] bcd;
    wire [6:0] seg;
    wire valid;

    bcd_to_7seg uut (.bcd(bcd), .seg(seg), .valid(valid));

    initial begin
        if (!$value$plusargs("input=%d", bcd)) bcd = 0;
        #1;
        $display("%b", seg);
        $finish;
    end
endmodule
