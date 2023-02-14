#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <bitset>
#include <vector>
#include "Vtop_memory.h"
#include "verilated.h"

using namespace std;

#define CACHE top_memory__DOT__cache__DOT__cac
#define CACHE_TAG top_memory__DOT__cache__DOT__cac_tag
#define CACHE_VALID top_memory__DOT__cache__DOT__cac_valid
#define CACHE_DIRTY top_memory__DOT__cache__DOT__cac_dirty
#define VICTIM top_memory__DOT__cache__DOT__vic
#define VICTIM_TAG top_memory__DOT__cache__DOT__vic_tag
#define VICTIM_VALID top_memory__DOT__cache__DOT__vic_valid
#define VICTIM_DIRTY top_memory__DOT__cache__DOT__vic_dirty
#define VICTIM_NMRU top_memory__DOT__cache__DOT__vic_NMRU
#define MAIN_MEMORY top_memory__DOT__dataMem__DOT__mem
#define CACHE_STATE top_memory__DOT__cache__DOT__cache_state

u_int64_t m_tickcount;

void tick(Vtop_memory *DUT,bool verbose = true);
void run_clocks(Vtop_memory *DUT,int n_clks=5,bool verbose = false);
void print_cache_out(Vtop_memory *DUT, bool data_alone=true);
void print_memory(Vtop_memory *DUT, int line=0);
void print_cache(Vtop_memory *DUT, int line = 0);
void print_victim(Vtop_memory *DUT, bool all_f = false, int line = 0);
void load_instruction(Vtop_memory *DUT, u_int32_t addr = 0, int byte_selection = 3);
void write_instruction(Vtop_memory *DUT, u_int32_t addr = 0, int data = 0, int byte_selection = 3);
void print_cache_state(Vtop_memory *DUT);
void tb_script(Vtop_memory *tb);

// bool write_instruction(Vtop_memory *DUT);


int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);
    Vtop_memory *DUT = new Vtop_memory;
    
    tb_script(DUT);

    delete DUT;
    exit(EXIT_SUCCESS);
    return 1;
}

void tick(Vtop_memory *DUT,bool verbose)
{
    m_tickcount++;
    if(verbose)
        cout << "CLOCK NUMBER " << bitset<8>(m_tickcount).to_string() << endl;
    DUT->eval();
    DUT->clk = 1;
    DUT->eval();
    DUT->clk = 0;
    DUT->eval();
    return;
}

void run_clocks(Vtop_memory *DUT,int n_clks, bool verbose){
    for(int i=0;i<n_clks;i++){
        tick(DUT,verbose);
    }
    return;
}

void print_cache_out(Vtop_memory *DUT, bool data_alone){
    if (!data_alone)
        cout<<endl<< "OUTPUT SIGNALS FROM MEMORY HIERARCHY..."<<endl;
    cout<<"CPU DATA IN LINE:\t"<<  bitset<32>(DUT->cpu_data_in).to_string()<<endl;
    if (!data_alone){
    cout<<"CPU READY SIGNAL:\t"<<bitset<1>(DUT-> cpu_ready).to_string()<<endl;
    cout<<"CPU WAIT:\t"<<bitset<1>(DUT-> cpu_wait).to_string()<<endl;
    }
    return;
}

void print_memory(Vtop_memory *DUT, int line)
{
    cout<< "MEMORY LINE:\t"<<line<<endl;
    cout << "DATA:\t"
         << "00: " << bitset<32>(DUT->MAIN_MEMORY[line][0]).to_string() << "\t01: " << bitset<32>(DUT->MAIN_MEMORY[line][1]).to_string() << "\t10: " << bitset<32>(DUT->MAIN_MEMORY[line][2]).to_string() << "\t11: " << bitset<32>(DUT->MAIN_MEMORY[line][3]).to_string() << endl;
    return;
}

