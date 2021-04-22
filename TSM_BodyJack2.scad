// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// This is the connection between the chassis and a track unit.
//
// Filename: TSM_BodyJack2.scad
// By: David M. Flynn
// Created: 10/16/2019
// Revision: 1.2.3  2/13/2021
// Units: mm
// *************************************************
//  ***** Notes *****
// This is a 183:1 ratio compound planetary drive w/ sun gear. 
// Motor has 11 pole pairs for 66 counts per rotation of the motor, yielding 12,078 counts per rotation.
// Caution: Changing Ring gear OD part way thru printing will make things not fit.
//   Possible fix: Set bolt circles as constants.
// Can be built with 300° or continuous rotation.
// Can have home switch or quadrature encoder on Ring A. 
// Variant:  Gimbal motor GBM5208H-200T (60mm Dia. x 23mm, 0.038Nm Torque) from robotshop.com?
// 	AS5047D encoder 7 pole pairs.
//
// *************************************************
//  ***** History ******
//
// 1.2.3  2/13/2021 Added Com alignment tool and minor changes.
// 1.2.2  2/3/2021  Spacers!
// 1.2.1  1/31/2021 Increased backlash and clearance.
// 1.2   1/25/2021  Copied from TSM_BodyJack.scad, straight gears, smaller bearing and sun gear.
// 1.1.8 7/16/2020  InnerPlanetCarrier:Shifted bearing up 1mm. Helical gear version added.
// 1.1.7 7/11/2020  RingABearing() holes.
// 1.1.6 6/30/2020  New version: LifterLockCover2.
// 1.1.5 6/13/2020  Shortened RingA_Stop to 24.3, Added clearance to ring gear teeth, moving teeth out by 0.2mm.
// 1.1.4 1/25/2020  Standardizing dimensions. 
// 1.1.3 1/8/2020   Fixes for GM5208 motor.
// 1.1.2 12/29/2019 Motor mount w/ adjustable timing. 
// 1.1.1 12/28/2019 Added GM4008 motor variant. 
// 1.1.0 12/25/2019 Gimbal motor version. 
// 1.0.2 12/22/2019 Code cleanup.
// 1.0.1 12/24/2019 Adjusted Ring C bolts based on Ring A OD. Removed dead code.
// 1.0.0 12/23/2019 Modified Planets so teeth meet in the middle of the 1mm gap. Added encoder.
// 0.9.9 12/22/2019 Added HomeSwitchMount, 48:1 option.
// 0.9.8 12/20/2019 Everything but the optical switch mount. Added GearBacklash to planets. FC1
// 0.9.7 12/19/2019 Changed RingABearing bolt circle
// 0.9.6 12/17/2019 Little fixes, Stop on RingA
// 0.9.5 10/30/2019 Reduced teeth on pulley from 36 to 32
// 0.9.4 10/26/2019 Added RingC() Inner planet carrier support bearing
// 0.9.3 10/20/2019 Added Lifter parts.
// 0.9.2 10/19/2019 Fixed planet gear, added PlanetCarrierDrivePulley,
// 0.9.1 10/18/2019 Ready to print? no
// 0.9.0 10/16/2019 First code.
// *************************************************
//  ***** for STL output *****
// RingABearing();
// RingA(HasStop=true);
// RingA(HasStop=false); // for continuous rotation
// RingA_HomeFinderDisk();
// RingA_EncoderDisk(PPR=70); // Pulses per rotation / 8 = n.25, must end in ".25" or ".75", 90° appart
// HomeSwitchMount();
// HallSwitchMount();
// RingA_Stop(HasSkirt=true, HasStop=false, nSensors=0); 
// RingA_Stop(HasSkirt=true, HasStop=true, nSensors=1); // use skirt in dirty environments
// RingA_Stop(HasSkirt=true, HasStop=false, nSensors=2); // for continuous rotation
// rotate([180,0,]) InnerPlanetBearing();
//
// RingB(HasSkirt=true);
//
//  ***** Brushless Gimbal Motor w/ Encoder
// RingCSpacerGM(HasSkirt=true); // Plain for sensored motor
// RingCSpacerGM4008Com(); // hall switchs for 11 pole pairs
// RingCEncoderMount();
// RoundRingCGM();
// RingCGMCover();
//
//  ***** Planet carrier parts
// PlanetCarrierOuter();
// rotate([180,0,0]) PlanetCarrierSpacer();
// Planet();
// Planet(O_a=PlanetToothOffset_a); // Planet A ccw 1/3 tooth
// Planet(O_a=PlanetToothOffset_a*2); // Planet B ccw 2/3 tooth
// SunGear();
//
// GM5208MountingPlate(HasCommutatorDisk=true, ShowMotor=false); // commutation disc
//
// LifterSpline(); // Lifter Arm Assy lock on to this.
//
// ***** Connector Only *****
// BallLockRing();
//
// ***** Lifter Arm Assy *****
// rotate([180,0,0]) LifterLock(); // locking ring
// LifterLockCover(nSpokes=7); // part of the lifter arm
// FlangedBallLockRing(nSpokes=7);
// DogLeg(CD=150,Offset=15);
//
// TestFixture();
// *************************************************
//  ***** for Viewing *****
//  ShowBodyJack(Rot_a=20,HasSkirt=true);
//  ShowBodyJack(Rot_a=20,HasSkirt=false);
//  ShowPlanetCarrier();
//  ShowLifter();
//  ShowBodyJackGM(HasSkirt=true);
//  ShowGM5208Module();
// *************************************************

include<ShaftEncoder.scad>
include<Pulleys.scad>
include<BearingLib.scad>
include<ring_gear.scad>
include<involute_gears.scad>
include<SplineLib.scad>
include<CommonStuffSAEmm.scad>

$fn=$preview? 24:90;
Overlap=0.05;
IDXtra=0.2;
Bolt4Inset=4;

GearBacklash=0.45; // this needs to be adjusted for the filament/printer used, 0.2 to 0.4 recommended
GearClearance=0.3; // moves hub in on planets
RingGearClearance=0.3; // moves teeth back on ring gears
BearingPreload=-0.15; // (-0.15 w/ -0.35 RingA is too loose Gray 1.00) (0.00 w/ -0.35 is OK, Gray 1.00)
// was -0.35 too loose, easy to back drive, -0.5 is too loose printed @ 0.2mm

// 16:1 ratio with symetrical planet gears, could be 24:1 (Ring B = 46 teeth)
//  or 48:1 (Ring B = 47 teeth) with asymetrical planet gears
nPlanets=3;
Pressure_a=20;

/*
// 16:1 
GearBPitch=286.8965517241379;
RingBTeeth=45;
PlanetBTeeth=16;
PlanetATeeth=16;
GearAPitch=260;
RingATeeth=48; // output gear
PlanetToothOffset_a=0;
/**/

/*
// 48:1
GearBPitch=268.3870967741936;
RingBTeeth=47;
PlanetBTeeth=16;
PlanetATeeth=16;
GearAPitch=260;
RingATeeth=48; // output gear
nTeeth_Sun=15;
PlanetToothOffset_a=360/PlanetBTeeth/3;

Sun_r=GearAPitch*nTeeth_Sun/360;
PlanetA_r=GearAPitch*PlanetATeeth/360;
RingA_cr=Sun_r+PlanetA_r*2;
RingA_r=GearAPitch*RingATeeth/360;
echo(RingA_r=RingA_r);
echo(RingA_cr=RingA_cr);
/**/


//*
// 183:1 w/ sun gear
GearAPitch=280;
nTeeth_Sun=15;
PlanetATeeth=15;
RingATeeth=45; // output gear
GearBPitch=270.9677419354839;
RingBTeeth=46;
PlanetBTeeth=15;

PlanetToothOffset_a=360/PlanetBTeeth/nPlanets;
Sun_r=GearAPitch*nTeeth_Sun/360;
PlanetA_r=GearAPitch*PlanetATeeth/360;
RingA_cr=Sun_r+PlanetA_r*2;
RingA_r=GearAPitch*RingATeeth/360;
//echo(RingA_r=RingA_r);
//echo(RingA_cr=RingA_cr);
/**/

/*
// 705:1
GearBPitch=268;
RingBTeeth=47;
PlanetBTeeth=16;
PlanetATeeth=15;
RingATeeth=44; // output gear
GearAPitch=286.4827586206896;
PlanetToothOffset_a=0;
/**/

Gear_w=12; // was 18

RingA_pd=RingATeeth*GearAPitch/180;
PC_BC_d=RingA_pd-PlanetATeeth*GearAPitch/180;
Ring_B_cpd=PC_BC_d+PlanetBTeeth*GearBPitch/180;
//RingBTeeth=floor(Ring_B_cpd*180/GearBPitch);

// Planet rotations per motor rotations, aka planet carrier
P_Ratio=RingBTeeth/PlanetBTeeth;
// Planet A teeth per motor rotation
PBt=P_Ratio*PlanetATeeth;
// Ring A rotations per motor rotation
Rf=1/(1-RingATeeth/PBt);
//*
// uncomment to show gearing calculations
echo("Ratio = ",Rf);
echo("Ring A PD = ",RingA_pd);
echo("PC BC Dia = ",PC_BC_d);
echo("Calc'd Ring B PD = ",Ring_B_cpd);
echo("Ring B PD = ",RingBTeeth*GearBPitch/180);
echo("Ring B PD error =",Ring_B_cpd-RingBTeeth*GearBPitch/180);
/**/

/*
// big bearing R8ZZ 1/2 x 1-1/8 x 5/16
Bearing_OD=0.750*25.4; //1.125*25.4;
Bearing_ID=0.500*25.4;
Bearing_w=5/32*25.4; //0.3125*25.4;
/**/

// big bearing R1212ZZ 1/2 x 3/4 x 5/32
Bearing_OD=0.750*25.4;
Bearing_ID=0.500*25.4;
Bearing_w=4; // rounded

/*
// little bearing 6 x 13 x 5
sBearing_OD=13;
sBearing_ID=6;
sBearing_w=5;
/**/

// little bearing R188ZZ 6.35mm ID x 12.7mm OD x 4.7mm Thick
sBearing_OD=12.7;
sBearing_ID=6.35;
sBearing_w=6;

Tube_OD=12.7; // 1/2" Aluminum tubing

Ball_d=5/16 * 25.4;

WT_OD=5/16 * 25.4;

twist=200; // was 200

RingA_OD=RingATeeth*GearAPitch/180+GearAPitch/60;
RingA_Bearing_BallCircle=84; // was RingA_OD+Ball_d;
RingA_Bearing_ID=RingA_Bearing_BallCircle-Ball_d-Bolt4Inset*2;// was RingA_OD-7;
RingA_Bearing_OD=RingA_Bearing_BallCircle+Ball_d+5;

RingA_Bearing_Race_w=10;

PC_Axil_L=1*25.4; //1.5*25.4;
PC_End_d=Bolt4Inset*2+2;
PC_Spacer_d=25;
PC_spacer_l=40;

RingA_Major_OD=80;
EncDisk_d=RingA_Major_OD+11;
Encoder_r=EncDisk_d/2-2.75;
EncoderSw_r=Encoder_r+8.25; // Increased 12/29/2019 by 0.25 so it wont rub on the A ring.

LeverOffset=47;
LeverMount_L=50;
RingB_OD=RingBTeeth*GearBPitch/180+GearBPitch/60+1;
RingB_OD_Xtra=3;

RingB_BC_d=100;
RingC_BC_d=86; //was RingA_OD+RingB_OD_Xtra+Bolt4Inset*2; 

// GM5208 Motor data
GM5208_d=60;
GM5208_h=23.8; // includes 0.8mm mounting inset
GM5208RBC1_d=25; // rotor
GM5208RBC2_d=30;
GM5208SBC1_d=25; // stator
GM5208SBC2_d=30;
GM5208SBC3_d=44; // 7 holes 45 degrees appart, wire path at 8th position
GM5208_nPolePairs=11;
GM5208Comm_d=GM5208_d+13; // 1mm motor to Sw, 3mm Sw end to slot, 2.5mm slot to OD
GM5208CommSw_d=GM5208Comm_d+11; // C/L of slot d-5, Sw mounting surface is slot center +8mm 
GM5208_nSplines=4; // was 6
GM5208_Spline_d=20;
/* // 7 pole pair values
GM5208CommU_a=360/GM5208_nPolePairs*3;
GM5208CommV_a=360/GM5208_nPolePairs/3+360/GM5208_nPolePairs;
GM5208CommW_a=360/GM5208_nPolePairs/3*2+360/GM5208_nPolePairs*5;
/**/
GM5208CommU_a=360/GM5208_nPolePairs*2;
GM5208CommV_a=360/GM5208_nPolePairs/3+360/GM5208_nPolePairs*10;
GM5208CommW_a=360/GM5208_nPolePairs/3*2+360/GM5208_nPolePairs*0;



