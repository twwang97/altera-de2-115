# Load modules (relative path)
set script_dir [file dirname [info script]]
source [file join $script_dir tcl/help.tcl]
source [file join $script_dir tcl/config.tcl]
source [file join $script_dir tcl/fileset.tcl]
source [file join $script_dir tcl/project_props.tcl]

# Create project and set properties
create_project $::config::xilinx_proj_name "./$::config::xilinx_proj_name" -part $::config::fpga_part_name
set ::proj_dir [get_property directory [current_project]]
set_project_properties $::proj_dir $::config::xilinx_proj_name $::config::fpga_part_name $::config::default_lib

# sources_1
set fs_sources [ensure_and_import_vhdl2008_fileset sources_1 -srcset $::files::vhdl_rel_files]
safe_set_property "top" $::config::top_source_name $fs_sources

# import IP file and set its properties
# import_ip_into_sources $fs_sources $::files::ip_file

# constrs_1
set fs_constrs [ensure_and_import_fileset constrs_1 -constrset [list $::files::xdc_file]]
safe_set_property "target_part" $::config::fpga_part_name $fs_constrs

# sim_1
set fs_sim [ensure_and_import_vhdl2008_fileset sim_1 -simset [list $::files::tb_file]]
safe_set_property "sim_wrapper_top" "1" $fs_sim
safe_set_property "top" $::config::top_tb_name $fs_sim
safe_set_property "top_lib" $::config::default_lib $fs_sim

update_compile_order -fileset sources_1