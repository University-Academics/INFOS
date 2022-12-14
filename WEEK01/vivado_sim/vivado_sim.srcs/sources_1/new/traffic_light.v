module Traffic_Light(
    output reg R1,R2,R3,R4,R5,R6,R7,R8,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,G1,G2,G3,G4,G5,G6,G7,G8
    );
    
reg [9:0] counter;
reg clk;

always
begin //clk defined
    #10 clk = !clk;
end

always@(posedge clk)
begin

if (0 < counter || counter == 0 || counter < (2**10/4)*58/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 0; R4 <= 0; R5 <= 0; R6 <= 0; R7 <= 0; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 1; G4 <= 1; G5 <= 1; G6 <= 1; G7 <= 1; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if ((2**10/4)*58/64 - 1 < counter || counter < (2**10/4)*60/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 0; R4 <= 0; R5 <= 0; R6 <= 0; R7 <= 0; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 1; Y4 <= 1; Y5 <= 1; Y6 <= 1; Y7 <= 1; Y8 <= 0;
end

if ((2**10/4)*60/64 - 1 < counter || counter < (2**10/4)*62/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 1; R5 <= 1; R6 <= 1; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if ((2**10/4)*62/64 - 1 < counter || counter < (2**10/4)*64/64)
begin
    R1 <= 1; R2 <= 0; R3 <= 0; R4 <= 0; R5 <= 1; R6 <= 1; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 1; Y3 <= 1; Y4 <= 1; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end


if (2**10/4 - 1 < counter || counter < 2**10/4 + (2**10/4)*58/64)
begin
    R1 <= 1; R2 <= 0; R3 <= 0; R4 <= 0; R5 <= 1; R6 <= 1; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 1; G3 <= 1; G4 <= 1; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if (2**10/4 + (2**10/4)*58/64 - 1 < counter || counter < 2**10/4 + (2**10/4)*60/64)
begin
    R1 <= 1; R2 <= 0; R3 <= 0; R4 <= 0; R5 <= 1; R6 <= 1; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 1; Y3 <= 1; Y4 <= 1; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if (2**10/4 + (2**10/4)*60/64 - 1 < counter || counter < 2**10/4 + (2**10/4)*62/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 1; R5 <= 1; R6 <= 1; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if (2**10/4 + (2**10/4)*62/64 - 1 < counter || counter < 2**10/4 + (2**10/4)*64/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 0; R5 <= 0; R6 <= 0; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 1; Y5 <= 1; Y6 <= 1; Y7 <= 0; Y8 <= 0;
end


if ((2**10/4)*2/4 - 1 < counter || counter < (2**10/4)*2/4 + (2**10/4)*58/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 0; R5 <= 0; R6 <= 0; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 1; G5 <= 1; G6 <= 1; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if ((2**10/4)*2/4 + (2**10/4)*58/64 - 1 < counter || counter < (2**10/4)*2/4 + (2**10/4)*60/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 0; R5 <= 0; R6 <= 0; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 1; Y5 <= 1; Y6 <= 1; Y7 <= 0; Y8 <= 0;
end

if ((2**10/4)*2/4 + (2**10/4)*60/64 - 1 < counter || counter < (2**10/4)*2/4 + (2**10/4)*62/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 1; R5 <= 1; R6 <= 1; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if ((2**10/4)*2/4 + (2**10/4)*62/64 - 1 < counter || counter < (2**10/4)*2/4 + (2**10/4)*64/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 1; R5 <= 1; R6 <= 0; R7 <= 0; R8 <= 0;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 1; Y7 <= 1; Y8 <= 1;
end


if ((2**10/4)*3/4 - 1 < counter || counter < (2**10/4)*3/4 + (2**10/4)*58/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 1; R5 <= 1; R6 <= 0; R7 <= 0; R8 <= 0;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 1; G7 <= 1; G8 <= 1;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if ((2**10/4)*3/4 + (2**10/4)*58/64 - 1 < counter || counter < (2**10/4)*3/4 + (2**10/4)*60/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 1; R5 <= 1; R6 <= 0; R7 <= 0; R8 <= 0;    
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 1; Y7 <= 1; Y8 <= 1;
end

if ((2**10/4)*3/4 + (2**10/4)*60/64 - 1 < counter || counter < (2**10/4)*3/4 + (2**10/4)*62/64)
begin
    R1 <= 1; R2 <= 1; R3 <= 1; R4 <= 1; R5 <= 1; R6 <= 1; R7 <= 1; R8 <= 1;
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 0; Y2 <= 0; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 0;
end

if ((2**10/4)*3/4 + (2**10/4)*62/64 - 1 < counter || counter < (2**10/4)*3/4 + (2**10/4)*64/64)
begin
    R1 <= 0; R2 <= 0; R3 <= 1; R4 <= 1; R5 <= 1; R6 <= 1; R7 <= 1; R8 <= 0;    
    G1 <= 0; G2 <= 0; G3 <= 0; G4 <= 0; G5 <= 0; G6 <= 0; G7 <= 0; G8 <= 0;
    Y1 <= 1; Y2 <= 1; Y3 <= 0; Y4 <= 0; Y5 <= 0; Y6 <= 0; Y7 <= 0; Y8 <= 1;
end


end

endmodule  
