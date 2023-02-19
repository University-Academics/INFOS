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
    parameter   MEMORY_ADDR_SIZE    =  14,
    parameter   MEMORY_DELAY_CYCLES =   5           // SHOULD BE GREATER THAN 3
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
    output reg  [MEMORY_ADDR_SIZE-1:0]      mem_addr,
    output reg  [WORD_SIZE-1:0]             cpu_data_in,
    output reg                              cpu_ready,
    output reg                              cpu_wait
);


// DEFINING STATES
parameter   IDLE                = 'd00,             
            CACHE_WRITE         = 'd01,             // UPDATING CACHE HIT, VICTIM HIT STATES
            CACHE_ALLOCATE      = 'd02,             // MEMORY -> CACHE -> VICTIM
            VICTIM_EXCHANGE     = 'd03,             // CACHE <-> VICTIM
            WRITE_BACK          = 'd04;             // VICTIM -> MEMORY



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
reg     [LINE_SIZE-1:0]                     cac                 [0:CACHE_DEPTH-1];
reg     [CACHE_TAG_SIZE-1:0]                cac_tag             [0:CACHE_DEPTH-1];
reg                                         cac_valid           [0:CACHE_DEPTH-1];
reg                                         cac_dirty           [0:CACHE_DEPTH-1];
reg     [LINE_SIZE-1:0]                     vic                 [0:VICTIM_DEPTH-1];
reg     [VICTIM_TAG_SIZE-1:0]               vic_tag             [0:VICTIM_DEPTH-1];
reg                                         vic_valid           [0:VICTIM_DEPTH-1];
reg                                         vic_dirty           [0:VICTIM_DEPTH-1];
reg     [1:0]                               vic_NMRU            [0:VICTIM_DEPTH-1];

// STORING DATA AND ADDRESS INORDER FOR CPU TO PROCEED WITH WRITE INSTRUCTION
reg     [MEMORY_ADDR_SIZE-1:0]              mem_addr_to_store;
reg     [WORD_SIZE-1:0]                     data_to_store;
reg     [1:0]                               type_to_store;
reg     [CACHE_INDEX_SIZE-1:0]              index_to_store;
reg     [3:0]                               offset_to_store;
reg     [CACHE_TAG_SIZE-1:0]                tag_to_store;

// SPECIAL PURPOSE REGISTERS
reg     [2:0]                               cache_state;
reg     [2:0]                               victim_line;
reg     [3:0]                               vic_hit_index,
                                            cle_find_index,
                                            rand_choice_index;
reg                                         selected;
reg                                         line_sel_req;
reg     [1:0]                               randomizer_acc;
reg     [2:0]                               mem_delay_acc;
reg                                         wr_re_todo;



// WIRES IN THE MIDDLE
wire    [3:0]                       cache_offset;
wire    [CACHE_INDEX_SIZE-1:0]      cache_index;
wire    [CACHE_TAG_SIZE-1:0]        cache_tag;
wire    [VICTIM_TAG_SIZE-1:0]       victim_tag;
wire    [1:0]                       randomizer_weight;


assign cache_offset         = cpu_addr[3:0];
assign cache_index          = cpu_addr[CACHE_INDEX_SIZE+3:4];
assign cache_tag            = cpu_addr[CACHE_TAG_SIZE+CACHE_INDEX_SIZE+3:CACHE_INDEX_SIZE+4];
assign victim_tag           = {cache_tag,cache_index};
assign randomizer_weight    = cpu_addr[3:2];                                                        // USING WORD ADDRESS FROM CPU REQUEST TO RANDOMIZE THE VICTIM LINE SELECTION

// HANDLING THE VALID BIT (THE WHOLE TASK OF INDICATING THE DATA IS READY IS LEFT TO THE LOGIC THAT PUTS THE TAG)
always@(*)begin
    if (cac_tag[cache_index]==cache_tag && cac_valid[cache_index])
        cpu_ready = 1'b1;
    else
        cpu_ready = 1'b0;
end

