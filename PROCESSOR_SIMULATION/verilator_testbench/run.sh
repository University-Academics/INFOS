rm -r obj_dir
verilator -Wall --cc cache_memory.v --exe cache.cpp &>-
make -C obj_dir -f Vcache_memory.mk &>-
obj_dir/Vcache_memory