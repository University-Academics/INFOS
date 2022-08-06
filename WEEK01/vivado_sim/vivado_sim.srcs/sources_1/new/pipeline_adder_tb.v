`timescale 1ns / 1ps

module PipelineSimulation;
    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg Cin, clk;

    // Outputs
    wire [31:0] S;
    wire Cout;
    
    PipelineAdder Adder(clk, A, B, Cin, S, Cout);
    always begin
    #8 clk=~clk;
    end
    initial begin
    
     $monitor($time, " A=%d, B=%d, S=%d" , A, B, S);
        clk=1'b1;
        
        #16
        A = 124532445;
        B = 212421455;
        Cin = 0;        
        
        #16
        A = 142352352;
        B = 465693463;
        Cin = 0;
     
        #16
        A = 847583573;
        B = 347583488;
        Cin = 0;

        #16
        A = 573286762;
        B = 235762376;
        Cin = 0;
        
        
    end
endmodule
