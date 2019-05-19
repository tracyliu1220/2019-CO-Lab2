`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:06:58 02/25/2016
// Design Name: 
// Module Name:    testbench 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define CYCLE_TIME 50

module TestBench;
  reg Clk, Start;
 // reg [31:0] i;

  Simple_Single_CPU CPU(Clk,Start);
  
  initial
  begin
	$dumpfile("tb_wave.vcd");
	$dumpvars(0, CPU);

    Clk = 0;
    Start = 0;
    
    #(`CYCLE_TIME)
    
    Start = 1;
    #(`CYCLE_TIME*560)	
    
  $finish;
  end
  
  always@(posedge Clk) begin
    $display("---------------------------------------------------------------------------------");
  	$display("PC = %d", CPU.PC.pc_out_o);
    $display("op = %d", CPU.Decoder.instr_op_i);
    // $display("btrl.zero = %d", CPU.BC.zero_i);
    // $display("btrl.result = %d", CPU.BC.result_i);
    // $display("btrl.type = %d", CPU.BC.BranchType);
    // $display("btrl.ctrl = %d", CPU.BC.control_o);
    $display("src1 = %d", CPU.ALU.src1_i);
    $display("src2 = %d", CPU.ALU.src2_i);
    $display("ALU = %d", CPU.ALU.result_o);
    // $display("address select = %d", CPU.Mux_Write_Reg.select_i);
    // $display("regdst = %d", CPU.Decoder.RegDst_o);
    // $display("memtoreg = %d", CPU.Decoder.MemtoReg);
    // $display("regwrite = %d", CPU.Decoder.RegWrite_o);
    // $display("Rd address = %d", CPU.RF.RDaddr_i);
    // $display("MemtoReg data = %d", CPU.Memory_MUX.data_o);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.DM.memory[0], CPU.DM.memory[1], CPU.DM.memory[2], CPU.DM.memory[3], CPU.DM.memory[4], CPU.DM.memory[5], CPU.DM.memory[6], CPU.DM.memory[7]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.DM.memory[8], CPU.DM.memory[9], CPU.DM.memory[10], CPU.DM.memory[11], CPU.DM.memory[12], CPU.DM.memory[13], CPU.DM.memory[14], CPU.DM.memory[15]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.DM.memory[16], CPU.DM.memory[17], CPU.DM.memory[18], CPU.DM.memory[19], CPU.DM.memory[20], CPU.DM.memory[21], CPU.DM.memory[22], CPU.DM.memory[23]);
    $display("Data Memory = %d, %d, %d, %d, %d, %d, %d, %d",CPU.DM.memory[24], CPU.DM.memory[25], CPU.DM.memory[26], CPU.DM.memory[27], CPU.DM.memory[28], CPU.DM.memory[29], CPU.DM.memory[30], CPU.DM.memory[31]);
    $display("Registers");
    $display("R0 = %d, R1 = %d, R2 = %d, R3 = %d, R4 = %d, R5 = %d, R6 = %d, R7 = %d", CPU.RF.Reg_File[ 0], CPU.RF.Reg_File[ 1], CPU.RF.Reg_File[ 2], CPU.RF.Reg_File[ 3], CPU.RF.Reg_File[ 4], CPU.RF.Reg_File[ 5], CPU.RF.Reg_File[ 6], CPU.RF.Reg_File[ 7]);
    $display("R8 = %d, R9 = %d, R10 =%d, R11 =%d, R12 =%d, R13 =%d, R14 =%d, R15 =%d", CPU.RF.Reg_File[ 8], CPU.RF.Reg_File[ 9], CPU.RF.Reg_File[10], CPU.RF.Reg_File[11], CPU.RF.Reg_File[12], CPU.RF.Reg_File[13], CPU.RF.Reg_File[14], CPU.RF.Reg_File[15]);
    $display("R16 =%d, R17 =%d, R18 =%d, R19 =%d, R20 =%d, R21 =%d, R22 =%d, R23 =%d", CPU.RF.Reg_File[16], CPU.RF.Reg_File[17], CPU.RF.Reg_File[18], CPU.RF.Reg_File[19], CPU.RF.Reg_File[20], CPU.RF.Reg_File[21], CPU.RF.Reg_File[22], CPU.RF.Reg_File[23]);
    $display("R24 =%d, R25 =%d, R26 =%d, R27 =%d, R28 =%d, R29 =%d, R30 =%d, R31 =%d", CPU.RF.Reg_File[24], CPU.RF.Reg_File[25], CPU.RF.Reg_File[26], CPU.RF.Reg_File[27], CPU.RF.Reg_File[28], CPU.RF.Reg_File[29], CPU.RF.Reg_File[30], CPU.RF.Reg_File[31]);
  end

  always #(`CYCLE_TIME/2) Clk = ~Clk;	
  
endmodule

