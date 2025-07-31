set_property PACKAGE_PIN V31 [get_ports gt_ref_clk_0_clk_p]

create_clock -period 6.400 -name gt_ref_clk [get_ports gt_ref_clk_0_clk_p]

set_property PACKAGE_PIN AA39 [get_ports *_grx_n]
set_property PACKAGE_PIN AA38 [get_ports *_grx_p]

set_property PACKAGE_PIN Y36 [get_ports *_gtx_n]
set_property PACKAGE_PIN Y35 [get_ports *_gtx_p]

set_property PACKAGE_PIN G12 [get_ports sfp0_tx_disable_*]
set_property IOSTANDARD LVCMOS12 [get_ports {sfp0_tx_disable_b[0]}]


set_false_path -to [get_pins -regex -hier .*pl_eth_1_10_25g.*/data_sync_reg1/D]
set_false_path -to [get_pins -regex -hier .*pl_eth_1_10_25g.*/reset_sync./PRE]

