`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2022 03:03:45 PM
// Design Name: 
// Module Name: PipelineAdder
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


module PipelineAdder(
    input clk,
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] S,
    output Cout
    );
    reg C_buffer_0, C_buffer_1, C_buffer_2;
    reg [15:0] buffer_01, buffer_02, buffer_03, buffer_12, buffer_13, buffer_23;
    reg [7:0] buffer_00, buffer_10, buffer_11, buffer_20, buffer_21, buffer_22;
    wire C0, C1, C2;
    wire [7:0] Sout_0, Sout_1, Sout_2;

    Bit8Adder Adder_0(A[7:0], B[7:0], Cin, Sout_0, C0);
    Bit8Adder Adder_1(buffer_01[7:0], buffer_01[15:8], C_buffer_0, Sout_1, C1);
    Bit8Adder Adder_2(buffer_12[7:0], buffer_12[15:8], C_buffer_1, Sout_2, C2);
    Bit8Adder Adder_3(buffer_23[7:0], buffer_23[15:8], C_buffer_2, S[31:24], Cout);
    assign S[23:16] = buffer_22;
    assign S[15:8] = buffer_21;
    assign S[7:0] = buffer_20;

    always @(posedge clk) begin
        buffer_00 <= Sout_0;
        buffer_01 <= {A[15:8], B[15:8]};
        buffer_02 <= {A[23:16], B[23:16]};
        buffer_03 <= {A[31:24], B[31:24]};

        buffer_10 <= buffer_00;
        buffer_11 <= Sout_1;
        buffer_12 <= buffer_02;
        buffer_13 <= buffer_03;

        buffer_20 <= buffer_10;
        buffer_21 <= buffer_11;
        buffer_22 <= Sout_2;
        buffer_23 <= buffer_13;

        C_buffer_0 <= C0;
        C_buffer_1 <= C1;
        C_buffer_2 <= C2;
    end
    
endmodule

module Bit8Adder(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
    );
    wire C1, C2, C3, C4, C5, C6, C7;
    
    Full_Adder FA0(A[0], B[0], Cin, S[0], C1);
    Full_Adder FA1(A[1], B[1], C1, S[1], C2);
    Full_Adder FA2(A[2], B[2], C2, S[2], C3);
    Full_Adder FA3(A[3], B[3], C3, S[3], C4);
    Full_Adder FA4(A[4], B[4], C4, S[4], C5);
    Full_Adder FA5(A[5], B[5], C5, S[5], C6);
    Full_Adder FA6(A[6], B[6], C6, S[6], C7);
    Full_Adder FA7(A[7], B[7], C7, S[7], Cout);
    
endmodule

module Full_Adder(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
    );
    wire y;
    assign y = A ^ B;
    assign S = y ^ Cin;
    assign Cout = (y & Cin) | (A & B);
endmodule
