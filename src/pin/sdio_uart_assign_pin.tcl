#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

#系统时钟引脚

set_location_assignment pin_23  -to clk

#系统复位引脚

set_location_assignment pin_25 -to rst


#UART
set_location_assignment pin_115 -to rxd
set_location_assignment pin_114 -to txd

#SDIO
set_location_assignment pin_141 -to sd_clk
set_location_assignment pin_138 -to cmd_i
set_location_assignment pin_143 -to finsh

#SEG
#set_location_assignment pin_137 -to seg_dsel[3]
#set_location_assignment pin_136 -to seg_dsel[2]
#set_location_assignment pin_135 -to seg_dsel[1]
#set_location_assignment pin_133 -to seg_dsel[0]
#set_location_assignment pin_127 -to seg_led_num_dig[7]
#set_location_assignment pin_124 -to seg_led_num_dig[6]
#set_location_assignment pin_126 -to seg_led_num_dig[5]
#set_location_assignment pin_132 -to seg_led_num_dig[4]
#set_location_assignment pin_129 -to seg_led_num_dig[3]
#set_location_assignment pin_125 -to seg_led_num_dig[2]
#set_location_assignment pin_121 -to seg_led_num_dig[1]
#set_location_assignment pin_128 -to seg_led_num_dig[0]
