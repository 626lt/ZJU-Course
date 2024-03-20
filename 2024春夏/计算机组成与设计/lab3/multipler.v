module multiplier(
    input clk,
    input start,
    input[31:0] A,
    input[31:0] B,
    output reg finish,
    output reg[63:0] res
);

    reg state; // 记录 multiplier 是不是正在进行运算
    reg[31:0] multiplicand; // 保存当前运算中的被乘数

    reg[4:0] cnt; // 记录当前计算已经经历了几个周期（运算与移位）
    wire[5:0] cnt_next = cnt + 6'b1;

    reg sign = 0; // 记录当前运算的结果是否是负数

    wire [31:0] unsighed_A;
    wire [31:0] unsighed_B;
    assign unsighed_A = (A[31] == 1'b1) ? ~A + 1 : A;
    assign unsighed_B = (B[31] == 1'b1) ? ~B + 1 : B;

    initial begin
        res <= 0;
        state <= 0;
        finish <= 0;
        cnt <= 0;
        multiplicand <= 0;
    end

    always @(posedge clk) begin
        if(~state && start) begin
        // Not Running
        sign <= A[31] ^ B[31];
        multiplicand <= unsighed_A;
        res <= {32'b0, unsighed_B};
        state <= 1'b1;
        finish <= 1'b0;
        cnt <= 1'b0;
        end else if(state) begin
        // Running
        // Why not "else"?
        // 你需要在这里处理“一次”运算与移位
        if(res[0] == 1'b1) begin
            res[63:32] = res[63:32] + multiplicand;
        end
        res = res >> 1;
        cnt = cnt + 1;
        end

        // 填写 cnt 相关的内容，用 cnt 查看当前运算是否结束
        if(cnt == 0 ) begin
        // 得到结果
            finish <= 1'b1;
            state <= 0;
            assign res <= (sign == 1'b1) ? ~res + 1 : res;
        end 
    end

endmodule