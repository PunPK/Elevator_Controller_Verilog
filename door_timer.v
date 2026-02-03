module door_timer (
    input clk,
    input reset,
    output timer_done       // ส่งสัญญาณบอกว่า ครบ 3 วิแล้ว ให้ประตูปิดได้
);

    wire [3:0] count_val;   // ค่าที่นับได้จาก Counter
    wire enable_count;      // สั่งให้ Counter นับ

    // นับเมื่อมีคำสั่ง start และค่ายังไม่ถึง 3 (นับ 0, 1, 2 พอถึง 3 หยุด)
    assign enable_count = (count_val < 4'd3);


    Counter_4bit my_counter (
        .out(count_val),       
        .enable(enable_count),  
        .clk(clk),             
        .reset(reset) 
    );

    // Logic ขาออก ส่งสัญญาณ 1 เมื่อนับถึง 3 เพื่อให้สั่งปิดประตู
    assign timer_done = (count_val >= 4'd3);

endmodule