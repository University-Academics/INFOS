`timescale 1ns / 1ps

module Simulation;
    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg Cin;

    // Outputs
    wire [31:0] S;
    wire Cout;
    
    Bit32CarryLookAheadAdder Adder(A, B, Cin, S, Cout);
    initial begin
    // Initialize Inputs
        A = 124532445;
        B = 212421455;
        Cin = 0;       
        
        #5;
        A = 142352352;
        B = 465693463;
        Cin = 0;
     
        #5;
        A = 847583573;
        B = 347583488;
        Cin = 0;
        
        #5;
        A = 573286762;
        B = 235762376;
        Cin = 0;
    end
endmodule
