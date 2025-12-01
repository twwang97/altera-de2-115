# File Name: assignments.tcl
# Objective: Pin Assignment to DE2-115
# User Manual: https://www.terasic.com.tw/attachment/archive/502/DE2_115_User_manual.pdf
# Author: David

# ============================================================
# Clock
# ============================================================
set_location_assignment PIN_Y2 -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk
set_location_assignment PIN_AC25 -to rst_n

# ============================================================
# Push Button
# ============================================================
set_location_assignment PIN_R24 -to enable

# ============================================================
# 7-Segment Display
# ============================================================
set_location_assignment PIN_M24 -to hex0_a
set_location_assignment PIN_Y22 -to hex0_b
set_location_assignment PIN_W21 -to hex0_c
set_location_assignment PIN_W22 -to hex0_d
set_location_assignment PIN_W25 -to hex0_e
set_location_assignment PIN_U23 -to hex0_f
set_location_assignment PIN_U24 -to hex0_g
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0_a
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0_b
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0_c
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0_d
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0_e
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0_f
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex0_g
