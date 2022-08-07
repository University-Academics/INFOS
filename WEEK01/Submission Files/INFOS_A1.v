////////////////////////////// RIPPLE CARRY ADDER //////////////////////////////////////

module ripple_adder_32bit(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] S,
    output Cout
    );
    wire C8, C16, C24;
    
    Bit8RippleAdder   Bit8Adder0(A[7:0], B[7:0], Cin, S[7:0], C8);
    Bit8RippleAdder   Bit8Adder1(A[15:8], B[15:8], C8, S[15:8], C16);
    Bit8RippleAdder   Bit8Adder2(A[23:16], B[23:16], C16, S[23:16], C24);
    Bit8RippleAdder   Bit8Adder3(A[31:24], B[31:24], C24, S[31:24], Cout);
    
endmodule

module Bit8RippleAdder(
    input [7:0] A,
    input [7:0] B,
    input Cin,
    output [7:0] S,
    output Cout
    );
    wire C1, C2, C3, C4, C5, C6, C7;
    reg [7:0]valid;
    
    FullAdder   FA0(A[0], B[0], Cin, S[0], C1);
    FullAdder   FA1(A[1], B[1], C1, S[1], C2);
    FullAdder   FA2(A[2], B[2], C2, S[2], C3);
    FullAdder   FA3(A[3], B[3], C3, S[3], C4);
    FullAdder   FA4(A[4], B[4], C4, S[4], C5);
    FullAdder   FA5(A[5], B[5], C5, S[5], C6);
    FullAdder   FA6(A[6], B[6], C6, S[6], C7);
    FullAdder   FA7(A[7], B[7], C7, S[7], Cout);
    
endmodule

module FullAdder(
    input A,
    input B,
    input Cin,
    output S,
    output Cout
    );
    wire y,t1,t2;
    xor  x1(y,A,B),
           x2(S,y,Cin);
    and  a1(t1,y,Cin),
           a2(t2,A,B);
    or   o(Cout,t1,t2);
endmodule

///////////////////////////////// RIPPLE CARRY ADDER : TEST_BENCH ///////////////////////////
module ripple_adder_32bit_tb;
    // Inputs
    reg [31:0] A;
    reg [31:0] B;
    reg Cin;

    // Outputs
    wire [31:0] S;
    wire Cout;
    
    ripple_adder_32bit #64 Adder(A, B, Cin, S, Cout);
    initial begin
        $monitor($time, " A=%d, B=%d, S=%d" , A, B, S);
    // Initialize Inputs
        A = 32'h1fffaaaa;
        B = 32'hbfffaaaa;
        Cin = 0;       
        
        #64;
        A = 32'd142352352;
        B = 32'd465693463;
        Cin = 0;
     
        #64;
        A = 32'd847583573;
        B = 32'd347583488;
        Cin = 0;
        
        #64;
        A = 32'd573286762;
        B = 32'd235762376;
        Cin = 0;
        #64 $finish;
    end
endmodule

//////////////////////////////////// PIPELINED ARCHITECTURE ///////////////////////////////////
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

///////////////////////////////////// PIPELINED-ARCHITECTURE : TEST_BENCH //////////////////////
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



///////////////////////////////////// CARRY LOOK-AHEAD ADDER ///////////////////////////////////
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

////////////////////////////////////////// CARRY LOOK-AHEAD ADDER : TEST_BENCH /////////////////////////
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


