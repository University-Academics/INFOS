module main_memory (
	address,
	clock,
	data,
	wren,
	q);

	input		[13:0]  address;
	input	  			clock;
	input		[127:0] data;
	input	  			wren;
	output reg	[127:0] q;

	// MEMORY DEFINITION
	reg [127:0] mem [0:16383];
	

	always @(posedge clock)begin
		if(wren)begin
			mem[address]<=data;
		end
		q <= mem[address];
	end
	
	
endmodule

