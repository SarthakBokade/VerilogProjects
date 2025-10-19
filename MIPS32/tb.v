`timescale 1ns / 1ps

module mips_tb();

reg clk1, clk2;
integer k;

mips DUT(clk1,clk2);

initial
  begin
    clk1=0; clk2=0;
    repeat (50)
      begin
        #5 clk1 = 1; #5 clk1=0;
        #5 clk2 = 1; #5 clk2=0;
      end  
  end  

/*  
//Example 1- Add 10,20,30 and store in processor register 
initial 
  begin
    for(k=0; k<31; k++)
      DUT.Reg[k] = k;

    DUT.Mem[0] = 32'h2801000a; //ADDI R1, R0, 10
    DUT.Mem[1] = 32'h28020014; //ADDI R2, R0, 20
    DUT.Mem[2] = 32'h28030019; //ADDI R3, R0, 25
    DUT.Mem[3] = 32'h0ce77800; //OR R7, R7, R7 --Dummy
    DUT.Mem[4] = 32'h0ce77800; //OR R7, R7, R7 --Dummy
    DUT.Mem[5] = 32'h00222000; //ADD R4, R1, R2
    DUT.Mem[6] = 32'h0ce77800; //OR R7, R7, R7 --Dummy
    DUT.Mem[7] = 32'h00832800; //ADD R5, R4, R3
    DUT.Mem[8] = 32'hfc000000; //HLT

    DUT.HALTED = 0;
    DUT.PC = 0;
    DUT.TAKEN_BRANCH = 0;
    
    #280;
    for (k=0;k<6;k=k+1)
      $display(" R%1d - %2d", k, DUT.Reg[k]);
  end   

  initial
    begin
      #300 $finish;
    end
*/

/*
//Example 2- Loading a word srored in memory location 120, adding 45 to it and store result in memory location 121

initial 
  begin
    for(k=0; k<31; k++)
      DUT.Reg[k] = k;
  
  DUT.Mem[0] = 32'h28010078; //ADDI R1, R0, 120
  DUT.Mem[1] = 32'h0c631800; //OR R3, R3, R3 --Dummy
  DUT.Mem[2] = 32'h20220000; //LW R2, 0(R1)
  DUT.Mem[3] = 32'h0c631800; //OR R3, R3, R3 --Dummy
  DUT.Mem[4] = 32'h2842002d; //ADDI R2, R2, 45
  DUT.Mem[5] = 32'h0c631800; //OR R3, R3, R3 --Dummy
  DUT.Mem[6] = 32'h24220001; //SW R2, 1(R1)
  DUT.Mem[7] = 32'hfc000000; //HLT

  DUT.Mem[120] = 85;

  DUT.HALTED = 0;
  DUT.PC = 0;
  DUT.TAKEN_BRANCH = 0;

  #500;
  $display(" Mem[120]: %4d \n Mem[121]: %4d", DUT.Mem[120], DUT.Mem[121]);

  end

  initial
    begin
      #600 $finish;
    end
*/


//Example 3 TO Compute the factorial of number N stored in memory location 200, the result should be stored in memory location 198

initial 
  begin
    for(k=0; k<31; k++)
      DUT.Reg[k] = k;
    
    DUT.Mem[0] = 32'h280a00c8; //ADDI R10, R0, 200
    DUT.Mem[1] = 32'h28020001; //ADDI R2, R0, 1
    DUT.Mem[2] = 32'h0e94a000; //OR R20, R20, R20 --Dummy
    DUT.Mem[3] = 32'h21430000; //LW R3, 0(R10)
    DUT.Mem[4] = 32'h0e94a000; //OR R20, R20, R20 --Dummy
    DUT.Mem[5] = 32'h14431000; //LOOP: MUL R2, R2, R3
    DUT.Mem[6] = 32'h2C630001; //SUBI R3, R3, 1
    DUT.Mem[7] = 32'h0e94a000; //OR R20, R20, R20 --Dummy
    DUT.Mem[8] = 32'h3460fffc; //BNEQZ R3,LOOP (offset= -4)
    DUT.Mem[9] = 32'h2542fffe; //SW R2, -2(R10)
    DUT.Mem[10] = 32'hfc000000; //HLT
    
  DUT.Mem[200] = 7;

  DUT.HALTED = 0;
  DUT.PC = 0;
  DUT.TAKEN_BRANCH = 0;
  
  #2000;
  $display(" Mem[200]: %2d \n Mem[198]: %6d", DUT.Mem[200], DUT.Mem[198]);

  end 
  
  initial
    begin
      $monitor ("R2: %4d",DUT.Reg[2]);
      #3000 $finish;
    end

endmodule


