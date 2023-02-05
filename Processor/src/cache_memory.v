/*
CACHE MEMORY IMPLEMENTATION
-------------------------------------
1. INPUTS
    i  . cpu_addr       32  : Address line from cpu 
    ii . cpu_data_out   32  : Data line from CPU (CPU --> Cache)
    iii. byte_selection  2  : 00 - INVALID, 01 - Byte operation, 10 - Half Word Operation, 11 - Full-Word Operation
    iv . cpu_wr_re       1  : 0 - Read Instruction, 1 - Write Instruction
    v  . mem_data_out  128  : Data line from Memory (Memory --> Cache)
2. OUTPUTS
    i  . mem_wren        1  : Memory Write Enable Line
    ii . mem_data_in   128  : Data Line to the Memory (Cache -> Memory)
    iii. mem_addr       14  : Address to Read from Memory
    iv . cpu_data_in    32  : Data Line to the CPU (Cache -> CPU)
    v  . cpu_ready       1  : Indicating CPU that it can proceed with loading
    vi . cpu_wait        1  : Indicating CPU that it can proceed after writing Instruction
*/


module cache_memory
#(
    // Parameters Define 
    parameter   CPU_ADDR_SIZE       =  32,
    parameter   WORD_SIZE           =  32,
    parameter   LINE_SIZE           = 128,
    parameter   MEMORY_ADDR_SIZE    =  14 
)
(
    input wire                              clk,
    input wire  [CPU_ADDR_SIZE-1:0]         cpu_addr,
    input wire  [WORD_SIZE -1:0]            cpu_data_out,
    input wire  [1:0]                       byte_selection,
    input wire                              cpu_wr_re,
    input wire  [LINE_SIZE-1:0]             mem_data_out,
    output reg                              mem_wren,
    output reg  [LINE_SIZE-1:0]             mem_data_in,
    output wire [MEMORY_ADDR_SIZE-1:0]      mem_addr,
    output reg  [WORD_SIZE-1:0]             cpu_data_in,
    output reg                              cpu_ready,
    output reg                              cpu_wait
);


// DEFINING STATES
parameter   IDLE                = 'd01,             
            COMPARE_TAG         = 'd02,             // UPDATING CACHE HIT, VICTIM HIT STATES
            CACHE_ALLOCATE      = 'd03,             // MEMORY -> CACHE -> VICTIM
            VICTIM_EXCHANGE     = 'd04,             // CACHE <-> VICTIM
            WRITE_BACK          = 'd05;             // VICTIM -> MEMORY



parameter   INVALID_REQ         = 2'b00,
            BYTE_REQ            = 2'b01,
            HALF_WORD_REQ       = 2'b10,
            FULL_WORD_REQ       = 2'b11;


// PARAMETERS 
parameter   CACHE_DEPTH         = 128,
            CACHE_INDEX_SIZE    =   7,
            CACHE_TAG_SIZE      =   7,
            VICTIM_DEPTH        =   8,
            VICTIM_INDEX_SIZE   =   3,
            VICTIM_TAG_SIZE     =  14,
            OFFSET_SIZE         =   4;
            

// DEFINING THE CACHE AND VICTIM CACHE
reg     [LINE_SIZE-1:0]                     cac                 [CACHE_DEPTH-1:0];
reg     [CACHE_TAG_SIZE-1:0]                cac_tag             [CACHE_DEPTH-1:0];
reg                                         cac_valid           [CACHE_DEPTH-1:0];
reg                                         cac_dirty           [CACHE_DEPTH-1:0];
reg     [LINE_SIZE-1:0]                     vic                 [VICTIM_DEPTH-1:0];
reg     [VICTIM_TAG_SIZE-1:0]               vic_tag             [VICTIM_DEPTH-1:0];
reg                                         vic_valid           [VICTIM_DEPTH-1:0];
reg                                         vic_dirty           [VICTIM_DEPTH-1:0];
reg     [2:0]                               vic_NMRU            [VICTIM_DEPTH-1:0];

// SPECIAL PURPOSE REGISTERS
reg     [2:0]                               cache_state;
reg                                         cache_hit;
reg                                         victim_hit;
reg                                         dealloc_req;
reg                                         victim_line;