// GM4008 Motor data
GM4008_d=46.4;
GM4008_h=25.4;
GM4008RBC1_d=19;
GM4008RBC2_d=25;
GM4008SBC1_d=19;
GM4008SBC2_d=25;
GM4008_nPolePairs=11;
GM4008Comm_d=70;
GM4008CommSw_d=GM4008Comm_d+11;
GM4008_nSplines=4;
GM4008_Spline_d=20;
GM4008CommU_a=360/GM4008_nPolePairs*2;
GM4008CommV_a=360/GM4008_nPolePairs/3+360/GM4008_nPolePairs*10;
GM4008CommW_a=360/GM4008_nPolePairs/3*2+360/GM4008_nPolePairs*0;


module ShowBodyJackGM(Rot_a=180/RingATeeth,HasSkirt=true){
	translate([0,0,-14.5]) rotate([180,0,0]) RingABearing();
	rotate([0,0,Rot_a]) RingA();
	
	translate([0,0,-14.5]){ 
		RingA_Stop(HasSkirt=HasSkirt, HasStop=false, nSensors=2);
		translate([0,0,16.5]) RingA_EncoderDisk(PPR=70); 
	}
	
	translate([0,0,Gear_w+1])  RingB(HasSkirt=HasSkirt);
	
	
	if (HasSkirt==false) ShowPlanetCarrier(GMVersion=true);
	
	//translate([0,0,-24]) rotate([180,0,0]) ShowLifter();
	
	//*
	translate([0,0,58-21.5-9+0.5+Overlap]){
		RingCSpacerGMCom();
		rotate([0,0,360/nPolePairs*3]) translate([GM5208_d/2+10,0,9]) 
			rotate([0,0,-90]) rotate([-90,0,0]) HallSwitchMount();
		rotate([0,0,360/nPolePairs/3+360/nPolePairs]) translate([GM5208_d/2+10,0,9]) 
			rotate([0,0,-90]) rotate([-90,0,0]) HallSwitchMount();
		rotate([0,0,360/nPolePairs/3*2+360/nPolePairs*5]) translate([GM5208_d/2+10,0,9]) 
			rotate([0,0,-90]) rotate([-90,0,0]) HallSwitchMount();
		
		//translate([0,0,6+26]) rotate([0,0,22.5]) RoundRingCGM();
		//translate([0,0,6+26+4]) RingCEncoderMount();
		//translate([0,0,6+26+6+Overlap]) rotate([0,0,22.5]) RingCCover();
		
		translate([0,0,6+26+Overlap]) RingCCoverCom();
	}
	/**/
} // ShowBodyJackGM

//translate([0,0,Gear_w]) ShowBodyJackGM(HasSkirt=false);
//translate([0,0,Gear_w]) ShowBodyJackGM(HasSkirt=true);



// *********************************************************************************************
//  ***** Planet Carrier Parts *****
// *********************************************************************************************
//  ***** STL for 48:1 w/ 5208 motor *****
// SplineShaft(d=GM5208_Spline_d,l=4,nSplines=GM5208_nSplines,Spline_w=30,Hole=12.7+IDXtra,Key=false);
// PlanetCarrierSpacer();
// rotate([180,0,0]) Planet(O_a=0);
// rotate([180,0,0]) Planet(O_a=PlanetToothOffset_a);
// rotate([180,0,0]) Planet(O_a=PlanetToothOffset_a*2);

// Non-Harring Bone Gears
// rotate([180,0,0]) Planet(O_a=0, HBG=false);
// rotate([180,0,0]) Planet(O_a=PlanetToothOffset_a, HBG=false);
// rotate([180,0,0]) Planet(O_a=PlanetToothOffset_a*2, HBG=false);

// PlanetCarrierOuter(); // print 2
// *********************************************************************************************
//  ***** STL for 48:1 w/ 4008 motor *****
// SplineShaft(d=GM4008_Spline_d,l=4,nSplines=GM4008_nSplines,Spline_w=30,Hole=12.7+IDXtra,Key=false);
// PlanetCarrierSpacer();
// rotate([180,0,0]) Planet(O_a=0);
// rotate([180,0,0]) Planet(O_a=PlanetToothOffset_a);
// rotate([180,0,0]) Planet(O_a=PlanetToothOffset_a*2);
// PlanetCarrierOuter(); // print 2
// *********************************************************************************************
PC_Drv_L=15;

module ShowPlanetCarrier(){
	P_a=(RingATeeth/nPlanets)*(360/PlanetATeeth);
	
	translate([0,0,-Gear_w/2]) SunGear();
	
	for (j=[0:nPlanets-1]) rotate([0,0,-360/nPlanets*j]) translate([-PC_BC_d/2,0,0]) rotate([0,0,0]) Planet(O_a=PlanetToothOffset_a*j);
		
	//*
	
	translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+Overlap]){
			//PlanetCarrierInnerGimbalMotor();
			translate([0,0,11+Overlap]) rotate([180,0,0]) GM5208MountingPlate(HasCommutatorDisk=false, ShowMotor=false);}
	
	/**/
	translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+Overlap]) PlanetCarrierOuter();
	translate([0,0,Gear_w/2+0.5-PC_Axil_L/2]) PlanetCarrierSpacer();
	translate([0,0,Gear_w/2+0.5-PC_Axil_L/2-Overlap]) rotate([180,0,0]) PlanetCarrierOuter();
} // ShowPlanetCarrier

// ShowPlanetCarrier();

module ShowPlanetCarrierEXP(){
    EXP_Xa=25;
    EXP_Ya=0;
    
	P_a=(RingATeeth/nPlanets)*(360/PlanetATeeth);
    
	translate([0,0,85]) rotate([EXP_Xa,EXP_Ya,0]) color("LightBlue")
        SplineShaft(d=GM5208_Spline_d,l=4,nSplines=GM5208_nSplines,Spline_w=30,Hole=12.7+IDXtra,Key=false);
    translate([0,0,80]) rotate([EXP_Xa,EXP_Ya,0]) color("LightBlue") Spacer(Len=3);
    
    translate([-80,0,70]) rotate([EXP_Xa,EXP_Ya,0]) color("Tan") InnerPlanetBearing();
    translate([80,0,55]) rotate([EXP_Xa,EXP_Ya,0]) color("Tan") RingB(HasSkirt=true);
    translate([80,0,0]) rotate([EXP_Xa,EXP_Ya,0]) color("Tan") RingA();
    
    translate([-80,0,0]) rotate([EXP_Xa,EXP_Ya,0]) color("Tan")
        RingA_Stop(HasSkirt=true, HasStop=false, nSensors=1); // Drive wheel using motor commutation for position
    translate([-80,0,-10]) rotate([EXP_Xa,EXP_Ya,0]) color("Tan") rotate([180,0,0]) RingABearing();

    
	translate([0,0,65]) rotate([EXP_Xa,EXP_Ya,0]) color("LightBlue") Spacer(Len=2);
	
	for (j=[0:nPlanets-1]) translate([0,0,25]) rotate([EXP_Xa,EXP_Ya,0]) rotate([0,0,-360/nPlanets*j]) translate([-PC_BC_d/2,0,0])
      color("Green")  Planet(O_a=PlanetToothOffset_a*j);
		
	/*
	
	translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+Overlap]){
			//PlanetCarrierInnerGimbalMotor();
			translate([0,0,11+Overlap]) rotate([180,0,0]) GM5208MountingPlate(HasCommutatorDisk=false, ShowMotor=false);}
	
	/**/
	translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+Overlap+35]) rotate([EXP_Xa,EXP_Ya,0]) color("Gray") PlanetCarrierOuter();
	translate([0,0,Gear_w/2+0.5-PC_Axil_L/2+25]) rotate([EXP_Xa,EXP_Ya,0]) color("Gray") PlanetCarrierSpacer();
    
    translate([0,0,-Gear_w/2+5]) rotate([EXP_Xa,EXP_Ya,0]) color("Green") SunGear();
    
	translate([0,0,Gear_w/2+0.5-PC_Axil_L/2-Overlap]) rotate([EXP_Xa,EXP_Ya,0]) rotate([180,0,0]) color("Gray") PlanetCarrierOuter();
    
    translate([0,0,-20]) rotate([EXP_Xa,EXP_Ya,0]) color("LightBlue") Spacer(Len=2);
} // ShowPlanetCarrierEXP

//ShowPlanetCarrierEXP();

module Spacer(Len=2){
	difference(){
		cylinder(d=Tube_OD+4, h=Len);
		
		translate([0,0,-Overlap]) cylinder(d=Tube_OD+IDXtra,h=Len+Overlap*2);
	} // difference
	
} // Spacer

// Spacer(Len=2);
// Spacer(Len=2.7);
// Spacer(Len=4);

module GimbalMotor5208(){
	color("Gray")
			difference(){
				cylinder(d=GM5208_d,h=GM5208_h);
				translate([0,0,-Overlap]) cylinder(d=8,h=GM5208_h+Overlap*2);
			} // difference
} // GimbalMotor5208

module GimbalMotor4008(){
	color("Gray")
			difference(){
				cylinder(d=GM4008_d,h=GM4008_h);
				translate([0,0,-Overlap]) cylinder(d=8,h=GM4008_h+Overlap*2);
			} // difference
} // GimbalMotor5208

//GimbalMotor4008();

PC_Hub_h=Bearing_w+1.5;

//echo(PC_BC_d=PC_BC_d);
//echo(GearAPitch*nTeeth_Sun/180*2);

module PlanetCarrierOuter(Shaft_d=Tube_OD+IDXtra){
	Hub_h=PC_Hub_h;
	
	difference(){
		for (j=[0:nPlanets*2-1]) rotate([0,0,180/nPlanets*j]) hull(){
			translate([-PC_BC_d/2,0,0]) cylinder(d=PC_End_d,h=3);
			cylinder(d=20,h=Hub_h);
			} // hull
		
		// Tube
		//translate([0,0,-Overlap]) cylinder(d=Shaft_d,h=Hub_h+Overlap*2);
			
		//Bearing
		translate([0,0,-Overlap]) cylinder(d=Bearing_OD+IDXtra,h=Bearing_w+Overlap*2);
		translate([0,0,Bearing_w])	cylinder(d1=Bearing_OD+IDXtra,d2=Bearing_OD-1,h=0.5);
			cylinder(d=Bearing_OD-1,h=Hub_h+Overlap*2);
			

		
		// Planet bolts
		for (j=[0:nPlanets*2-1]) rotate([0,0,180/nPlanets*j]) translate([-PC_BC_d/2,0,4]) 
			Bolt4ButtonHeadHole();
			
	} // difference
} // PlanetCarrierOuter

//translate([0,0,Gear_w/2+0.5-PC_Axil_L/2-Overlap]) rotate([180,0,0]) PlanetCarrierOuter();

module PlanetCarrierSpacer(Shaft_d=Tube_OD+IDXtra){
	difference(){
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) hull(){
				translate([-PC_BC_d/2,0,0]) cylinder(d=PC_End_d,h=PC_Axil_L);
				cylinder(d=20,h=PC_Axil_L);
			} // hull
		
		// Cut-outs for planet gears
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,-Overlap]) 
			cylinder(d=30,h=PC_Axil_L+Overlap*2);
			
		// Bolt holes
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) translate([-PC_BC_d/2,0,0]) {
			rotate([180,0,0]) Bolt4Hole();
			translate([0,0,PC_Axil_L]) Bolt4Hole();
		} // for
		
		// Tube
		translate([0,0,-Overlap])  cylinder(d=Shaft_d+IDXtra*2,h=PC_Axil_L+Overlap*2);
		
		// Sun Gear
		translate([0,0,-Overlap]) cylinder(d=nTeeth_Sun*GearAPitch/180+5,h=Gear_w+1);
		
	} // difference
} // PlanetCarrierSpacer

//translate([0,0,Gear_w/2+0.5-PC_Axil_L/2]) PlanetCarrierSpacer();


module SunGear(){
	SunGear_w=Gear_w;
	SunGearTwist=-twist/nTeeth_Sun*(SunGear_w/Gear_w);
	
	difference(){
		gear(number_of_teeth=nTeeth_Sun,
			circular_pitch=GearAPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = GearClearance,
			gear_thickness=SunGear_w,
			rim_thickness=SunGear_w,
			rim_width=5,
			hub_thickness=SunGear_w,
			hub_diameter=15,
			bore_diameter=Tube_OD-1,
			circles=0,
			backlash=GearBacklash,
			twist=SunGearTwist,
			involute_facets=0,
			flat=false);

		// top
		translate([0,0,SunGear_w-2+Overlap])
			difference(){
				cylinder(d=30,h=2);
				translate([0,0,-Overlap]) cylinder(d1=27,d2=20.25,h=2+Overlap*2);
			}// difference
			
		// bottom
		translate([0,0,-Overlap])
			difference(){
				cylinder(d=30,h=2);
				translate([0,0,-Overlap]) cylinder(d2=27,d1=20.25,h=2+Overlap*2);
			}// difference
			
		// bore
		translate([0,0,-Overlap]) cylinder(d=Tube_OD+IDXtra,h=SunGear_w+Overlap*2);
	}// difference
} // SunGear
	
