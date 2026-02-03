module JK_FF (q, j, k, enable, clk, reset); 
    output q;
    input j, k, enable, clk, reset;       
    reg q;

    always @(posedge reset or posedge clk)
    begin
        if (reset) begin
            q <= 1'b0;
        end
        else if (enable) begin 
            case ({j,k})
                2'b00 : q <= q;      // No change
                2'b01 : q <= 1'b0;   // Reset
                2'b10 : q <= 1'b1;   // Set
                2'b11 : q <= ~q;     // Toggle
            endcase
        end
        // ถ้า enable = 0 จะไม่ทำอะไร (ค่า q เหมือนเดิม)
    end
endmodule