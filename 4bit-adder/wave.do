quit -sim
project compileoutofdate
vsim -gui work.ripple_adder_display
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ripple_adder/rst_n
add wave -noupdate /tb_ripple_adder/en
add wave -noupdate /tb_ripple_adder/a
add wave -noupdate /tb_ripple_adder/b
add wave -noupdate /tb_ripple_adder/sum
add wave -noupdate /tb_ripple_adder/cout
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
run 50ns
wave zoom full
