# File Name: assignments.tcl
# Objective: Pin Assignment to DE2-115
# User Manual: https://www.terasic.com.tw/attachment/archive/502/DE2_115_User_manual.pdf
# Author: twwang97

# ============================================================
# Clock
# ============================================================
set_location_assignment PIN_Y2 -to clk
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk
set_location_assignment PIN_Y24 -to rst_n

# ============================================================
# Inputs of 2 Adders
# ============================================================

# Switch
set_location_assignment PIN_AB28 -to a[0]
set_location_assignment PIN_AC28 -to a[1]
set_location_assignment PIN_AC27 -to a[2]
set_location_assignment PIN_AD27 -to a[3]
set_location_assignment PIN_AB27 -to a[4]
set_location_assignment PIN_AC26 -to a[5]
set_location_assignment PIN_AD26 -to a[6]
set_location_assignment PIN_AB26 -to a[7]
set_location_assignment PIN_AC25 -to b[0]
set_location_assignment PIN_AB25 -to b[1]
set_location_assignment PIN_AC24 -to b[2]
set_location_assignment PIN_AB24 -to b[3]
set_location_assignment PIN_AB23 -to b[4]
set_location_assignment PIN_AA24 -to b[5]
set_location_assignment PIN_AA23 -to b[6]
set_location_assignment PIN_AA22 -to b[7]
set_location_assignment PIN_Y23  -to cin

# Key
set_location_assignment PIN_M23  -to start

# ============================================================
# Display of Comparing Inputs (Red LEDs)
# ============================================================
set_location_assignment PIN_G19 -to A_gt_B
set_location_assignment PIN_F19 -to A_eq_B
set_location_assignment PIN_E19 -to A_lt_B

# ============================================================
# Display of Comparing Sum (Green LEDs)
# ============================================================
set_location_assignment PIN_E21 -to rca8_sum_larger
set_location_assignment PIN_E25 -to cla8_sum_larger
set_location_assignment PIN_E22 -to equal_sum
