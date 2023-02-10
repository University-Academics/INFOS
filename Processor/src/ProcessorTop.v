module ProcessorTop(
input clock,
input reset,
output led,
output reset_led
);

wire [24:0]  q;
wire slowClock;
wire  [31:0] io_instr;
wire  [31:0] io_memReadData;
wire         io_cpu_wait;
wire         io_cpu_ready;
wire [8:0]  io_instrAddrs;
wire [31:0] io_ALUOut;
wire [31:0] io_memWriteData;
wire        io_memWrite;
wire [1:0]  io_storeType;

  
wire [127:0] mem_data_out;
wire mem_wren;
wire [127:0] mem_data_in;
wire [13:0] mem_addr;

SlowClock counter(clock, q);
assign slowClock = q[20];
assign led = q[20];
assign reset_led = ~reset;


Core core(
.clock(slowClock),
.reset(~reset),
.io_instr(io_instr),
.io_memReadData(io_memReadData),
.io_cpu_wait(io_cpu_wait),
.io_cpu_ready(io_cpu_ready),
.io_instrAddrs(instrAddrs),
.io_ALUOut(io_ALUOut),
.io_memWriteData(io_memWriteData),
.io_memWrite(io_memWrite),
.io_storeType(io_storeType)
 );
 
 cache_memory cache(
 .clk(slowClock),
 .cpu_addr(io_ALUOut),
 .cpu_data_out(io_memWriteData),
 .byte_selection(io_storeType),
 .cpu_wr_re(io_memWrite),
 .mem_data_out(mem_data_out),
 .mem_wren(mem_wren),
 .mem_data_in(mem_data_in),
 .mem_addr(mem_addr),
 .cpu_data_in(io_memReadData),
 .cpu_ready(io_cpu_ready),
 .cpu_wait(io_cpu_wait)
 );

 main_memory dataMem(
 .address(mem_addr),
 .clock(slowClock),
 .data(mem_data_in),
 .wren(mem_wren),
 .q(mem_data_out)
 );

 InstructionMem instructionMem(
.address(instrAddrs),
.clock(clock),
.data(32'b0),
.wren(1'b0),
.q(io_instr)
 );

endmodule
