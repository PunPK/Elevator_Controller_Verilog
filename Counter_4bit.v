module Counter_4bit (out, enable, clk, reset);
    output [3:0] out;
    input enable, clk, reset;
    reg [3:0] out;

    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            out <= 4'b0000; // reset = 0
        end
        else if (enable) begin
            out <= out + 1; // บวกเพิ่มทีละ 1
        end
    end
endmodule