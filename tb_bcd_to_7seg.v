// tb_bcd_to_7seg.v
`timescale 1ns/1ps

module tb_bcd_to_7seg;

    reg  [3:0] bcd;
    wire [6:0] seg;   // {a,b,c,d,e,f,g}
    wire       valid;

    bcd_to_7seg uut (
        .bcd(bcd),
        .seg(seg),
        .valid(valid)
    );

    task print_7seg;
        reg a,b,c,d,e,f,g;
        begin
            a = seg[6];
            b = seg[5];
            c = seg[4];
            d = seg[3];
            e = seg[2];
            f = seg[1];
            g = seg[0];

            $display("\n t=%0t | bcd=%0d (0x%0h) | valid=%0b | seg=%b", $time, bcd, bcd, valid, seg);
            $display("   %s   ", a ? "___" : "   ");
            $display(" %s   %s ", f ? "|"   : " ", b ? "|"   : " ");
            $display("   %s   ", g ? "___" : "   ");
            $display(" %s   %s ", e ? "|"   : " ", c ? "|"   : " ");
            $display("   %s   ", d ? "___" : "   ");
        end
    endtask

    integer i;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_bcd_to_7seg);

        for (i = 0; i < 16; i = i + 1) begin
            bcd = i[3:0];
            #1;           // settle
            print_7seg();
            #9;           // total 10ns/step
        end

        $finish;
    end

endmodule