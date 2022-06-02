
quit -sim

vlib work
vmap work work

vlog ../rtl/*.v
vsim uart_tx_rx_tb

#view vsim.wlf 
#do uart_wave.do
add wave uart_tx_rx_tb/*

run -all
