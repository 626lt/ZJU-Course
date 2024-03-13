module CSSTE(
    input         clk_100mhz,
    input         RSTN,
    input  [3:0]  BTN_y,
    input  [15:0] SW,
    output [3:0]  Blue,
    output [3:0]  Green,
    output [3:0]  Red,
    output        HSYNC,
    output        VSYNC,
    output [15:0] LED_out,
    output [7:0] AN,
    output [7:0] segment
);

    wire U1_MemRW;
    wire [31:0] U1_Addr_out;
    wire [31:0] U1_Data_out;
    wire [31:0] U1_PC_out;

    wire [31:0] U2_spo;

    wire [31:0] U3_douta;

    wire [31:0] U4_Cpu_data4bus;
    wire [31:0] U4_ram_data_in;
    wire [9:0] U4_ram_addr;
    wire U4_data_ram_we;
    wire U4_GPIOf0000000_we;
    wire U4_GPIOe0000000_we;
    wire U4_counter_we;
    wire [31:0] U4_Peripheral_in;

    wire [7:0] U5_point_out;
    wire [7:0] U5_LE_out;
    wire [31:0] U5_Disp_num;

    // wire [7:0] U6_AN;
    // wire [7:0] U6_segment;

    wire [1:0] U7_counter_set;
    //wire [15:0] U7_LED_out;

    wire [31:0] U8_clkdiv;
    wire U8_Clk_CPU;

    wire [3:0] U9_BTN_OK;
    wire [15:0] U9_SW_OK;
    wire U9_rst;

    wire U10_counter0_OUT;
    wire U10_counter1_OUT;
    wire U10_counter2_OUT;
    wire [31:0] U10_counter_out;

    
    SCPU U1(
        .clk(U8_Clk_CPU),
        .rst(U9_rst),
        .Data_in(U4_Cpu_data4bus),
        .inst_in(U2_spo),
        .MemRW(U1_MemRW),
        .Addr_out(U1_Addr_out),
        .Data_out(U1_Data_out),
        .PC_out(U1_PC_out)
    );

    ROM_I U2(
        .a(U1_PC_out[11:2]),
        .spo(U2_spo)
    );

    RAM_B U3(
        .clka(~clk_100mhz),
        .wea(U4_data_ram_we),
        .addra(U4_ram_addr),
        .dina(U4_ram_data_in),
        .douta(U3_douta)
    );

    MIO_BUS U4(
        .clk(clk_100mhz),
        .rst(U9_rst),
        .BTN(U9_BTN_OK),
        .SW(U9_SW_OK),
        .mem_w(U1_MemRW),
        .Cpu_data2bus(U1_Data_out),
        .addr_bus(U1_Addr_out),
        .ram_data_out(U3_douta),
        .led_out(U7_LED_out),
        .counter_out(U10_counter_out),
        .counter0_out(U10_counter0_OUT),
        .counter1_out(U10_counter1_OUT),
        .counter2_out(U10_counter2_OUT),
        .Cpu_data4bus(U4_Cpu_data4bus),
        .ram_data_in(U4_ram_data_in),
        .ram_addr(U4_ram_addr),
        .data_ram_we(U4_data_ram_we),
        .GPIOf0000000_we(U4_GPIOf0000000_we),
        .GPIOe0000000_we(U4_GPIOe0000000_we),
        .counter_we(U4_counter_we),
        .Peripheral_in(U4_Peripheral_in)
    );

    Multi_8CH32 U5(
        .clk(~U8_Clk_CPU),
        .rst(U9_rst),
        .EN(U4_GPIOe0000000_we),
        .Test(SW[7:5]),
        .point_in({U8_clkdiv[31:0],U8_clkdiv[31:0]}),
        .LES(64'b0),
        .Data0(U4_Peripheral_in),
        .data1({2'b0,U1_PC_out[31:2]}),
        .data2(U2_spo),
        .data3(U10_counter_out),
        .data4(U1_Addr_out),
        .data5(U1_Data_out),
        .data6(U4_Cpu_data4bus),
        .data7(U1_PC_out),
        .point_out(U5_point_out),
        .LE_out(U5_LE_out),
        .Disp_num(U5_Disp_num)
    );

    Seg7_Dev_v1_0 U6(
        .disp_num(U5_Disp_num),
        .point(U5_point_out),
        .les(U5_LE_out),
        .scan({clk_div[18],clk_div[17,clk_div[16]]}),
        .AN(AN),
        .segment(segment)
    );

    SPIO U7(
        .clk(~U8_Clk_CPU),
        .rst(U9_rst),
        .Start(U8_clkdiv[20]),
        .EN(U4_GPIOf0000000_we),
        .P_Data(U4_Peripheral_in),
        .counter_set(U7_counter_set),
        .LED_out(LED_out)
    );

    clkdiv U8(
        .clk(clk_100mhz),
        .rst(U9_rst),
        .SW2(U9_SW_OK[2]),
        .SW8(U9_SW_OK[8]),
        .STEP(U9_SW_OK[10]),
        .clkdiv(U8_clkdiv),
        .Clk_CPU(U8_Clk_CPU)
    );

    SAnti_jitter U9(
        .clk(clk_100mhz),
        .RSTN(RSTN),
        .Key_y(BTN_y),
        .SW(SW),
        .BTN_OK(U9_BTN_OK),
        .SW_OK(U9_SW_OK),
        .rst(U9_rst)
    );

    Counter_x U10(
        .clk(~U8_Clk_CPU),
        .rst(U9_rst),
        .clk0(U8_clkdiv[6]),
        .clk1(U8_clkdiv[9]),
        .clk2(U8_clkdiv[11]),
        .counter_we(U4_counter_we),
        .counter_val(U4_Peripheral_in),
        .counter_ch(U7_counter_set),
        .counter0_OUT(U10_counter0_OUT),
        .counter1_OUT(U10_counter1_OUT),
        .counter2_OUT(U10_counter2_OUT),
        .counter_out(U10_counter_out)
    );

    VGA_v1_0 U11(
        .clk_25m(U8_clkdiv[1]),
        .clk_100m(clk_100mhz),
        .rst(U9_rst),
        .pc(U1_PC_out),
        .inst(U2_spo),
        .alu_res(U1_Addr_out),
        .men_wen(U1_MemRW),
        .dmem_o_data(U3_douta),
        .dmem_i_data(U4_ram_data_in),
        .dmem_addr(U1_Addr_out),
        .hs(HSYNC),
        .vs(VSYNC),
        .vga_r(Red),
        .vga_g(Green),
        .vga_b(Blue)
    );

endmodule
