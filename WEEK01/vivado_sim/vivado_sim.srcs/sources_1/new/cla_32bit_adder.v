`timescale 1ns / 1ps

module Bit32CarryLookAheadAdder(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] S,
    output Cout
    );
    wire [3:0] GP, GG, C;
    GroupCarryLookAheadGenerator GCLAG(GP, GG, Cin, C);
    CarryLookAheadAdder CLA0(A[7:0], B[7:0], Cin, S[7:0], GP[0], GG[0]);
    CarryLookAheadAdder CLA1(A[15:8], B[15:8], C[0], S[15:8], GP[1], GG[1]);
    CarryLookAheadAdder CLA2(A[23:16], B[23:16], C[1], S[23:16], GP[2], GG[2]);
    CarryLookAheadAdder CLA3(A[31:24], B[31:24], C[2], S[31:24], GP[3], GG[3]);
   
    assign Cout = C[3];
endmodule

module GroupCarryLookAheadGenerator(
    input [3:0] GP,
    input [3:0] GG,
    input Cin,
    output [3:0]C
    );
    
    assign C[0] = GG[0] | (GP[0] & Cin);
    assign C[1] = GG[1] | (GP[1] & GG[0]) | (GP[1] & GP[0] & Cin);
    assign C[2] = GG[2] | (GP[2] & GG[1]) | (GP[2] & GP[1] & GG[0]) | (GP[2] & GP[1] & GP[0] & Cin);
    assign C[3] = GG[3] | (GP[3] & GG[2]) | (GP[3] & GP[2] & GG[1]) | (GP[3] & GP[2] & GP[1] & GG[0]) | (GP[3] & GP[2] & GP[1] & GP[0] & Cin);
endmodule



module CarryLookAheadAdder(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output GP,
    output GG
    );
    wire [7:0] P, G, C;
    FullBitAdder FA0(A[0], B[0], Cin, S[0], P[0], G[0]);
    FullBitAdder FA1(A[1], B[1], C[0], S[1], P[1], G[1]);
    FullBitAdder FA2(A[2], B[2], C[1], S[2], P[2], G[2]);
    FullBitAdder FA3(A[3], B[3], C[2], S[3], P[3], G[3]);
    FullBitAdder FA4(A[4], B[4], C[3], S[4], P[4], G[4]);
    FullBitAdder FA5(A[5], B[5], C[4], S[5], P[5], G[5]);
    FullBitAdder FA6(A[6], B[6], C[5], S[6], P[6], G[6]);
    FullBitAdder FA7(A[7], B[7], C[6], S[7], P[7], G[7]);
    CarryLockAheadGenerator CLAG(Cin, P, G, C);
    
    assign GP = P[0]&P[1]&P[2]&P[3]&P[4]&P[5]&P[6]&P[7];
    assign GG = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) |
      (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]);
    
endmodule



module CarryLockAheadGenerator(
    input Cin,
    input [7:0]P,
    input [7:0]G,
    output [7:0]C
    );
    
    assign C[0] = G[0] | (P[0] & Cin);
    assign C[1] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & Cin);
    assign C[2] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & Cin);
    assign C[3] = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & Cin);
    assign C[4] = G[4] | (P[4] & G[3]) | (P[4] & P[3] & G[2]) | (P[4] & P[3] & P[2] & G[1]) | (P[4] & P[3] & P[2] & P[1] & G[0]) |
        (P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign C[5] = G[5] | (P[5] & G[4]) | (P[5] & P[4] & G[3]) | (P[5] & P[4] & P[3] & G[2]) | (P[5] & P[4] & P[3] & P[2] & G[1]) |
        (P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign C[6] = G[6] | (P[6] & G[5]) | (P[6] & P[5] & G[4]) | (P[6] & P[5] & P[4] & G[3]) | (P[6] & P[5] & P[4] & P[3] & G[2]) |
        (P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0]) | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);
    assign C[7] = G[7] | (P[7] & G[6]) | (P[7] & P[6] & G[5]) | (P[7] & P[6] & P[5] & G[4]) | (P[7] & P[6] & P[5] & P[4] & G[3]) |
        (P[7] & P[6] & P[5] & P[4] & P[3] & G[2]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1]) | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0])
        | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & Cin);

endmodule




module FullBitAdder(
    input A,
    input B,
    input Cin,
    output S,
    output P,
    output G
    );
    
    assign P = A ^ B;
    assign G = A & B;
    assign S = P ^ Cin;
endmodule
