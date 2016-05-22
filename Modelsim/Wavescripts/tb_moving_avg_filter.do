onerror {resume}
quietly virtual signal -install /tb_moving_avg_filter { /tb_moving_avg_filter/out_1(13 downto 6)} out_1_8bits
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_moving_avg_filter/CLK
add wave -noupdate /tb_moving_avg_filter/RESET
add wave -noupdate /tb_moving_avg_filter/AVG
add wave -noupdate -format Analog-Step -height 100 -max 300.0 -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/STIM
add wave -noupdate -format Analog-Step -height 100 -max 300.0 -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_1_8bits
add wave -noupdate -format Analog-Step -height 100 -max 20000.0 -radix unsigned -childformat {{/tb_moving_avg_filter/out_1(13) -radix unsigned} {/tb_moving_avg_filter/out_1(12) -radix unsigned} {/tb_moving_avg_filter/out_1(11) -radix unsigned} {/tb_moving_avg_filter/out_1(10) -radix unsigned} {/tb_moving_avg_filter/out_1(9) -radix unsigned} {/tb_moving_avg_filter/out_1(8) -radix unsigned} {/tb_moving_avg_filter/out_1(7) -radix unsigned} {/tb_moving_avg_filter/out_1(6) -radix unsigned} {/tb_moving_avg_filter/out_1(5) -radix unsigned} {/tb_moving_avg_filter/out_1(4) -radix unsigned} {/tb_moving_avg_filter/out_1(3) -radix unsigned} {/tb_moving_avg_filter/out_1(2) -radix unsigned} {/tb_moving_avg_filter/out_1(1) -radix unsigned} {/tb_moving_avg_filter/out_1(0) -radix unsigned}} -radixshowbase 0 -subitemconfig {/tb_moving_avg_filter/out_1(13) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(12) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(11) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(10) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(9) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(8) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(7) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(6) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(5) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(4) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(3) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(2) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(1) {-height 15 -radix unsigned -radixshowbase 0} /tb_moving_avg_filter/out_1(0) {-height 15 -radix unsigned -radixshowbase 0}} /tb_moving_avg_filter/out_1
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_2
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_3
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_4
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_5
add wave -noupdate -radix unsigned -radixshowbase 0 /tb_moving_avg_filter/out_6
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1880000000000 ps} 0} {{Cursor 2} {1182000000000 ps} 0}
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
WaveRestoreZoom {0 ps} {3150 ms}
