onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group control /spi_master_tb/clk
add wave -noupdate -expand -group control /spi_master_tb/rst_n
add wave -noupdate -expand -group control /spi_master_tb/spi_wr_cmd
add wave -noupdate -expand -group control /spi_master_tb/spi_rd_cmd
add wave -noupdate -expand -group control /spi_master_tb/mosi_data
add wave -noupdate -expand -group spi_m0 -color Magenta -radix binary /spi_master_tb/sck_0
add wave -noupdate -expand -group spi_m0 -radix binary /spi_master_tb/cs_0
add wave -noupdate -expand -group spi_m0 -color Magenta -radix binary /spi_master_tb/mosi_0
add wave -noupdate -expand -group spi_m0 /spi_master_tb/miso_0
add wave -noupdate -expand -group spi_m0 /spi_master_tb/miso_data_0
add wave -noupdate -expand -group spi_m1 -color Blue -radix binary /spi_master_tb/sck_1
add wave -noupdate -expand -group spi_m1 -radix binary /spi_master_tb/cs_1
add wave -noupdate -expand -group spi_m1 -color Blue -radix binary /spi_master_tb/mosi_1
add wave -noupdate -expand -group spi_m1 /spi_master_tb/miso_1
add wave -noupdate -expand -group spi_m1 /spi_master_tb/miso_data_1
add wave -noupdate -expand -group spi_m2 -color Orange -radix binary /spi_master_tb/sck_2
add wave -noupdate -expand -group spi_m2 -radix binary /spi_master_tb/cs_2
add wave -noupdate -expand -group spi_m2 -color Orange -radix binary /spi_master_tb/mosi_2
add wave -noupdate -expand -group spi_m2 /spi_master_tb/miso_2
add wave -noupdate -expand -group spi_m2 /spi_master_tb/miso_data_2
add wave -noupdate -expand -group spi_m3 -color Pink -radix binary /spi_master_tb/sck_3
add wave -noupdate -expand -group spi_m3 -radix binary /spi_master_tb/cs_3
add wave -noupdate -expand -group spi_m3 -color Pink -radix binary /spi_master_tb/mosi_3
add wave -noupdate -expand -group spi_m3 /spi_master_tb/miso_3
add wave -noupdate -expand -group spi_m3 /spi_master_tb/miso_data_3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6007922 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 217
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {11119500 ps}
