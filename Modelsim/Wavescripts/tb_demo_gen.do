onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_demo_gen/CLK50
add wave -noupdate /tb_demo_gen/RESET
add wave -noupdate /tb_demo_gen/A1/calc_offsets
add wave -noupdate -radix hexadecimal -radixshowbase 0 /tb_demo_gen/A1/shiftreg
add wave -noupdate -format Analog-Step -height 100 -max 200.0 -min 50.0 -radix unsigned -radixshowbase 0 /tb_demo_gen/demo_setpos_1
add wave -noupdate -format Analog-Step -height 100 -max 200.0 -min 50.0 -radix unsigned -radixshowbase 0 /tb_demo_gen/demo_setpos_2
add wave -noupdate -format Analog-Step -height 100 -max 200.0 -min 50.0 -radix unsigned -radixshowbase 0 /tb_demo_gen/demo_setpos_3
add wave -noupdate -format Analog-Step -height 100 -max 200.0 -min 50.0 -radix unsigned -radixshowbase 0 /tb_demo_gen/demo_setpos_4
add wave -noupdate -format Analog-Step -height 100 -max 200.0 -min 50.0 -radix unsigned -radixshowbase 0 /tb_demo_gen/demo_setpos_5
add wave -noupdate -format Analog-Step -height 100 -max 200.0 -min 50.0 -radix unsigned -radixshowbase 0 /tb_demo_gen/demo_setpos_6
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10852851 ps} 0}
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
WaveRestoreZoom {0 ps} {52500 ns}
