module Decoder_7_Seg (seg, floor_code);
    output [6:0] seg; 
    input [1:0] floor_code; 
    reg [6:0] seg;

    always @(floor_code)
    begin
        case (floor_code)
            2'd0 : seg = 7'b0111111; // เลข 0
            2'd1 : seg = 7'b0000110; // เลข 1
            2'd2 : seg = 7'b1011011; // เลข 2
            2'd3 : seg = 7'b1001111; // เลข 3
            default : seg = 7'b0000000; // ดับหมด
        endcase
    end
endmodule