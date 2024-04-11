`timescale 1ns / 1ps

 module mips32_core(
 input clk1,clk2,rst_n
 );
 
 reg [31:0] PC,IF_ID_IR,IF_ID_NPC;
 reg [31:0] ID_EX_IR,ID_EX_A,ID_EX_B,ID_EX_NPC,ID_EX_Imm;
 reg [31:0] EX_MEM_IR,EX_MEM_ALUOUT,EX_MEM_B,EX_MEM_NPC;
 reg [31:0] MEM_WB_IR,MEM_WB_ALUOUT,MEM_WB_LMD;
 reg [2:0] ID_EX_type,EX_MEM_type,MEM_WB_type;
 reg EX_MEM_COND,HALTED, TAKEN_BRANCH,FORWARD_A,FORWARD_B;
 
 reg[31:0] Mem [1023:0];

 reg[31:0] Reg [31:0];
 
 parameter ADD=6'b100000 , SUB=6'b100010, AND=6'b100100, OR=6'b100101,XOR=6'b100110, SLT=6'b101010,SLL=6'b000000,SRL=6'b000010,SRA=6'b000011,
 LW=6'b100011, SW=6'b101011,LUI=6'b001111, ADDI=6'b001000,SLTI=6'b001010,ANDI=6'b001100,ORI=6'b001101,XORI=6'b001110,BEQ=6'b000100,BNE=6'b000101,JAL=6'b000011,
 HLT=6'b111111, RR_ALU=3'b000,RM_ALU=3'b001,LOAD=3'b010,STORE=3'b011,BRANCH=3'b100,JUMP=3'b101,HALT=3'b110;


always @(posedge clk1) //IF STAGE
if(~rst_n) begin
		PC          <=0;
		IF_ID_IR    <=0;
		IF_ID_NPC   <=0;
		HALTED      <=0;
		TAKEN_BRANCH<=0;
end
else begin
if (HALTED==0)
	begin
		if(((EX_MEM_type==BRANCH) && (EX_MEM_COND==1)) ||(EX_MEM_IR[31:26]==JAL))
			begin
			IF_ID_IR	<= Mem[EX_MEM_ALUOUT];
			TAKEN_BRANCH	<= 1'b1;
			IF_ID_NPC 	<= EX_MEM_ALUOUT +1;
			PC 		<=  EX_MEM_ALUOUT +1;
		    	end	
		else
			begin
			TAKEN_BRANCH	<= 1'b0;
			IF_ID_IR        <= Mem[PC];
			IF_ID_NPC 	<= PC +1;
			PC		<=  PC +1;
		    	end		
 	end
 end
 
 always @(posedge clk2) //ID STAGE
 if (HALTED==0)
	begin
	if((IF_ID_IR[25:21]==EX_MEM_IR[15:11] && (EX_MEM_type!=BRANCH))||(IF_ID_IR[25:21]==EX_MEM_IR[20:16] &&(EX_MEM_type==RM_ALU))) begin FORWARD_A=(EX_MEM_type==STORE)? 0 : 1; FORWARD_B=0; end
	else if((IF_ID_IR[20:16]==EX_MEM_IR[15:11] &&  (EX_MEM_type!=BRANCH))||(IF_ID_IR[20:16]==EX_MEM_IR[20:16] &&(EX_MEM_type==RM_ALU))) begin FORWARD_B=(EX_MEM_type==STORE)? 0 :1;  FORWARD_A=0; end
	else begin
		FORWARD_A=0;
		FORWARD_B=0;
	end
		if(IF_ID_IR[25:21] == 5'b00000)
			ID_EX_A =0;
		else 
			ID_EX_A = (FORWARD_A)? EX_MEM_ALUOUT :Reg[IF_ID_IR[25:21]]; 
			
			
		if(IF_ID_IR[20:16] == 5'b00000) 
			ID_EX_B =0;
		else 
			ID_EX_B =(FORWARD_B)? EX_MEM_ALUOUT :Reg[IF_ID_IR[20:16]]; 
		
		ID_EX_IR   <= IF_ID_IR;
		ID_EX_NPC  <= IF_ID_NPC;
		ID_EX_Imm  <= (IF_ID_IR[31:26]==JAL)? {{6{IF_ID_IR[25]}},IF_ID_IR[25:0]}:{{16{IF_ID_IR[15]}},IF_ID_IR[15:0]};
		
		
		case(IF_ID_IR[31:26])
			6'b000000                      : ID_EX_type <= RR_ALU;
			ADDI,SLTI,ANDI,ORI,XORI        : ID_EX_type <= RM_ALU;
			LW,LUI			       : ID_EX_type <= LOAD;
			SW                             : ID_EX_type <= STORE;
			BEQ,BNE                        : ID_EX_type <= BRANCH;
			JAL                            : ID_EX_type <= JUMP;
			HLT                            : ID_EX_type <= HALT;
			default                        : ID_EX_type <= HALT;
		endcase
	end
	
	
	
 always @(posedge clk1) //EX STAGE
 if (HALTED==0)
	begin
		EX_MEM_type 	<= ID_EX_type;
		EX_MEM_IR   	<= ID_EX_IR;
		
		
		case(ID_EX_type)
			RR_ALU :begin
						case(ID_EX_IR[5:0])
							ADD		: EX_MEM_ALUOUT <= ID_EX_A + ID_EX_B;
							SUB 		: EX_MEM_ALUOUT <= ID_EX_A - ID_EX_B;
							AND 		: EX_MEM_ALUOUT <= ID_EX_A & ID_EX_B;
							OR  		: EX_MEM_ALUOUT <= ID_EX_A | ID_EX_B;
							XOR  		: EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_B;
							SLT 		: EX_MEM_ALUOUT <= ID_EX_A < ID_EX_B;
                  			SLL         : EX_MEM_ALUOUT <= ID_EX_B << ID_EX_IR[10:6];
                   			SRL         : EX_MEM_ALUOUT <= ID_EX_B >> ID_EX_IR[10:6];
                            SRA         : EX_MEM_ALUOUT <= ID_EX_A >>> ID_EX_IR[10:6];
							default  : EX_MEM_ALUOUT <= 32'hxxxxxxxx;
						endcase
					  end
					  
			RM_ALU :begin
						case(ID_EX_IR[31:26])
							ADDI 		: EX_MEM_ALUOUT <= ID_EX_A + ID_EX_Imm;
							SLTI 		: EX_MEM_ALUOUT <= ID_EX_A < ID_EX_Imm;
							ANDI 		: EX_MEM_ALUOUT <= ID_EX_A & ID_EX_Imm;
							ORI  		: EX_MEM_ALUOUT <= ID_EX_A | ID_EX_Imm;
							XORI  		: EX_MEM_ALUOUT <= ID_EX_A ^ ID_EX_Imm;
							default  : EX_MEM_ALUOUT <= 32'hxxxxxxxx;
						endcase
					  end
					  
			LOAD,STORE:begin
							EX_MEM_ALUOUT <= (ID_EX_IR[31:26]==LUI) ? ID_EX_Imm<<16 : (ID_EX_A + ID_EX_Imm);
							EX_MEM_B      <=  ID_EX_B;
						  end
						  
			BRANCH :begin
						EX_MEM_ALUOUT <= PC-1 + ID_EX_Imm;
						case(ID_EX_IR[31:26])
						BEQ: EX_MEM_COND   <= (ID_EX_A == ID_EX_B);
						BNE: EX_MEM_COND   <= (ID_EX_A != ID_EX_B);
						endcase
					  end
		    JUMP    :begin
		              EX_MEM_ALUOUT <= ID_EX_Imm<<2; 	
		              EX_MEM_NPC	    <= ID_EX_NPC;          	            
		            end
		endcase
	  end
	  					 						
 
 always @(posedge clk2) //MEM STAGE
 if (HALTED==0) 
   begin
		MEM_WB_IR   <=EX_MEM_IR;
		MEM_WB_type <=EX_MEM_type;
		
		case(EX_MEM_type)
			RR_ALU,RM_ALU :MEM_WB_ALUOUT <= EX_MEM_ALUOUT;
			JUMP          :MEM_WB_ALUOUT <= EX_MEM_NPC;
			LOAD          :MEM_WB_LMD <= Mem[EX_MEM_ALUOUT];
			STORE         :if (TAKEN_BRANCH==0)	
					           Mem[EX_MEM_ALUOUT] <= EX_MEM_B;
		endcase
	end


 always @(posedge clk1) //WB STAGE
	begin
		if(TAKEN_BRANCH==0)
			case(MEM_WB_type)
				RR_ALU : Reg[MEM_WB_IR[15:11]] <= MEM_WB_ALUOUT;
				RM_ALU : Reg[MEM_WB_IR[20:16]] <= MEM_WB_ALUOUT;
				LOAD   : Reg[MEM_WB_IR[20:16]] <= MEM_WB_LMD;
				JUMP   : Reg[31]               <= MEM_WB_ALUOUT;
				HALT	: HALTED <= 1'b1;
			endcase
	end	
endmodule






/*
		if(IF_ID_IR[25:21] == 5'b00000)
			ID_EX_A =0;
		else 
			ID_EX_A = (FORWARD_A)?((EX_MEM_type==LOAD)?Mem[EX_MEM_ALUOUT]:EX_MEM_ALUOUT) :Reg[IF_ID_IR[25:21]]; 
			
			
		if(IF_ID_IR[20:16] == 5'b00000) 
			ID_EX_B =0;
		else 
			ID_EX_B =(FORWARD_B)?((EX_MEM_type==LOAD)?Mem[EX_MEM_ALUOUT]:EX_MEM_ALUOUT) :Reg[IF_ID_IR[20:16]]; 
		
*/	