// VICTIM LINE SELECTION PART: IF VICTIM HIT CHOOSE THAT LINE --> DIRTYLESS NMRU LINE --> RANDOM LINE FROM AVAILABLE ONES
always@(*)begin
    if (line_sel_req)begin
        selected = 0;
        randomizer_acc = 0;

        // CHECKING WHETHER THE SAME TAG IS AVAILABLE SOMEWHERE
        for (vic_hit_index = 0;vic_hit_index < VICTIM_DEPTH;vic_hit_index = vic_hit_index + 1)
            if (vic_tag[vic_hit_index[2:0]] == victim_tag)begin
                victim_line = vic_hit_index[2:0];
                selected = 1;
            end

        // SEARCHING FOR DIRTY LESS LINES
        for (cle_find_index = 0;cle_find_index<VICTIM_DEPTH;cle_find_index = cle_find_index + 1)
            if (vic_NMRU[cle_find_index[2:0]]==0 && ~vic_dirty[cle_find_index[2:0]] && ~selected)begin
                victim_line = cle_find_index[2:0];
                selected = 1;
            end
        
        // RANDOMLY CHOOSE A LINE FROM AVAILABLE ONES
        for (rand_choice_index = 0;rand_choice_index<VICTIM_DEPTH;rand_choice_index = rand_choice_index + 1)
            if(vic_NMRU[rand_choice_index[2:0]]==0 && ~selected)begin
                if(randomizer_acc == randomizer_weight)begin
                    victim_line = rand_choice_index[2:0];
                    selected =1;
                end
                else randomizer_acc= randomizer_acc + 1;
            end
    end
end


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
            default:    ;
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
            default:    ;
            endcase
        end
        2'b11: // FULL WORD
        begin
            case(cache_offset)
            4'b0000:    cpu_data_in = cac[cache_index][31:0];
            4'b0100:    cpu_data_in = cac[cache_index][63:32];
            4'b1000:    cpu_data_in = cac[cache_index][95:64];
            4'b1100:    cpu_data_in = cac[cache_index][127:96];
            default:    ;
            endcase
        end
        default:;
    endcase
end

// INTEGERS USED FOR INITIALIZATION OF CACHE MEMORY CONTENTS
integer cac_init_var,vic_init_var;

//----------------------------------------------------------------------------------------------------//
// INITIALIZING THE BLOCKS AS REQUIRED
initial begin
    for(cac_init_var=0;cac_init_var<CACHE_DEPTH;cac_init_var=cac_init_var+1)begin
        cac[cac_init_var] = 0;
        cac_tag[cac_init_var] = 0;
        cac_valid[cac_init_var] = 0;
        cac_dirty[cac_init_var] = 0;
    end
    for (vic_init_var=0;vic_init_var<VICTIM_DEPTH;vic_init_var=vic_init_var+1)begin
        vic[vic_init_var] = 0;
        vic_tag[vic_init_var] = 0;
        vic_valid[vic_init_var] = 0;
        vic_dirty[vic_init_var] = 0;
    end

    // RANDOM INITIALIZATION TO START THE GAME
    vic_NMRU [0] = 2'b00;
    vic_NMRU [1] = 2'b00;
    vic_NMRU [2] = 2'b00;
    vic_NMRU [3] = 2'b00;
    vic_NMRU [4] = 2'b00;
    vic_NMRU [5] = 2'b00;
    vic_NMRU [6] = 2'b00;
    vic_NMRU [7] = 2'b00;


    cache_state     = IDLE;
    line_sel_req    = 1'b1;
    cpu_wait        = 1'b0;

end

