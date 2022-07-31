`timescale 1ns / 1ps

module Bit32RippleAdder(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] S,
    output Cout
    );
    wire C8, C16, C24;
    
    Bit8RippleAdder Bit8Adder0(A[7:0], B[7:0], Cin, S[7:0], C8);
    Bit8RippleAdder Bit8Adder1(A[15:8], B[15:8], C8, S[15:8], C16);
    Bit8RippleAdder Bit8Adder2(A[23:16], B[23:16], C16, S[23:16], C24);
    Bit8RippleAdder Bit8Adder3(A[31:24], B[31:24], C24, S[31:24], Cout);
    
endmodule

module Bit8RippleAdder(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
    );
    wire C1, C2, C3, C4, C5, C6, C7;
    
    FullAdder FA0(A[0], B[0], Cin, S[0], C1);
    FullAdder FA1(A[1], B[1], C1, S[1], C2);
    FullAdder FA2(A[2], B[2], C2, S[2], C3);
    FullAdder FA3(A[3], B[3], C3, S[3], C4);
    FullAdder FA4(A[4], B[4], C4, S[4], C5);
    FullAdder FA5(A[5], B[5], C5, S[5], C6);
    FullAdder FA6(A[6], B[6], C6, S[6], C7);
    FullAdder FA7(A[7], B[7], C7, S[7], Cout);
    
endmodule

module FullAdder(
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
