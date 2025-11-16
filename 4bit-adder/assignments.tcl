# File Name: assignments.tcl
# Objective: Pin Assignment to DE2-115
* User Manual: https://www.terasic.com.tw/attachment/archive/502/DE2_115_User_manual.pdf
# Author: David

# ============================================================
# Clock
# ============================================================
set_location_assignment PIN_Y2 -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk
set_location_assignment PIN_AC25 -to rst_n

# ============================================================
# Ripple Adder
# ============================================================
set_location_assignment PIN_AB28 -to a[0]
set_location_assignment PIN_AC28 -to a[1]
set_location_assignment PIN_AC27 -to a[2]
set_location_assignment PIN_AD27 -to a[3]
set_location_assignment PIN_AB27 -to b[0]
set_location_assignment PIN_AC26 -to b[1]
set_location_assignment PIN_AD26 -to b[2]
set_location_assignment PIN_AB26 -to b[3]
set_location_assignment PIN_AB25 -to en
set_location_assignment PIN_G19 -to carry

# ============================================================
# 7-Segment Display - Units Digits
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


# ============================================================
# 7-Segment Display - Tens Digits
# ============================================================
set_location_assignment PIN_AA25 -to hex1_a
set_location_assignment PIN_AA26 -to hex1_b
set_location_assignment PIN_Y25 -to hex1_c
set_location_assignment PIN_W26 -to hex1_d
set_location_assignment PIN_Y26 -to hex1_e
set_location_assignment PIN_W27 -to hex1_f
set_location_assignment PIN_W28 -to hex1_g
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1_a
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1_b
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1_c
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1_d
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1_e
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1_f
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to hex1_g