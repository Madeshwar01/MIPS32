`timescale 1ns / 1ps
module testbench;
reg clk1,clk2,rst_n;

integer k;

mips32_core uut(
.clk1(clk1),.clk2(clk2),.rst_n(rst_n));

initial
begin
clk1=0;  clk2=0;
repeat(60)
begin
#5 clk1=1; #5 clk1=0;
#5 clk2=1; #5 clk2=0;
end
end

initial
begin

//Data with dependencies
uut.Mem[0] = 32'h20190200;   //ADDI t9,zero,0x200
uut.Mem[1] = 32'h20180300;  //ADDI t8,zero,0x300
uut.Mem[2] = 32'h03191020;  //ADD $v0 $t8 $t9

//Branching Instructions
uut.Mem[3] = 32'h13190002; //beq t8 t9 0x2 // To Memory Address 5
uut.Mem[4] = 32'h17190005; //bne t8 t9 0x5 // To Memory Address 9

//Load& Store ( BEQ)
uut.Mem[5]= 32'h8C100023; //lw s0 0x23 zero
uut.Mem[6]= 32'h8C110043; //lw s1 0x43 zero
uut.Mem[7]= 32'hAC180050; //sw t8 0x50 zero
uut.Mem[8]= 32'hAC190051; //sw t9 0x51 zero

//Load & Store (BNE)
uut.Mem[9]= 32'h8C100024 ;//lw s0 0x24 zero
uut.Mem[10]= 32'h8C110044 ;//lw s1 0x44 zero
uut.Mem[11]= 32'hAC100050; //sw s0 0x50 zero
uut.Mem[12]= 32'hAC110051 ;//sw s1 0x51 zero

//Arithmetic Operations

uut.Mem[13]= 32'h02119020; //add s2 s0 s1
uut.Mem[14]= 32'h02509822; //sub s3 s2 s0
uut.Mem[15]= 32'h0260A020; //add s4 s3 zero
uut.Mem[16]= 32'h0272A82A; //slt s5 s3 s2
uut.Mem[17]= 32'h0015B080; //sll s6 s5 0x2
uut.Mem[18]= 32'h0016B842; //srl s7 s6 0x1
uut.Mem[19]= 32'h02F64025; //or t0 s7 s6


uut.Mem[10'h23]=32'd1;
uut.Mem[10'h24]=32'd11;
uut.Mem[10'h43]=32'd22;
uut.Mem[10'h44]=32'd33;


end


initial begin
rst_n=1;
#3 rst_n=0;
#4 rst_n=1;
end



endmodule
