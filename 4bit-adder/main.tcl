# Copyright (C) 2025  Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, the Altera Quartus Prime License Agreement,
# the Altera IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Altera and sold by Altera or its authorized distributors.  Please
# refer to the Altera Software License Subscription Agreements 
# on the Quartus Prime software download page.

# Quartus Prime: Generate Tcl File for Project
# File: ripple_adder_7seg_display_proj.tcl
# Generated on: Sat Nov 15 12:50:00 2025

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set make_assignments 1
# set need_to_close_project 1
set project_name "ripple_adder_7seg_display_proj"
set project_output_dir "output_compiled_files"

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) $project_name]} {
		puts "Project $project_name is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists $project_name]} {
		project_open -revision top_level $project_name
	} else {
		project_new -revision top_level $project_name
	}
}

# Make assignments
if {$make_assignments} {
	# ==================================================
	# FPGA Assignments
	# ==================================================
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE115F29C7
	set_global_assignment -name TOP_LEVEL_ENTITY ripple_adder_display
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 24.1STD.0
	set_global_assignment -name LAST_QUARTUS_VERSION "24.1std.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY $project_output_dir

	# ==================================================
	# Block Diagram and VHDL Scripts
	# ==================================================
	set_global_assignment -name VHDL_FILE tb_ripple_adder.vhd
	set_global_assignment -name VHDL_FILE full_adder.vhd
	set_global_assignment -name VHDL_FILE rca_4bit.vhd
	set_global_assignment -name VHDL_FILE cla_4bit.vhd
	set_global_assignment -name VHDL_FILE pass_or_zero.vhd
	set_global_assignment -name VHDL_FILE ripple_adder.vhd
	set_global_assignment -name VHDL_FILE sevenseg_display.vhd
	set_global_assignment -name VHDL_FILE div_by_10.vhd
	set_global_assignment -name BDF_FILE ripple_adder_display.bdf

	# ==================================================
	# ModelSim
	# ==================================================
	set_global_assignment -name EDA_SIMULATION_TOOL "QuestaSim (VHDL)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_RUN_TOOL_AUTOMATICALLY OFF -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS TEST_BENCH_MODE -section_id eda_simulation
	set_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH tb_ripple_adder -section_id eda_simulation
	set_global_assignment -name EDA_TEST_BENCH_NAME tb_ripple_adder -section_id eda_simulation
	set_global_assignment -name EDA_DESIGN_INSTANCE_NAME NA -section_id tb_ripple_adder
	set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME tb_ripple_adder -section_id tb_ripple_adder
	set_global_assignment -name EDA_TEST_BENCH_FILE tb_ripple_adder.vhd -section_id tb_ripple_adder
	
	set_global_assignment -name PROJECT_IP_REGENERATION_POLICY ALWAYS_REGENERATE_IP

	# ==================================================
	# Pin Assignments
	# ==================================================
	source ./assignments.tcl	
	export_assignments
}
