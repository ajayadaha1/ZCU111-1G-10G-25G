# Set the name of the project:
set project_name pl_eth_1_10_25g

# Set the project device:
set device xczu28dr-ffvg1517-2-e

# If using a UI layout, uncomment this line:
#set ui_name layout.ui


# Set the path to the directory we want to put the Vivado build in. Convention is <PROJECT NAME>_hw
set proj_dir ../Hardware/${project_name}_hw


create_project -name ${project_name} -force -dir ${proj_dir} -part ${device}

# Set the board_part property to the correct development board: ZCU111
set_property board_part xilinx.com:zcu111:part0:1.4 [current_project]

# Source the BD file, BD naming convention is project_bd.tcl
source pl_eth_1_10_25g.tcl

#Set the path to the constraints file:
set impl_const ../Hardware/constraints/constraints.xdc

if [file exists ${impl_const}] {
    add_files -fileset constrs_1 -norecurse ./${impl_const}
    set_property used_in_synthesis true [get_files ./${impl_const}]
}

make_wrapper -files [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd] -top

add_files -norecurse ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/hdl/${project_name}_wrapper.v
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

validate_bd_design
save_bd_design
close_bd_design ${project_name}

# If using UI, uncomment these two lines:
file mkdir ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/ui
file copy -force ${ui_name} ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/ui/${ui_name}

open_bd_design ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd
set_property synth_checkpoint_mode None [get_files ${proj_dir}/${project_name}.srcs/sources_1/bd/${project_name}/${project_name}.bd]
