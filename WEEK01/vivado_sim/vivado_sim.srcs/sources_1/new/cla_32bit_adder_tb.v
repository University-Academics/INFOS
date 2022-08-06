`timescale 1ns / 1ps

module cla_32bit_adder_tb;
    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg Cin;

    // Outputs
    wire [31:0] S;
    wire Cout;
    
    Bit32CarryLookAheadAdder Adder(A, B, Cin, S, Cout);
    initial begin
    $monitor($time, " A=%d, B=%d, S=%d" , A, B, S);
    // Initialize Inputs
        A = 124532445;
        B = 212421455;
        Cin = 0;       
        
        #11;
        A = 142352352;
        B = 465693463;
        Cin = 0;
     
        #11;
        A = 847583573;
        B = 347583488;
        Cin = 0;
        
        #11;
        A = 573286762;
        B = 235762376;
        Cin = 0;
    end
endmodule
