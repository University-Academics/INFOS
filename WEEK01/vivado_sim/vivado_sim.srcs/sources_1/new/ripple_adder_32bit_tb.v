`timescale 1ns / 1ps

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
