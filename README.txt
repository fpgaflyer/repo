Project: Flightsimulator controller VHDL code to control Brushless DC motors for a 6DOF moving platform

Project status: under development, XXXXXXXXXXXXX  THIS COMMIT DOES NOT WORK  XXXXXXXXXXX

Project description 
Code running on Xilinx FPGA Starter Kit Board to drive six Roboteq SBL1360 Brushless 
6 Roboteq motor controllers connected via serial in/out.


Speed control loop implemented on SBL1360 controller:
configuration settings = profile_roboteq/Profile.xml 
microBasic script = scripts_roboteq/dec2hex.mbs MicroBasic script sents every ms the absolute encoder value 
in hexadecimal format (25um steps, only positive values !)

Position control loop implemented in FPGA:

Serial out: !G runtime commands to SBL1360
Serial in: actual position motor axis from SBL1360

Home position sensor is a slotted sensor to detect zero position

Rotary switch to set motor_axis position in 1.6mm steps (range 00 - FF)
Rotary Push_Button enables position controlled mode and sets position

Button north/south enables speed mode, north = speed +50 (up), south = speed -50 (down)
Button west/east:	select controller 1 to 6, index is displayed on LCD lower left corner digit

SW0 = '1' enables home_position (set position counter to zero) when home_position sensor goes high
SW1,SW2 sets kp value 0..2, kp value is displayed on LCD upper left corner digit

SW3 = '1' sets mode of operation (mode is displayed on LCD lower left corner digit):
mode
A: set position by rotary switch
B: set position via serial input, interface see 6-DOF BFF Motion Driver User Guide**
C: set position by sinus generator : YAW
D: set position by sinus generator : SURGE
E: set position = 0x10
F: set position = 0x80 

** serial data input is BIN format, 38400 Baud

led on = position mode
led off = speed mode
led5 to led0 => controller 1 to 6 ! 

LCD screen shows 6 actual motor axis positions (00-FF/1.6mm) in the upper line and 
6 set positions (00-FF/1.6mm) on lower line



VHDL Files:
top_flightsim_controller_n.vhd: top level 
lcd_controller_n.vhd, display_controller_n.vhd: controls 2-line, 16-character LCD screen
rotary decoder.vhd: decode rotary switch postion
conv:  generates Roboteq runtime speed command (!G) string, includes double dabble or shift and add3 algoritm
readpos.vhd: read serial input position data
uart_rx.vhd, uart_tx.vhd, bbfifo_16x8.vhd, kcuart_rx.vhd, kcuart_tx.vhd: Ken Chapman UART with buffer
p_controller_n.vhd: proportial position controller 
interpol.vhd: interpolator on set position improves position stability (more intermediate position steps) NOT USED
home_position.vhd: gives offset to position counter when home position detected
drive_mux: selects position mode (position control loop active) or speed mode (no position control)

tb_ ... are the testbenches NOT UPDATED 

Xilinx:
project file: top_flightsim_controller_n.xise
constraints : additional sources/top_flightsim_controller_n.ucf

Modelsim:
/Wavescripts for corresponding testbenches NOT UPDATED


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
BFF simulation 6-DOF motion driver	http://bffsimulation.com/
 