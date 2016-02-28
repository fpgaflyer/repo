onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_datalog_n/CLK
add wave -noupdate /tb_datalog_n/RESET
add wave -noupdate /tb_datalog_n/reset_log
add wave -noupdate /tb_datalog_n/log_enable
add wave -noupdate /tb_datalog_n/send_log
add wave -noupdate /tb_datalog_n/tx_datalog
add wave -noupdate /tb_datalog_n/log_data
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_datalog_n/addra
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_datalog_n/addrb
add wave -noupdate /tb_datalog_n/dinb
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_datalog_n/douta
add wave -noupdate /tb_datalog_n/web
add wave -noupdate /tb_datalog_n/sync_2ms
add wave -noupdate /tb_datalog_n/data_rdy
add wave -noupdate /tb_datalog_n/A1/sm
add wave -noupdate /tb_datalog_n/A1/nxt_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {500220209 ps} 0}
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
WaveRestoreZoom {499776891 ps} {500482463 ps}
