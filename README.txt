Project: Flightsimulator controller VHDL code to control Brushless DC motors for a 6DOF moving platform

Project status: test fase for 24V

Project description 
Code running on Xilinx FPGA Starter Kit Board to drive six Roboteq SBL1360 Brushless 
6 Roboteq motor controllers connected via serial in/out.


Speed control loop implemented on SBL1360 controller:
configuration settings = profile_roboteq/Profile.xml 
microBasic script = scripts_roboteq/dec2hex.mbs MicroBasic script sents every ms the absolute encoder value 
in hexadecimal format (25um steps, only positive values !)

Position control loop implemented in FPGA, kp = control loop gain 0 - 3 (SW0,SW1)  

Serial out: !G runtime commands to SBL1360
Serial in: actual position motor axis from SBL1360

Home position sensor is a slotted sensor to detect home position
This sensor input is also used as safety limit switch: the sensor input is activated if the actuator
reaches its minimal (home position) but also if a limit switch is activated when the actuator reaches
the maximal mechanical position. The limit switch is connected in parallel with the home position sensor.
This safety feature cuts the power (power_off) and is only active during rampup and run
   
Rotary switch to set motor_axis position in 1.6mm steps (range 00 - FF), selected LCD display blinks
Rotary Push_Button will enter set position, selected LCD display stops blinking

Button north/south enables manual control in speed mode, north = speed +50 (up), south = speed -50 (down)
Button west/east (SW3 = 0):	select controller 1 to 6, index is displayed on LCD lower left corner digit
Button west/east (SW3 = 1):	sets mode
Button west/east together : export datalog to PC

remark: speed mode is a not protected mode! 

External run_switch 
on:	motor activated in position controlled mode, speed ramps up in 20 sec
off:	stop, motor can be activated in controlled speed mode with button north/south
off (during run): speed ramps down in 2sec followed by stop		

External reset_button stops motor and reset error flags
Press external reset_button for: 
>2.5sec to enable home_position (set position counter in FPGA to preset value 0x10) 
>7.5sec to drive actuators down until home position sensor is active (bring the platform down) 

motor_enable: signal to roboteq motor controller, low will stop motor 
power_off: signal disables power to motor controllers   

SW0,SW1 sets kp value 0..3, kp value is displayed on LCD upper left corner digit
SW3 = '1' sets mode of operation (mode is displayed on LCD lower left corner digit):

mode:
A: set position via serial input, interface see 6-DOF BFF Motion Driver User Guide**
B: set position by rotary switch
C: set position = 0x30 (lowest operational position)
D: set position = 0x80 (starting position)
E: set position = 0xD0 (highest operational position)
F: set position by demo generator: random sinusoidal movement of actuators, sinusoidal sequence is set
to different offsets (pseudo random) each time the sim is activated with the run switch.  

** serial data input is BIN (8 bits) format, 38400 Baud

leds:			sim state:
off			stop 
glow			homeposition enable is on 
scroll			rampup
on			run	
led3+4 on		rampdown	
flashing all		error (see error codes)
flashing led0 		communication error with PC
flashing led7		singularity error
alternate   		going to home position (bring the platform down)  

buzzer: 		singularity error, be carefull not to bring the platform in a singular condition
			especially after power off !

buzzer short beep:	platform is not in home position when the controllers were powered, this can cause 
			an unwanted position offset			
			

LCD screen shows 6 actual motor axis positions (00-FF/1.6mm) in the upper line and 
6 set positions (00-FF/1.6mm) on lower line
In case there is a error the lower line displays error code per actuator. 

error codes:
01: position too low		<0x20 = 5.12cm
02: position too high		>0xE0 = 35.84cm
04: loop error			loop error >10.2375cm for 1.28sec
08: position update error	no position update received within 64ms

10: setpos error		set position <0x20 = 5.12cm or >0xE0 = 35.84cm
20: home error			not in home position before rampup
40: home pos during rampup	home position detected during rampup
80: home pos during run		home position detected during run

error codes are added for a combination of errors 

VHDL Files:
top_flightsim_controller_n.vhd: top level 
lcd_controller_n.vhd, display_controller_n.vhd: controls 2-line, 16-character LCD screen
rotary decoder.vhd: decode rotary switch postion
control.vhd: control section 
conv:  generates Roboteq runtime speed command (!G) string, includes double dabble or shift and add3 algoritm
readpos.vhd: read serial input position data
uart_rx.vhd, uart_tx.vhd, bbfifo_16x8.vhd, kcuart_rx.vhd, kcuart_tx.vhd: Ken Chapman UART with buffer
p_controller_n.vhd: proportial position controller 
interpol.vhd: interpolator on set position improves position stability (more intermediate position steps) NOT USED
home_position.vhd: gives offset to position counter when home position detected
drive_mux.vhd: selects position mode (position control loop active) or speed mode (no position control)
sinus_rom.vhd: generates position que for testpurposes 
demo_gen.vhd: generates position que for demos
sinus.xls: sinus table for sinus/demo 
singularity_detector: detector for singular situations
data_logger_n: stores all position,setposition,drive and homesensor data each 2ms for 4.096 seconds (circular buffer)
log_serial_tx: serial datalogger output 38400Baud to PC: 2048 lines x 16 bytes  
moving_avg_filter: moving average filter added to set pos via serial input to smooth movements due 
too large BFF driver processing time (>60ms) 

dumplog: application to readout serial datalog, with example datafile and excellsheet to display data 

tb_ ... are the testbenches (not all are updated)


Xilinx:
project file: top_flightsim_controller_n.xise
constraints : additional sources/top_flightsim_controller_n.ucf

Modelsim:
/Wavescripts for corresponding testbenches (not all are updated)


Hardware:

Spartan-3E FPGA Starter Kit Board
see: http://www.xilinx.com/support/documentation/boards_and_kits/ug230.pdf

Roboteq SBL1360 Brushless DC motor controller
see: http://www.roboteq.com/index.php/roboteq-products-and-services/brushless-dc-motor-controllers/sbl1360-detail

ENCODER AVAGO HEDS-9040#B00 1000CPR, mounted on motor axis, connected to SBL1360 ENCA/ENCB encoder input 
see: http://www.avagotech.com/docs/AV02-1132EN


Tools/references
VHDL design creation: Sigasi 		http://www.sigasi.com/
Simulation: Modelsim PE SE 10.3d	http://www.mentor.com/products/fv/modelsim/
Xilinx: ISE Design Suite 14.1 		http://www.xilinx.com/products/design-tools/ise-design-suite.html
Roboteq: Roborun+ PC Utility 1.4	http://www.roboteq.com/
BFF simulation 6-DOF motion driver	http://bffsimulation.com/
 