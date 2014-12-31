onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_interpol/A2/clk
add wave -noupdate /tb_interpol/A2/reset
add wave -noupdate -radix unsigned /tb_interpol/A3/dout
add wave -noupdate /tb_interpol/A2/sync_2ms
add wave -noupdate -format Analog-Step -height 100 -max 256.0 -radix unsigned /tb_interpol/A2/din
add wave -noupdate -radix unsigned /tb_interpol/A2/line__42/di
add wave -noupdate /tb_interpol/A2/dvalid
add wave -noupdate -format Analog-Step -height 100 -max 16384.0 -radix unsigned /tb_interpol/A2/dout
add wave -noupdate -radix unsigned /tb_interpol/A2/dout
add wave -noupdate -radix unsigned /tb_interpol/A2/n
add wave -noupdate -radix unsigned /tb_interpol/A2/delta
add wave -noupdate -radix unsigned -childformat {{/tb_interpol/A2/do(15) -radix unsigned} {/tb_interpol/A2/do(14) -radix unsigned} {/tb_interpol/A2/do(13) -radix unsigned} {/tb_interpol/A2/do(12) -radix unsigned} {/tb_interpol/A2/do(11) -radix unsigned} {/tb_interpol/A2/do(10) -radix unsigned} {/tb_interpol/A2/do(9) -radix unsigned} {/tb_interpol/A2/do(8) -radix unsigned} {/tb_interpol/A2/do(7) -radix unsigned} {/tb_interpol/A2/do(6) -radix unsigned} {/tb_interpol/A2/do(5) -radix unsigned} {/tb_interpol/A2/do(4) -radix unsigned} {/tb_interpol/A2/do(3) -radix unsigned} {/tb_interpol/A2/do(2) -radix unsigned} {/tb_interpol/A2/do(1) -radix unsigned} {/tb_interpol/A2/do(0) -radix unsigned}} -subitemconfig {/tb_interpol/A2/do(15) {-radix unsigned} /tb_interpol/A2/do(14) {-radix unsigned} /tb_interpol/A2/do(13) {-radix unsigned} /tb_interpol/A2/do(12) {-radix unsigned} /tb_interpol/A2/do(11) {-radix unsigned} /tb_interpol/A2/do(10) {-radix unsigned} /tb_interpol/A2/do(9) {-radix unsigned} /tb_interpol/A2/do(8) {-radix unsigned} /tb_interpol/A2/do(7) {-radix unsigned} /tb_interpol/A2/do(6) {-radix unsigned} /tb_interpol/A2/do(5) {-radix unsigned} /tb_interpol/A2/do(4) {-radix unsigned} /tb_interpol/A2/do(3) {-radix unsigned} /tb_interpol/A2/do(2) {-radix unsigned} /tb_interpol/A2/do(1) {-radix unsigned} /tb_interpol/A2/do(0) {-radix unsigned}} /tb_interpol/A2/do
add wave -noupdate -radix unsigned /tb_interpol/A2/do(15)
add wave -noupdate -radix unsigned /tb_interpol/A2/do(14)
add wave -noupdate -radix symbolic /tb_interpol/A2/line__42/up
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12839991951 ps} 0}
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
WaveRestoreZoom {12838764209 ps} {12841286473 ps}