void print_cache(Vtop_memory *DUT, int line)
{
    cout<<endl;
    cout << "CACHE LINE:\t" << line << endl;
    cout << "TAG:\t" << bitset<7>(DUT->CACHE_TAG[line]).to_string() << endl;
    cout << "DATA:\t"
         << "00: " << bitset<32>(DUT->CACHE[line][0]).to_string() << "\t01: " << bitset<32>(DUT->CACHE[line][1]).to_string() << "\t10: " << bitset<32>(DUT->CACHE[line][2]).to_string() << "\t11: " << bitset<32>(DUT->CACHE[line][3]).to_string() << endl;
    cout << "VALIDITY:\t" << bitset<1>(DUT->CACHE_VALID[line]).to_string() << endl;
    cout << "DIRTY:\t" << bitset<1>(DUT->CACHE_DIRTY[line]).to_string() << endl;
    cout<<endl;
    return;
}

void print_victim(Vtop_memory *DUT, bool all_f, int line)
{
    if (all_f)
    {
        for (int i = 0; i < 8; i++)
        {
            cout<<endl;
            cout << "VICTIM LINE: " << i << endl;
            cout << "TAG:\t" << bitset<14>(DUT->VICTIM_TAG[i]).to_string() << endl;
            cout << "DATA:\t"
                 << "00: " << bitset<32>(DUT->VICTIM[i][0]).to_string() << "\t01: " << bitset<32>(DUT->VICTIM[i][1]).to_string() << "\t10: " << bitset<32>(DUT->VICTIM[i][2]).to_string() << "\t11: " << bitset<32>(DUT->VICTIM[i][3]).to_string() << endl;
            cout << "VALIDITY:\t" << bitset<1>(DUT->VICTIM_VALID[i]).to_string() << endl;
            cout << "DIRTY:\t" << bitset<1>(DUT->VICTIM_DIRTY[i]).to_string() << endl;
            cout << "NMRU:\t" << bitset<2>(DUT->VICTIM_NMRU[i]).to_string() << endl;
            cout<<endl;
        }
    }
    else
    {
        cout << "VICTIM LINE: " << line << endl;
        cout << "TAG:\t" << bitset<14>(DUT->VICTIM_TAG[line]).to_string() << endl;
        cout << "DATA:\t"
             << "00: " << bitset<32>(DUT->VICTIM[line][0]).to_string() << "\t01: " << bitset<32>(DUT->VICTIM[line][1]).to_string() << "\t10: " << bitset<32>(DUT->VICTIM[line][2]).to_string() << "\t11: " << bitset<32>(DUT->VICTIM[line][3]).to_string() << endl;
        cout << "VALIDITY:\t" << bitset<1>(DUT->VICTIM_VALID[line]).to_string() << endl;
        cout << "DIRTY:\t" << bitset<1>(DUT->VICTIM_DIRTY[line]).to_string() << endl;
        cout << "NMRU:\t" << bitset<2>(DUT->VICTIM_NMRU[line]).to_string() << endl;
    }
    return;
}

void load_instruction(Vtop_memory *DUT, u_int32_t addr, int byte_selection)
{
    DUT->cpu_wr_re = 0;
    DUT->cpu_addr = addr;
    DUT->cpu_data_out = 0;
    DUT->byte_selection = byte_selection;
    DUT-> eval();
    while (!DUT->cpu_ready)
    {
        tick(DUT,false);
    }
    cout << "LOADED SUCCESSFULLY...!" << endl;
    tick(DUT);
    DUT-> byte_selection=0;
    DUT-> eval();
    cout << addr << ":\t" << bitset<32>(DUT->cpu_data_in).to_string() << endl;
    return;
}

void write_instruction(Vtop_memory *DUT, u_int32_t addr, int data, int byte_selection)
{
    DUT-> cpu_wr_re = 1;
    DUT->cpu_addr = addr;
    DUT->cpu_data_out = data;
    DUT->byte_selection = byte_selection;
    DUT-> eval();
    while (DUT-> cpu_wait)
    {
        tick(DUT,false);
    }
    cout << "DATA WRITE REQUESTED SUCCESSFULLY...!" << endl;
    tick(DUT);
    DUT->byte_selection = 0;
    DUT-> eval();
    return;
}

