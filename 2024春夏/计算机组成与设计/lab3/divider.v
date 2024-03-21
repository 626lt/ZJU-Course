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

    reg [63:0] remainder;
    reg [31:0] quotient;
    reg [63:0] high_divisor;
    reg [5:0] count;
    reg state;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            divide_zero <= 0;
            finish <= 0;
            res <= 0;
            rem <= 0;
            state <= 0;
            count <= 0;
            remainder <= 0;
            quotient <= 0;
            high_divisor <= 0;
        end
        else if(start && ~state) begin
            state <= 1;
            if(divisor == 0) begin
                finish = 1;
                divide_zero = 1;
            end
            else begin
                remainder = {32'b0, dividend};
                high_divisor = {divisor, 32'b0};
                count = 0;
                quotient = 0;
                finish = 0;
            end
        end
        else if(state && ~finish) begin
            if(remainder > high_divisor) begin
                remainder = remainder - high_divisor;
                quotient[0] = 1;
            end
            quotient = quotient << 1;
            high_divisor >> 1;
            count = count + 1;
        end

        if(count == 32 && state) begin
            state = 0;
            finish = 1;
        end
    end
endmodule