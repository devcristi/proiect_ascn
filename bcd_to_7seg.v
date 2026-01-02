//* decoder combinational
// * intrare 4 biti
// * iesire 7 biti

module bcd_to_7seg
(
    input [3:0] bcd, //* input de 4 biti
    output reg [6:0] seg, //* output de 7 biti
    output reg valid //* output validare / semnal pe 1 bit
);

always @(*) begin
    valid = 1'b1; //* initializam validarea pe 1

    case (bcd)
        4'b0000: seg = 7'b1111110; //* 0 
        4'b0001: seg = 7'b0110000; //* 1
        4'b0010: seg = 7'b1101101; //* 2
        4'b0011: seg = 7'b1111001; //* 3
        4'b0100: seg = 7'b0110011; //* 4
        4'b0101: seg = 7'b1011011; //* 5
        4'b0110: seg = 7'b1011111; //* 6
        4'b0111: seg = 7'b1110000; //* 7
        4'b1000: seg = 7'b1111111; //* 8
        4'b1001: seg = 7'b1111011; //* 9
        
        default:
            begin
                seg = 7'b1001111; //* toate segmentele stinse
                valid = 1'b0; //* semnal de validare pe 0
            end
    endcase
end
endmodule