void print_cache_state(Vtop_memory *DUT)
{
    switch (DUT->CACHE_STATE)
    {
    case (0):
        cout << "CACHE IN IDLE STATE" << endl;
        break;
    case (1):
        cout << "CACHE IN CACHE WRITE STATE" << endl;
        break;
    case (2):
        cout << "CACHE IN CACHE ALLOCATE STATE" << endl;
        break;
    case (3):
        cout << "CACHE IN VICTIM EXCHANGE STATE" << endl;
        break;
    case (4):
        cout << "CACHE IN WRITE BACK STATE" << endl;
        break;
    }
    return;
}

void tb_script(Vtop_memory *tb){
    cout<< "HELLO... CACHE CONTROLLER HERE...!"<<endl;
    m_tickcount = 0;

    // ENSURING PROPER INITTIALIZATION OF VARIABLES
    run_clocks(tb,4,false);
    tick(tb);
    cout<<"@echo: Variables Are Properly Initiated." <<endl;

    cout<<endl<<"FIRST WRITE REQUEST --> ADDR:16, DATA:12"<<endl;
    write_instruction(tb, 16, 12, 3);
    cout<<"@echo: CPU can proceed to the next instruction from here."<<endl;

    cout<<endl<<"LOADING THE SAME DATA (ADDR: 16)"<<endl;
    load_instruction(tb, 16, 3);
    print_cache_out(tb);
    cout<<"@echo: Observe that the data is only available after five more clock cycles from Write Request.\n@echo: This is because controller will consider the line valid only after neighbouring elements are fetched from Main Memory"<<endl;
    print_cache(tb,1);

    cout<<endl<<"WRITE REQUEST ON THE SAME LINE...! --> ADDR: 2064, DATA: 23"<<endl;
    write_instruction(tb,2064,23,3);
    run_clocks(tb,5);
    cout<<endl<<"-----------ANALYZING THE MEMORY CONTENT----------------"<<endl;
    tick(tb);
    cout<<"@echo: Overiding the cache line, forced the content in the first primary cache line to a line in the victim cache."<<endl;
    print_cache(tb,1);
    print_victim(tb);

    cout<<endl<<"READING THE EARLIER DATA AGAIN(ADDR: 16)"<<endl;
    load_instruction(tb, 16, 3);
    print_cache_out(tb);
    cout<<endl<<"-----------ANALYZING THE MEMORY CONTENT----------------"<<endl;
    tick(tb);
    cout<<"@echo: Victim Hit: Data will be swapped between primary cache and victim cache."<<endl;
    print_cache(tb,1);
    print_victim(tb);

    cout<<endl<<"FILLING THE VICTIM...!"<<endl;
    write_instruction(tb,24592,23,3);
    write_instruction(tb,6160,34,3);
    load_instruction(tb,28688,3); // LEAVING ONE SLOT IN THE VICTIM NOT-DIRTY
    write_instruction(tb,4112,43,3);
    write_instruction(tb,20496,49,3);
    write_instruction(tb,16400,478,3);
    write_instruction(tb,129040,2323,3);
    run_clocks(tb,15);
    cout<<endl<<"@echo: Victim is filled while leaving a line clean(Load Instruction)."<<endl;
    print_memory(tb,3586);
    cout<<"-----------------------VIEWING THE VICTIM CONTENT------------------------------"<<endl;
    print_victim(tb,true);
    cout<<"------------------------------- VICTIM END -------------------------------------"<<endl;

    cout<<endl<<"WRITING ONE MORE DATA ON THE SAME LINE."<<endl;
    write_instruction(tb,55312,345,3);
    run_clocks(tb,10);
    cout<<"@echo: Controller will choose the dirty less line and Override it(Best option since no need for a WRITE_BACK stage)"<<endl;
    cout<<"-----------------------VIEWING THE VICTIM CONTENT------------------------------"<<endl;
    print_victim(tb,true);
    cout<<"------------------------------- VICTIM END -------------------------------------"<<endl;
    return;
}
