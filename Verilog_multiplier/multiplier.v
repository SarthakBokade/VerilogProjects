`timescale 1ns / 1ps
//Data Path Design
module multiplication(eqz,LdA,LdP,LdB,clrP,decB,data_in,clk);
input LdA,LdB,LdP,clrP,decB,clk;
input [15:0]data_in;
output wire eqz;
wire [15:0] Bus,X,Y,Z,Bout;
assign Bus = data_in;

PIPO1 A(X,Bus,LdA,clk);
PIPO2 P(Y,Z,LdP,clrP,clk);
CNTR B(Bout,Bus,LdB,decB,clk);
ADDER AD(Z,X,Y);
EQZ COMP(eqz,Bout);

endmodule


module PIPO1(out,in,ld,clk);

input[15:0] in;
output reg [15:0]out;
input ld,clk;

always @(posedge clk)
begin 
if(ld)
out<=in;
end
endmodule


module PIPO2(out,in,ld,clr,clk);
input ld,clr,clk;
input [15:0]in;
output reg[15:0] out;

always@(posedge clk)
begin 
if(clr)
out<=0;
else if(ld)
out<=in;

end
endmodule


module CNTR(out,in,ld,dec,clk);
input [15:0]in;
input ld,dec,clk;
output reg [15:0]out;

always@(posedge clk)
begin 
if(ld)
out<=in;
else if(dec)
out<=out-1;
end
endmodule   


module ADDER(out,in1,in2);
input [15:0]in1,in2;
output reg [15:0]out;
always @(*)
out<=in1+in2;
endmodule

module EQZ(eqz,data);
input[15:0]data;
output eqz;

assign eqz=(data==0);
endmodule


//Control Path Design 
module controller(LdA,LdB,LdP,clrP,decB,done,clk,eqz,start); 
input clk,eqz,start;
output reg LdA,LdB,LdP,clrP,decB,done;
reg [2:0]state;
parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100;
always@(posedge clk)
begin
case(state)
S0:
   if(start)
   state<=S1;
S1:
   state<=S2;
S2:
   state<=S3;
S3:
#2 if(eqz)
   state<=S4;
S4:
   state<=S4;
default: 
   state<=S0;
            
endcase   
end

always @(state)
begin 
LdA  = 0;
LdB  = 0;
LdP  = 0;
clrP = 0;
decB = 0;
done = 0;
case(state)
S0:
  begin 
  LdA=0;LdB=0;LdP=0;clrP=0;decB=0;
  end
S1:
  begin 
  LdA=1;
  end  
S2:
  begin 
  LdA=0;LdB=1;clrP=1;
  end  
S3:
  begin 
  LdB=0;LdP=1;clrP=0;decB=1;
  end  
S4:
  begin 
  done=1;LdB=0;LdP=0;decB=0;
  end  
default:
   begin 
   LdA=0;LdB=0;LdP=0;clrP=0;decB=0;
   end  
endcase
end
endmodule