///////////////////////////////////// FLOATING POINT ADD/SUB //////////////////////////////////////
module float_add_sub(clk,rst,start,X,Y,operation,valid,sum);
    input clk;
    input rst;
    input start;
    input operation;            // 0- Addition / 1- Substraction
    
    // IEEE FORMAT INPUTS AND OUTPUT
    input [31:0]X,Y;
    output [31:0]sum;
    
    // INDICATE WHEN THE OUTPUT IS OF VALID FORM
    output valid;
    
    reg X_sign,Y_sign,sum_sign, next_sum_sign;
    reg [7:0] X_exp, Y_exp, sum_exp, next_sum_exp;
    reg [23:0] X_mant, Y_mant;                      // Extracted mantissa {1, extraction}
    reg [23:0] X_mantissa, Y_mantissa;              // Normalized mantissa (equalizing exponents)
    reg [24:0] sum_mantissa, next_sum_mantissa;     // Providing space for overflow
    
    reg valid, next_valid;
    reg [8:0] expsub, abs_diff;
    reg [24:0] sum_mantissa_temp;
    reg [1:0] next_state, pres_state;
    
    // Defining States of Module
    parameter IDLE = 2'b00;
    parameter START = 2'b01;
    parameter SHIFT_MANT =2'b10;
    
    wire add_carry, sub_borrow;
    
    assign sum = {sum_sign, sum_exp, sum_mantissa[22:0]};
    assign add_carry = sum_mantissa[24]&!(X_sign^Y_sign);
    assign sub_borrow = sum_mantissa_temp[24] &(X_sign^Y_sign);
    
    always @(posedge clk or negedge rst)
    begin
        if(!rst) begin
            valid           <= 1'b0;
            pres_state      <= 2'd0;
            sum_exp         <= 8'd0;
            sum_mantissa    <= 25'd0;
            sum_sign        <= 1'b0;
        end
        else begin
            valid           <= next_valid;
            pres_state      <= next_state;
            sum_exp         <= next_sum_exp;
            sum_mantissa    <= next_sum_mantissa;
            sum_sign        <= next_sum_sign;
        end
    end
   
    always @(*)
    begin
        next_valid = 1'b0;
        
        X_sign = X[31];
        Y_sign = (operation)? ~Y[31]: Y[31];
        X_exp = X[30:23];
        Y_exp = Y[30:23];
        X_mant = {1'b1,X[22:0]};
        Y_mant = {1'b1,Y[22:0]};
        
        next_sum_sign = sum_sign;
        next_sum_exp  = 8'd0;
        next_sum_mantissa = 25'd0;
        next_state = IDLE;
        sum_mantissa_temp = 25'd0;
        
        
        case (pres_state)
            IDLE: 
            begin
                next_valid = 1'b0;
                
                X_sign = X[31];
                Y_sign = (operation)? ~Y[31]: Y[31];
                X_exp = X[30:23];
                Y_exp = Y[30:23];
                X_mant = {1'b1,X[22:0]};
                Y_mant = {1'b1,Y[22:0]};
                
                next_sum_sign = 1'b0;
                next_sum_exp  = 8'd0;
                next_sum_mantissa = 25'd0;
                next_state = (start)? START:pres_state;
                
            end
            
            START:
            begin
                expsub = X_exp - Y_exp;
                abs_diff = expsub[8]? !(expsub[7:0])+1'b1 : expsub[7:0];
                
                X_mantissa = expsub[8]? X_mant >> abs_diff : X_mant;
                Y_mantissa = expsub[8]? Y_mant : Y_mant >> abs_diff;
                
                next_sum_exp = expsub[8]? Y_exp : X_exp;
                sum_mantissa_temp = !(X_sign ^Y_sign) ? X_mantissa + Y_mantissa :               // If both numbers are of same sign add the mantissas
                                    (X_sign) ? Y_mantissa - X_mantissa :                        // If X is negative
                                    (Y_sign) ? X_mantissa - Y_mantissa : sum_mantissa;          // If Y is negative otherwise invalid
                next_sum_mantissa = sub_borrow ? ~(sum_mantissa_temp)+1'b1 : sum_mantissa_temp;
                next_sum_sign = (X_sign & Y_sign) || sub_borrow;
                next_valid = 1'b0;
                next_state = SHIFT_MANT;
            end
            
            SHIFT_MANT:
            begin
                next_sum_exp = sum_mantissa[23]? sum_exp : (add_carry)? sum_exp + 1'b1 : sum_exp - 1'b1;
                next_sum_mantissa = sum_mantissa[23] ? sum_mantissa : (add_carry)?  sum_mantissa >> 1 : sum_mantissa <<1;
                next_valid = sum_mantissa[23] ? 1'b1 : 1'b0;
                next_state = sum_mantissa [23] ? IDLE: pres_state;
            end
        endcase
    end        
endmodule

////////////////////////////////////// FLOATING POINT ADD/SUB : TEST_BENCH /////////////////////////////////
module float_add_sub_tb;

reg clk,rst,start,operation;
reg [31:0]X,Y;
wire [31:0]sum;
wire valid;

always #5 clk = ~clk;

float_add_sub inst (clk,rst,start,X,Y,operation,valid,sum);

initial
$monitor($time," X=%d, Y=%d, sum=%d, Valid =%b ",X,Y,sum,valid);

initial
begin
operation = 1'b0;
X=32'h40d80000; Y=32'hc0700000;	          //6.75,-3.75
//X=32'hc0d80000; Y=32'h40700000;	      //-6.75,3.75
//X=32'h40700000; Y=32'hc0d80000;	      //3.75,-6.75
//X=32'hc0700000; Y=32'h40d80000;	      //-3.75,6.75
clk=1'b1; rst=1'b0; start=1'b0;
#10 rst = 1'b1;
#10 start = 1'b1;
#10 start = 1'b0;
@valid
operation = 1'b1;
#10 X=32'h40d80000; Y=32'h40700000;      //6.75,3.75
//#10 X=32'hc0d80000; Y=32'hc0700000;    //-6.75,-3.75
start = 1'b1;
#10 start = 1'b0;
end      
endmodule




////////////////////////////////////////////// TRAFFIC LIGHT ///////////////////////////////////////////
module traffic_lights(
    input clk, en,
    output R1,R2,R3,R4,R5,R6,R7,R8,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,G1,G2,G3,G4,G5,G6,G7,G8
    );
    reg A, B, C, D;
    always @(posedge en) begin
        A <= 1'b0;
        B <= 1'b0;
        C <= 1'b0;
        D <= 1'b0;
    end
    
    assign R1 = B | (~A&C);
    assign R2 = B | (~A&C) | (C&~D) | (A&~C);
    assign R3 = B&D | B&C | A&~C | A&~D;
    assign R4 = A | (~B&~C) | (~C&D) + (B&C);
    assign R5 = A | (~B&~C);
    assign R6 = ~B | (~C&~D);
    assign R7 = (~A&~B) | (~A&~C&~D) | (~B&C&D);
    assign R8 = ~A | (C&D);

    assign Y1 = (A&~C&~D) + (~A&~B&~C&D);
    assign Y2 = (A&C&D) | (~A&~B&~C&D);
    assign Y3 = (B&~C&~D) | (A&C&D);
    assign Y4 = (B&~C&~D) | (~A&~B&C&~D);
    assign Y5 = (B&C&D) | (~A&~B&C&~D);
    assign Y6 = B&D;
    assign Y7 = (B&~C&D) | (A&C&~D);
    assign Y8 = A&~D;

    assign G1 = (A&D) | (A&C) + (~A&~B&~C&~D);
    assign G2 = (~A&~B&~C&~D);
    assign G3 = (~A&~B);
    assign G4 = (~A&~B&C&D);
    assign G5 = (B&~C) | (B&~D) | (~A&~B&C&D);
    assign G6 = (B&C&~D);
    assign G7 = (B&C) | (A&~C);
    assign G8 = (A&~C&D);

    always @(posedge clk) begin
        A <= (A&~B&~C) | (A&~B&~D) | (~A&B&C&D);
        B <= (~A&B&~C) | (~A&B&~D) | (~A&~B&C&D);
        C <= (~A&~C&D) | (~B&~C&D) | (~A&C&~D) | (~B&C&~D);
        D <= (~A&~D) | (~B&~D);
    end
endmodule


//////////////////////////////////////////////// TRAFFIC_LIGHT : TEST_BENCH //////////////////////////
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
