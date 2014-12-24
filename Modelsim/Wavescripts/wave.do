onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top_flightsim_controller_n/CLK50
add wave -noupdate /tb_top_flightsim_controller_n/strataflash_oe
add wave -noupdate /tb_top_flightsim_controller_n/strataflash_ce
add wave -noupdate /tb_top_flightsim_controller_n/strataflash_we
add wave -noupdate -radix hexadecimal /tb_top_flightsim_controller_n/lcd_d
add wave -noupdate /tb_top_flightsim_controller_n/lcd_rs
add wave -noupdate /tb_top_flightsim_controller_n/lcd_rw
add wave -noupdate /tb_top_flightsim_controller_n/lcd_e
add wave -noupdate /tb_top_flightsim_controller_n/ROT_A
add wave -noupdate /tb_top_flightsim_controller_n/ROT_B
add wave -noupdate /tb_top_flightsim_controller_n/ROT_P
add wave -noupdate /tb_top_flightsim_controller_n/serial_out
add wave -noupdate -radix ascii /tb_top_flightsim_controller_n/data_out
add wave -noupdate /tb_top_flightsim_controller_n/buffer_data_present
add wave -noupdate /tb_top_flightsim_controller_n/buffer_full
add wave -noupdate /tb_top_flightsim_controller_n/buffer_half_full
add wave -noupdate /tb_top_flightsim_controller_n/en_16xbaud
add wave -noupdate /tb_top_flightsim_controller_n/reset
add wave -noupdate -divider uart
add wave -noupdate -radix ascii /tb_top_flightsim_controller_n/A1/A6/data_in
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/write_buffer
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/reset_buffer
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/en_16_x_baud
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/serial_out
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/buffer_full
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/buffer_half_full
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/clk
add wave -noupdate -radix hexadecimal /tb_top_flightsim_controller_n/A1/A6/fifo_data_out
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/fifo_data_present
add wave -noupdate /tb_top_flightsim_controller_n/A1/A6/fifo_read
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1008760100 ps} 0} {{Cursor 2} {1017400100 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {18053238 ns}