//translate([0,0,-Gear_w/2]) rotate([0,0,0]) SunGear();

module Planet(O_a=0){
	
	TrimValue=0.5;
	Cone_s=19.75;
	Cone_l=28.5;
	BearingXTra=0.4;
	
	difference(){
		union(){ // not Harring Bone Gears
			translate([0,0,-Gear_w/2])
			difference(){
			gear(number_of_teeth=PlanetATeeth,
				circular_pitch=GearAPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = GearClearance,
				gear_thickness=Gear_w,
				rim_thickness=Gear_w,
				rim_width=5,
				hub_thickness=Gear_w+1+Overlap,
				hub_diameter=20,
				bore_diameter=sBearing_OD-1,
				circles=0,
				backlash=GearBacklash,
				twist=twist/PlanetATeeth,
				involute_facets=0,
				flat=false);
				
				// top
				translate([0,0,Gear_w-2+Overlap])
				difference(){
					cylinder(d=30,h=2);
					translate([0,0,-Overlap]) cylinder(d1=Cone_l,d2=Cone_s,h=2+Overlap*2);
				} // difference
				
				// bottom
				translate([0,0,-Overlap])
				difference(){
					cylinder(d=30,h=2);
					translate([0,0,-Overlap]) cylinder(d2=Cone_l,d1=Cone_s,h=2+Overlap*2);
				} // difference
				
			} // difference
			
			translate([0,0,Gear_w/2+1]) rotate([0,0,O_a]) difference(){
				gear(number_of_teeth=PlanetBTeeth,
					circular_pitch=GearBPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = GearClearance,
					gear_thickness=Gear_w,
					rim_thickness=Gear_w,
					rim_width=5,
					hub_thickness=Gear_w,
					hub_diameter=15,
					bore_diameter=sBearing_OD-1,
					circles=0,
					backlash=GearBacklash,
					twist=twist/PlanetBTeeth,
					involute_facets=0,
					flat=false);

				// top
				translate([0,0,Gear_w-2+Overlap])
					difference(){
						cylinder(d=30,h=2);
						translate([0,0,-Overlap]) cylinder(d1=Cone_l,d2=Cone_s,h=2+Overlap*2);
					}// difference
					
				// bottom
				translate([0,0,-Overlap])
					difference(){
						cylinder(d=30,h=2);
						translate([0,0,-Overlap]) cylinder(d2=Cone_l,d1=Cone_s,h=2+Overlap*2);
					}// difference
			}// difference
		}
		
		//Trim Ends
		translate([0,0,-Gear_w/2-Overlap]) cylinder(d=Cone_l,h=TrimValue);
		translate([0,0,Gear_w*1.5+1-TrimValue]) cylinder(d=Cone_l,h=TrimValue+Overlap);

		if (O_a!=0) 
			rotate([0,0,O_a]) translate([-8.5,0,Gear_w*1.5]) cylinder(d=2,h=2);

		// Bearings
		translate([0,0,-Gear_w/2-Overlap]) cylinder(d=sBearing_OD+IDXtra,h=sBearing_w+BearingXTra+Overlap);
		translate([0,0,Gear_w+Gear_w/2+1-sBearing_w-BearingXTra]) cylinder(d=sBearing_OD+IDXtra,h=sBearing_w+BearingXTra+Overlap);
	} // difference
} // Planet

//for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,0]) rotate([0,0,180/PlanetBTeeth]) Planet(O_a=PlanetToothOffset_a*j);
//Planet(O_a=PlanetToothOffset_a);
// Planet(O_a=0);
//cylinder(d=13,h=50);
	
// *************************************************************************************
//  ***** Ring A, drive ring and bearing *****
// *************************************************************************************
//  ***** STL for 48:1 GM5208 *****
// RingA(HasStop=false);
// RingA(HasStop=false, HBG=false); // Harring Bone Gear = false >> Hielical Gear
// RingA_Stop(HasSkirt=true, HasStop=false, nSensors=1); // Drive wheel using motor commutation for position
// RingABearing();
//
// RingA_HomeFinderDisk(); // or
// RingA_EncoderDisk(PPR=70);
//
// HomeSwitchMount();
// *************************************************************************************
//  ***** STL for 48:1 GM4008 *****
// RingA(HasStop=false);
// RingA_Stop(HasSkirt=true, HasStop=false, nSensors=1); // Drive wheel using motor commutation for position
// RingABearing();
//
// RingA_HomeFinderDisk(); // or
// RingA_EncoderDisk(PPR=70);
//
// HomeSwitchMount();
// *************************************************************************************

RingABearingMountingRing_t=3;

module RingABearing(){
	OnePieceOuterRace(BallCircle_d=RingA_Bearing_BallCircle, Race_OD=RingA_Bearing_OD, Ball_d=Ball_d, 
			Race_w=RingA_Bearing_Race_w, PreLoadAdj=BearingPreload, VOffset=0.50, BI=true, myFn=$preview? 60:720);
	
	
	RingABearingMountingRing_BC_d=104;
	RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;
	nBolts=8;
	
	difference(){
		union(){
			cylinder(d=RingABearingMountingRing_d,h=RingABearingMountingRing_t);
			
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				
				translate([RingABearingMountingRing_BC_d/2-Bolt4Inset,0,0])
					cylinder(d=Bolt4Inset*2+2,h=RingABearingMountingRing_t);
				translate([RingABearingMountingRing_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=RingABearingMountingRing_t);
			}
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_OD-1,h=RingABearingMountingRing_t+Overlap*2);
		
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j])
			translate([RingABearingMountingRing_BC_d/2,0,RingABearingMountingRing_t+3])
				Bolt4ClearHole();
	} // difference
} // RingABearing

//translate([15-0.5,0,0]) rotate([0,90,0]) RingABearing();

//rotate([180,0,0]) RingABearing();

module RingA_Stop(HasSkirt=false, HasStop=true, nSensors=2){
	// Connects RingA bearing to RingB
	RingABearingMountingRing_BC_d=104;
	RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;
	nBolts=8;
	PostToRingB_h=15.5;
	
	module OptoMountPlate(Z=20){
		hull(){
			translate([2.5,-20,0]) cube([2,40,Z]);
			translate([0,-12,0]) cube([4,24,Z]);
		} // hull
	} // OptoMount
	
	
	difference(){
		union(){
			// lower ring
			cylinder(d=RingABearingMountingRing_d-6,h=RingABearingMountingRing_t);
			
			//skirt
			if (HasSkirt==true)
			difference(){
				cylinder(d=RingB_BC_d,h=PostToRingB_h);
				
				translate([0,0,-Overlap]) cylinder(d=RingB_BC_d-4,h=PostToRingB_h+Overlap*2);
			} // difference
			
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				
				translate([RingB_BC_d/2,0,PostToRingB_h-7])
					cylinder(d=Bolt4Inset*2,h=7);
				translate([RingABearingMountingRing_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=7);
			} // for
			
			// Optical sensor mount
			if (nSensors>0)
				rotate([0,0,22.5]) translate([-EncoderSw_r,0,0]) OptoMountPlate(Z=PostToRingB_h);
			if (nSensors==2) rotate([0,0,-22.5]) 
				translate([-EncoderSw_r,0,0]) OptoMountPlate(Z=PostToRingB_h);
		} // union
		
		// lower inside
		translate([0,0,-Overlap]) cylinder(d=EncDisk_d+0.5,h=RingABearingMountingRing_t+Overlap*2);
		
		// Optical sensor mount
		if (nSensors>0)
			rotate([0,0,22.5]) translate([-EncoderSw_r-3-Overlap,0,0])  rotate([180,180,0]) HallOptoMountHoles(Disk_CL=PostToRingB_h-3); 
		if (nSensors==2) rotate([0,0,-22.5]) 
			translate([-EncoderSw_r-Overlap,0,0]) rotate([180,180,0]) HallOptoMountHoles(Disk_CL=PostToRingB_h-3);
			
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]){
			translate([RingABearingMountingRing_BC_d/2,0,0])
				rotate([180,0,0]) Bolt4Hole();
			translate([RingB_BC_d/2,0,PostToRingB_h]) Bolt4Hole();
		}
	} // difference
	
	//Stop_z=-5.5;
	
	if (HasStop==true)
	// hard stop
		rotate([0,0,22.5]){
			// gusset
			hull(){
				translate([RingA_Major_OD/2+7,-14,0]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,14,0]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,-3,PostToRingB_h-11]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,3,PostToRingB_h-11]) cylinder(d=3,h=1);
			} // hull
			// stop
			hull(){
				translate([RingA_Major_OD/2+1,0,0]) scale([0.2,1,1]) cylinder(d=8,h=PostToRingB_h-10);
				translate([RingA_Major_OD/2+7,0,0]) scale([0.2,1,1]) cylinder(d=8,h=PostToRingB_h-10);
				//translate([RingA_Major_OD/2+9,0,0]) scale([0.3,1,1]) #cylinder(d=8,h=1);
			} // hull
		} // if
	
} // RingA_Stop

// translate([0,0,-Gear_w/2-1-PC_Hub_h-Bearing_w-2-Overlap+RingA_Bearing_Race_w]) RingA_Stop(HasSkirt=true, HasStop=true, nSensors=1);
//translate([0,0,-Gear_w/2-1-PC_Hub_h-Bearing_w-2-Overlap*2+RingA_Bearing_Race_w]) rotate([180,0,0]) RingABearing();

/*
RingA_Stop(HasSkirt=false, HasStop=true, nSensors=2);
translate([0,0,Gear_w/2+6]) rotate([0,0,10]) RingA();
//rotate([180,0,0]) RingABearing();
//translate([0,0,Gear_w+16]) ScrewMountRingB();
translate([0,0,Gear_w/2+6+2]) RingA_HomeFinderDisk();
//translate([0,0,60]) rotate([180,0,0]) RoundRingC();
/**/


module RingA(HasStop=true){
	nSpokes=7;
	EncDiscFaceOffset=12.6; // "A" bearing face to encoder disc face.
	BearingFaceOffset=Gear_w/2+1+PC_Hub_h+Bearing_w+2; // Center of Ring A Gear to bearing face.
	
	RingAGear_w=BearingFaceOffset-RingA_Bearing_Race_w+Gear_w/2;
	RingATwist=twist/RingATeeth*(RingAGear_w/Gear_w);

	translate([0,0,-BearingFaceOffset+RingA_Bearing_Race_w-Overlap])
		ring_gear(number_of_teeth=RingATeeth,
			circular_pitch=GearAPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = RingGearClearance,
			gear_thickness=RingAGear_w,
			rim_thickness=RingAGear_w,
			rim_width=2,
			backlash=GearBacklash,
			twist=RingATwist,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
		
	RingA_Teeth_ID=RingATeeth*GearAPitch/180-GearAPitch/90;
	
	
	//*
	// Encoder or home disc sits here
	translate([0,0,-BearingFaceOffset+RingA_Bearing_Race_w-Overlap])
		difference(){
			union(){
				cylinder(d1=RingA_OD,d2=RingA_Major_OD,h=EncDiscFaceOffset);
				cylinder(d=RingA_Major_OD-2,h=BearingFaceOffset-RingA_Bearing_Race_w+Gear_w/2);
			} // union
			
			translate([0,0,-Overlap]) cylinder(d=RingA_OD, h=BearingFaceOffset-RingA_Bearing_Race_w+Gear_w/2+Overlap*4);
		} // difference
	/**/

	/*
	// Skirt connecting bearing to gear
	translate([0,0,-BearingFaceOffset+RingA_Bearing_Race_w-Overlap])
		difference(){
			Skirt_OD=RingA_Bearing_BallCircle-Ball_d*0.7;
			cylinder(d1=Skirt_OD, d2=RingA_Major_OD, h=2+Overlap*2);
			
			translate([0,0,-Overlap]) cylinder(d1=Skirt_OD-7, d2=RingA_Teeth_ID, h=6+Overlap*4);
		} // difference
		/**/
	
	// Planet carrier bearing mount
	translate([0,0,-BearingFaceOffset])
	difference(){
		union(){
			translate([0,0,RingA_Bearing_Race_w]) rotate([180,0,0])
			OnePieceInnerRace(BallCircle_d=RingA_Bearing_BallCircle,	Race_ID=RingA_Bearing_ID,	
				Ball_d=Ball_d, Race_w=RingA_Bearing_Race_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=$preview? 60:720);

			 cylinder(d=Bearing_OD+6,h=Bearing_w+2);
			
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]){
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=6,h=RingA_Bearing_Race_w);
				
					hull(){
					translate([Bearing_OD/2+3,0,0]) rotate([0,0,45]) cylinder(d=2,h=Bearing_w+2,$fn=4);
					translate([RingA_Bearing_ID/2+1,0,0]) rotate([0,0,45]) cylinder(d=2,h=Bearing_w+2,$fn=4);
				} // hull
			} // for
		} // union
		//Bearing_OD=1.125*25.4;
		//Bearing_ID=0.500*25.4;
		//Bearing_w=0.3125*25.4;

		translate([0,0,-Overlap]) cylinder(d=Bearing_OD-1,h=3);
		translate([0,0,2]) cylinder(d=Bearing_OD,h=Bearing_w+1);
		
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) 
			translate([RingA_Bearing_ID/2,0,0]) rotate([180,0,0]) Bolt4Hole();
	} // difference
	
	// hard stop
	Stop_z=-0.5-5.5;
	if (HasStop==true)
		difference(){
			hull(){
				translate([RingA_Major_OD/2+2,0,Stop_z]) scale([0.2,1,1]) cylinder(d=8,h=4);
				translate([RingA_Major_OD/2-2,0,Stop_z]) cylinder(d=8,h=4);
				translate([RingA_Major_OD/2-4,0,Stop_z-5]) cylinder(d=4,h=1);
			} // hull
			
			translate([0,0,Stop_z-6]) cylinder(d=RingA_Major_OD-4,h=16);
		} // difference
	
} // RingA

