
quit -sim

vlib work
vmap work work

vlog ../rtl/*.v
vsim spi_master_tb

view vsim.wlf 
do spi_wave.do
#add wave spi_master_tb/*

run -all
