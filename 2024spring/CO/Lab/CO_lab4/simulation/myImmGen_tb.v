`include "Lab4_header.vh"
`include "../source/ImmGen.v"

module ImmGen_tb ();
    reg [2:0] ImmSel;
    reg [31:0] inst_field;
    wire [31:0] Imm_out;

    ImmGen m0(
        .ImmSel(ImmSel),
        .inst_field(inst_field),
        .Imm_out(Imm_out)
    );

    `define Inst(inst) \
        inst_field = inst; \
        #5;

    initial begin
        $dumpfile("ImmGen.vcd");
        $dumpvars(0,ImmGen_tb);


        ImmSel = `IMM_SEL_I;
        `Inst(32'h3e850513); // addi x10, x10, 1000
        `Inst(32'h06454513); // xori x10, x10, 100
        `Inst(32'h00a56513); // ori x10, x10, 10
        `Inst(32'h0c857513); // addi x10, x10, 200
        `Inst(32'h00151513); // slli x10, x10, 1
        `Inst(32'h00255513); // srli x10, x10, 2
        `Inst(32'h40355513); // srai x10, x10, 3
        `Inst(32'hfff52513); // slti x10, x10, -1
        `Inst(32'h01453513); // sltiu x10, x10, 20
        `Inst(32'h06400503); // lb x10, 100(x0)
        `Inst(32'h0c851503); // lh x10, 200(x10)
        `Inst(32'h12c52503); // lw x10, 300(x10)
        `Inst(32'h19054503); // lbu x10, 400(x10)
        `Inst(32'h1f455503); // lhu x10, 500(x10)
        `Inst(32'h00000067); // jalr x0, 0(x0)
        #20;

        ImmSel = `IMM_SEL_S;
        `Inst(32'h06538223); // sb x5, 100(x7)
        `Inst(32'h02539423); // sh x5, 40(x7)
        `Inst(32'h0453a823); // sw x5, 80(x7)
        #20;

        ImmSel = `IMM_SEL_B;
        `Inst(32'h06a50263); // beq x10, x10, 100
        `Inst(32'h0aa51063); // bne x10, x10, 160
        `Inst(32'h06734263); // blt x6, x7, 100
        `Inst(32'h06735263); // bge x6, x7, 100
        `Inst(32'h12736663); // bltu x6, x7, 300
        `Inst(32'h12737663); // bgeu x6, x7, 300
        #20;

        ImmSel = `IMM_SEL_J;
        `Inst(32'hF9DFF06F); // jal x0, -100
        `Inst(32'h3FE000EF); // jal x1, 1022

        ImmSel = `IMM_SEL_U;
        `Inst(32'h003e8537); //lui x10, 1000
        `Inst(32'h003e8517); //auipc x10, 1000

        #20;



    end
    
endmodule