// rotate([0,0,180/RingATeeth+7]) RingA(HasStop=true);
// translate([0,0,Gear_w/2+0.5-PC_Axil_L/2-Overlap]) rotate([180,0,0]) PlanetCarrierOuter();

// translate([0,0,-Gear_w/2-1-PC_Hub_h-Bearing_w-2-Overlap+RingA_Bearing_Race_w]) rotate([180,0,0]) RingABearing();

module RingA_HomeFinderDisk(){
	Thickness=1.5;
	
	difference(){
		cylinder(d=EncDisk_d,h=Thickness);
		
		// on 180°, off 180°
		difference(){
			translate([-RingA_Major_OD/2-10,0,-Overlap]) cube([RingA_Major_OD+20,RingA_Major_OD+20,Thickness+Overlap*2]);
			translate([0,0,-Overlap*2]) cylinder(d=RingA_Major_OD+4,h=Thickness+Overlap*4);
		} // difference
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=RingA_Major_OD-2+IDXtra*2,h=Thickness+Overlap*2);
	} // difference
	
} // RingA_HomeFinderDisk

// translate([0,0,Gear_w/2-1.9+Overlap]) RingA_HomeFinderDisk();


module RingA_EncoderDisk(PPR=100){
	Thickness=1.5;
	
	OuterBC_r=EncDisk_d/2-1.5;
	OuterBC_Hole_d=OuterBC_r*PI/PPR;
	InnerBC_r=EncDisk_d/2-4;
	InnerBC_Hole_d=InnerBC_r*PI/PPR;
	
	difference(){
		cylinder(d=EncDisk_d,h=Thickness);
		
		for (j=[0:PPR-1]) rotate([0,0,360/PPR*j]){
			
			hull(){
			translate([OuterBC_r,0,-Overlap]) {
				translate([0,OuterBC_Hole_d/2-0.5,0]) cylinder(d=1,h=Thickness+Overlap*2,$fn=18);
				translate([0,-OuterBC_Hole_d/2+0.5,0]) cylinder(d=1,h=Thickness+Overlap*2,$fn=18);
				}
				
			translate([InnerBC_r,0,-Overlap]) {
				translate([0,InnerBC_Hole_d/2-0.5,0]) cylinder(d=1,h=Thickness+Overlap*2,$fn=18);
				translate([0,-InnerBC_Hole_d/2+0.5,0]) cylinder(d=1,h=Thickness+Overlap*2,$fn=18);		
				}
			} // hull	
		} // for
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=RingA_Major_OD-2+IDXtra,h=Thickness+Overlap*2);
	} // difference
	
	if ($preview==true){
			rotate([0,0,45]) translate([0,EncDisk_d/2+1,0]) cylinder(d=1,h=1);
			translate([0,EncDisk_d/2+1,0]) cylinder(d=1,h=1);
		}
} // RingA_EncoderDisk

//translate([0,0,Gear_w/2+6+2+Overlap]) RingA_EncoderDisk(PPR=70);

module SwitchHoles(T=3){
	X=5.42+IDXtra;
	Y=4.53+IDXtra;
	Y1=5.5;
	Y2=13.4;
	
	translate([0,0,T]) Bolt4Hole();
	translate([-X/2,Y1-Y/2,-Overlap]) cube([X,Y,T+Overlap*2]);
	translate([-X/2,Y2-Y/2,-Overlap]) cube([X,Y,T+Overlap*2]);
} // SwitchHoles

// ***********************************************************************************************
//  ***** Ring B, Stationary ring gear *****
// ***********************************************************************************************
//  ***** STL for GM4008/GM5208 *****
// rotate([180,0,0]) InnerPlanetBearing();
// RingB(HasSkirt=true);
// ***********************************************************************************************

module InnerPlanetBearing(){
	// 7/16/2020 Shifted bearing up 1mm
	nBolts=8;
	BoltBossB_h=6;
	Skirt_h=PC_Hub_h+Bearing_w+2;
	Skirt_ID=GM5208Comm_d+1.5;
	
	difference(){
		union(){
			cylinder(d=RingB_OD+RingB_OD_Xtra,h=Skirt_h);
			
			// Ring B bolt bosses
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingB_OD/2,0,0])
						cylinder(d=Bolt4Inset*2+2,h=Skirt_h);
				translate([RingC_BC_d/2,0,0]) cylinder(d=Bolt4Inset*2,h=Skirt_h);
			} // hull
			
			// Ring C bolt bosses
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+22.5]) hull(){
				translate([RingB_OD/2,0,Skirt_h-BoltBossB_h])
						cylinder(d=Bolt4Inset*2+2,h=BoltBossB_h);
				translate([RingC_BC_d/2,0,Skirt_h-BoltBossB_h]) cylinder(d=Bolt4Inset*2,h=BoltBossB_h);
				translate([(RingB_OD+RingB_OD_Xtra)/2,0,3]) sphere(d=6,$fn=12);
			} // hull
		} // union
		
		// Bolts to Ring B
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,BoltBossB_h])
				Bolt4HeadHole(lHead=Skirt_h);

		// Bolts to Rinc C, Motor
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+22.5]) translate([RingC_BC_d/2,0,Skirt_h])
				Bolt4Hole(depth=8);
		
		// remove inside
		translate([0,0,-Overlap]) cylinder(d=Skirt_ID,h=Skirt_h+Overlap*2);
	} // difference
	
	nSpokes=7;
	
	// Planet carrier bearing mount
	
	difference(){
		union(){
			 translate([0,0,Skirt_h-(Bearing_w+1)]) cylinder(d=Bearing_OD+6,h=Bearing_w+1);
			
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
					translate([Bearing_OD/2+3,0,Skirt_h-(Bearing_w+1)]) rotate([0,0,45]) cylinder(d=2,h=Bearing_w+1,$fn=4);
					translate([RingB_OD/2,0,Skirt_h-(Bearing_w+2)]) rotate([0,0,45]) cylinder(d=2,h=Bearing_w+2,$fn=4);
				} // hull
			
		} // union
		//Bearing_OD=1.125*25.4;
		//Bearing_ID=0.500*25.4;
		//Bearing_w=0.3125*25.4;

		translate([0,0,Skirt_h-2]) cylinder(d=Bearing_OD-1,h=3);
		translate([0,0,Skirt_h-(Bearing_w+1)-Overlap]) cylinder(d=Bearing_OD,h=Bearing_w+Overlap*2);
		
	} // difference
		
} // InnerPlanetBearing

//translate([0,0,Gear_w*1.5+1.0+Overlap])  InnerPlanetBearing();

module RingB_Gear(){
	// Stationary Ring Gear
	// 12/17/2019 added RingB_OD_Xtra to thicken ring gear
	
	
		translate([0,0,-Gear_w/2])
		ring_gear(number_of_teeth=RingBTeeth,
			circular_pitch=GearBPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = RingGearClearance,
			gear_thickness=Gear_w,
			rim_thickness=Gear_w,
			rim_width=2,
			backlash=GearBacklash,
			twist=twist/RingBTeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
	

	translate([0,0,-Gear_w/2])
	difference(){
		cylinder(d=RingB_OD+RingB_OD_Xtra,h=Gear_w);
		
		translate([0,0,-Overlap]) cylinder(d=RingB_OD,h=Gear_w+Overlap*2);
	} // difference
} // RingB_Gear

//translate([0,0,Gear_w+16]) RingB_Gear();

module RingB(HasSkirt=false, nSensors=0){
	nBolts=8;

	RingB_Gear();
	
	module OptoMountPlate(Z=20){
		hull(){
			translate([2.5,-20,0]) cube([4,40,Z]);
			translate([0,-12,0]) cube([4,24,Z]);
		} // hull
	} // OptoMount
	
	translate([0,0,-Gear_w/2])
	difference(){
		union(){
			// bolt bosses to ring C
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingB_OD/2,0,Gear_w/2])
					cylinder(d=Bolt4Inset*2+2,h=Gear_w/2);
				translate([RingC_BC_d/2,0,Gear_w/2])
					cylinder(d=Bolt4Inset*2,h=Gear_w/2);
			}
			
			// bolt bosses to ring A
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				
				translate([RingB_OD/2,0,0])
					cylinder(d=Bolt4Inset*2+2,h=Gear_w/2);
				translate([RingB_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=Gear_w/2);
			}
			
			if (HasSkirt==true)
				difference(){
					cylinder(d1=RingB_BC_d,d2=RingB_OD+RingB_OD_Xtra,h=Gear_w);
					
					translate([0,0,-Overlap]) cylinder(d1=RingB_BC_d-4,d2=RingB_OD+RingB_OD_Xtra-4,h=Gear_w+Overlap*2);
				} // difference
				
			// Optical sensor mount
			if (nSensors>0)
				rotate([0,0,22.5]) translate([-EncoderSw_r,0,0]) OptoMountPlate(Z=Gear_w/2);
			if (nSensors==2) rotate([0,0,-22.5]) 
				translate([-EncoderSw_r,0,0]) OptoMountPlate(Z=Gear_w/2);
		} // union
		
		// Optical sensor mount
		if (nSensors>0)
			rotate([0,0,22.5]) translate([-EncoderSw_r-5-Overlap,0,0])  rotate([180,180,0]) HallOptoMountHoles(Disk_CL=-3); 
		if (nSensors==2) rotate([0,0,-22.5]) 
			translate([-EncoderSw_r-5-Overlap,0,0]) rotate([180,180,0]) HallOptoMountHoles(Disk_CL=-3);


		// remove inside
		translate([0,0,-Overlap]) cylinder(d=RingB_OD,h=Gear_w+Overlap*2);
		
		// bolts to ring A
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) 
			translate([RingB_BC_d/2,0,Gear_w/2]) Bolt4HeadHole(depth=Gear_w);
		
		// bolts to Ring C
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) 
			translate([RingC_BC_d/2,0,Gear_w]) Bolt4Hole(depth=Gear_w);
	} // difference
	
} // RingB

//translate([0,0,Gear_w+1]) RingB(HasSkirt=true, nSensors=1);
//RingB(HasSkirt=true);
//translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+Overlap]) PlanetCarrierOuter();

// ****************************************************************************************************
//  ***** Ring C, Motor mount, Commutator disk, end bearing support *****
//  ***** Used with a brushless gimbal motor (4008/5208) and "Hall switch" disk *****
// ****************************************************************************************************
//  ***** STL for 48:1 GM5208 *****
// RingCGMCover();
// CommutatorAlignmentTool();
// rotate([180,0,0])RingCMtrMountGM5208Com();
// RingCCoverGM5208Com();
// RingCSpacerGM5208Com();
//
// GM5208MountingPlate(HasCommutatorDisk=true); // Commutator, simulates hall switches
//
// HallSwitchMount(); // print 3
// ****************************************************************************************************
//  ***** STL for 48:1 GM4008 *****
// RingCGMCover();
// rotate([180,0,0])RingCMtrMountGM4008Com();
// RingCCoverGM4008Com();
// RingCSpacerGM4008Com();
//
// GM4008MountingPlate(HasCommutatorDisk=true); // Commutator, simulates hall switches
//
// HallSwitchMount(); // print 3
// ****************************************************************************************************

