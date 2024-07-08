addi x19, x0, 40 
addi x18, x0, trap
csrrw x0, 0x305, x18 # mtvec = trap

csr_test:
    lui x28, 0x0EDCB
    addi x28, x28, 0x666
    csrrw x29, 0x300, x28 # m tstatus = 0x0EDCB666
    lui x18, 0x1235
    addi x18, x18, -1093 # x18 = 0x01234BBB
    csrrs x30, 0x300, x18 # mtstatus = 0x0FFFFFFF
    csrrwi x27, 0x300, x31 # mtstatus = 31, x27 = 0xFFFFFFFF
    addi x27, x0, 0b10101
    csrrc x29, 0x300, x27 # mtstatus = 0x0000000A, x29 = 0x31
    csrrsi x30, 0x300, x16 # mtstatus = 0x0000001A, x30 = 0xC
    csrrci x27, 0x300, x15 # mtstatus = 0x00000010, x27 = 0x1C
    csrrwi x29, 0x300, x0 # mtstatus = 0x00000010, x29 = 0x10
    csrrsi x28, 0x300, x0 # mtstatus = 0x00000010, x28 = 0x10
    csrrci x27, 0x300, x0 # mtstatus = 0x00000010, x27 = 0x10

Exception_test:
    nop # INT test # 
    ecall # 
    nop # illegal instruction
    lui x31, 0x666
    
dummy:
    nop
    nop
    nop
    nop
    nop
    jal x0, dummy

trap:
    addi x19, x19, -20
    sw x20, 0(x19)
    sw x21, 4(x19)
    sw x22, 8(x19)
    sw x23, 12(x19)
    sw x24, 16(x19)

    csrrwi x20, 0x300, x0 # mstatus
    csrrwi x21, 0x305, x0 # mtvec
    csrrwi x22, 0x341, x0 # mepc
    csrrwi x23, 0x342, x0 # mcause
    csrrwi x24, 0x343, x0 # mtval

    srai x28, x23, 1 
    andi x28, x28, 1 # x28 = 1 异常， x28 = 0 中断
    beq x28, x0, Interruption
    jal x0, Exception
    nop
    nop
    nop

Exception:
    addi x29, x22, 4
    csrrw x0, 0x341, x29 # mepc = mepc + 4
    beq x0, x0, ret

Interruption:
    nop
    nop
    beq x0, x0, ret

ret:
    lw x24, 16(x19)
    lw x23, 12(x19)
    lw x22, 8(x19)
    lw x21, 4(x19)
    lw x20, 0(x19)
    addi x19, x19, 20
    nop #mret

