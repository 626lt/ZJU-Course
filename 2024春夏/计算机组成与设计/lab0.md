







<img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240224201037292.png" alt="image-20240224201037292" style="zoom:200%;" />





<center>
  <font face="黑体" size = 6>
    《计算机组成与设计》实验报告
  </font>
    <br></br><br></br><br></br><br></br>
  <center><font face="黑体" size = 4>
    姓名：刘韬
  </font>
  <center><font face="黑体" size = 4>
    学院：计算机科学与技术学院
  </font>
  <center><font face="黑体" size = 4>
    专业：人工智能（图灵班）
  </font>
  <center><font face="黑体" size = 4>
    邮箱：3220103422@zju.edu.cn
  </font>
</center> 






<center><font face="黑体" size = 5>
    报告日期: 2024/2/28
  </font>
</center> 




<div STYLE="page-break-after: always;"></div>



# Lab0 安装并使用 Vivado

> 

## 操作方法与实验步骤

### 新建工程文件

点击 Create New Project，创建名为 Project1 的工程到对应的文件目录，后选择 RTL Project，此时把 Do not specify at this time 勾上，表示在新建工程时不去指定源文件。在器件(Defalut Part)界面，选择之前添加好的板卡`Nexys A7-100T`，然后完成工程创建。

<img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240228135051701.png" alt="image-20240228135051701" style="zoom:15%;" />

### 新建源文件和MUX的功能实现

添加 Design Sources，选择Create design sources，并命名为`MUX.v`，输入下面**代码**：

```verilog
module MUX(
    input [15:0]SW,
    output [3:0]LED
    );
    assign LED = SW[14]?(SW[15]?0:SW[7:4]):(SW[15]?SW[11:8]:SW[3:0]);
endmodule
```

以上代码实现了四输入 MUX，其中 `SW[15:14]` 作为选择信号。

- `SW[15:14]=0` 时输出 `SW[3:0]`。
- `SW[15:14]=1` 时输出 `SW[7:4]`。
- `SW[15:14]=2` 时输出 `SW[11:8]`。
- `SW[15:14]=3` 时输出常数 `0`。
- 输出直接绑到四个 LED 灯。

上面的`assign`语句是判断`SW[14]`，然后判断`SW[15]`，选择对应的输出。

### 进行仿真

添加 Simulation Sources，选择Create，命名为`MUX_tb.v`，输入**测试代码**：

```verilog
module MUX_tb;
    reg [15:0]SW;
    wire [3:0]LED;
    MUX m1(SW,LED);

    initial begin
        SW[11:0] = 12'b011100110001;
        SW[15:14] = 2'b00;#50;
        SW[15:14] = 2'b01;#50;
        SW[15:14] = 2'b10;#50;
        SW[15:14] = 2'b11;#50;
    end
endmodule
```

测试代码固定`SW[11:0] = 12'b011100110001;`。那么

在`SW[15:14] == 00`时，`LED = 4b'0001`对应第四个灯亮；

在`SW[15:14] == 01`时，`LED = 4b'0011`对应第三四个灯亮；

在`SW[15:14] == 10`时，`LED = 4b'0111`对应第二三四个灯亮；

在`SW[15:14] == 11`时，`LED = 4b'0000`对应全部灯不亮；

仿真**波形截图**如下：

<img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240228104306386.png" alt="image-20240228104306386" style="zoom: 25%;" />

仿真图像上看到当`SW[15:14] == 00`时，`LED = 1`；当`SW[15:14] == 01`时，`LED = 3`；当`SW[15:14] == 10`时，`LED = 7`；当`SW[15:14] == 11`时，`LED = 0`;与预期相符。

### 进行下板验证

添加约束文件 constraints，输入以下**约束代码**：

```verilog
# LED
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { LED[0] }]; #IO_L18P_T2_A24_15 Sch=led[0]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { LED[1] }]; #IO_L24P_T3_RS1_15 Sch=led[1]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { LED[2] }]; #IO_L17N_T2_A25_15 Sch=led[2]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { LED[3] }]; #IO_L8P_T1_D11_14 Sch=led[3]

# SW
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { SW[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { SW[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { SW[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { SW[3] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { SW[4] }]; #IO_L12N_T1_MRCC_14 Sch=sw[4]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { SW[5] }]; #IO_L7N_T1_D10_14 Sch=sw[5]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { SW[6] }]; #IO_L17N_T2_A13_D29_14 Sch=sw[6]
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { SW[7] }]; #IO_L5N_T0_D07_14 Sch=sw[7]
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { SW[8] }]; #IO_L24N_T3_34 Sch=sw[8]
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS18 } [get_ports { SW[9] }]; #IO_25_34 Sch=sw[9]
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { SW[10] }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=sw[10]
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { SW[11] }]; #IO_L23P_T3_A03_D19_14 Sch=sw[11]
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { SW[12] }]; #IO_L24P_T3_35 Sch=sw[12]
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { SW[13] }]; #IO_L20P_T3_A08_D24_14 Sch=sw[13]
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { SW[14] }]; #IO_L19N_T3_A09_D25_VREF_14 Sch=sw[14]
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { SW[15] }]; #IO_L21P_T3_DQS_14 Sch=sw[15]

```

约束代码分别对应LED灯和SWITCH开关，SWITCH作为输入，LED作为输出显示。

**下面是验证结果**：

<img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240228144408279.png" alt="image-20240228144408279" style="zoom:12%;" />  <img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240228144455388.png" alt="image-20240228144455388" style="zoom:12%;" />  <img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240228144625375.png" alt="image-20240228144625375" style="zoom:12%;" />  <img src="C:\Users\12583\AppData\Roaming\Typora\typora-user-images\image-20240228144739444.png" alt="image-20240228144739444" style="zoom:12%;" />

`SW[11:0]=12b'011100110001`，上图中已经标出`SW[15:14]`的各种取值，对应的输出，均满足预期。

## 讨论、心得

lab0主要是对vivado的使用和熟悉，已经基本掌握了添加源代码文件，仿真，下板验证的流程。使用的是vivado2022.2，配置过程中没有遇到特别大的问题。值得吐槽的是vivado的编辑器，配色和区分十分蛋疼，所以迅速地转移到了VS Code。

### 思考题

+ Error 是出在Generate Bitstream阶段的，因为有一些I/O端口缺少约束
+ 可能的解决方案：
  + 指定所有I/O标准，完善所有的引脚约束
  + 或者使用如下命令：`set_property SEVERITY {Warning} [get_drc_checks NSTD-1]`来允许未约束的端口生成比特流文件。使用这个命令的方法是将它输入到一个`.tcl`文件中，然后通过右键点击左侧Program and Debug 后点击 Bitstream Setting将刚刚创立的.tcl 文件指定为tcl.pre.就可以继续Generate Bitstream。
+ 如何得到解决方案的：我是通过阅读报错信息直接得到以上两种解决方案的。