module TopAssy4008(){
	translate([0,0,46]) RingCGMCover();
	translate([0,0,36]) RingCMtrMountGM4008Com();
	translate([0,0,36])  RingCCoverGM4008Com();
	RingCSpacerGM4008Com();
	
} // TopAssy4008

//TopAssy4008();

module ShowGM5208Module(){
	translate([0,0,110]) RingCGMCover();
	translate([0,0,90]) RingCMtrMountGM5208Com();
	translate([0,0,80]) RingCCoverGM5208Com();
	
	translate([0,0,50]) GimbalMotor5208();
	
	translate([0,0,40]) rotate([180,0,0]) GM5208MountingPlate(HasCommutatorDisk=true, ShowMotor=false);
	RingCSpacerGM5208Com();
	translate([0,0,-20]) PlanetCarrierInnerGM5208();
	
} // ShowGM5208Module

//ShowGM5208Module();

module HallSwitchMount(T=3){
	BoltOffset_X=6;
	BoltOffset_Y=5;
	X=BoltOffset_X*2+Bolt4Inset*2;
	Y=BoltOffset_Y*2+Bolt4Inset*2+1;
	
	difference(){
		hull(){
			translate([-BoltOffset_X,-BoltOffset_Y-2,0]) cylinder(d=8,h=T);
			translate([-BoltOffset_X,BoltOffset_Y,0]) cylinder(d=8,h=T);
			translate([BoltOffset_X,-BoltOffset_Y-2,0]) cylinder(d=8,h=T);
			translate([BoltOffset_X,BoltOffset_Y,0]) cylinder(d=8,h=T);
		} // hull
		
		translate([-BoltOffset_X,-BoltOffset_Y,T]) Bolt4ClearHole();
		translate([-BoltOffset_X,BoltOffset_Y,T]) Bolt4ClearHole();
		translate([BoltOffset_X,-BoltOffset_Y,T]) Bolt4ClearHole();
		translate([BoltOffset_X,BoltOffset_Y,T]) Bolt4ClearHole();

		translate([0,-BoltOffset_Y-2.5,0]) SwitchHoles(T);
	} // difference
} // HallSwitchMount

// HallSwitchMount();

	module HallOptoMountPlate(Z=20,Label="W"){
		Width=20;
		
		difference(){
			hull(){
				translate([-1,-Width/2+1,0]) cylinder(d=2,h=Z);
				translate([-1,Width/2-1,0]) cylinder(d=2,h=Z);
				translate([-6,-Width/2,0]) cube([1,Width,Z]);
			} // hull
			
			translate([0,0,Z-6]) rotate([0,90,0]) rotate([0,0,90])
				linear_extrude(1,center=true) text(Label,size=8 ,halign="center",valign="center");
		} // difference
	} // HallOptoMountPlate
	
	module HallOptoMountHoles(Disk_CL=13){
		Bolt_Y=6;
		hull(){
			translate([+Overlap,0,Disk_CL+9]) rotate([0,-90,0]) cylinder(d=7,h=12+Overlap);
			translate([-12,-3.5,Disk_CL-6.5]) cube([12+Overlap,7,Overlap]); //cylinder(d=7,h=12);
		} // hull
		translate([0,-Bolt_Y,Disk_CL-3]) rotate([0,90,0]) Bolt4Hole(depth=20);
		translate([0,Bolt_Y,Disk_CL-3]) rotate([0,90,0]) Bolt4Hole(depth=20);
		translate([0,-Bolt_Y,Disk_CL+7]) rotate([0,90,0]) Bolt4Hole(depth=20);
		translate([0,Bolt_Y,Disk_CL+7]) rotate([0,90,0]) Bolt4Hole(depth=20);
	} // HallOptoMountHoles
	
//	HallOptoMountHoles();
	
RingC_BC_GM4008Twist_a=-2.0;
RingC_BC_GM5208Twist_a=-2.0;
	
module RingCGMCover(){
	// Cover w/ wire exit and wire guide tube holder
	nBolts=8;
	RingC_d=RingC_BC_d-Bolt4Inset*2;
	RingC_h=6;
	Cover_h=16;
	
	// basic ring with wire path
	difference(){
		union(){
			cylinder(d=RingC_d,h=RingC_h);
			
			// bolt bosses to ring C
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingC_d/2-2,0,0])
					cylinder(d=Bolt4Inset*2+2,h=RingC_h);
				translate([RingC_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=RingC_h);
			} // hull
		} // union
		
		// Remove extra thickness
		translate([0,0,-Overlap]) cylinder(d=RingC_d-4,h=RingC_h+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,RingC_h])
			Bolt4HeadHole();
		
		// Wire path
		hull(){
			translate([0,0,5]) rotate([90,0,22.5]) cylinder(d=5,h=RingC_d);
			translate([0,0,4]) rotate([90,0,22.5]) cylinder(d=5,h=RingC_d);
		} // hull

	} // difference
	
	// top decoration
	difference(){
		union(){
			cylinder(d=RingC_d,h=3);
			translate([0,0,3]) cylinder(d1=RingC_d-4+Overlap,d2=35, h=Cover_h-6);
			
			cylinder(d=35,h=Cover_h);
			
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingC_d/2-2,0,2]) {
					cylinder(d=4,h=RingC_h-2);
					translate([0,0,RingC_h-2]) sphere(d=4);}
				translate([35/2,0,Cover_h-RingC_h+2]) {
					cylinder(d=4,h=RingC_h-2);
					translate([0,0,RingC_h-2]) sphere(d=4);}
			} // hull
			
			// Wire path
		hull(){
			translate([0,0,5]) rotate([90,0,22.5]) cylinder(d=8,h=RingC_d/2);
			translate([0,0,4]) rotate([90,0,22.5]) cylinder(d=8,h=RingC_d/2);
		} // hull
		} // union
		
		// Remove extra thickness
		translate([0,0,-Overlap]) cylinder(d=RingC_d-4,h=1+Overlap);
		translate([0,0,1-Overlap]) cylinder(d1=RingC_d-4,d2=35-5,h=Cover_h-5);
		cylinder(d=35-5,h=Cover_h-3);
		
		// Wire path
		hull(){
			translate([0,0,5]) rotate([90,0,22.5]) cylinder(d=5,h=RingC_d);
			translate([0,0,4]) rotate([90,0,22.5]) cylinder(d=5,h=RingC_d);
		} // hull
	} // difference
	
	// wire tube support
	
	difference(){
		union(){
			translate([0,0,3]) cylinder(d=WT_OD+6,h=Cover_h-3);
			
			// ribs
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingC_d/2-2,0,2]) cylinder(d=4,h=RingC_h-2);
				translate([0,0,3]) cylinder(d=4,h=Cover_h-4);
				translate([35/2-4,0,3]) cylinder(d=4,h=Cover_h-4);
					
			} // hull
		} // union
		
		cylinder(d=WT_OD,h=7);
		cylinder(d=WT_OD-1,h=Cover_h-3);
		translate([0,0,Cover_h-6]) rotate([90,0,22.5]) cylinder(d=5,h=12);
	} // difference
} // RingCGMCover

//translate([0,0,7]) RingCGMCover();

PC_InnerGM4008_h=3;

module RingCSpacerGM4008Com(){
	nBolts=8;
	BoltBossB_h=6;
	Spacer_h=GM4008MP_h+PC_InnerGM4008_h+GM4008_h+0.5; // xtra 0.5 is a little extra space
	//echo(Spacer_h=Spacer_h);
	//echo(GM4008_h=GM4008_h);
	Encoder_z=Spacer_h-GM4008_h-13; // hole pattern offest from top, adjusted -0.4 1/8/2020
	nPolePairs=GM4008_nPolePairs;
	
	difference(){
		union(){
			cylinder(d=RingB_OD+RingB_OD_Xtra,h=BoltBossB_h+Overlap);
				
			// Ring B bolt bosses
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+RingC_BC_GM4008Twist_a]) hull(){
				translate([RingB_OD/2,0,0])
						cylinder(d=Bolt4Inset*2+2,h=BoltBossB_h);
				translate([RingC_BC_d/2,0,0]) cylinder(d=Bolt4Inset*2,h=BoltBossB_h);
			} // hull
			
			// RingC bolt bosses
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j-RingC_BC_GM4008Twist_a]) hull(){
					translate([RingB_OD/2,0,Spacer_h-8]) cylinder(d=Bolt4Inset*2+2,h=8);
					translate([RingB_OD/2-1,0,8]) cylinder(d=4,h=BoltBossB_h);
				
				translate([RingC_BC_d/2,0,Spacer_h-8]) cylinder(d=Bolt4Inset*2,h=8);
			} // hull
			
			// Skirt
			difference(){
				translate([0,0,BoltBossB_h])
					cylinder(d1=RingB_OD+RingB_OD_Xtra,d2=RingC_BC_d-Bolt4Inset*2,h=Spacer_h-BoltBossB_h);
				translate([0,0,BoltBossB_h-Overlap])
					cylinder(d1=RingB_OD+RingB_OD_Xtra-4,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);
			} // difference
			
			// Opto switch mounting plates
			rotate([0,0,GM4008CommU_a])
				translate([GM4008CommSw_d/2,0,0])  HallOptoMountPlate(Z=Spacer_h,Label="U");
			rotate([0,0,GM4008CommV_a])
				translate([GM4008CommSw_d/2,0,0])  HallOptoMountPlate(Z=Spacer_h,Label="V");
			rotate([0,0,GM4008CommW_a])
				translate([GM4008CommSw_d/2,0,0])  HallOptoMountPlate(Z=Spacer_h,Label="W");
		} // union
		
		// Opto switches for commutation
		rotate([0,0,GM4008CommU_a])
			translate([GM4008CommSw_d/2,0,Encoder_z])  HallOptoMountHoles();
		rotate([0,0,GM4008CommV_a])
			translate([GM4008CommSw_d/2,0,Encoder_z])  HallOptoMountHoles();
		rotate([0,0,GM4008CommW_a]) 
			translate([GM4008CommSw_d/2,0,Encoder_z])  HallOptoMountHoles();
		
		// Bolts to Ring B
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+RingC_BC_GM4008Twist_a]) translate([RingC_BC_d/2,0,BoltBossB_h])
				Bolt4HeadHole(lHead=7);
		
		// Bolts to Ring C
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j-RingC_BC_GM4008Twist_a]) translate([RingC_BC_d/2,0,Spacer_h])
				Bolt4Hole();
	
		// center hole
			translate([0,0,-Overlap]) cylinder(d=RingB_OD+RingB_OD_Xtra-4,h=BoltBossB_h+Overlap);
			translate([0,0,BoltBossB_h-Overlap]) 
				cylinder(d1=RingB_OD+RingB_OD_Xtra-4,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);
	} // difference
	
	// Commutation sensor positions
	if ($preview==true) {
		rotate([0,0,GM4008CommU_a]) translate([GM4008CommSw_d/2,0,0]) cylinder(d=2,h=2); // U
		rotate([0,0,GM4008CommV_a]) translate([GM4008CommSw_d/2,0,0]) cylinder(d=2,h=2); // V
		rotate([0,0,GM4008CommW_a]) translate([GM4008CommSw_d/2,0,0]) cylinder(d=2,h=2); // W
	}
} // RingCSpacerGM4008Com

//RingCSpacerGM4008Com();

PC_InnerGM5208_h=3;

module CommutatorAlignmentTool(){
	
	rotate([0,0,45]) SplineShaft(d=GM5208_Spline_d+IDXtra*2,l=7,nSplines=GM5208_nSplines,Spline_w=30,Hole=12.7+IDXtra,Key=false);
	
} // CommutatorAlignmentTool

//CommutatorAlignmentTool();

module RingCSpacerGM5208Com(){
	nBolts=8;
	BoltBossB_h=6;
	Spacer_h=GM5208MP_h+GM5208_h+PC_InnerGM5208_h+0.5; // xtra 0.5 is a little extra space
	//echo(Spacer_h=Spacer_h);
	//echo(GM5208_h=GM5208_h);
	Encoder_z=Spacer_h-GM5208_h-13.4; // hole pattern offest from top, adjusted -0.8 1/8/2020
	nPolePairs=GM5208_nPolePairs;
	Skirt_ID=GM5208Comm_d+1.5;
	
	difference(){
		union(){
			cylinder(d=RingB_OD+RingB_OD_Xtra,h=BoltBossB_h+Overlap);
				
			// Ring B bolt bosses
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+RingC_BC_GM5208Twist_a]) hull(){
				translate([RingB_OD/2,0,0])
						cylinder(d=Bolt4Inset*2+2,h=BoltBossB_h);
				translate([RingC_BC_d/2,0,0]) cylinder(d=Bolt4Inset*2,h=BoltBossB_h);
			} // hull
			
