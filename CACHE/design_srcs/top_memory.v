module top_memory#(
    parameter WORD_SIZE = 32,
    parameter CPU_ADDR_SIZE = 32
)(
    input clk,
    input [CPU_ADDR_SIZE-1:0]   cpu_addr,
    input [WORD_SIZE-1:0]       cpu_data_out,
    input [1:0]                 byte_selection,
    input                       cpu_wr_re,

    output [WORD_SIZE-1:0]      cpu_data_in,
    output                      cpu_ready,
    output                      cpu_wait
);

parameter   LINE_SIZE       = 128,
            MEM_ADDR_SIZE   = 14;

wire [LINE_SIZE-1:0]        mem_data_out;
wire [LINE_SIZE-1:0]        mem_data_in;
wire [MEM_ADDR_SIZE-1:0]    mem_addr;
wire                        mem_wren;


 cache_memory cache(
 .clk(clk),
 .cpu_addr(cpu_addr),
 .cpu_data_out(cpu_data_out),
 .byte_selection(byte_selection),
 .cpu_wr_re(cpu_wr_re),
 .mem_data_out(mem_data_out),
 .mem_wren(mem_wren),
 .mem_data_in(mem_data_in),
 .mem_addr(mem_addr),
 .cpu_data_in(cpu_data_in),
 .cpu_ready(cpu_ready),
 .cpu_wait(cpu_wait)
 );

 main_memory dataMem(
 .address(mem_addr),
 .clock(clk),
 .data(mem_data_in),
 .wren(mem_wren),
 .q(mem_data_out)
 );



endmodule