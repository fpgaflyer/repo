Project: Flightsimulator controller VHDL code to control Brushless DC motors for a 6DOF moving platform

Project status: under development

Project description (current status >>>):
>>> Code running on Xilinx FPGA Starter Kit Board to drive one Roboteq SBL1360 Brushless 
Roboteq motor controller connected via serial in/out.
>>> Code will not run ok due ......

Speed control loop implemented on SBL1360 controller:
configuration settings = profile_roboteq/Profile.xml 
microBasic script = scripts_roboteq/dec2hex.mbs MicroBasic script sents every ms the absolute encoder value in hexadecimal format (only positive values !!)

Position control loop implemented in FPGA:

Serial out: !G runtime commands to SBL1360
Serial in: actual position motor axis from SBL1360

Rotary Push-Button switch to set motor_axis position (SW0 = '0')
OR
Ramp generator (ramp_gen.vhd) generates motor_axis position (SW0 = '1')

Button west/east  set Kp value position controller
LCD screen shows Kp(0-F) and set position (0-3FFF) on line 1, motor axis position (0-FFFFFFFF) on line2  


VHDL Files:
top_flightsim_controller_n.vhd: top level 
lcd_controller_n.vhd, display_controller_n.vhd: controls 2-line, 16-character LCD screen
rotary decoder.vhd, counter.vhd: decode rotary switch postion
conv:  generates Roboteq runtime speed command (!G) string, includes double dabble or shift and add3 algoritm
readpos.vhd: read serial input position data
uart_rx.vhd, uart_tx.vhd, bbfifo_16x8.vhd, kcuart_rx.vhd, kcuart_tx.vhd: Ken Chapman UART with buffer
p_controller_n.vhd: proportial position controller
interpol.vhd: interpolator on set position from ramp generator improves position stability (more intermediate position steps)

tb_ ... are the testbenches

Xilinx:
project file: top_flightsim_controller_n.xise
constraints : additional sources/top_flightsim_controller_n.ucf

Modelsim:
/Wavescripts for corresponding testbenches


Hardware:

Spartan-3E FPGA Starter Kit Board
see: http://www.xilinx.com/support/documentation/boards_and_kits/ug230.pdf

Roboteq SBL1360 Brushless DC motor controller
see: http://www.roboteq.com/index.php/roboteq-products-and-services/brushless-dc-motor-controllers/sbl1360-detail

ENCODER AVAGO HEDS-9040#B00 1000CPR, mounted on motor axis, connected to SBL1360 ENCA/ENCB encoder input 
see: http://www.avagotech.com/docs/AV02-1132EN


Tools:
VHDL design creation: Sigasi 		http://www.sigasi.com/
Simulation: Modelsim PE SE 10.3d	http://www.mentor.com/products/fv/modelsim/
Xilinx: ISE Design Suite 14.1 		http://www.xilinx.com/products/design-tools/ise-design-suite.html
Roboteq: Roborun+ PC Utility 1.4	http://www.roboteq.com/
 