// WIRES IN THE MIDDLE
wire    [3:0]                       cache_offset;
wire    [CACHE_INDEX_SIZE-1:0]      cache_index;
wire    [CACHE_TAG_SIZE-1:0]        cache_tag;
wire    [VICTIM_TAG_SIZE-1:0]       victim_tag;

assign cache_offset         = cpu_addr[3:0];
assign cache_index          = cpu_addr[CACHE_INDEX_SIZE+3:3];
assign cache_tag            = cpu_addr[CACHE_TAG_SIZE+CACHE_INDEX_SIZE+3:CACHE_INDEX_SIZE+4];
assign victim_tag           = {cache_tag,cache_index};

// ASSINGNING THE CPU_OUT LINE
always@(*)begin
    case(byte_selection)
        2'b00: // INVALID
        begin
        end
        2'b01: // BYTE OPERATION
        begin
            case(cache_offset)
            4'b0000:    cpu_data_in[7:0] = cac[cache_index][7:0];
            4'b0001:    cpu_data_in[7:0] = cac[cache_index][15:8];
            4'b0010:    cpu_data_in[7:0] = cac[cache_index][23:16];
            4'b0011:    cpu_data_in[7:0] = cac[cache_index][31:24];
            4'b0100:    cpu_data_in[7:0] = cac[cache_index][39:32];
            4'b0101:    cpu_data_in[7:0] = cac[cache_index][47:40];
            4'b0110:    cpu_data_in[7:0] = cac[cache_index][55:48];
            4'b0111:    cpu_data_in[7:0] = cac[cache_index][63:56];
            4'b1000:    cpu_data_in[7:0] = cac[cache_index][71:64];
            4'b1001:    cpu_data_in[7:0] = cac[cache_index][79:72];
            4'b1010:    cpu_data_in[7:0] = cac[cache_index][87:80];
            4'b1011:    cpu_data_in[7:0] = cac[cache_index][95:88];
            4'b1100:    cpu_data_in[7:0] = cac[cache_index][103:96];
            4'b1101:    cpu_data_in[7:0] = cac[cache_index][111:104];
            4'b1110:    cpu_data_in[7:0] = cac[cache_index][119:112];
            4'b1111:    cpu_data_in[7:0] = cac[cache_index][127:120];
            endcase
        end
        2'b10: // HALF WORD
        begin
            case(cache_offset)
            4'b0000:    cpu_data_in[15:0] = cac[cache_index][15:0];
            4'b0010:    cpu_data_in[15:0] = cac[cache_index][31:16];
            4'b0100:    cpu_data_in[15:0] = cac[cache_index][47:32];
            4'b0110:    cpu_data_in[15:0] = cac[cache_index][63:48];
            4'b1000:    cpu_data_in[15:0] = cac[cache_index][79:64];
            4'b1010:    cpu_data_in[15:0] = cac[cache_index][95:80];
            4'b1100:    cpu_data_in[15:0] = cac[cache_index][111:96];
            4'b1110:    cpu_data_in[15:0] = cac[cache_index][127:112];
            endcase
        end
        2'b11: // FULL WORD
        begin
            case(cache_offset)
            4'b0000:    cpu_data_in = cac[cache_index][31:0];
            4'b0100:    cpu_data_in = cac[cache_index][63:32];
            4'b1000:    cpu_data_in = cac[cache_index][95:64];
            4'b1100:    cpu_data_in = cac[cache_index][127:96];
            endcase
        end
    endcase
end

// DELAYING RELATED PARAMETERS
parameter MEMORY_DELAY_CYCLE = 6;

integer i,j;

//----------------------------------------------------------------------------------------------------//
// INITIALIZING THE BLOCKS AS REQUIRED
initial begin
    for(i=0;i<CACHE_DEPTH;i=i+1)begin
        cac[i] <= 0;
        cac_tag[i] <= 0;
        cac_valid[i] <= 0;
        cac_dirty[i] <= 0;
    end
    for (j=0;j<VICTIM_DEPTH;j=j+1)begin
        vic[j] <= 0;
        vic_tag[j] <= 0;
        vic_valid[j] <= 0;
        vic_dirty[j] <= 0;
    end
    cache_state = IDLE;
