module divider(
    input   clk,
    input   rst,
    input   start,          // 开始运算
    input[31:0] dividend,   // 被除数
    input[31:0] divisor,    // 除数
    output divide_zero,     // 除零异常
    output  finish,         // 运算结束信号
    output[31:0] res,       // 商
    output[31:0] rem        // 余数
);
    reg [63:0] high_divisor;
    reg [63:0] remainder;
    reg [4:0] cnt;
    reg [31:0] Quotient;
    reg state;//state = 0 notrunning, state = 1 running

    assign remainder = {32'b0, dividend};
    assign high_divisor = {divisor, 32'b0};
    // assign res = Quotient;
    // assign rem = remainder[31:0];
    

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            divide_zero <= 0;
            finish <= 0;
            state <= 0;
        end
        else if(start) begin // Not Running
            state = 1;
            if (divisor == 0) begin
                finish = 1;
                divide_zero = 1;
            end
            else if(state & ~finish) begin
                if(high_divisor < remainder) begin
                    remainder = remainder - high_divisor;
                    Quotient[0] = 1;   
                end
                Quotient = Quotient << 1;
                high_divisor = high_divisor >> 1;
                cnt = cnt + 1;
            end
        end
        if(cnt == 0 && state) begin
            finish = 1;
            state = 0;
            assign res = Quotient;
            assign rem = remainder[31:0];
        end
    end


endmodule