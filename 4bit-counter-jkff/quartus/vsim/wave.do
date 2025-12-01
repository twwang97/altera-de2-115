quit -sim
project compileoutofdate
vsim -gui work.jk_4bit_counter
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_jk_4bit_counter/Clock
add wave -noupdate -radix hexadecimal /tb_jk_4bit_counter/nReset
add wave -noupdate -radix hexadecimal /tb_jk_4bit_counter/Enable
add wave -noupdate -radix hexadecimal /tb_jk_4bit_counter/Q
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {282680 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 172
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
run 350ns
wave zoom full
