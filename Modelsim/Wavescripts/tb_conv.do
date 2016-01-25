onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_conv/CLK
add wave -noupdate /tb_conv/RESET
add wave -noupdate /tb_conv/START
add wave -noupdate /tb_conv/RST_MOT_CTRL
add wave -noupdate /tb_conv/DI
add wave -noupdate -radix ascii -radixshowbase 0 /tb_conv/DO
add wave -noupdate /tb_conv/DVALID
add wave -noupdate -divider {New Divider}
add wave -noupdate /tb_conv/A1/clk
add wave -noupdate /tb_conv/A1/rst
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_conv/A1/di
add wave -noupdate /tb_conv/A1/start
add wave -noupdate /tb_conv/A1/rst_mot_ctrl
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_conv/A1/do
add wave -noupdate /tb_conv/A1/dvalid
add wave -noupdate /tb_conv/A1/digits
add wave -noupdate /tb_conv/A1/bin
add wave -noupdate /tb_conv/A1/sign
add wave -noupdate /tb_conv/A1/nozero
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_conv/A1/pc
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {210427699 ps} 0}
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
WaveRestoreZoom {0 ps} {600351 ps}
