quit -sim
project compileoutofdate
vsim -gui work.adder3
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_adder3/a
add wave -noupdate /tb_adder3/b
add wave -noupdate /tb_adder3/cin
add wave -noupdate /tb_adder3/sum
add wave -noupdate /tb_adder3/cout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
run 680ns
wave zoom full
