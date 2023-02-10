#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <bitset>
#include <vector>
#include "Vcache_memory.h"
#include "verilated.h"

using namespace std;

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Vcache_memory *tb = new Vcache_memory;

    while (!Verilated::gotFinish())
    {
        tb->clk = 0;
        tb->eval();
        tb->cpu_data_in = 3;
        tb->byte_selection = 3;
        tb->cpu_wr_re = 1;
        tb->cpu_addr = 0;

        tb->clk = 1;
        tb->eval();
        
        cout <<  std::bitset<1>(tb->cache_memory__DOT__cac_valid[0]).to_string() << " test" << endl;

        usleep(20000);

        
    }
    delete tb;
    exit(EXIT_SUCCESS);
}