end
//----------------------------------------------------------------------------------------------------//
// DEFINING THE TASKS OF EACH STATES
always @(posedge clk)
begin
    case(cache_state)
    IDLE:begin
    end

    // UPDATE STATES CACHE HIT, VICTIM HIT, VICTIM LINE SELECTION, HIT REQUEST
    COMPARE_TAG:begin

    end

    // MEMORY -> CACHE -> VICTIM
    CACHE_ALLOCATE:begin

        // CACHE DATA VALID --> BRIGING DATA INTO VICTIM
        if (cac_valid[cache_index])begin
            vic[victim_line]        <= cac[cache_index];
            vic_dirty[victim_line]  <= cac_dirty[cache_index];
            vic_tag[victim_line]    <= {cac_tag[cache_index],cache_index};
            vic_valid[victim_line]  <= 1'b1;
        end

        // WRITE INSTRUCTION
        if (cpu_wr_re)begin
            cac_dirty[cache_index]  <= 1;

            case(byte_selection)
                2'b00: // INVALID
                begin
                end
                2'b01: // BYTE OPERATION
                begin
                    case(cache_offset)
                    4'b0000:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:8],cpu_data_out[7:0]};
                    4'b0001:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:16],cpu_data_out[7:0],mem_data_out[7:0]};
                    4'b0010:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:24],cpu_data_out[7:0],mem_data_out[15:0]};
                    4'b0011:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:32],cpu_data_out[7:0],mem_data_out[23:0]};
                    4'b0100:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:40],cpu_data_out[7:0],mem_data_out[31:0]};
                    4'b0101:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:48],cpu_data_out[7:0],mem_data_out[39:0]};
                    4'b0110:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:56],cpu_data_out[7:0],mem_data_out[47:0]};
                    4'b0111:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:64],cpu_data_out[7:0],mem_data_out[55:0]};
                    4'b1000:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:72],cpu_data_out[7:0],mem_data_out[63:0]};
                    4'b1001:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:80],cpu_data_out[7:0],mem_data_out[71:0]};
                    4'b1010:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:88],cpu_data_out[7:0],mem_data_out[79:0]};
                    4'b1011:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:96],cpu_data_out[7:0],mem_data_out[87:0]};
                    4'b1100:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:104],cpu_data_out[7:0],mem_data_out[95:0]};
                    4'b1101:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:112],cpu_data_out[7:0],mem_data_out[103:0]};
                    4'b1110:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:120],cpu_data_out[7:0],mem_data_out[111:0]};
                    4'b1111:    cac[cache_index] <=   {cpu_data_out[7:0],mem_data_out[119:0]};
                    endcase
                end
                2'b10: // HALF WORD
                begin
                    case(cache_offset)
                    4'b0000:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:16],cpu_data_out[15:0]};
                    4'b0010:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:32],cpu_data_out[15:0],mem_data_out[15:0]};
                    4'b0100:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:48],cpu_data_out[15:0],mem_data_out[31:0]};
                    4'b0110:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:64],cpu_data_out[15:0],mem_data_out[47:0]};
                    4'b1000:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:80],cpu_data_out[15:0],mem_data_out[63:0]};
                    4'b1010:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:96],cpu_data_out[15:0],mem_data_out[79:0]};
                    4'b1100:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:112],cpu_data_out[15:0],mem_data_out[95:0]};
                    4'b1110:    cac[cache_index] <=   {cpu_data_out[15:0],mem_data_out[111:0]};
                    endcase
                end
                2'b11: // FULL WORD
                begin
                    case(cache_offset)
                    4'b0000:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:32],cpu_data_out};
                    4'b0100:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:64],cpu_data_out,mem_data_out[31:0]};
                    4'b1000:    cac[cache_index] <=   {mem_data_out[LINE_SIZE-1:96],cpu_data_out,mem_data_out[63:0]};
                    4'b1100:    cac[cache_index] <=   {cpu_data_out,mem_data_out[95:0]};
                    endcase
                end
            endcase
        end

        // READ INSTRUCTION
        else begin
            cac_dirty[cache_index]      <= 1'b1;
            cac[cache_index]            <= mem_data_out;
        end

        cac_tag[cache_index]    <= cache_tag;
        cac_valid[cache_index]  <= 1;
    end

    // VICTIM <-> CACHE
    VICTIM_EXCHANGE:begin
        
        // WRITE INSTRUCTION
        if(cpu_wr_re)begin
            cac_dirty[cache_index]  <= 1;
            
            case(byte_selection)
                2'b00: // INVALID
                begin
                end
                2'b01: // BYTE OPERATION
                begin
                    case(cache_offset)
                    4'b0000:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:8],cpu_data_out[7:0]};
                    4'b0001:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:16],cpu_data_out[7:0],vic[victim_line][7:0]};
                    4'b0010:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:24],cpu_data_out[7:0],vic[victim_line][15:0]};
                    4'b0011:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:32],cpu_data_out[7:0],vic[victim_line][23:0]};
                    4'b0100:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:40],cpu_data_out[7:0],vic[victim_line][31:0]};
                    4'b0101:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:48],cpu_data_out[7:0],vic[victim_line][39:0]};
                    4'b0110:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:56],cpu_data_out[7:0],vic[victim_line][47:0]};
                    4'b0111:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:64],cpu_data_out[7:0],vic[victim_line][55:0]};
                    4'b1000:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:72],cpu_data_out[7:0],vic[victim_line][63:0]};
                    4'b1001:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:80],cpu_data_out[7:0],vic[victim_line][71:0]};
                    4'b1010:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:88],cpu_data_out[7:0],vic[victim_line][79:0]};
                    4'b1011:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:96],cpu_data_out[7:0],vic[victim_line][87:0]};
                    4'b1100:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:104],cpu_data_out[7:0],vic[victim_line][95:0]};
                    4'b1101:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:112],cpu_data_out[7:0],vic[victim_line][103:0]};
                    4'b1110:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:120],cpu_data_out[7:0],vic[victim_line][111:0]};
                    4'b1111:    cac[cache_index] <=   {cpu_data_out[7:0],vic[victim_line][119:0]};
                    endcase
                end
                2'b10: // HALF WORD
                begin
                    case(cache_offset)
                    4'b0000:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:16],cpu_data_out[15:0]};
                    4'b0010:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:32],cpu_data_out[15:0],vic[victim_line][15:0]};
                    4'b0100:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:48],cpu_data_out[15:0],vic[victim_line][31:0]};
                    4'b0110:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:64],cpu_data_out[15:0],vic[victim_line][47:0]};
                    4'b1000:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:80],cpu_data_out[15:0],vic[victim_line][63:0]};
                    4'b1010:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:96],cpu_data_out[15:0],vic[victim_line][79:0]};
                    4'b1100:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:112],cpu_data_out[15:0],vic[victim_line][95:0]};
                    4'b1110:    cac[cache_index] <=   {cpu_data_out[15:0],vic[victim_line][111:0]};
                    endcase
                end
                2'b11: // FULL WORD
                begin
                    case(cache_offset)
                    4'b0000:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:32],cpu_data_out};
                    4'b0100:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:64],cpu_data_out,vic[victim_line][31:0]};
                    4'b1000:    cac[cache_index] <=   {vic[victim_line][LINE_SIZE-1:96],cpu_data_out,vic[victim_line][63:0]};
                    4'b1100:    cac[cache_index] <=   {cpu_data_out,vic[victim_line][95:0]};
                    endcase
        
                end
            endcase
        end


        // READ INSTRUCTION
        else begin
            cac[cache_index]        <= vic[victim_line];
            cac_dirty[cache_index]  <= vic_dirty[victim_line];
        end
        cac_tag[cache_index]    <= vic_tag[victim_line][CACHE_INDEX_SIZE+CACHE_TAG_SIZE-1:CACHE_INDEX_SIZE]; 
        cac_valid[cache_index]  <= vic_valid[victim_line];

        // CACHE --> VICTIM
        vic_tag[victim_line]    <=  {cac_tag[cache_index],cache_index};
        vic[victim_line]        <= cac[cache_index];
        vic_dirty[victim_line]  <= cac_dirty[cache_index];
        vic_valid[victim_line]  <= cac_valid[cache_index];
    end



    WRITE_BACK:begin
        mem_addr <= vic_tag[victim_line];
        mem_data_in <= vic[victim_line];
        mem_wren <= 1;
        vic_dirty[victim_line] <= 0b'0;

    end

    endcase
end
endmodule