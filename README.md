# MIPS 32 CORE WITH HAZARD DETECTION & DATA FORWARDING 
 The MIPS 32 CPU core is a five stage pipelined central processing unit based on the MIPS (Microprocessor without Interlocked Pipeline Stages) architecture with Hazard detection and data forwarding unit.MIPS is a Reduced Instruction Set Computer (RISC) architecture that is widely used in embedded systems, networking devices, and other applications.
 
The term "MIPS 32" refers to a specific version of the MIPS architecture, which is a 32-bit instruction set architecture. It means that the CPU core can process instructions that are 32 bits in length. The MIPS 32 architecture provides a standardized set of instructions and registers that the CPU core can execute.

Some key features of a MIPS 32 CPU core include:

**RISC architecture:** MIPS 32 follows the RISC philosophy, which emphasizes simplicity and efficiency by using a reduced set of instructions that can be executed in a single clock cycle.

**Instruction pipeline:** MIPS 32 CPUs typically use a classic five-stage pipeline, which allows for efficient instruction fetching, decoding, execution, memory access, and write-back stages.

**Register set:** MIPS 32 CPUs have a set of 32 general-purpose registers (GPRs) that can be used for arithmetic, data manipulation, and storage operations

![image](https://github.com/sivaram-07/MIPS32/assets/114935240/0da78841-4978-45b3-8623-c707c4028a6e)



**The MIPS32 instruction set architecture (ISA) **is a 32-bit RISC (Reduced Instruction Set Computer) architecture developed by MIPS Technologies. 

Instruction Formats: MIPS32 instructions are encoded in a fixed-length format of 32 bits. The three primary instruction formats are:
a. R-Format: Used for arithmetic and logical operations between registers.
b. I-Format: Used for immediate arithmetic and logical operations, memory loads, and branches.
c. J-Format: Used for unconditional and jump instructions.

![image](https://github.com/sivaram-07/MIPS32/assets/114935240/d7aeec68-aeaf-49a8-b935-605bb3f36dbd)

MIPS processor architecture has been implemented using 5 pipeline stages. These pipeline stages are Instruction Fetch (IF), Instruction Decode (ID), Execution (EX), Memory Access (MEM) and Write Back (WB). These stages are separated by special registers called pipeline registers. The purpose of these registers is to separate the stages of the instructions so that there is no conflicting data due to multiple instructions being executed simultaneously. They are named after the stages that they are placed in-between: IF/ID Register, ID/EX Register, EX/MEM Register, and MEM/WB Register. 

![Screenshot 2024-04-11 104303](https://github.com/Madeshwar01/MIPS32/assets/142793292/586e5e1b-a668-485d-9be3-61850f9cb997)

This pipe lined architecture consist two extra modules Hazard detection unit and Data forwarding unit to improve datapath of architecture.

![Screenshot 2024-04-11 104310](https://github.com/Madeshwar01/MIPS32/assets/142793292/629338b3-4f81-4980-9c3e-e2733e019b87)

Hazard Detection Unit: 
There are three types of pipeline hazards: Structural hazard, data hazard and control hazard. In this paper we are concentrating on data hazard only. Data hazards arise when an instruction depends on the result of a previous instruction in a way that is exposed by the overlapping of the instructions in the pipeline, thus causing the pipeline to stall until the results are made available.

![Screenshot 2024-04-11 104319](https://github.com/Madeshwar01/MIPS32/assets/142793292/ea41d46f-f8cf-447f-91ea-12997f8aeda3)

Data Forwarding Unit: 
One solution of data hazard is called Data forwarding, which supplies the resulting operand to the dependant instruction as soon it has been computed. Figure 10 shows 
how dependencies are resolved using a Data forwarding unit. [t shows that in sub instruction, result is available at EXECUT[ON stage (after 3rd clock cycle) and successive instructions reads $2 at the end of execution stage or 4th or 5th clock cycle. This means instructions can be execute without stalls by just forwarding the data. So, here forwarding unit gives remedy for data hazard. 

![Screenshot 2024-04-11 104330](https://github.com/Madeshwar01/MIPS32/assets/142793292/7f58a15b-3887-4639-a3b0-6993037c61ff)

Design of 32-bit MIPS based RISC processor is implemented successfully with pipeline functionalities. Every instruction is executed in one clock cycle with 5-stage 
pipe lining. This design shows the implementation of MIPS based CPU capable of handling various R -type, J-type and I-type of instruction and each of these categories has a 
different format. These instructions are verified successfully through testbench. Designing Forwarding unit and hazard detection unit to overcome the data dependencies was 
critical task and it was implemented successfully.

