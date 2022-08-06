`timescale 1ns / 1ps

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