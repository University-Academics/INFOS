`timescale 1ns / 1ps

module traffic_lights_tb;
    reg clk, en;
    wire R1, R2, R3,R4,R5,R6,R7,R8,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,G1,G2,G3,G4,G5,G6,G7,G8;
    integer i;
    traffic_lights TL(clk, en, R1, R2, R3,R4,R5,R6,R7,R8,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,G1,G2,G3,G4,G5,G6,G7,G8);
//    initial begin
//        clk = 0;
//        forever #5 clk = ~clk;
        
//    end
    initial begin
        en = 0;#10;en = 1;#1;en = 0;
        clk = 0;
        
        forever begin
            for ( i=0 ;i<4 ;i=i+1 ) begin
                #100
                clk=1;#5;clk=0;#5;
                
                #20
                clk=1;#5;clk=0;#5;
                
                #20
                clk=1;#5;clk=0;#5;
            end
        end
    end

    
endmodule