			// RingC bolt bosses
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j-RingC_BC_GM5208Twist_a]) hull(){
					translate([RingB_OD/2,0,Spacer_h-8]) cylinder(d=Bolt4Inset*2+2,h=8);
					translate([RingB_OD/2-1,0,8]) cylinder(d=4,h=BoltBossB_h);
				
				translate([RingC_BC_d/2,0,Spacer_h-8]) cylinder(d=Bolt4Inset*2,h=8);
			} // hull
			
			// Skirt
			difference(){
				translate([0,0,BoltBossB_h])
					cylinder(d1=RingB_OD+RingB_OD_Xtra,d2=RingC_BC_d-Bolt4Inset*2,h=Spacer_h-BoltBossB_h);
				translate([0,0,BoltBossB_h-Overlap])
					cylinder(d1=Skirt_ID,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);
			} // difference
			
			rotate([0,0,GM5208CommU_a])
				translate([GM5208CommSw_d/2,0,0])  HallOptoMountPlate(Z=Spacer_h,Label="U");
			rotate([0,0,GM5208CommV_a])
				translate([GM5208CommSw_d/2,0,0])  HallOptoMountPlate(Z=Spacer_h,Label="V");
			rotate([0,0,GM5208CommW_a])
				translate([GM5208CommSw_d/2,0,0])  HallOptoMountPlate(Z=Spacer_h,Label="W");
		} // union
		
		// Opto switches for commutation
		rotate([0,0,GM5208CommU_a])
			translate([GM5208CommSw_d/2,0,Encoder_z])  HallOptoMountHoles();
		rotate([0,0,GM5208CommV_a])
			translate([GM5208CommSw_d/2,0,Encoder_z])  HallOptoMountHoles();
		rotate([0,0,GM5208CommW_a]) 
			translate([GM5208CommSw_d/2,0,Encoder_z])  HallOptoMountHoles();
		
		// Bolts to Ring B
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j+RingC_BC_GM5208Twist_a]) translate([RingC_BC_d/2,0,BoltBossB_h])
				Bolt4HeadHole(lHead=7);
		
		// Bolts to Ring C
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j-RingC_BC_GM5208Twist_a]) translate([RingC_BC_d/2,0,Spacer_h])
				Bolt4Hole();
	
		// center hole
			translate([0,0,-Overlap]) cylinder(d=Skirt_ID,h=BoltBossB_h+Overlap);//cylinder(d=RingB_OD+RingB_OD_Xtra-4,h=BoltBossB_h+Overlap);
			translate([0,0,BoltBossB_h-Overlap]) 
				cylinder(d1=Skirt_ID,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);//cylinder(d1=RingB_OD+RingB_OD_Xtra-4,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);
	} // difference
	
	// Commutation sensor positions
	if ($preview==true) {
		rotate([0,0,GM5208CommU_a]) translate([GM5208CommSw_d/2,0,0]) cylinder(d=2,h=2); // U
		rotate([0,0,GM5208CommV_a]) translate([GM5208CommSw_d/2,0,0]) cylinder(d=2,h=2); // V
		rotate([0,0,GM5208CommW_a]) translate([GM5208CommSw_d/2,0,0]) cylinder(d=2,h=2); // W
	}
} // RingCSpacerGM5208Com

// RingCSpacerGM5208Com();

//rotate([0,0,360/nPolePairs*3]) translate([GM5208_d/2+7,0,11]) 
	//rotate([0,0,-90]) rotate([-90,0,0]) HallSwitchMount();

module RingCMtrMountGM4008Com(){
	nBolts=6;
	RingC_d=RingC_BC_d-Bolt4Inset*2-5;
	RimgCMMFlange_d=RingC_d-Bolt4Inset*4;
	RingC_h=6;
	
	difference(){
		cylinder(d=RingC_d,h=RingC_h);
		
		// Remove extra thickness
		translate([0,0,-Overlap]) difference(){
			cylinder(d=RingC_d+Overlap,h=3+Overlap);
			translate([0,0,-Overlap]) cylinder(d=RimgCMMFlange_d,h=3+Overlap*2);
		} // difference
		
		// Bolts
		for (j=[0:nBolts-1]) 
		 for (k=[0:0.5:360/GM4008_nPolePairs]) hull(){
			 rotate([0,0,360/nBolts*j+k-0.5]) translate([RingC_d/2-Bolt4Inset,0,-Overlap]) cylinder(d=3,h=RingC_h+Overlap*2,$fn=12);
			 rotate([0,0,360/nBolts*j+k+0.5]) translate([RingC_d/2-Bolt4Inset,0,-Overlap]) cylinder(d=3,h=RingC_h+Overlap*2,$fn=12);
		 } // hull
		
		// Motor mounting bolts
		for (j=[0:3]) rotate([0,0,45+90*j]) translate([GM4008SBC2_d/2,0,RingC_h]) Bolt4ClearHole();

		// center hole
		translate([0,0,-Overlap]) cylinder(d=13,h=RingC_h+Overlap*2);
	} // difference
} // RingCMtrMountGM4008Com

//rotate([180,0,0]) RingCMtrMountGM4008Com();

module RingCMtrMountGM5208Com(){
	nBolts=6;
	RingC_d=RingC_BC_d-Bolt4Inset*2-5;
	RimgCMMFlange_d=RingC_d-Bolt4Inset*4;
	RingC_h=6.8;
	MotorBoss_h=3.8; // added 1/8/2020
	
	difference(){
		cylinder(d=RingC_d,h=RingC_h);
		
		// Remove extra thickness
		translate([0,0,-Overlap]) difference(){
			cylinder(d=RingC_d+Overlap,h=MotorBoss_h+Overlap);
			translate([0,0,-Overlap]) cylinder(d=RimgCMMFlange_d,h=MotorBoss_h+Overlap*2);
		} // difference
		
		// Bolts
		for (j=[0:nBolts-1]) 
		 for (k=[0:0.5:360/GM5208_nPolePairs]) hull(){
			 rotate([0,0,360/nBolts*j+k-0.5]) translate([RingC_d/2-Bolt4Inset,0,-Overlap]) cylinder(d=3,h=RingC_h+Overlap*2,$fn=12);
			 rotate([0,0,360/nBolts*j+k+0.5]) translate([RingC_d/2-Bolt4Inset,0,-Overlap]) cylinder(d=3,h=RingC_h+Overlap*2,$fn=12);
		 } // hull
		
		// Motor mounting bolts
		for (j=[0:3]) rotate([0,0,45+90*j]) translate([GM5208SBC3_d/2,0,RingC_h]) Bolt4ClearHole();
			
		// Wire path
		translate([25,0,-Overlap]) cylinder(d=7,h=RingC_h+Overlap*2);

		// center hole
		translate([0,0,-Overlap]) cylinder(d=13,h=RingC_h+Overlap*2);
	} // difference
} // RingCMtrMountGM5208Com

//rotate([180,0,0]) RingCMtrMountGM5208Com();

module RingCCoverGM4008Com(){
	nBolts=8;
	nMtrBolts=6;
	RingC_d=RingC_BC_d-Bolt4Inset*2;
	RimgCMMFlange_d=RingC_d-5-Bolt4Inset*4;
	RingC_h=6;
	
	difference(){
		union(){
			cylinder(d=RingC_d,h=RingC_h);
			
			// bolt bosses to ring C
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingC_d/2-2,0,0])
					cylinder(d=Bolt4Inset*2+2,h=RingC_h);
				translate([RingC_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=RingC_h);
			} // hull
		} // union
		
		// Remove extra thickness
		translate([0,0,3]) cylinder(d=RingC_d-4,h=RingC_h+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,RingC_h])
			Bolt4HeadHole();
		
		// Motor mounting bolts
		for (j=[0:nMtrBolts-1]) 
			 rotate([0,0,360/nMtrBolts*j]) translate([RimgCMMFlange_d/2+Bolt4Inset,0,RingC_h]) Bolt4Hole();
			 

		// center hole
		translate([0,0,-Overlap]) cylinder(d=RimgCMMFlange_d+IDXtra,h=RingC_h+Overlap*2);
	} // difference
} // RingCCoverGM4008Com

//RingCCoverGM4008Com();

module RingCCoverGM5208Com(){
	nBolts=8;
	nMtrBolts=6;
	RingC_d=RingC_BC_d-Bolt4Inset*2;
	RimgCMMFlange_d=RingC_d-5-Bolt4Inset*4;
	RingC_h=6;
	
	difference(){
		union(){
			cylinder(d=RingC_d,h=RingC_h);
			
			// bolt bosses to ring C
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingC_d/2-2,0,0])
					cylinder(d=Bolt4Inset*2+2,h=RingC_h);
				translate([RingC_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=RingC_h);
			} // hull
		} // union
		
		// Remove extra thickness
		translate([0,0,3]) cylinder(d=RingC_d-4,h=RingC_h+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,RingC_h])
			Bolt4HeadHole();
		
		// Motor mounting bolts
		for (j=[0:nMtrBolts-1]) 
			 rotate([0,0,360/nMtrBolts*j]) translate([RimgCMMFlange_d/2+Bolt4Inset,0,RingC_h]) Bolt4Hole();

		// center hole
		translate([0,0,-Overlap]) cylinder(d=RimgCMMFlange_d+IDXtra,h=RingC_h+Overlap*2);
	} // difference
} // RingCCoverGM5208Com

//RingCCoverGM5208Com();



GM4008MP_h=8; // Mounting Plate thickness, was 5

module GM4008MountingPlate(HasCommutatorDisk=true, ShowMotor=true){
	Spline_d=GM4008_Spline_d;
	nSplines=GM4008_nSplines;
	nPolePairs=GM4008_nPolePairs;
	CommDisk_h=1.5;
	nNotchStep=30;
	
	WireTube_d=WT_OD+1;
	
	difference(){
		union(){
			cylinder(d=GM4008RBC2_d+Bolt4Inset*2+2,h=4.5);
			cylinder(d=Spline_d+5,h=GM4008MP_h);
			
			if (HasCommutatorDisk==true) cylinder(d=GM4008Comm_d,h=CommDisk_h);
		} // union
		
		translate([0,0,-Overlap]) rotate([0,0,45]) SplineHole(d=Spline_d,l=GM4008MP_h+Overlap*2,nSplines=nSplines,Spline_w=30,Gap=IDXtra,Key=false);
		
		for (j=[0:3]) rotate([0,0,90*j]) translate([GM4008RBC2_d/2,0,3.5]) Bolt4ButtonHeadHole();
			
		if (HasCommutatorDisk==true) 
			for (j=[0:nPolePairs]) rotate([0,0,360/nPolePairs*j])
				for (k=[0:nNotchStep-2]) hull() {
					rotate([0,0,180/nPolePairs/nNotchStep*k]){
						translate([GM4008Comm_d/2-3,0.5,-Overlap]) 
							cylinder(d=1,h=CommDisk_h+Overlap*2,$fn=12);
						translate([GM4008Comm_d/2-2,0.5,-Overlap]) 
							cylinder(d=1,h=CommDisk_h+Overlap*2,$fn=12);}
					rotate([0,0,180/nPolePairs/nNotchStep*k+1]){
						translate([GM4008Comm_d/2-3,-0.5,-Overlap]) 
							cylinder(d=1,h=CommDisk_h+Overlap*2,$fn=12);
						translate([GM4008Comm_d/2-2,-0.5,-Overlap]) 
							cylinder(d=1,h=CommDisk_h+Overlap*2,$fn=12);}
					} // hull
	} // difference
	
	// motor
	if ($preview==true && ShowMotor==true) rotate([180,0,0]) GimbalMotor4008();
		
	// Commutation sensor positions
	if ($preview==true) 
	for (j=[0:2]) rotate([0,0,360/nPolePairs/3*j]) translate([GM4008Comm_d/2+1,0,0]) cylinder(d=2,h=2);
} // GM4008MountingPlate

//GM4008MountingPlate(HasCommutatorDisk=true);

GM5208MP_h=7; // Mounting Plate thickness

module GM5208MountingPlate(HasCommutatorDisk=true, ShowMotor=true){
	Spline_d=GM5208_Spline_d;
	nSplines=GM5208_nSplines;
	nPolePairs=GM5208_nPolePairs;
	CommDisk_h=1.5;
	nNotchStep=30;
	
