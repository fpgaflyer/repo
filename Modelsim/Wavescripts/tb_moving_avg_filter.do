onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_moving_avg_filter/CLK
add wave -noupdate /tb_moving_avg_filter/RESET
add wave -noupdate -format Analog-Step -height 100 -max 300.0 -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/STIM
add wave -noupdate -format Analog-Step -height 100 -max 300.0 -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_1
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_2
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_3
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_4
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_5
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_6
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1580000000000 ps} 0} {{Cursor 2} {880000000000 ps} 0}
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
WaveRestoreZoom {0 ps} {3150 ms}
