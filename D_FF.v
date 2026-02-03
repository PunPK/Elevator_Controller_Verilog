module D_FF (q, d, clk, reset);
    output q;
    input d, clk, reset;
    reg q;

    always @(posedge reset or posedge clk)
    begin
        if (reset)
            q = 1'b0;  // ให้ q เป็น 0
        else
            q = d;     // ให้ q รับค่า d
    end
endmodule