//---------------------------------------------- CORE PART OF THE CODE: START ------------------------------------------------------//
// VARIABLE FOR UPDATING VICTIM NMRU
integer victim_nmru_update_var;
// DEFINING THE TASKS OF EACH STATES
always @(posedge clk)
begin
    case(cache_state)
    IDLE:begin

        // ALWAYS STORE THE WRITING DATA INORDER FOR MEMORY TO ALLOW WRITING PROPERLY
        data_to_store       <=  cpu_data_out;
        type_to_store       <=  byte_selection;
        index_to_store      <=  cache_index;
        offset_to_store     <=  cache_offset;
        mem_addr_to_store   <=  victim_tag;
        tag_to_store        <=  cache_tag;
        wr_re_todo <= cpu_wr_re;

        // VALID MEMORY OPERATION
        if (byte_selection != 2'b00)begin

            // CACHE HIT AND WRITE INSTRUCTION
            if (cpu_ready && cpu_wr_re)begin
                cache_state <= CACHE_WRITE;
                line_sel_req <= 1'b0;
                cpu_wait <= 1'b1;
            end

            // CACHE HIT AND READ INSTRUCTION
            if (cpu_ready && ~cpu_wr_re)begin
                cache_state     <= IDLE;
                line_sel_req    <= 1'b1;
                cpu_wait        <= 1'b0;
            end

            // VICTIM HIT
            else if(vic_tag[victim_line]==victim_tag && vic_valid[victim_line])begin
                cache_state <= VICTIM_EXCHANGE;
                line_sel_req <= 0;
                cpu_wait <= 1;
            end

            // VICTIM NOT DIRTY OR VICTIM NOT VALID
            else if (~vic_dirty[victim_line] || ~vic_valid[victim_line])begin
                cache_state <= CACHE_ALLOCATE;
                line_sel_req <= 1'b0;
                cpu_wait <= 1'b1;
                mem_delay_acc <= 3'b000;
            end

            // VICTIM VALID AND DIRTY
            else begin
                cache_state <=  WRITE_BACK;
                line_sel_req <= 1'b0;
                cpu_wait <= 1'b1;
                mem_delay_acc <= 3'b000;
            end

        end

        // ENSURING PROPER LOGIC ASSIGNMENT IN IDLE STATE
        else begin
            line_sel_req    <= 1'b1;
            cpu_wait        <= 1'b0;
        end
        
        // ENSURING NO OTHER OPERATIONS ARE HAPPENING
        mem_wren <= 1'b0;


    end

    // CACHE HIT AND WRITE OPERATION
    CACHE_WRITE:begin
        case(type_to_store)
            2'b00:begin
                // Invalid so direct it to case IDLE
                cache_state <= IDLE;
                cpu_wait <= 0;
                line_sel_req <= 1;
            end
           2'b01: // BYTE OPERATION 
           begin
            case(offset_to_store)
            4'b0000:    cac[index_to_store][7:0]    <=  data_to_store[7:0];
            4'b0001:    cac[index_to_store][15:8]   <=  data_to_store[7:0];
            4'b0010:    cac[index_to_store][23:16]  <=  data_to_store[7:0];
            4'b0011:    cac[index_to_store][31:24]  <=  data_to_store[7:0];
            4'b0100:    cac[index_to_store][39:32]  <=  data_to_store[7:0];
            4'b0101:    cac[index_to_store][47:40]  <=  data_to_store[7:0];
            4'b0110:    cac[index_to_store][55:48]  <=  data_to_store[7:0];
            4'b0111:    cac[index_to_store][63:56]  <=  data_to_store[7:0];
            4'b1000:    cac[index_to_store][71:64]  <=  data_to_store[7:0];
            4'b1001:    cac[index_to_store][79:72]  <=  data_to_store[7:0];
            4'b1010:    cac[index_to_store][87:80]  <=  data_to_store[7:0];
            4'b1011:    cac[index_to_store][95:88]  <=  data_to_store[7:0];
            4'b1100:    cac[index_to_store][103:96] <=  data_to_store[7:0];
            4'b1101:    cac[index_to_store][111:104]<=  data_to_store[7:0];
            4'b1110:    cac[index_to_store][119:112]<=  data_to_store[7:0];
            4'b1111:    cac[index_to_store][127:120]<=  data_to_store[7:0];
            default:;
            endcase
            cac_dirty[index_to_store] <= 1'b1;
        end
        2'b10: // HALF WORD
        begin
            case(cache_offset)
            4'b0000:    cac[index_to_store][15:0]   <=  data_to_store[15:0];
            4'b0010:    cac[index_to_store][31:16]  <=  data_to_store[15:0];
            4'b0100:    cac[index_to_store][47:32]  <=  data_to_store[15:0];
            4'b0110:    cac[index_to_store][63:48]  <=  data_to_store[15:0];
            4'b1000:    cac[index_to_store][79:64]  <=  data_to_store[15:0];
            4'b1010:    cac[index_to_store][95:80]  <=  data_to_store[15:0];
            4'b1100:    cac[index_to_store][111:96] <=  data_to_store[15:0];
            4'b1110:    cac[index_to_store][127:112]<=  data_to_store[15:0];
            default:;
            endcase
            cac_dirty[index_to_store] <= 1'b1;
        end
        2'b11: // FULL WORD
        begin
            case(cache_offset)
            4'b0000:    cac[index_to_store][31:0]   <=  data_to_store;
            4'b0100:    cac[index_to_store][63:32]  <=  data_to_store;
            4'b1000:    cac[index_to_store][95:64]  <=  data_to_store;
            4'b1100:    cac[index_to_store][127:96] <=  data_to_store;
            default:;
            endcase
            cac_dirty[index_to_store] <= 1'b1;
        end
        endcase
        cache_state <= IDLE;
        line_sel_req <= 1'b1;
        cpu_wait <= 1'b0;
    end

    // MEMORY -> CACHE -> VICTIM
    CACHE_ALLOCATE:begin

        if(mem_delay_acc == MEMORY_DELAY_CYCLES - 3)begin
            mem_delay_acc <= mem_delay_acc + 1;
            mem_addr <= mem_addr_to_store;
            // CACHE DATA VALID: CACHE -->  VICTIM
            if (cac_valid[index_to_store])begin
                vic[victim_line]        <= cac[index_to_store];
                vic_dirty[victim_line]  <= cac_dirty[index_to_store];
                vic_tag[victim_line]    <= {cac_tag[index_to_store],index_to_store};
                vic_valid[victim_line]  <= 1'b1;

                // UPDATING VICTIM NMRU
                for(victim_nmru_update_var = 0;victim_nmru_update_var<VICTIM_DEPTH;victim_nmru_update_var = victim_nmru_update_var +1)begin
                    if(victim_nmru_update_var[2:0] == victim_line)
                        vic_NMRU[victim_line] <= 2'b11;
                    else if(vic_NMRU[victim_nmru_update_var[2:0]]!= 2'b00) 
                        vic_NMRU[victim_nmru_update_var[2:0]] <= vic_NMRU[victim_nmru_update_var[2:0]] - 1;
                end
            end
        end

        if(mem_delay_acc == MEMORY_DELAY_CYCLES - 2)begin

            // WRITE INSTRUCTION
            if (wr_re_todo)begin
                case(type_to_store)
                    2'b00: // INVALID
                    begin
                        // some thing went wrong
                        cache_state <= IDLE;
                        cpu_wait <= 1'b0;
                        line_sel_req <= 1'b1;
                    end
                    2'b01: // BYTE OPERATION
                    begin
                        case(offset_to_store)
                        4'b0000:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:8],data_to_store[7:0]};
                        4'b0001:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:16],data_to_store[7:0],mem_data_out[7:0]};
                        4'b0010:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:24],data_to_store[7:0],mem_data_out[15:0]};
                        4'b0011:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:32],data_to_store[7:0],mem_data_out[23:0]};
                        4'b0100:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:40],data_to_store[7:0],mem_data_out[31:0]};
                        4'b0101:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:48],data_to_store[7:0],mem_data_out[39:0]};
                        4'b0110:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:56],data_to_store[7:0],mem_data_out[47:0]};
                        4'b0111:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:64],data_to_store[7:0],mem_data_out[55:0]};
                        4'b1000:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:72],data_to_store[7:0],mem_data_out[63:0]};
                        4'b1001:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:80],data_to_store[7:0],mem_data_out[71:0]};
                        4'b1010:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:88],data_to_store[7:0],mem_data_out[79:0]};
                        4'b1011:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:96],data_to_store[7:0],mem_data_out[87:0]};
                        4'b1100:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:104],data_to_store[7:0],mem_data_out[95:0]};
                        4'b1101:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:112],data_to_store[7:0],mem_data_out[103:0]};
                        4'b1110:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:120],cpu_data_out[7:0],mem_data_out[111:0]};
                        4'b1111:    cac[index_to_store] <=   {data_to_store[7:0],mem_data_out[119:0]};
                        default:;
                        endcase
                        cac_dirty[index_to_store]  <= 1'b1;
                    end
                    2'b10: // HALF WORD
                    begin
                        case(offset_to_store)
                        4'b0000:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:16],data_to_store[15:0]};
                        4'b0010:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:32],data_to_store[15:0],mem_data_out[15:0]};
                        4'b0100:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:48],data_to_store[15:0],mem_data_out[31:0]};
                        4'b0110:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:64],data_to_store[15:0],mem_data_out[47:0]};
                        4'b1000:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:80],data_to_store[15:0],mem_data_out[63:0]};
                        4'b1010:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:96],data_to_store[15:0],mem_data_out[79:0]};
                        4'b1100:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:112],data_to_store[15:0],mem_data_out[95:0]};
                        4'b1110:    cac[index_to_store] <=   {data_to_store[15:0],mem_data_out[111:0]};
                        default:;
                        endcase
                        cac_dirty[index_to_store]  <= 1'b1;
                    end
                    2'b11: // FULL WORD
                    begin
                        case(offset_to_store)
                        4'b0000:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:32],data_to_store};
                        4'b0100:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:64],data_to_store,mem_data_out[31:0]};
                        4'b1000:    cac[index_to_store] <=   {mem_data_out[LINE_SIZE-1:96],data_to_store,mem_data_out[63:0]};
                        4'b1100:    cac[index_to_store] <=   {data_to_store,mem_data_out[95:0]};
                        default:;
                        endcase
                        cac_dirty[index_to_store]  <= 1'b1;
                    end
                endcase
            end

            // READ INSTRUCTION
            else begin
                cac_dirty[index_to_store]      <= 1'b0;
                cac[index_to_store]            <= mem_data_out;
            end

            mem_delay_acc <= mem_delay_acc + 1;

        end else if(mem_delay_acc == MEMORY_DELAY_CYCLES-1 ) begin
            cac_valid[index_to_store]  <= 1'b1;
            cache_state     <= IDLE;
            line_sel_req    <= 1'b1;
            cpu_wait        <= 1'b0;
            cac_tag[index_to_store]  <= tag_to_store;
            mem_delay_acc <= 3'b000;
        end

        // HANDLING EXCEPTION
        else if(mem_delay_acc >= MEMORY_DELAY_CYCLES)begin
            mem_delay_acc <= 3'b000;
        end
        else begin
            mem_delay_acc <= mem_delay_acc + 1;
        end
    end

    // VICTIM <-> CACHE
    VICTIM_EXCHANGE:begin
        
        // WRITE INSTRUCTION
        if(wr_re_todo)begin
            case(type_to_store)
                2'b00: // INVALID
                begin
                    cache_state     <= IDLE;
                    line_sel_req    <= 1'b1;
                    cpu_wait        <= 1'b0;
                end
                2'b01: // BYTE OPERATION
                begin
                    case(offset_to_store)
                    4'b0000:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:8],data_to_store[7:0]};
                    4'b0001:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:16],data_to_store[7:0],vic[victim_line][7:0]};
                    4'b0010:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:24],data_to_store[7:0],vic[victim_line][15:0]};
                    4'b0011:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:32],data_to_store[7:0],vic[victim_line][23:0]};
                    4'b0100:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:40],data_to_store[7:0],vic[victim_line][31:0]};
                    4'b0101:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:48],data_to_store[7:0],vic[victim_line][39:0]};
                    4'b0110:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:56],data_to_store[7:0],vic[victim_line][47:0]};
                    4'b0111:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:64],data_to_store[7:0],vic[victim_line][55:0]};
                    4'b1000:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:72],data_to_store[7:0],vic[victim_line][63:0]};
                    4'b1001:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:80],data_to_store[7:0],vic[victim_line][71:0]};
                    4'b1010:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:88],data_to_store[7:0],vic[victim_line][79:0]};
                    4'b1011:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:96],data_to_store[7:0],vic[victim_line][87:0]};
                    4'b1100:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:104],data_to_store[7:0],vic[victim_line][95:0]};
                    4'b1101:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:112],data_to_store[7:0],vic[victim_line][103:0]};
                    4'b1110:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:120],data_to_store[7:0],vic[victim_line][111:0]};
                    4'b1111:    cac[index_to_store] <=   {data_to_store[7:0],vic[victim_line][119:0]};
                    endcase
                    cac_dirty[index_to_store]  <= 1'b1;
                end
                2'b10: // HALF WORD
                begin
                    case(offset_to_store)
                    4'b0000:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:16],data_to_store[15:0]};
                    4'b0010:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:32],data_to_store[15:0],vic[victim_line][15:0]};
                    4'b0100:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:48],data_to_store[15:0],vic[victim_line][31:0]};
                    4'b0110:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:64],data_to_store[15:0],vic[victim_line][47:0]};
                    4'b1000:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:80],data_to_store[15:0],vic[victim_line][63:0]};
                    4'b1010:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:96],data_to_store[15:0],vic[victim_line][79:0]};
                    4'b1100:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:112],data_to_store[15:0],vic[victim_line][95:0]};
                    4'b1110:    cac[index_to_store] <=   {data_to_store[15:0],vic[victim_line][111:0]};
                    default:;
                    endcase
                    cac_dirty[index_to_store]  <= 1'b1;
                end
                2'b11: // FULL WORD
                begin
                    case(offset_to_store)
                    4'b0000:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:32],data_to_store};
                    4'b0100:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:64],data_to_store,vic[victim_line][31:0]};
                    4'b1000:    cac[index_to_store] <=   {vic[victim_line][LINE_SIZE-1:96],data_to_store,vic[victim_line][63:0]};
                    4'b1100:    cac[index_to_store] <=   {data_to_store,vic[victim_line][95:0]};
                    default:;
                    endcase
                    cac_dirty[index_to_store]  <= 1'b1;
                end
            endcase
        end


        // READ INSTRUCTION
        else begin
            cac[cache_index]        <= vic[victim_line];
            cac_dirty[cache_index]  <= vic_dirty[victim_line];
        end
        cac_tag[index_to_store]     <= vic_tag[victim_line][CACHE_INDEX_SIZE+CACHE_TAG_SIZE-1:CACHE_INDEX_SIZE]; 
        cac_valid[index_to_store]      <= vic_valid[victim_line];

        // CACHE --> VICTIM
        vic_tag[victim_line]    <=  {cac_tag[index_to_store],index_to_store};
        vic[victim_line]        <= cac[index_to_store];
        vic_dirty[victim_line]  <= cac_dirty[index_to_store];
        vic_valid[victim_line]  <= cac_valid[index_to_store];

        // UPDATING VICTIM NMRU
        for(victim_nmru_update_var = 0;victim_nmru_update_var<VICTIM_DEPTH;victim_nmru_update_var = victim_nmru_update_var +1)begin
            if(victim_nmru_update_var[2:0] == victim_line)
                vic_NMRU[victim_line] <= 2'b11;
            else if(vic_NMRU[victim_nmru_update_var[2:0]] != 2'b00) 
                vic_NMRU[victim_nmru_update_var[2:0]] <= vic_NMRU[victim_nmru_update_var[2:0]] - 1;
        end

        cache_state     <= IDLE;
        line_sel_req    <= 1'b1;
        cpu_wait        <= 1'b0;
    end

    WRITE_BACK:begin
        if(mem_delay_acc == MEMORY_DELAY_CYCLES-2)begin
            mem_addr <= vic_tag[victim_line];
            mem_data_in <= vic[victim_line];
            mem_wren <= 1;
            vic_dirty[victim_line] <= 0;
            mem_delay_acc <= mem_delay_acc + 1;
        end
        else if(mem_delay_acc == MEMORY_DELAY_CYCLES - 1)begin
            cache_state     <= CACHE_ALLOCATE;
            mem_wren        <= 1'b0;
            mem_delay_acc   <= 3'b000;

            // ENSURING PURPOSES
            line_sel_req    <= 1'b0;
            cpu_wait        <= 1'b1;
        end
        else begin
            mem_delay_acc <= mem_delay_acc + 1;
        end
    end
    default:;
    endcase
end
//---------------------------------------------------------------- CORE PART OF THE CODE: END ----------------------------------------------------------------//
endmodule