	difference(){
		union(){
			cylinder(d=GM5208RBC2_d+Bolt4Inset*2+2,h=4.5);
			cylinder(d=Spline_d+5,h=GM5208MP_h); // spline hub
			
			if (HasCommutatorDisk==true) cylinder(d=GM5208Comm_d,h=CommDisk_h);
		} // union
		
		translate([0,0,-Overlap]) rotate([0,0,45]) SplineHole(d=Spline_d,l=GM5208MP_h+Overlap*2,nSplines=nSplines,Spline_w=30,Gap=IDXtra*2,Key=false);
		
		//translate([0,0,-Overlap]) SplineHole(d=Spline_d,l=7,nSplines=nSplines,Spline_w=30,Gap=IDXtra,Key=false);
		
		for (j=[0:3]) rotate([0,0,90*j]) translate([GM5208RBC2_d/2,0,3.5]) Bolt4ButtonHeadHole();
			
		if (HasCommutatorDisk==true) 
			for (j=[0:nPolePairs]) rotate([0,0,360/nPolePairs*j])
				for (k=[0:nNotchStep-2]) hull() {
					rotate([0,0,180/nPolePairs/nNotchStep*k]){
						translate([GM5208Comm_d/2-3,0.5,-Overlap]) 
							cylinder(d=1,h=CommDisk_h+Overlap*2,$fn=12);
						translate([GM5208Comm_d/2-2,0.5,-Overlap]) 
							cylinder(d=1,h=CommDisk_h+Overlap*2,$fn=12);}
					rotate([0,0,180/nPolePairs/nNotchStep*k+1]){
						translate([GM5208Comm_d/2-3,-0.5,-Overlap]) 
							cylinder(d=1,h=CommDisk_h+Overlap*2,$fn=12);
						translate([GM5208Comm_d/2-2,-0.5,-Overlap]) 
							cylinder(d=1,h=CommDisk_h+Overlap*2,$fn=12);}
					} // hull
	} // difference
	
	// motor
	if ($preview==true && ShowMotor==true) rotate([180,0,0]) GimbalMotor5208();
		
	// Commutation sensor positions
	if ($preview==true) 
	for (j=[0:2]) rotate([0,0,360/nPolePairs/3*j]) translate([GM5208Comm_d/2+1,0,0]) cylinder(d=2,h=2);
} // GM5208MountingPlate

//translate([0,0,8+Overlap]) rotate([180,0,0]) GM5208MountingPlate(HasCommutatorDisk=true, ShowMotor=false);


// ****************************************************************************************************
//  ***** Ring C, Motor mount, encoder mount and end bearing support *****
//  ***** Used with a brushless gimbal motor (4008/5208) and magnetic encoder *****
// ****************************************************************************************************


module RingCSpacerGM(HasSkirt=false){
	// plain skirt w/o hall sensors

	nBolts=8;
	BoltBossB_h=6;
	Spacer_h=6+26;
	
	//if ($preview==true) translate([0,0,6]) GimbalMotor5208();
	
	difference(){
		union(){
			cylinder(d=RingB_OD+RingB_OD_Xtra,h=BoltBossB_h+Overlap);
				
			// Ring B bolt bosses
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingB_OD/2,0,0])
						cylinder(d=Bolt4Inset*2+2,h=BoltBossB_h);
				translate([RingC_BC_d/2,0,0]) cylinder(d=Bolt4Inset*2,h=BoltBossB_h);
			} // hull
			
			// RingC bolt bosses
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) hull(){
				if (HasSkirt==true){ 
					translate([RingB_OD/2,0,Spacer_h-8]) cylinder(d=Bolt4Inset*2+2,h=8);
					translate([RingB_OD/2-1,0,0]) cylinder(d=4,h=BoltBossB_h);
				} else {
					//translate([RingB_OD/2,0,Spacer_h-8]) cylinder(d=Bolt4Inset*2+2,h=8);
					translate([RingB_OD/2,0,0.01]) cube([2.5,Bolt4Inset*2+2,0.02],center=true); //cylinder(d=Bolt4Inset*2+4,h=BoltBossB_h);
				} // else
				translate([RingC_BC_d/2,0,Spacer_h-8]) cylinder(d=Bolt4Inset*2,h=8);
			} // hull
			
			if (HasSkirt==true) difference(){
				translate([0,0,BoltBossB_h]) cylinder(d1=RingB_OD+RingB_OD_Xtra,d2=RingC_BC_d-Bolt4Inset*2,h=Spacer_h-BoltBossB_h);
				
				translate([0,0,BoltBossB_h-Overlap]) cylinder(d1=RingB_OD+RingB_OD_Xtra-4,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);
				
			} // difference
		} // union
		
		// Bolts to Ring B
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,BoltBossB_h])
				Bolt4HeadHole();
		
		// Bolts to Ring C
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) translate([RingC_BC_d/2,0,Spacer_h])
				Bolt4Hole();
	
		// center hole
		if (HasSkirt==true){
			translate([0,0,-Overlap]) cylinder(d=RingB_OD+RingB_OD_Xtra-4,h=BoltBossB_h+Overlap);
			translate([0,0,BoltBossB_h-Overlap]) 
				cylinder(d1=RingB_OD+RingB_OD_Xtra-4,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);
		} else {
			translate([0,0,-Overlap]) cylinder(d=RingB_OD+RingB_OD_Xtra-4,h=Spacer_h+Overlap*3);
		} // if else
		
	} // difference
		
} // RingCSpacerGM

//RingCSpacerGM(HasSkirt=true);
//RingCSpacerGM(HasSkirt=false);


// ***********************************************************************************************
//  ***** Lifter Parts *****
// ***********************************************************************************************
//  ***** STL for 48:1 GM4008/GM5208 *****
// LifterSpline(nSpokes=7); // bolts to Ring A
// LifterWireTubeSupport(nSpokes=7); // presses into top of LifterSpline
// FlangedBallLockRing(nSpokes=7);
// LifterLock(nSpokes=7); // locking ring
//
// LifterLockCover(nSpokes=7); // has flange to connect to DogLeg
// DogLeg(CD=150, Offset=15);
// ***********************************************************************************************


module ShowLifter2(){
	CenterDistance=-150;
	
	translate([0,0,-2.2]) LifterSpline();
	FlangedBallLockRing(nSpokes=7); // OK
	translate([0,0,6]) LifterLock(nSpokes=7); // OK
	//translate([0,0,20]) LifterLockCover(nSpokes=7); 
	
	/*
	translate([CenterDistance,0,50]) rotate([0,180,0]){
		translate([0,0,-2.2]) LifterSpline();
		FlangedBallLockRing(nSpokes=7); // OK
		translate([0,0,6]) LifterLock(nSpokes=7); // OK
		translate([0,0,20]) LifterLockCover(nSpokes=7); 
	}
	/**/
	
	DogLeg(CD=150,Offset=15);
} // ShowLifter2

//ShowLifter2();

Lock_Ball_d=3/8*25.4;

module LifterLock(nSpokes=7){
	// locking ring, twist version, FC 1
	
	Gap=IDXtra*2;
	Twist_a=10;
	Twist_Inc=1;
	
	Lock_Ball_Circle_d=RingA_Bearing_ID+Lock_Ball_d;
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLR_h=14;
	
	difference(){
		// align key with main spline
		SplineShaft(d=Major_d+6,l=LLR_h,nSplines=nSpokes,Spline_w=25,
			Hole=Lock_Ball_Circle_d+Lock_Ball_d-2+Gap,Key=true);
		
		//*
		// Bolts bosses
		rotate([0,0,-Twist_a])
		for (T_a=[0:Twist_Inc:Twist_a-Twist_Inc])
			for (j=[0:nSpokes-1]) hull(){
				rotate([0,0,360/nSpokes*j+T_a]){
					translate([Major_d/2-Bolt4Inset-2,0,-Overlap]) cylinder(r=Bolt4Inset+Gap,h=LLR_h+Overlap*4,$fn=$preview? 12:90);
					translate([Major_d/2-Bolt4Inset*2,0,-Overlap]) cylinder(r=Bolt4Inset+1+Gap,h=LLR_h+Overlap*4,$fn=$preview? 12:90);
				}
				rotate([0,0,360/nSpokes*j+T_a+Twist_Inc]){
					translate([Major_d/2-Bolt4Inset-2,0,-Overlap]) cylinder(r=Bolt4Inset+Gap,h=LLR_h+Overlap*4,$fn=$preview? 12:90);
					translate([Major_d/2-Bolt4Inset*2,0,-Overlap]) cylinder(r=Bolt4Inset+1+Gap,h=LLR_h+Overlap*4,$fn=$preview? 12:90);
				}
			}
		/**/
			
		translate([0,0,-2.5]){
		// Ball detents
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) 
			translate([Lock_Ball_Circle_d/2,0,LLR_h/2]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
		
		// Ball releases
		for (j=[0:nSpokes-1]) hull(){
			rotate([0,0,360/nSpokes*(j+0.5)-3]) translate([Lock_Ball_Circle_d/2,0,LLR_h/2])
				sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
			rotate([0,0,360/nSpokes*(j+0.5)-Twist_a]) translate([Lock_Ball_Circle_d/2+2,0,LLR_h/2])
				sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
		} // hull
		
		// Ball inserts, slide ring on while in unlocked position
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)-Twist_a]) hull(){
			 translate([Lock_Ball_Circle_d/2+2,0,LLR_h/2])
				sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
			translate([Lock_Ball_Circle_d/2+2,0,0])
				sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
		} // hull
	}
	} // difference
	
} // LifterLock

//rotate([180,0,0]) LifterLock(); // for STL

Dogbone_L=90;

module LifterLockCover(nSpokes=7){
	// old
	
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLC_h=6;
	Skirt_t=5;
	WirePath_d=6;
	WirePath_w=25;
	WirePathLeft=-50;
	
	nBolts=5;
	Bolt_BCr=Major_d/2+6+Bolt4Inset;
	BoltArc_a=60;
	
	difference(){
		union(){
			cylinder(d=Major_d-Bolt4Inset,h=3.5);
			translate([0,0,3.5]) rotate_extrude() translate([Major_d/2-Bolt4Inset/2-1.5,0,0]) circle(r=1.5);
			
			// Dog leg bolt flange
			difference(){
				hull(){
					rotate([0,0,-BoltArc_a/2]) translate([-Bolt_BCr,0,0]) rotate([0,0,BoltArc_a/2]) translate([Bolt_BCr,0,0]) cylinder(r=Bolt4Inset+2,h=Skirt_t);
					rotate([0,0,BoltArc_a/2]) translate([-Bolt_BCr,0,0]) rotate([0,0,-BoltArc_a/2]) translate([Bolt_BCr,0,0]) cylinder(r=Bolt4Inset+2,h=Skirt_t);

					for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
						translate([-Bolt_BCr,0,0]) cylinder(r=Bolt4Inset+2,h=Skirt_t);
				} // hull
				
				translate([0,0,-Overlap]) cylinder(d=Major_d-Bolt4Inset-3.5,h=Skirt_t+Overlap*2);
				// Flange Bolts
				for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
						translate([-Bolt_BCr,0,Skirt_t+1]) Bolt4ButtonHeadHole();
				
				
			} // difference
			
			hull(){
				translate([0,0,7]) scale([2,2,1]) sphere(r=6,$fn=$preview? 18:90);
				scale([2,2,1]) cylinder(r=7,h=7);}
			
			// Wire Path
			translate([0,10,0]) {
			hull(){ cylinder(d=WirePath_d+5,h=Overlap); translate([0,0,3+WirePath_d/2]) sphere(d=WirePath_d+5,$fn=$preview? 18:90);}
			hull(){ translate([0,0,3+WirePath_d/2]) sphere(d=WirePath_d+5,$fn=$preview? 18:90);
					translate([-Bolt_BCr+10,-4,3+WirePath_d/2]) sphere(d=WirePath_d+5,$fn=$preview? 18:90);}
		}
			mirror([0,1,0])
			translate([0,10,0]) {
				hull(){ cylinder(d=WirePath_d+5,h=Overlap); translate([0,0,3+WirePath_d/2]) sphere(d=WirePath_d+5,$fn=$preview? 18:90);}
				hull(){ translate([0,0,3+WirePath_d/2]) sphere(d=WirePath_d+5,$fn=$preview? 18:90);
						translate([-Bolt_BCr+10,-4,3+WirePath_d/2]) sphere(d=WirePath_d+5,$fn=$preview? 18:90);}
			}
		
			
			// Bolts bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
					translate([Major_d/2-Bolt4Inset-2,0,0]) cylinder(r=Bolt4Inset,h=LLC_h);
					cylinder(r=Bolt4Inset+1,h=LLC_h);
			}
		} // union
		
