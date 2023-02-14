rm -r obj_dir
verilator -Wall --cc top_memory.v --exe tb_top_memory.cpp &>-
make -C obj_dir -f Vtop_memory.mk &>-
obj_dir/Vtop_memory