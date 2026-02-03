module stimulus;
    reg clk;
    reg reset;
    reg [1:0] sw_floor; 
    reg sw_open;  
    reg sw_close; 

    wire [6:0] seg_out;
    wire door_led;

    Elevator_System uut (
        .clk(clk),
        .reset(reset),
        .sw_floor(sw_floor),
        .sw_open(sw_open),   
        .sw_close(sw_close), 
        .seg_out(seg_out),
        .door_led(door_led)
    );

    wire [1:0] debug_floor = uut.current_floor;
    wire debug_j0          = uut.j0_val;
    wire debug_k0          = uut.k0_val;
    wire debug_j1          = uut.j1_val;
    wire debug_k1          = uut.k1_val;
    
    wire debug_door_active = uut.door_q; 
    wire [3:0] debug_count = uut.timer.count_val; 

    // สร้าง Clock
    initial begin
        clk = 0;
        forever #1 clk = ~clk; 
    end

    // จำลองสถานการณ์
    initial begin
        $dumpfile("elevator_wave.vcd");
        $dumpvars(0, stimulus); 
        
        // กำหนดค่าเริ่มต้น
        reset = 1; sw_floor = 2'b00; sw_open = 0; sw_close = 0;
        #1.5 reset = 0;
        
        // ไปชั้น 1
        #25 sw_floor = 2'b01;
        
        // ไปชั้น 2
        #25 sw_floor = 2'b10;

        // ไปชั้น 3
        #25 sw_floor = 2'b11;

        // กลับมาชั้น 0
        #25 sw_floor = 2'b00;

        // ทดสอบ Open/Close
        // 1. ไปชั้น 2
        #25 sw_floor = 2'b10;
        
        // รอให้ประตูเริ่มเปิด
        #6; 
        
        // รอให้ประตูปิด
        #10;

        // 2. ไปชั้น 3
        sw_floor = 2'b11;
        
        // รอให้ประตูเปิด
        #3; 

        // ทดสอบกด CLOSE (ปิดทันที)
        sw_close = 1;
        #2;
        sw_close = 0;

        #5; 

        // ทดสอบกด Open (เปิดทันที)
        sw_open = 1;
        #6;
        sw_open = 0;

        // จบการทำงาน
        #10 $finish;
    end
    
    initial begin
        $display("----------------------------------------------------------------------------------------");
        $display("Time(s)| CLK | SW_Fl | Opn | Cls | Floor | Door_Q (1=Opn) | Count | Door_LED (0=ON)");
        $display("----------------------------------------------------------------------------------------");
        $monitor("%4g   |  %b  |  %b   |  %b  |  %b  |   %d   |       %b        |  %2d   |    %b", 
                 $time, 
                 clk, 
                 sw_floor,
                 sw_open,   
                 sw_close, 
                 debug_floor,      
                 debug_door_active,      
                 debug_count,  
                 door_led);
    end
endmodule