		// Flange Bolts
				for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
						translate([-Bolt_BCr,0,Skirt_t+1]) Bolt4ButtonHeadHole();
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) translate([Major_d/2-Bolt4Inset-2,0,LLC_h]) Bolt4HeadHole();
		
		// wire path
				rotate([0,0,BoltArc_a/(nBolts-1)/2])
					hull(){
						translate([-Bolt_BCr+2,0,-Overlap]) cylinder(d=7,h=Overlap);
						translate([-Bolt_BCr+10,0,Skirt_t+Overlap]) cylinder(d=7,h=Overlap);
					}
				rotate([0,0,-BoltArc_a/(nBolts-1)/2])
					hull(){
						translate([-Bolt_BCr+2,0,-Overlap]) cylinder(d=7,h=Overlap);
						translate([-Bolt_BCr+10,0,Skirt_t+Overlap]) cylinder(d=7,h=Overlap);
					}
					
		translate([0,10,-Overlap]) {
			hull(){ cylinder(d=WirePath_d,h=Overlap); translate([0,0,3+WirePath_d/2]) sphere(d=WirePath_d,$fn=18);}
			hull(){ translate([0,0,3+WirePath_d/2]) sphere(d=WirePath_d,$fn=18);
					translate([-Bolt_BCr+10,-4,3+WirePath_d/2]) sphere(d=WirePath_d,$fn=18);}
		}
		mirror([0,1,0])
		translate([0,10,-Overlap]) {
			hull(){ cylinder(d=WirePath_d,h=Overlap); translate([0,0,3+WirePath_d/2]) sphere(d=WirePath_d,$fn=18);}
			hull(){ translate([0,0,3+WirePath_d/2]) sphere(d=WirePath_d,$fn=18);
					translate([-Bolt_BCr+10,-4,3+WirePath_d/2]) sphere(d=WirePath_d,$fn=18);}
		}
				
		translate([0,0,-Overlap]) cylinder(d=5/16*25.4+IDXtra,h=6);
			
	} // difference
} // LifterLockCover

//LifterLockCover(nSpokes=7);


module BallLockRing(nSpokes=7){
	// only the ring, can be used stand alone or combines with dog leg. 
	
	Spline_h=20;
	Lock_Ball_Circle_d=RingA_Bearing_ID+Lock_Ball_d;
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLC_h=6;
	Skirt_t=5;
	
	difference(){
		cylinder(d=Major_d,h=Spline_h);
		
		translate([0,0,-Overlap]) SplineHole(d=RingA_Bearing_ID+Bolt4Inset*2,l=Spline_h+Overlap*2,nSplines=nSpokes,Spline_w=25,Gap=IDXtra,Key=true);
		
		// lock ring
		difference(){
			translate([0,0,Spline_h/2-Lock_Ball_d/2-IDXtra]) cylinder(d=Major_d+Overlap,h=Spline_h);
			
			translate([0,0,Spline_h/2-Lock_Ball_d/2-IDXtra-Overlap])
				cylinder(d=Lock_Ball_Circle_d+Lock_Ball_d-2,h=Spline_h+Overlap*2);
			
			// Bolts bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
					translate([Major_d/2-Bolt4Inset-2,0,-Overlap]) cylinder(r=Bolt4Inset,h=Spline_h+Overlap*4);
					translate([Major_d/2-Bolt4Inset*2,0,-Overlap]) cylinder(r=Bolt4Inset+1,h=Spline_h+Overlap*4);
			}
		} // difference
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) translate([Major_d/2-Bolt4Inset-2,0,Spline_h]) Bolt4Hole();
		
		// Ball detents
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
			translate([Lock_Ball_Circle_d/2,0,Spline_h/2]) sphere(d=Lock_Ball_d+IDXtra, $fn=$preview? 18:90);
			translate([Lock_Ball_Circle_d/2,0,Spline_h/2]) rotate([0,90,0]) cylinder(d=Lock_Ball_d+IDXtra,h=15, $fn=$preview? 18:90);
		} // hull
	} // difference
	
	// Balls
	if ($preview==true)
	for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)])
			translate([Lock_Ball_Circle_d/2,0,Spline_h/2]) color("Red") sphere(d=Lock_Ball_d, $fn=18);
} // BallLockRing

//BallLockRing();

module DogLeg(CD=150, Offset=30){
	Spline_h=20;
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	Skirt_t=15;
	nBolts=5;
	Bolt_BCr=Major_d/2+6+Bolt4Inset;
	BoltArc_a=60;
	
	module End(){
		difference(){
			hull(){
				for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
					translate([-Bolt_BCr,0,0]){ 
						cylinder(r=Bolt4Inset+2,h=Skirt_t);
						
						//rotate([0,0,-(BoltArc_a/(nBolts-1)*j-BoltArc_a/2)])
							//translate([-Bolt4Inset,0,0]) cylinder(r=Bolt4Inset+2,h=Skirt_t);
					}
			} // hull
			
			// Remove end facing lock.
			translate([0,0,-Overlap]) cylinder(r=Bolt_BCr-Bolt4Inset-2,h=Skirt_t+Overlap*2);
			
		} // difference
	} // End
	
	module EndBolts(){
			for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
					translate([-Bolt_BCr,0,Skirt_t]) Bolt4Hole(depth=Skirt_t);
	} // EndBolts
	
	
	difference(){
		union(){
			End();
			translate([-CD,0,Skirt_t+Offset]) rotate([0,180,0]) End();
			
			// connector
			difference(){
			hull(){
				
				for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
					translate([-Bolt_BCr,0,0])
							rotate([0,0,-(BoltArc_a/(nBolts-1)*j-BoltArc_a/2)])
								cylinder(r=Bolt4Inset+2,h=Skirt_t-3);
					
					
				translate([-CD,0,Skirt_t+Offset]) rotate([0,180,0]) 
					for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
						translate([-Bolt_BCr,0,0])
							rotate([0,0,-(BoltArc_a/(nBolts-1)*j-BoltArc_a/2)])
								cylinder(r=Bolt4Inset+2,h=Skirt_t-3);
					
			} // hull
				// Remove end facing lock.
				translate([0,0,-Overlap]) cylinder(r=Bolt_BCr, h=Skirt_t+Overlap*2);
				translate([-CD,0,Skirt_t+Offset]) rotate([0,180,0]) 
					translate([0,0,-Overlap]) cylinder(r=Bolt_BCr, h=Skirt_t+Overlap*2);
			} // difference
		
		} // union
		
		EndBolts();
		translate([-CD,0,Skirt_t+Offset]) rotate([0,180,0]) EndBolts();
		
		// Wire path
		translate([0,0,-Overlap]) {
			rotate([0,0,BoltArc_a/(nBolts-1)/2]) translate([-Bolt_BCr,0,0]){
				cylinder(d=6,h=Skirt_t+Overlap*2);
				hull(){
					translate([0,0,Skirt_t/2]) sphere(d=6,$fn=18);
					rotate([0,0,-BoltArc_a/(nBolts-1)/2]) translate([30,0,Skirt_t/2]) sphere(d=6,$fn=18);
				}
			}
			rotate([0,0,-BoltArc_a/(nBolts-1)/2]) translate([-Bolt_BCr,0,0]){
				cylinder(d=6,h=Skirt_t+Overlap*2);
				hull(){
					translate([0,0,Skirt_t/2]) sphere(d=6,$fn=18);
					rotate([0,0,BoltArc_a/(nBolts-1)/2]) translate([30,0,Skirt_t/2]) sphere(d=6,$fn=18);
				}
				}}
			
		hull(){
			rotate([0,0,BoltArc_a/(nBolts-1)/2]) translate([-Bolt_BCr,0,Skirt_t/2]) sphere(d=6,$fn=18);
			translate([-CD,0,Skirt_t+Offset]) rotate([0,180,0]) rotate([0,0,BoltArc_a/(nBolts-1)/2])
				translate([-Bolt_BCr,0,Skirt_t/2]) sphere(d=6,$fn=18);
		}
		hull(){
			rotate([0,0,-BoltArc_a/(nBolts-1)/2]) translate([-Bolt_BCr,0,Skirt_t/2]) sphere(d=6,$fn=18);
			translate([-CD,0,Skirt_t+Offset]) rotate([0,180,0]) rotate([0,0,-BoltArc_a/(nBolts-1)/2]) 
				translate([-Bolt_BCr,0,Skirt_t/2]) sphere(d=6,$fn=18);
		}
			
		hull() for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
				translate([-Bolt_BCr,0,Skirt_t]) cylinder(r=Bolt4Inset+2+IDXtra,h=Skirt_t);
		
		translate([-CD,0,Skirt_t+Offset]) rotate([0,180,0]) {
			// Wire path
		translate([0,0,-Overlap]) {
			rotate([0,0,BoltArc_a/(nBolts-1)/2]) translate([-Bolt_BCr,0,0]) {
				cylinder(d=6,h=Skirt_t+Overlap*2);
				hull(){
					translate([0,0,Skirt_t/2]) sphere(d=6,$fn=18);
					rotate([0,0,-BoltArc_a/(nBolts-1)/2]) translate([30,0,Skirt_t/2]) sphere(d=6,$fn=18);
				}
			}
			rotate([0,0,-BoltArc_a/(nBolts-1)/2]) translate([-Bolt_BCr,0,0]){
				cylinder(d=6,h=Skirt_t+Overlap*2);
				hull(){
					translate([0,0,Skirt_t/2]) sphere(d=6,$fn=18);
					rotate([0,0,BoltArc_a/(nBolts-1)/2]) translate([30,0,Skirt_t/2]) sphere(d=6,$fn=18);
				}
			}
				}
			
			hull() for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
				translate([-Bolt_BCr,0,Skirt_t]) cylinder(r=Bolt4Inset+2+IDXtra,h=Skirt_t);
		}
	} // difference
} // DogLeg

//translate([0,0,5]) DogLeg(CD=150,Offset=15);

module FlangedBallLockRing(nSpokes=7){
	
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	Skirt_t=5;
	nBolts=5;
	Bolt_BCr=Major_d/2+6+Bolt4Inset;
	BoltArc_a=60;
	
	BallLockRing(nSpokes=nSpokes);
	
	difference(){
		hull(){
			rotate([0,0,-BoltArc_a/2]) translate([-Bolt_BCr,0,0]) rotate([0,0,BoltArc_a/2]) translate([Bolt_BCr,0,0]) cylinder(r=Bolt4Inset+2,h=Skirt_t);
			rotate([0,0,BoltArc_a/2]) translate([-Bolt_BCr,0,0]) rotate([0,0,-BoltArc_a/2]) translate([Bolt_BCr,0,0]) cylinder(r=Bolt4Inset+2,h=Skirt_t);
			
			for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
				translate([-Bolt_BCr,0,0]) cylinder(r=Bolt4Inset+2,h=Skirt_t);
		} // hull
		
		translate([0,0,-Overlap]) cylinder(d=Major_d-1,h=Skirt_t+Overlap*2);
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,BoltArc_a/(nBolts-1)*j-BoltArc_a/2])
				translate([-Bolt_BCr,0,0]) rotate([180,0,0]) Bolt4ButtonHeadHole();
	} // difference
	
	
} // FlangedBallLockRing

//FlangedBallLockRing(nSpokes=7);

module LifterWireTubeSupport(nSpokes=7){
	WireTube_d=5/16*25.4;
	Support_h=3;
	Support_d=RingA_Bearing_ID-Bolt4Inset*2;
	
	difference(){
		cylinder(d=Support_d,h=Support_h);
		
		translate([0,0,-Overlap]) cylinder(d=Support_d-5,h=Support_h+Overlap*2);
		
	} // difference
	
	difference(){
		union(){
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
				cylinder(d=1.2,h=Support_h); 
				translate([Support_d/2-1.5,0,0]) cylinder(d=1.2,h=Support_h);}
			cylinder(d=WireTube_d+5,h=Support_h);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=WireTube_d+IDXtra,h=Support_h+Overlap*2);
	} // difference
	
} // LifterWireTubeSupport

//LifterWireTubeSupport(nSpokes=7);


module LifterSpline(nSpokes=7){
	// Bolts to Ring A, output of reduction unit.
	
	Spline_h=20;
	Lock_Ball_Circle_r=RingA_Bearing_ID/2+Lock_Ball_d/2;
	
	difference(){
		union(){
			cylinder(d=RingA_Bearing_BallCircle+Ball_d+4,h=2);
			
			SplineShaft(d=RingA_Bearing_ID+Bolt4Inset*2,l=Spline_h+2,nSplines=nSpokes,Spline_w=25,Hole=Spline_Hole_d,Key=true);
		} // union
		
		// Center hole
		translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID-Bolt4Inset*2,h=Spline_h+2+Overlap*2);
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,12]) Bolt4HeadHole(depth=Spline_h,lHead=Spline_h);
		
		// Ball detents
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)])
			translate([Lock_Ball_Circle_r,0,2+Spline_h/2]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
	} // difference
	
} // LifterSpline

//translate([0,0,-2.2]) LifterSpline(nSpokes=7);



//translate([0,0,-RingA_Bearing_Race_w-0.5]) RingABearing();
//translate([0,0,-Gear_w/2-RingA_Bearing_Race_w-6-Overlap*2]) rotate([180,0,0]) RingA();
//LifterRing();
//translate([50,0,18.4]) rotate([180,0,180]) LifterRing();




