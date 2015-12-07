onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_sinus_rom/CLK50
add wave -noupdate -format Analog-Step -height 74 -max 160.0 -min 96.0 -radix unsigned /tb_sinus_rom/sin_0
add wave -noupdate -format Analog-Step -height 74 -max 160.0 -min 96.0 -radix unsigned /tb_sinus_rom/sin_60
add wave -noupdate -format Analog-Step -height 74 -max 160.0 -min 101.0 -radix unsigned /tb_sinus_rom/sin_120
add wave -noupdate -format Analog-Step -height 74 -max 160.0 -min 96.0 -radix unsigned /tb_sinus_rom/sin_180
add wave -noupdate -format Analog-Step -height 74 -max 160.0 -min 96.0 -radix unsigned /tb_sinus_rom/sin_240
add wave -noupdate -format Analog-Step -height 74 -max 160.0 -min 96.0 -radix unsigned /tb_sinus_rom/sin_300
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {631369 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {115500 ns}
