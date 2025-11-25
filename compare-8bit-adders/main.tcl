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
# File: adders8_cmp_proj.tcl
# Generated on: Sat Nov 22 09:43:56 2025

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set make_assignments 1
# set need_to_close_project 1
set project_name "cmp_8bit_adders_proj"
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
	# FPGA with QUARTUS
	# ==================================================
	set_global_assignment -name FAMILY "Cyclone IV E"
	set_global_assignment -name DEVICE EP4CE115F29C7
	set_global_assignment -name TOP_LEVEL_ENTITY top_sequential_exp
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 24.1STD.0
	set_global_assignment -name LAST_QUARTUS_VERSION "24.1std.0 Lite Edition"
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY $project_output_dir
	
	# ==================================================
	# Block Diagram and VHDL/Verilog Scripts
	# ==================================================
	set_global_assignment -name VERILOG_FILE src/full_adder.v -hdl_version Verilog_2001
	set_global_assignment -name VERILOG_FILE src/sequential_trigger_rca8.v -hdl_version Verilog_2001
	set_global_assignment -name VERILOG_FILE src/sequential_ctrl.v -hdl_version Verilog_2001
	set_global_assignment -name VERILOG_FILE src/sequential_rca_latches.v -hdl_version Verilog_2001
	set_global_assignment -name VERILOG_FILE src/cla8.v -hdl_version Verilog_2001
	set_global_assignment -name VERILOG_FILE src/sequential_cla_latches.v -hdl_version Verilog_2001
	set_global_assignment -name VERILOG_FILE src/sequential_trigger_cla8.v -hdl_version Verilog_2001
	set_global_assignment -name VERILOG_FILE src/mag_cmp4.v -hdl_version Verilog_2001
	set_global_assignment -name VERILOG_FILE src/mag_cmp8.v -hdl_version Verilog_2001
	set_global_assignment -name BDF_FILE src/top_sequential_exp.bdf
	set_global_assignment -name VHDL_FILE src/tb_compare_8bit_adders.vhd -hdl_version VHDL_2008
	set_global_assignment -name VHDL_FILE src/tb_rca_8bit.vhd -hdl_version VHDL_2008
	set_global_assignment -name VHDL_FILE src/tb_cla_8bit.vhd -hdl_version VHDL_2008
	set_global_assignment -name VHDL_FILE src/tb_mag_cmp4.vhd -hdl_version VHDL_2008
	set_global_assignment -name VHDL_FILE src/tb_mag_cmp8.vhd -hdl_version VHDL_2008
	set_global_assignment -name PROJECT_IP_REGENERATION_POLICY ALWAYS_REGENERATE_IP

	# ==================================================
	# ModelSim
	# ==================================================
	set_global_assignment -name EDA_SIMULATION_TOOL "QuestaSim (VHDL)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT VHDL -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name EDA_TEST_BENCH_ENABLE_STATUS TEST_BENCH_MODE -section_id eda_simulation
	set_global_assignment -name EDA_RUN_TOOL_AUTOMATICALLY ON -section_id eda_simulation

	# ==================================================
	# Testbench (Default: tb_compare_8bit_adders)
	# ==================================================
	set testbench_top_name "tb_compare_8bit_adders"
	set testbench_top_file "src/${testbench_top_name}.vhd"
	set_global_assignment -name EDA_NATIVELINK_SIMULATION_TEST_BENCH $testbench_top_name -section_id eda_simulation
	set_global_assignment -name EDA_TEST_BENCH_NAME $testbench_top_name -section_id eda_simulation
	set_global_assignment -name EDA_DESIGN_INSTANCE_NAME NA -section_id $testbench_top_name
	set_global_assignment -name EDA_TEST_BENCH_MODULE_NAME $testbench_top_name -section_id $testbench_top_name
	set_global_assignment -name EDA_TEST_BENCH_FILE $testbench_top_file -section_id $testbench_top_name -hdl_version VHDL_2008

	# ==================================================
	# Pin Assignments
	# ==================================================
	source src/assignments.tcl
	export_assignments
}
