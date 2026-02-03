module Elevator_System (
    input clk,
    input reset,
    input sw_open,  
    input sw_close, 
    input [1:0] sw_floor,
    output [6:0] seg_out,
    output door_led
);

    wire q1, q0;
    wire [1:0] current_floor = {q1, q0};


    wire not_input1, not_input0, not_q0;
    not (not_input1, sw_floor[1]);
    not (not_input0, sw_floor[0]);
    not (not_q0, q0);

    // FF1 Logic
    wire j1_val, k1_val;
    and (j1_val, sw_floor[1], q0);
    and (k1_val, not_input1, not_q0);

    // FF0 Logic
    wire xor_term, j0_val, k0_val;
    xor (xor_term, q1, sw_floor[1]);
    or (j0_val, sw_floor[0], xor_term);
    or (k0_val, not_input0, xor_term);

    
    wire door_q;    
    wire timer_done;
    
    // ใช้ XNOR เพื่อเช็คว่า Input ตรงกับ Q หรือไม่ (เหมือนกัน = 1)
    wire eq_bit1, eq_bit0;
    xnor (eq_bit1, sw_floor[1], q1);
    xnor (eq_bit0, sw_floor[0], q0); 

    // นำผลการเปรียบเทียบมา AND กัน เพื่อเป็นสัญญาณ Clock
    wire arrival_clk;
    and (arrival_clk, eq_bit1, eq_bit0);

    wire d_clk;
    or (d_clk, arrival_clk, sw_open);

    // D Flip-Flop
    wire door_reset;
    or (door_reset, reset, timer_done, sw_close);

    D_FF door_control (
        .q(door_q), 
        .d(1'b1),           // ขา D ต่อกับ 1
        .clk(d_clk),        // ขา Clock มาจาก Comparator
        .reset(door_reset)  // รีเซ็ตเมื่อกดปุ่ม หรือ เวลาหมด
    );

    // Counter (Delay)
    // เอา Q D_FF มาต่อเป็น clock ของ counter
    // wire door_open;
    // or (door_open, door_q, sw_open);

    wire counter_clk;
    and (counter_clk, clk, door_p);

    door_timer timer (
        .clk(counter_clk),     
        .reset(reset), 
        .timer_done(timer_done)
    );

    // Flip-Flops
    wire system_enable;
    not (system_enable, door_q); 

    JK_FF ff1 (.q(q1), .j(j1_val), .k(k1_val), .enable(system_enable), .clk(clk), .reset(reset));
    JK_FF ff0 (.q(q0), .j(j0_val), .k(k0_val), .enable(system_enable), .clk(clk), .reset(reset));

    // Output: Door LED

    wire door_led_q;
    or (door_led_q, door_q, door_open);
    assign door_led = door_led_q;

    Decoder_7_Seg display (seg_out, current_floor);

endmodule