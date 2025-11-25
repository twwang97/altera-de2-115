quit -sim
project compileoutofdate
vsim -gui work.top_sequential_exp
onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/clk
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/rst_n
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/start
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/a
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/b
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/cin
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/rca8_sum
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/rca8_cout
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/rca8_busy
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/rca8_done
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/rca8_cycle_count
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/cla8_sum
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/cla8_cout
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/cla8_busy
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/cla8_done
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/cla8_cycle_count
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/A_gt_B
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/A_lt_B
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/A_eq_B
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/rca8_sum_larger
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/equal_sum
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/cla8_sum_larger
add wave -noupdate -radix hexadecimal /tb_compare_8bit_adders/done_prev
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
run 250ns
wave zoom full
