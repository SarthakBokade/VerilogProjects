`timescale 1ns / 1ps

module multiplication_TB();
    reg[15:0] data_in;
    reg clk;
    reg start;
    wire done;
    wire eqz;
    wire LdA, LdB, LdP, clrP, decB;

    initial
    begin
        clk=0;
        forever
        #5 clk=~clk;
    end

    multiplication DUT1(eqz,LdA,LdP,LdB,clrP,decB,data_in,clk);
    controller DUT2(LdA,LdB,LdP,clrP,decB,done,clk,eqz,start);

    initial
    begin
        #17 data_in=17;
        #10 data_in=5;
    end

    initial
    begin
        
        #10 start = 1;
        #10 start = 0;
        #500 $finish;
    end

    initial
    begin
        
        $monitor($time, "  State=%b, A=%d, B=%d, P=%d , done=%b, eqz=%b",
                 DUT2.state, DUT1.A.out, DUT1.B.out, DUT1.P.out, done, eqz);
    end

endmodule
