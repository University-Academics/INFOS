`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/26/2022 08:32:58 PM
// Design Name: 
// Module Name: Simulation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PipelineSimulation;
    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg Cin, clk;

    // Outputs
    wire [31:0] S;
    wire Cout;
    
    PipelineAdder Adder(clk, A, B, Cin, S, Cout);
    initial begin
        
        A = 124532445;
        B = 212421455;
        Cin = 0;        
        clk = 0;#5;clk = 1;#5;
        
        A = 142352352;
        B = 465693463;
        Cin = 0;
        clk = 0;#5;clk = 1;#5;
     
        A = 847583573;
        B = 347583488;
        Cin = 0;
        clk = 0;#5;clk = 1;#5;
        
        A = 573286762;
        B = 235762376;
        Cin = 0;
        clk = 0;#5;clk = 1;#5;
        clk = 0;#5;clk = 1;#5;
        clk = 0;#5;clk = 1;#5;
        
        
    end
endmodule
