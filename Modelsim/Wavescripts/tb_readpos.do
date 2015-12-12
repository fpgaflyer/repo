onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_readpos/CLK
add wave -noupdate /tb_readpos/RESET
add wave -noupdate -radix ascii -radixshowbase 0 /tb_readpos/DATA_IN
add wave -noupdate /tb_readpos/WRITE_BUFFER
add wave -noupdate /tb_readpos/serial
add wave -noupdate -radix ascii -radixshowbase 0 /tb_readpos/data
add wave -noupdate /tb_readpos/read_buffer
add wave -noupdate /tb_readpos/buffer_data_present
add wave -noupdate /tb_readpos/buffer_full
add wave -noupdate /tb_readpos/buffer_half_full
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_readpos/pos
add wave -noupdate -divider read_pos
add wave -noupdate /tb_readpos/CLK
add wave -noupdate /tb_readpos/RESET
add wave -noupdate /tb_readpos/serial
add wave -noupdate -radix ascii -radixshowbase 0 /tb_readpos/DATA_IN
add wave -noupdate /tb_readpos/WRITE_BUFFER
add wave -noupdate -radix ascii -radixshowbase 0 /tb_readpos/data
add wave -noupdate /tb_readpos/read_buffer
add wave -noupdate /tb_readpos/buffer_data_present
add wave -noupdate /tb_readpos/buffer_full
add wave -noupdate /tb_readpos/buffer_half_full
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_readpos/pos
add wave -noupdate /tb_readpos/sync_2ms
add wave -noupdate /tb_readpos/pos_update_error
add wave -noupdate /tb_readpos/en_16xbaud
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_readpos/A3/line__31/cnt_2ms
add wave -noupdate /tb_readpos/A3/sm
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {163180000 ps} 0}
quietly wave cursor active 1
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
WaveRestoreZoom {0 ps} {210 us}
