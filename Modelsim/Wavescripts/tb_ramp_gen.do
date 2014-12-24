onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ramp_gen/A1/clk
add wave -noupdate /tb_ramp_gen/A1/start
add wave -noupdate /tb_ramp_gen/A1/sync_20ms
add wave -noupdate -format Analog-Step -height 74 -max 103.99999999999999 -radix unsigned /tb_ramp_gen/A1/dout
add wave -noupdate /tb_ramp_gen/A3/clk
add wave -noupdate /tb_ramp_gen/A3/reset
add wave -noupdate /tb_ramp_gen/A3/sync_2ms
add wave -noupdate /tb_ramp_gen/A3/dvalid
add wave -noupdate -radix unsigned /tb_ramp_gen/A3/d
add wave -noupdate -radix unsigned /tb_ramp_gen/A3/n
add wave -noupdate -radix unsigned /tb_ramp_gen/A3/delta
add wave -noupdate -radix unsigned /tb_ramp_gen/A3/dout
add wave -noupdate /tb_ramp_gen/A3/do
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {798727088 ps} 0}
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
WaveRestoreZoom {0 ps} {1050 us}
