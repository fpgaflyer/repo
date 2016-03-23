Project: Flightsimulator controller VHDL code to control Brushless DC motors for a 6DOF moving platform

Project status: test fase

Project description 
Code running on Xilinx FPGA Starter Kit Board to drive six Roboteq SBL1360 Brushless 
6 Roboteq motor controllers connected via serial in/out.

***********************************************************
test version to analyse position output cue from BFF driver DO NOT USE THIS VERSION FOR NORMAL OPERATION 
***********************************************************




LCD screen shows position output cue data (dataformat BIN2B):

upper line  MSB  (data byte 2 - 7)
lower line LSB   (data byte 8 - 13)





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
 