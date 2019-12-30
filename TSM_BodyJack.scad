// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// This is the connection between the chassis and a track unit.
//
// Filename: TSM_BodyJack.scad
// By: David M. Flynn
// Created: 10/16/2019
// Revision: 1.1.2 12/29/2019
// Units: mm
// *************************************************
//  ***** Notes *****
// Caution: Changing Ring gear OD part way thru printing will make things not fit.
//   Possible fix: Set bolt circles as constants.
// Can be built with 300° or continuous rotation.
// Can have home switch or quadrature encoder on Ring A. 
// Can be 16:1 or 48:1 reduction. 
// Variant:  Gimbal motor GBM5208H-200T (60mm Dia. x 23mm, 0.038Nm Torque) from robotshop.com?
// 	AS5047D encoder 7 pole pairs.
// *************************************************
//  ***** History ******
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
// RingA_Stop(HasSkirt=false, HasStop=true, Has2Sensors=false); // shortened to 24.5mm 12/20/2019
// RingA_Stop(HasSkirt=true, HasStop=true, Has2Sensors=false); // use skirt in dirty environments
// RingA_Stop(HasSkirt=true, HasStop=false, Has2Sensors=true); // for continuous rotation
// ScrewMountRingB(HasSkirt=false); // Fixed ring. flange mount version.
// ScrewMountRingB(HasSkirt=true); // use skirt is dirty environments
//
//  ***** Brushed motor *****
// RingCSpacer(HasSkirt=true);
// rotate([180,0,0]) RoundRingC(HasSkirt=true); // print w/ support for motor screws
//
//  ***** Brushless Gimbal Motor w/ Encoder
// RingCSpacerGM(HasSkirt=true);
// RingCEncoderMount();
// RingCCover();
// RoundRingCGM();
//
//  ***** Planet carrier parts
// PlanetCarrierOuter();
// PlanetCarrierSpacer();
// PlanetCarrierInner();
// PlanetCarrierInnerGimbalMotor(); // not ready to print
// rotate([180,0,0]) Planet();
// rotate([180,0,0]) Planet(O_a=PlanetToothOffset_a); // Planet A ccw 1/3 tooth
// rotate([180,0,0]) Planet(O_a=PlanetToothOffset_a*2); // Planet B ccw 2/3 tooth
//
// PlanetCarrierDrivePulley(nTeeth=32); // print 2 /jack
//
// LifterRing();
// LifterBearingCover();
//
// TestFixture();
// *************************************************
//  ***** for Viewing *****
//  ShowBodyJack(Rot_a=20,HasSkirt=true);
//  ShowBodyJack(Rot_a=20,HasSkirt=false);
//  ShowPlanetCarrier();
//  ShowLifter();
//  ShowBodyJackGM(HasSkirt=true);
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

GearBacklash=0.25; // this needs to be adjusted for the filament/printer used, 0.2 to 0.4 recommended
BearingPreload=-0.3; // easy to back drive

// 16:1 ratio with symetrical planet gears, could be 24:1 (Ring B = 46 teeth)
//  or 48:1 (Ring B = 47 teeth) with asymetrical planet gears
nPlanets=3;
Pressure_a=20;
PlanetATeeth=16;
PlanetBTeeth=16;
GearAPitch=260;
RingATeeth=48; // output gear

/*
// 16:1 
GearBPitch=286.8965517241379;
RingBTeeth=45;
PlanetToothOffset_a=0;
/**/

//*
// 48:1
GearBPitch=268.3870967741936;
RingBTeeth=47;
PlanetToothOffset_a=360/PlanetBTeeth/3;
/**/

Gear_w=18;

RingA_pd=RingATeeth*GearAPitch/180;
PC_BC_d=RingA_pd-PlanetATeeth*GearAPitch/180;
Ring_B_cpd=PC_BC_d+PlanetBTeeth*GearBPitch/180;
//RingBTeeth=floor(Ring_B_cpd*180/GearBPitch);

// Planet rotations per motor rotations, aka planet carrier
P_Ratio=RingATeeth/PlanetATeeth;
// Planet B teeth per motor rotation
PBt=P_Ratio*PlanetBTeeth;
// Ring A rotations per motor rotation
Rf=1/(1-RingBTeeth/PBt);
/*
// uncomment to show gearing calculations
echo("Ratio = ",Rf);
echo("Ring A PD = ",RingA_pd);
echo("PC BC Dia = ",PC_BC_d);
echo("Calc'd Ring B PD = ",Ring_B_cpd/2);
echo("Ring B PD error =",Ring_B_cpd-RingBTeeth*GearBPitch/180);
/**/

// big bearing 1/2 x 1-1/8 x 5/16
Bearing_OD=1.125*25.4;
Bearing_ID=0.500*25.4;
Bearing_w=0.3125*25.4;

/*
// little bearing 6 x 13 x 5
sBearing_OD=13;
sBearing_ID=6;
sBearing_w=5;
/**/

// little bearing 6.35 x 12.7 x 4.7
sBearing_OD=12.7;
sBearing_ID=6.35;
sBearing_w=4.7;

Tube_OD=12.7; // 1/2" Aluminum tubing

Ball_d=5/16*25.4;

twist=200;

RingA_OD=RingATeeth*GearAPitch/180+GearAPitch/60;
RingA_Bearing_ID=RingA_OD-7;
RingA_Bearing_BallCircle=RingA_OD+Ball_d;
RingA_Bearing_Race_w=10;

RingA_Bearing_OD=RingA_Bearing_BallCircle+Ball_d+5;
//RingA_Gear_OD=RingATeeth*GearAPitch/180+6;

PC_Axil_L=1.5*25.4;
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

RingC_BC_d=RingA_OD+RingB_OD_Xtra+Bolt4Inset*2; // was RingB_OD which is mor likely to change

// GM5208 Motor data
GM5208_d=60;
GM5208_h=23;
GM5208RBC1_d=25; // rotor
GM5208RBC2_d=30;
GM5208SBC_d=44; // stator
GM5208_nPolePairs=7;
GM5208Comm_d=70;
GM5208CommSw_d=GM5208Comm_d+11; // C/L of slot d-5, Sw mounting surface is slot center +8mm 
GM5208_nSplines=6;
GM5208_Spline_d=20;
GM5208CommU_a=360/GM5208_nPolePairs*3;
GM5208CommV_a=360/GM5208_nPolePairs/3+360/GM5208_nPolePairs;
GM5208CommW_a=360/GM5208_nPolePairs/3*2+360/GM5208_nPolePairs*5;


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
		RingA_Stop(HasSkirt=HasSkirt, HasStop=false, Has2Sensors=true);
		translate([0,0,16.5]) RingA_EncoderDisk(PPR=70); 
		rotate([0,0,22.5]) translate([-50,0,15]) rotate([0,-90,0]) rotate([0,0,-90]) HomeSwitchMount();
		rotate([0,0,22.5-45]) translate([-50,0,15]) rotate([0,-90,0]) rotate([0,0,-90]) HomeSwitchMount();
	}
	
	translate([0,0,Gear_w+1])  ScrewMountRingB(HasSkirt=HasSkirt);
	
	
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

module ShowBodyJack(Rot_a=180/RingATeeth,HasSkirt=true){
	translate([0,0,-14.5]) rotate([180,0,0]) RingABearing();
	rotate([0,0,Rot_a]) RingA();
	
	translate([0,0,-14.5]){ 
		RingA_Stop(HasSkirt=HasSkirt, HasStop=true, Has2Sensors=false);
		rotate([0,0,22.5]) translate([-50,0,15]) rotate([0,-90,0]) rotate([0,0,-90]) HomeSwitchMount();
	}
	
	translate([0,0,Gear_w+1])  ScrewMountRingB(HasSkirt=HasSkirt);
	
	translate([0,0,58-21.5-9]) RingCSpacer(HasSkirt=HasSkirt);
	translate([0,0,58]) rotate([180,0,22.5]) RoundRingC(HasSkirt=HasSkirt);
	
	if (HasSkirt==false) ShowPlanetCarrier();
	
	translate([0,0,-24]) rotate([180,0,0]) ShowLifter();
} // ShowBodyJack

//rotate([90,0,0]) ShowBodyJack(Rot_a=20,HasSkirt=true);
//translate([0,0,-110]) rotate([90,0,0]) ShowBodyJack(Rot_a=20,HasSkirt=true);
// rotate([0,-90,0]) ShowBodyJack(Rot_a=0,HasSkirt=true);
//translate([0,0,50-16]) PlanetCarrierDrivePulley();
//ShowBodyJack(Rot_a=20,HasSkirt=false);

// *********************************************************************************************
//  ***** Planet Carrier Parts *****
// *********************************************************************************************

PC_Drv_L=15;

module ShowPlanetCarrier(GMVersion=true){
	
	
	for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,0]) Planet();
		
	
	if (GMVersion==false){
		translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+PC_spacer_l/2+Overlap])
			PlanetCarrierInner();
		translate([0,0,33.5])PlanetCarrierDrivePulley(nTeeth=32);
	} else {
		translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+Overlap]){
			PlanetCarrierInnerGimbalMotor();
			translate([0,0,8+Overlap]) rotate([180,0,0]) GM5208MountingPlate();}
	}
	translate([0,0,Gear_w/2+0.5-PC_Axil_L/2]) PlanetCarrierSpacer();
	translate([0,0,Gear_w/2+0.5-PC_Axil_L/2-Overlap]) rotate([180,0,0]) PlanetCarrierOuter();
} // ShowPlanetCarrier

//ShowPlanetCarrier();

module PlanetCarrierDrivePulley(nTeeth=32){
	// Used with the brushed gear motor belt driven version.
	
	nSpokes=7;
	Spoke_Thickness=1.6;
	BeltPitch=0.2*25.4;
	Belt_Thickness=2.36;
	Wall_Thickness=2;
	PulleyBore_d=nTeeth*BeltPitch/PI-Belt_Thickness*2-Wall_Thickness*2; //52;
	Belt_w=10;
	Pulley_w=Belt_w+1.2*4;
	
	
	difference(){
		union(){
			cylinder(d=PC_Spacer_d+5,h=PC_Drv_L);
			IdlePulley(Belt_w = Belt_w ,Teeth = nTeeth, Bore_d=PulleyBore_d);
			
			// spokes
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
				rotate([0,0,45]) cylinder(d=Spoke_Thickness,h=Pulley_w,$fn=4);
				translate([0,PulleyBore_d/2,0]) rotate([0,0,45]) cylinder(d=Spoke_Thickness,h=Pulley_w,$fn=4);
			} // hull
		} // union
		
		translate([0,0,-Overlap])
			SplineHole(d=PC_Spacer_d,l=PC_Drv_L+Overlap*2,nSplines=6,Spline_w=30,Gap=IDXtra,Key=false);
	} // difference
	
} // PlanetCarrierDrivePulley

//translate([0,0,50-16]) PlanetCarrierDrivePulley(nTeeth=32);

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

GM4008MP_h=5;

module GM4008MountingPlate(HasCommutatorDisk=true){
	Spline_d=GM4008_Spline_d;
	nSplines=GM4008_nSplines;
	nPolePairs=GM4008_nPolePairs;
	CommDisk_h=1.5;
	nNotchStep=30;
	
	
	difference(){
		union(){
			cylinder(d=GM4008RBC2_d+Bolt4Inset*2,h=2.5);
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
	if ($preview==true) rotate([180,0,0]) GimbalMotor4008();
		
	// Commutation sensor positions
	if ($preview==true) 
	for (j=[0:2]) rotate([0,0,360/nPolePairs/3*j]) translate([GM4008Comm_d/2+1,0,0]) cylinder(d=2,h=2);
} // GM4008MountingPlate

//GM4008MountingPlate(HasCommutatorDisk=true);

module GM5208MountingPlate(HasCommutatorDisk=true){
	Spline_d=GM5208_Spline_d;
	nSplines=GM5208_nSplines;
	nPolePairs=GM5208_nPolePairs;
	CommDisk_h=1.5;
	nNotchStep=30;
	
	difference(){
		union(){
			cylinder(d=GM5208RBC2_d+Bolt4Inset*2,h=2.5);
			cylinder(d=Spline_d+5,h=5);
			
			if (HasCommutatorDisk==true) cylinder(d=GM5208Comm_d,h=CommDisk_h);
		} // union
		
		translate([0,0,-Overlap]) SplineHole(d=Spline_d,l=7,nSplines=nSplines,Spline_w=30,Gap=IDXtra,Key=false);
		
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
	if ($preview==true) rotate([180,0,0]) GimbalMotor5208();
		
	// Commutation sensor positions
	if ($preview==true) 
	for (j=[0:2]) rotate([0,0,360/nPolePairs/3*j]) translate([GM5208Comm_d/2+1,0,0]) cylinder(d=2,h=2);
} // GM5208MountingPlate

//translate([0,0,8+Overlap]) rotate([180,0,0]) GM5208MountingPlate(HasCommutatorDisk=true);

PC_InnerGM4008_h=3;

module PlanetCarrierInnerGM4008(){
	// Used with a brushless gimbal motor (4008) 
	Spline_d=GM4008_Spline_d;
	nSplines=GM4008_nSplines;
	
	difference(){
		PlanetCarrierOuter(Shaft_d=6.35);
		
		translate([0,0,PC_InnerGM4008_h]) cylinder(d=Spline_d+5+IDXtra,h=6);
	} // difference
	
	SplineShaft(d=Spline_d,l=8,nSplines=nSplines,Spline_w=30,Hole=6.35,Key=false);
} // PlanetCarrierInnerGM4008

//PlanetCarrierInnerGM4008();

PC_InnerGM5208_h=3;

module PlanetCarrierInnerGM5208(){
	// Used with a brushless gimbal motor (5208) 
	Spline_d=GM5208_Spline_d;
	nSplines=GM5208_nSplines;
	
	difference(){
		PlanetCarrierOuter(Shaft_d=6.35);
		
		translate([0,0,PC_InnerGM5208_h]) cylinder(d=Spline_d+5+IDXtra,h=6);
	} // difference
	
	SplineShaft(d=Spline_d,l=8,nSplines=nSplines,Spline_w=30,Hole=6.35,Key=false);
} // PlanetCarrierInnerGM5208

// PlanetCarrierInnerGM5208();

module PlanetCarrierInner(){
	// Used with the brushed gear motor belt driven version.
	
	translate([0,0,-PC_spacer_l/2]) PlanetCarrierOuter();
	
	translate([0,0,-PC_spacer_l/2])
	SplineShaft(d=PC_Spacer_d,l=PC_spacer_l/2,nSplines=6,Spline_w=30,Hole=Tube_OD+IDXtra,Key=false);
} // PlanetCarrierInner

//translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+PC_spacer_l/2+Overlap]) PlanetCarrierInner();

module PlanetCarrierOuter(Shaft_d=Tube_OD+IDXtra){
	difference(){
		for (j=[0:nPlanets*2-1]) rotate([0,0,180/nPlanets*j]) hull(){
			translate([-PC_BC_d/2,0,0]) cylinder(d=PC_End_d,h=3);
			cylinder(d=20,h=5);
			} // hull
		
		// Tube
		translate([0,0,-Overlap]) cylinder(d=Shaft_d,h=6+Overlap*2);
		
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
		translate([0,0,-Overlap])  cylinder(d=Shaft_d,h=PC_Axil_L+Overlap*2);
		
	} // difference
} // PlanetCarrierSpacer

//translate([0,0,Gear_w/2+0.5-PC_Axil_L/2]) PlanetCarrierSpacer();

module Planet(O_a=0){
	
	difference(){
		union(){
			gear(number_of_teeth=PlanetATeeth,
				circular_pitch=GearAPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Gear_w/2,
				rim_thickness=Gear_w/2,
				rim_width=5,
				hub_thickness=Gear_w/2,
				hub_diameter=15,
				bore_diameter=sBearing_OD-1,
				circles=0,
				backlash=GearBacklash,
				twist=twist/PlanetATeeth,
				involute_facets=0,
				flat=false);
			
			mirror([0,0,1])
			gear(number_of_teeth=PlanetATeeth,
				circular_pitch=GearAPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Gear_w/2,
				rim_thickness=Gear_w/2,
				rim_width=5,
				hub_thickness=Gear_w/2,
				hub_diameter=15,
				bore_diameter=sBearing_OD-1,
				circles=0,
				backlash=GearBacklash,
				twist=twist/PlanetATeeth,
				involute_facets=0,
				flat=false);
			
			
			// Transition section
			translate([0,0,Gear_w/2-Overlap]) rotate([0,0,180/PlanetATeeth-1.18])
			difference(){
				gear(number_of_teeth=PlanetATeeth,
					circular_pitch=GearAPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=1+Overlap*2,
					rim_thickness=1+Overlap*2,
					rim_width=5,
					hub_thickness=1+Overlap*2,
					hub_diameter=15,
					bore_diameter=sBearing_OD-1,
					circles=0,
					backlash=GearBacklash,
					twist=25/PlanetATeeth,
					involute_facets=0,
					flat=false);
				
				translate([0,0,0.5+Overlap]) cylinder(d=PlanetATeeth*GearAPitch/180+10,h=1);
			} // difference
				
			
			
			translate([0,0,Gear_w/2-Overlap]) rotate([0,0,O_a+180/PlanetBTeeth-2.75])
			difference(){
				gear(number_of_teeth=PlanetBTeeth,
					circular_pitch=GearBPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=1+Overlap*2,
					rim_thickness=1+Overlap*2,
					rim_width=5,
					hub_thickness=1+Overlap*2,
					hub_diameter=15,
					bore_diameter=sBearing_OD-1,
					circles=0,
					backlash=GearBacklash,
					twist=-25/PlanetBTeeth,
					involute_facets=0,
					flat=false);
				
				translate([0,0,-Overlap]) cylinder(d=PlanetBTeeth*GearBPitch/180+10,h=0.5+Overlap);
			} // difference
		
			translate([0,0,Gear_w+1]) rotate([0,0,O_a]) {
				gear(number_of_teeth=PlanetBTeeth,
					circular_pitch=GearBPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=Gear_w/2,
					rim_thickness=Gear_w/2,
					rim_width=5,
					hub_thickness=Gear_w/2,
					hub_diameter=15,
					bore_diameter=sBearing_OD-1,
					circles=0,
					backlash=GearBacklash,
					twist=twist/PlanetBTeeth,
					involute_facets=0,
					flat=false);

				mirror([0,0,1])
					gear(number_of_teeth=PlanetBTeeth,
					circular_pitch=GearBPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=Gear_w/2,
					rim_thickness=Gear_w/2,
					rim_width=5,
					hub_thickness=Gear_w/2,
					hub_diameter=15,
					bore_diameter=sBearing_OD-1,
					circles=0,
					backlash=GearBacklash,
					twist=twist/PlanetBTeeth,
					involute_facets=0,
					flat=false);
			}
		} // union

		if (O_a!=0) 
			rotate([0,0,O_a]) translate([-8.5,0,Gear_w*1.5]) cylinder(d=1.5,h=2);

		translate([0,0,-Gear_w/2-Overlap]) cylinder(d=sBearing_OD,h=sBearing_w+Overlap);
		translate([0,0,Gear_w+Gear_w/2+1-sBearing_w]) cylinder(d=sBearing_OD,h=sBearing_w+Overlap);
	} // difference
} // Planet

//for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,0]) rotate([0,0,180/PlanetBTeeth]) Planet(O_a=PlanetToothOffset_a*j);
//Planet(O_a=PlanetToothOffset_a);
//Planet();
//cylinder(d=13,h=50);
	
// *************************************************************************************
//  ***** Ring A, drive ring and bearing *****
// *************************************************************************************

module RingABearing(){
	OnePieceOuterRace(BallCircle_d=RingA_Bearing_BallCircle, Race_OD=RingA_Bearing_OD, Ball_d=Ball_d, 
			Race_w=RingA_Bearing_Race_w, PreLoadAdj=BearingPreload, VOffset=0.50, BI=true, myFn=$preview? 60:720);
	
	RingABearingMountingRing_t=3;
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
				Bolt4Hole();
	} // difference
} // RingABearing

//translate([15-0.5,0,0]) rotate([0,90,0]) RingABearing();

module RingA_Stop(HasSkirt=false, HasStop=true, Has2Sensors=true){
	RingABearingMountingRing_t=3;
	RingABearingMountingRing_BC_d=104;
	RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;
	nBolts=8;
	PostToRingB_h=24.5;
	
	module OptoMountPlate(Z=20){
		translate([0,-20,0]) cube([4,40,Z]);
	} // OptoMount
	
	module OptoMountHoles(){
		hull(){
			translate([0,0,8]) rotate([0,90,0]) cylinder(d=7,h=6);
			translate([0,0,25]) rotate([0,90,0]) cylinder(d=7,h=6);
		} // hull
		translate([0,-7.5,10]) rotate([0,-90,0]) Bolt4Hole();
		translate([0,7.5,10]) rotate([0,-90,0]) Bolt4Hole();
		translate([0,-7.5,20]) rotate([0,-90,0]) Bolt4Hole();
		translate([0,7.5,20]) rotate([0,-90,0]) Bolt4Hole();
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
			rotate([0,0,22.5]) translate([-EncoderSw_r,0,0]) OptoMountPlate(Z=PostToRingB_h);
			if (Has2Sensors==true) rotate([0,0,-22.5]) 
				translate([-EncoderSw_r,0,0]) OptoMountPlate(Z=PostToRingB_h);
		} // union
		
		// lower inside
		translate([0,0,-Overlap]) cylinder(d=RingA_Major_OD+8,h=RingABearingMountingRing_t+Overlap*2);
		
		// Optical sensor mount
		rotate([0,0,22.5]) translate([-EncoderSw_r-Overlap,0,0]) OptoMountHoles();
		if (Has2Sensors==true) rotate([0,0,-22.5]) 
			translate([-EncoderSw_r-Overlap,0,0]) OptoMountHoles();
			
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]){
			translate([RingABearingMountingRing_BC_d/2,0,0])
				rotate([180,0,0]) Bolt4Hole();
			translate([RingB_BC_d/2,0,PostToRingB_h]) Bolt4Hole();
		}
	} // difference
	
	if (HasStop==true)
	// hard stop
	rotate([0,0,22.5])
	difference(){
		union(){
			hull(){
				translate([RingA_Major_OD/2+7,-14,0]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,14,0]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,-2,10]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,2,10]) cylinder(d=3,h=1);
			}
			
			hull(){
				translate([RingA_Major_OD/2+5,0,5]) cylinder(d=8,h=6);
				translate([RingA_Major_OD/2+7,0,5]) cylinder(d=8,h=6);
				translate([RingA_Major_OD/2+9,0,0]) cylinder(d=8,h=1);
			} // hull
		} // union
		
		translate([50,0,-15]) cylinder(d=RingA_Major_OD-4,h=16);
	} // difference
	
} // RingA_Stop

// RingA_Stop(HasSkirt=true, HasStop=true, Has2Sensors=true);

module SwitchHoles(T=3){
	X=5.42+IDXtra;
	Y=4.53+IDXtra;
	Y1=5.5;
	Y2=13.4;
	
	translate([0,0,T]) Bolt4Hole();
	translate([-X/2,Y1-Y/2,-Overlap]) cube([X,Y,T+Overlap*2]);
	translate([-X/2,Y2-Y/2,-Overlap]) cube([X,Y,T+Overlap*2]);
} // SwitchHoles


module HomeSwitchMount(){
	BoltOffset_X=7.5;
	BoltOffset_Y=5;
	X=BoltOffset_X*2+Bolt4Inset*2;
	Y=BoltOffset_Y*2+Bolt4Inset*2+1;
	T=3;
	
	difference(){
		translate([-X/2,-Y/2-2,0]) cube([X,Y+2,T]);
		
		translate([-BoltOffset_X,-BoltOffset_Y,T]) Bolt4ClearHole();
		translate([-BoltOffset_X,BoltOffset_Y,T]) Bolt4ClearHole();
		translate([BoltOffset_X,-BoltOffset_Y,T]) Bolt4ClearHole();
		translate([BoltOffset_X,BoltOffset_Y,T]) Bolt4ClearHole();

		translate([0,-BoltOffset_Y-2.5,0]) SwitchHoles(T);
	} // difference
} // HomeSwitchMount

//rotate([0,0,22.5]) translate([-50,0,15]) rotate([0,-90,0]) rotate([0,0,-90]) HomeSwitchMount();

/*
RingA_Stop(HasSkirt=false, HasStop=true, Has2Sensors=true);
translate([0,0,Gear_w/2+6]) rotate([0,0,10]) RingA();
//rotate([180,0,0]) RingABearing();
//translate([0,0,Gear_w+16]) ScrewMountRingB();
translate([0,0,Gear_w/2+6+2]) RingA_HomeFinderDisk();
//translate([0,0,60]) rotate([180,0,0]) RoundRingC();
/**/

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

//translate([0,0,2]) RingA_EncoderDisk(PPR=7);

module RingA_HomeFinderDisk(){
	Thickness=1.5;
	
	difference(){
		cylinder(d=RingA_Major_OD+10,h=Thickness);
		
		// on 180°, off 180°
		difference(){
			translate([-RingA_Major_OD/2-10,0,-Overlap]) cube([RingA_Major_OD+20,RingA_Major_OD+20,Thickness+Overlap*2]);
			translate([0,0,-Overlap*2]) cylinder(d=RingA_Major_OD+4,h=Thickness+Overlap*4);
		} // difference
		
		// center hole
		translate([0,0,-Overlap]) cylinder(d=RingA_Major_OD-2+IDXtra,h=Thickness+Overlap*2);
	} // difference
	
} // RingA_HomeFinderDisk

//translate([0,0,2]) RingA_HomeFinderDisk();

module RingA(HasStop=true){
	
	ring_gear(number_of_teeth=RingATeeth,
		circular_pitch=GearAPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.2,
		gear_thickness=Gear_w/2,
		rim_thickness=Gear_w/2,
		rim_width=2,
		backlash=GearBacklash,
		twist=twist/RingATeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
	
	mirror([0,0,1])
		ring_gear(number_of_teeth=RingATeeth,
			circular_pitch=GearAPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Gear_w/2,
			rim_thickness=Gear_w/2,
			rim_width=2,
			backlash=GearBacklash,
			twist=twist/RingATeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
	
	RingA_Teeth_ID=RingATeeth*GearAPitch/180-GearAPitch/90;
	
	
	nSpokes=7;
	
	translate([0,0,-Gear_w/2])
	difference(){
		union(){
			cylinder(d=RingA_Major_OD,h=Gear_w-7);
			cylinder(d=RingA_Major_OD-2,h=Gear_w);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingA_OD,h=Gear_w+Overlap*2);
	} // difference
	

	// Skirt connecting bearing to gear
	translate([0,0,-Gear_w/2-6-Overlap])
	difference(){
		cylinder(d1=RingA_Bearing_BallCircle-Ball_d*0.7,d2=RingA_Major_OD,h=6+Overlap*2);
		
		translate([0,0,-Overlap]) cylinder(d1=RingA_Bearing_BallCircle-Ball_d*0.7-5,d2=RingA_Teeth_ID,h=6+Overlap*4);
	} // difference
	
	// Planet carrier bearing mount
	translate([0,0,-Gear_w/2-6-RingA_Bearing_Race_w])
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
	if (HasStop==true)
		difference(){
			hull(){
				translate([RingA_Major_OD/2+2,0,-8]) cylinder(d=8,h=4);
				translate([RingA_Major_OD/2-2,0,-8]) cylinder(d=8,h=4);
				translate([RingA_Major_OD/2-4,0,-15]) cylinder(d=4,h=1);
			} // hull
			
			translate([0,0,-15]) cylinder(d=RingA_Major_OD-4,h=16);
		} // difference
	
} // RingA

//RingA(HasStop=false);

// ***********************************************************************************************
//  ***** Ring B, Stationary ring gear *****
// ***********************************************************************************************

module RingB_Gear(){
	// Stationary Ring Gear
	// 12/17/2019 added RingB_OD_Xtra to thicken ring gear
	
	ring_gear(number_of_teeth=RingBTeeth,
		circular_pitch=GearBPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.2,
		gear_thickness=Gear_w/2,
		rim_thickness=Gear_w/2,
		rim_width=2,
		backlash=GearBacklash,
		twist=twist/RingBTeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
	
	mirror([0,0,1])
	ring_gear(number_of_teeth=RingBTeeth,
		circular_pitch=GearBPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.2,
		gear_thickness=Gear_w/2,
		rim_thickness=Gear_w/2,
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

module ScrewMountRingB(HasSkirt=false){
	
	nBolts=8;
	
	RingB_Gear();
	
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
		} // union
		
		// remove inside
		translate([0,0,-Overlap]) cylinder(d=RingB_OD,h=Gear_w+Overlap*2);
		
		// bolts to ring A
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) 
			translate([RingB_BC_d/2,0,Gear_w/2]) Bolt4HeadHole(depth=Gear_w);
		
		// bolts to Ring C
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) 
			translate([RingC_BC_d/2,0,Gear_w]) Bolt4Hole(depth=Gear_w);
	} // difference
	
} // ScrewMountRingB

//translate([0,0,14.5+Gear_w+1.1]) ScrewMountRingB(HasSkirt=true);

module RingB(){
	// old square version
	
	// Stationary Ring Gear
	// 12/17/2019 added RingB_OD_Xtra to thicken ring gear
	RingB_Gear();
		
	MB_X=90;
	MB_Y=MB_X;
	MB_Rim_t=2;
	nSpokes=16;
	Spoke_w=2;
	//echo(MB_X=MB_X);
	
	translate([0,0,-Gear_w/2])
	difference(){
		union(){
			difference(){
				translate([-MB_X/2,-MB_Y/2,0]) cube([MB_X,MB_Y,Gear_w]);
				translate([-MB_X/2+MB_Rim_t,-MB_Y/2+MB_Rim_t,-Overlap]) cube([MB_X-MB_Rim_t*2,MB_Y-MB_Rim_t*2,Gear_w+Overlap*2]);
			} // difference
			
			for (j=[0:3]) rotate([0,0,90*j]){
				hull(){
					translate([-MB_X/2+10-Bolt4Inset*1.5,-MB_Y/2,0]) cube([Bolt4Inset*3,Overlap,Gear_w]);
					translate([-MB_X/2+10-Bolt4Inset,-MB_Y/2+5,0]) cube([Bolt4Inset*2,Overlap,Gear_w]);
				} // hull
				hull(){
					translate([MB_X/2-10-Bolt4Inset*1.5,-MB_Y/2,0]) cube([Bolt4Inset*3,Overlap,Gear_w]);
					translate([MB_X/2-10-Bolt4Inset,-MB_Y/2+5,0]) cube([Bolt4Inset*2,Overlap,Gear_w]);
				} // hull
			} // for
			
			// Spokes
			difference(){
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
					translate([RingB_OD/2,0,0]) cylinder(d=Spoke_w,h=Gear_w);
					translate([MB_X*0.7,0,0]) cylinder(d=Spoke_w,h=Gear_w);
				} // hull
				
				difference(){
					translate([-MB_X/2-30,-MB_Y/2-30,-Overlap]) cube([MB_X+60,MB_Y+60,Gear_w+Overlap*2]);
					translate([-MB_X/2+1,-MB_Y/2+1,-Overlap*2]) cube([MB_X-2,MB_Y-2,Gear_w+Overlap*4]);
				} // difference
			} // difference
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingB_OD,h=Gear_w+Overlap*2);
		
		// Bolt holes
		for (j=[0:3]) rotate([0,0,90*j]) {
			
		translate([-MB_X/2+10,-MB_Y/2,Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([-MB_X/2+10,-MB_Y/2,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([MB_X/2-10,-MB_Y/2,Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([MB_X/2-10,-MB_Y/2,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		}
	} // difference
} // RingB

//translate([0,0,Gear_w+16]) RingB();
//translate([0,0,Gear_w+1]) RingB();
//rotate([0,0,180/RingBTeeth])

// ****************************************************************************************************
//  ***** Ring C, Motor mount, Commutator disk, end bearing support *****
//  ***** Used with a brushless gimbal motor (4008/5208) and "Hall switch" disk *****
// ****************************************************************************************************

module HallSwitchMount(){
	BoltOffset_X=6;
	BoltOffset_Y=5;
	X=BoltOffset_X*2+Bolt4Inset*2;
	Y=BoltOffset_Y*2+Bolt4Inset*2+1;
	T=3;
	
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
	
	module HallOptoMountHoles(){
		Bolt_Y=6;
		hull(){
			translate([+Overlap,0,22]) rotate([0,-90,0]) cylinder(d=7,h=12+Overlap);
			translate([-12,-3.5,6.5]) cube([12+Overlap,7,Overlap]); //cylinder(d=7,h=12);
		} // hull
		translate([0,-Bolt_Y,10]) rotate([0,90,0]) Bolt4Hole(depth=20);
		translate([0,Bolt_Y,10]) rotate([0,90,0]) Bolt4Hole(depth=20);
		translate([0,-Bolt_Y,20]) rotate([0,90,0]) Bolt4Hole(depth=20);
		translate([0,Bolt_Y,20]) rotate([0,90,0]) Bolt4Hole(depth=20);
	} // HallOptoMountHoles
	
module RingCSpacerGM4008Com(){
	nBolts=8;
	BoltBossB_h=6;
	Spacer_h=GM4008MP_h+PC_InnerGM4008_h+GM4008_h+0.5; // xtra 0.5 is a little extra space
	//echo(Spacer_h=Spacer_h);
	//echo(GM4008_h=GM4008_h);
	Encoder_z=Spacer_h-GM4008_h-12.6; // hole pattern offest from top 
	nPolePairs=GM4008_nPolePairs;
		
	
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
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
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
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,BoltBossB_h])
				Bolt4HeadHole(lHead=7);
		
		// Bolts to Ring C
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,Spacer_h])
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

// RingCSpacerGM4008Com();
	
module RingCSpacerGM5208Com(){
	// some dimensions are wrong, needs update w/ real motor values
	nBolts=8;
	BoltBossB_h=6;
	Spacer_h=GM5208MP_h+PC_InnerGM5208_h+GM5208_h+0.5; // xtra 0.5 is a little extra space
	//echo(Spacer_h=Spacer_h);
	//echo(GM5208_h=GM5208_h);
	Encoder_z=Spacer_h-GM5208_h-12.6; // hole pattern offest from top 
	nPolePairs=GM5208_nPolePairs;
	
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
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
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
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,BoltBossB_h])
				Bolt4HeadHole(lHead=7);
		
		// Bolts to Ring C
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,Spacer_h])
				Bolt4Hole();
	
		// center hole
			translate([0,0,-Overlap]) cylinder(d=RingB_OD+RingB_OD_Xtra-4,h=BoltBossB_h+Overlap);
			translate([0,0,BoltBossB_h-Overlap]) 
				cylinder(d1=RingB_OD+RingB_OD_Xtra-4,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);
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
	RingC_d=RingC_BC_d-Bolt4Inset*2;
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
		//translate([0,0,3]) cylinder(d=RingC_d-4,h=RingC_h+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,RingC_h])
			Bolt4HeadHole();
		
		// Motor mounting bolts
		for (j=[0:3]) rotate([0,0,45+90*j]) translate([GM5208SBC_d/2,0,5]) Bolt4ButtonHeadHole();

		// center hole
		translate([0,0,-Overlap]) cylinder(d=12,h=RingC_h+Overlap*2);
	} // difference
} // RingCCoverGM5208Com

//RingCCoverGM5208Com();

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


module RingCCover(){
	// Tall cover for magnetic encoder
	nBolts=8;
	RingC_d=RingC_BC_d-Bolt4Inset*2;
	RingC_h=6;
	Cover_h=30;
	
	difference(){
		union(){
			cylinder(d=RingC_d,h=RingC_h+Overlap);
			
			translate([0,0,RingC_h]) cylinder(d1=RingC_d,d2=45, h=Cover_h);
			
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
		translate([0,0,RingC_h]) cylinder(d1=RingC_d-4,d2=45-4,h=Cover_h-2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,RingC_h])
			Bolt4HeadHole();

	} // difference
} // RingCCover

//translate([0,0,6+23+6]) rotate([0,0,22.5]) RingCCover();

module RingCEncoderMount(){
	// Aligning the encoder to the motor phase 12N14P may require 360/14 rotation.
	
	Adj_a=360/14;
	
	if ($preview==true) translate([0,0,4]) color("Blue") cylinder(d=32,h=22);
	
	difference(){
		union(){
			cylinder(d=SE_Cover_OD+Bolt4Inset*4,h=2);
			translate([0,0,2.5]) IntegratedBase();
		} // union
		
		// bolt holes
		for (j=[0:Adj_a-1]){
			hull(){
				rotate([0,0,j]) translate([SE_Cover_OD/2+Bolt4Inset,0,-Overlap]) 
					cylinder(d=3,h=2+Overlap*2);
				rotate([0,0,j-1]) translate([SE_Cover_OD/2+Bolt4Inset,0,-Overlap]) 
					cylinder(d=3,h=2+Overlap*2);
			} // hull
			hull(){
				rotate([0,0,120+j]) translate([SE_Cover_OD/2+Bolt4Inset,0,-Overlap]) 
					cylinder(d=3,h=2+Overlap*2);
				rotate([0,0,120+j-1]) translate([SE_Cover_OD/2+Bolt4Inset,0,-Overlap]) 
					cylinder(d=3,h=2+Overlap*2);
			} // hull
			hull(){
				rotate([0,0,240+j]) translate([SE_Cover_OD/2+Bolt4Inset,0,-Overlap]) 
					cylinder(d=3,h=2+Overlap*2);
				rotate([0,0,240+j-1]) translate([SE_Cover_OD/2+Bolt4Inset,0,-Overlap]) 
					cylinder(d=3,h=2+Overlap*2);
			} // hull
			hull(){
				rotate([0,0,180+j]) translate([SE_Cover_OD/2+Bolt4Inset,0,-Overlap]) 
					cylinder(d=3,h=2+Overlap*2);
				rotate([0,0,180+j-1]) translate([SE_Cover_OD/2+Bolt4Inset,0,-Overlap]) 
					cylinder(d=3,h=2+Overlap*2);
			} // hull
		} // for
		
		translate([0,0,-Overlap]) cylinder(d=sBearing_OD,h=6);
	} // difference
	
} // RingCEncoderMount

//translate([0,0,6+23+4]) RingCEncoderMount();

module RoundRingCGM(){
	// Used w/ magnetic encoder on motor
	nBolts=8;
	RingC_d=RingC_BC_d-Bolt4Inset*2;
	RingC_h=6;
	RingC_Plate_h=4;
	
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
		translate([0,0,RingC_Plate_h]) cylinder(d=RingC_d-4,h=RingC_h-3+Overlap*2);
		
		// Motor mounting bolts
		for (j=[0:3]) rotate([0,0,45+90*j]) translate([MotorBC_d/2,0,RingC_Plate_h]) Bolt4ButtonHeadHole();
		
		// Encoder shaft bearing
		translate([0,0,-Overlap]) cylinder(d=sBearing_OD-1,h=RingC_h+Overlap*2);
		translate([0,0,1]) cylinder(d=sBearing_OD,h=RingC_h+Overlap*2);
		
		// encoder bolt holes
		translate([SE_Cover_OD/2+Bolt4Inset,0,RingC_Plate_h]) Bolt4Hole();
		rotate([0,0,120]) translate([SE_Cover_OD/2+Bolt4Inset,0,RingC_Plate_h]) 
					Bolt4Hole();
		rotate([0,0,240]) translate([SE_Cover_OD/2+Bolt4Inset,0,RingC_Plate_h]) 
					Bolt4Hole();
		rotate([0,0,180]) translate([SE_Cover_OD/2+Bolt4Inset,0,RingC_Plate_h]) 
					Bolt4Hole();
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,RingC_h])
			Bolt4HeadHole();
	} // difference
		
} // RoundRingCGM

//translate([0,0,6+23]) rotate([0,0,22.5]) RoundRingCGM();

// ****************************************************************************************************
//  ***** Ring C, Motor mount and end bearing support *****
//  ***** Used with the brushed gear motor belt driven version. *****
// ****************************************************************************************************

module RoundRect(X=10,Y=10,Z=5,R=3){
	hull(){
		translate([-X/2+R,-Y/2+R,0]) cylinder(r=R,h=Z);
		translate([-X/2+R,Y/2-R,0]) cylinder(r=R,h=Z);
		translate([X/2-R,-Y/2+R,0]) cylinder(r=R,h=Z);
		translate([X/2-R,Y/2-R,0]) cylinder(r=R,h=Z);
	} // hull
} // RoundRect

Motor_X=69.6; // 69.8 is OK but tight, 69.3; works but belt is loose
	
module RingCSpacer(HasSkirt=false){
	nBolts=8;
	BoltBossB_h=6;
	Spacer_h=21.5;
	
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
				}
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
	
		// Belt
		translate([0,0,BoltBossB_h]) rotate([0,0,180/nBolts]) difference(){
				hull(){
					cylinder(d=54+6,h=Spacer_h);
					translate([Motor_X,0,0]) cylinder(d=21+6,h=Spacer_h);
				} // hull
				translate([0,0,-Overlap])
					hull(){
						cylinder(d=54-15,h=Spacer_h+Overlap*2);
						translate([Motor_X,0,0]) cylinder(d=21-15,h=Spacer_h+Overlap*2);
					} // hull
			} // difference
		
		// center hole
		if (HasSkirt==true){
			translate([0,0,-Overlap]) cylinder(d=RingB_OD+RingB_OD_Xtra-4,h=BoltBossB_h+Overlap);
			translate([0,0,BoltBossB_h-Overlap]) cylinder(d1=RingB_OD+RingB_OD_Xtra-4,d2=RingC_BC_d-Bolt4Inset*2-4,h=Spacer_h-BoltBossB_h+Overlap*2);
		} else {
			translate([0,0,-Overlap]) cylinder(d=RingB_OD+RingB_OD_Xtra-4,h=Spacer_h+Overlap*3);
		}
	} // difference
} // RingCSpacer

//RingCSpacer(HasSkirt=true);
//RingCSpacer(HasSkirt=false);

module RoundRingC(HasSkirt=false){
	nBolts=8;
	MB_X=90;
	MB_Y=MB_X;
	nSpokes=8;
	Spoke_w=2;
	Motor_a=0;
	
	// Planet carrier bearing mount
	translate([0,0,Gear_w/2-(Bearing_w+2)])
	difference(){	

		cylinder(d=Bearing_OD+6,h=Bearing_w+2);
			
		//Bearing_OD=1.125*25.4;
		//Bearing_ID=0.500*25.4;
		//Bearing_w=0.3125*25.4;

		translate([0,0,-Overlap]) cylinder(d=Bearing_OD-1,h=3);
		translate([0,0,2]) cylinder(d=Bearing_OD,h=Bearing_w+1);
		
	} // difference
	
	if (HasSkirt==true) translate([0,0,Gear_w/2-2]) difference(){
		cylinder(d=RingC_BC_d-8,h=2);
		
		translate([0,0,-Overlap]) cylinder(d=Bearing_OD+5,h=2+Overlap*2);
	} // difference
	
	rotate([0,0,Motor_a])
	difference(){
		union(){
			cylinder(d=RingC_BC_d-8,h=Gear_w/2);
		// bolt bosses to ring C
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingB_OD/2-4,0,0])
					cylinder(d=Bolt4Inset*2+2,h=Gear_w/2);
				translate([RingC_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=Gear_w/2);
				
			}
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingC_BC_d-8-4,h=Gear_w/2+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,0])
			rotate([180,0,0]) Bolt4HeadHole();
	} // difference
			
	
	// Spokes
			difference(){
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
					translate([Bearing_OD/2+2,0,0]) cylinder(d=Spoke_w,h=Gear_w/2);
					translate([RingC_BC_d/2-6,0,0]) cylinder(d=Spoke_w,h=Gear_w/2);
				} // hull
				
				difference(){
					translate([-MB_X/2-30,-MB_Y/2-30,-Overlap]) cube([MB_X+60,MB_Y+60,Gear_w+Overlap*2]);
					translate([-MB_X/2+1,-MB_Y/2+1,-Overlap*2]) cube([MB_X-2,MB_Y-2,Gear_w+Overlap*4]);
				} // difference
			} // difference
			
			// motor mount
			
			
		/*	
	//belt
			translate([0,0,12])
		difference(){
			hull(){
				cylinder(d=54,h=10);
				translate([Motor_X,0,0]) cylinder(d=21,h=10);
			}
			translate([0,0,-Overlap])
			hull(){
				cylinder(d=54-5,h=10+Overlap*2);
				translate([Motor_X,0,0]) cylinder(d=21-5,h=10+Overlap*2);
			}
		}
			/**/
			
	MotorShaftHole_d=16;
	MotorSetback=8;
	Motor_BC_d=22.5;
	MotorBig_d=37;
	MotorFace_d=32;
	MM_t=6;
		Extra_W=22;
	
	difference(){
		hull(){
			translate([Motor_X,0,0]) cylinder(d=MotorBig_d,h=Gear_w/2);
			translate([RingB_OD/2-10,-(MotorBig_d+Extra_W)/2,0]) cube([Overlap,MotorBig_d+Extra_W,Gear_w/2]);
		} // hull
		
		hull(){
			rotate([0,0,32]) translate([RingB_OD/2+4,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,10]) translate([RingB_OD/2+4,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,7]) translate([RingB_OD/2+12,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,16.5]) translate([RingB_OD/2+22,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
		}
		
		mirror([0,1,0])
		hull(){
			rotate([0,0,32]) translate([RingB_OD/2+4,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,10]) translate([RingB_OD/2+4,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,7]) translate([RingB_OD/2+12,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,16.5]) translate([RingB_OD/2+22,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
		}
		
		translate([Motor_X,0,-Gear_w/2-Overlap]) cylinder(d=MotorFace_d,h=Gear_w-MotorSetback);
		translate([Motor_X,0,-Gear_w/2-Overlap]) cylinder(d=MotorShaftHole_d,h=Gear_w+Overlap*2);
		
		translate([Motor_X,0,Gear_w/2-MotorSetback+MM_t])
		for (j=[0:3]) rotate([0,0,90*j]) translate([Motor_BC_d/2,0,0]) Bolt8ButtonHeadHole(); //Bolt8ClearHole();
			
		// hex key access
		translate([Motor_X,0,Gear_w/2-3]) rotate([0,90,45]) cylinder(d=3,h=30);
		
		translate([0,0,-Overlap]) cylinder(d=RingC_BC_d-8-4,h=Gear_w/2+Overlap*2);
		
		// Bolts
		rotate([0,0,Motor_a])
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,0])
			rotate([180,0,0]) Bolt4HeadHole();
	} // difference
	
} // RoundRingC

//RoundRingC(HasSkirt=false);
//RoundRingC(HasSkirt=true);
//translate([0,0,10]) PlanetCarrierDrivePulley(nTeeth=32);

module RingC(){
	// Inner planet carrier support bearing
	
	RingB_OD=RingBTeeth*GearBPitch/180+GearBPitch/60;
	MB_X=90;
	MB_Y=MB_X;
	MB_Rim_t=2;
	nSpokes=8;
	Spoke_w=2;
	//echo(MB_X=MB_X);
	
	// Planet carrier bearing mount
	translate([0,0,Gear_w/2-(Bearing_w+2)])
	difference(){	

		cylinder(d=Bearing_OD+6,h=Bearing_w+2);
			
		//Bearing_OD=1.125*25.4;
		//Bearing_ID=0.500*25.4;
		//Bearing_w=0.3125*25.4;

		translate([0,0,-Overlap]) cylinder(d=Bearing_OD-1,h=3);
		translate([0,0,2]) cylinder(d=Bearing_OD,h=Bearing_w+1);
		
	} // difference
	
	translate([0,0,-Gear_w/2])
	difference(){
		union(){
			difference(){
				Rad=4;
				RoundRect(X=MB_X,Y=MB_Y,Z=Gear_w,R=Rad);
				translate([0,0,-Overlap]) RoundRect(X=MB_X-MB_Rim_t*2,Y=MB_Y-MB_Rim_t*2,Z=Gear_w+Overlap*2,R=Rad-MB_Rim_t);
			} // difference
			
			//difference(){
			//	translate([-MB_X/2,-MB_Y/2,0]) cube([MB_X,MB_Y,Gear_w]);
			//	translate([-MB_X/2+MB_Rim_t,-MB_Y/2+MB_Rim_t,-Overlap]) cube([MB_X-MB_Rim_t*2,MB_Y-MB_Rim_t*2,Gear_w+Overlap*2]);
			//} // difference
			
			// Bolt bosses
			for (j=[0:3]) rotate([0,0,90*j]){
				hull(){
					translate([-MB_X/2+10-Bolt4Inset*1.5,-MB_Y/2,0]) cube([Bolt4Inset*3,Overlap,Gear_w]);
					translate([-MB_X/2+10-Bolt4Inset,-MB_Y/2+5,0]) cube([Bolt4Inset*2,Overlap,Gear_w]);
				} // hull
				hull(){
					translate([MB_X/2-10-Bolt4Inset*1.5,-MB_Y/2,0]) cube([Bolt4Inset*3,Overlap,Gear_w]);
					translate([MB_X/2-10-Bolt4Inset,-MB_Y/2+5,0]) cube([Bolt4Inset*2,Overlap,Gear_w]);
				} // hull
			} // for
			
			// Spokes
			difference(){
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
					translate([Bearing_OD/2+2,0,Gear_w-(Bearing_w+2)]) cylinder(d=Spoke_w,h=Bearing_w+2);
					translate([MB_X*0.7,0,0]) cylinder(d=Spoke_w,h=Gear_w);
				} // hull
				
				difference(){
					translate([-MB_X/2-30,-MB_Y/2-30,-Overlap]) cube([MB_X+60,MB_Y+60,Gear_w+Overlap*2]);
					translate([-MB_X/2+1,-MB_Y/2+1,-Overlap*2]) cube([MB_X-2,MB_Y-2,Gear_w+Overlap*4]);
				} // difference
			} // difference
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=Bearing_OD+1,h=Gear_w+Overlap*2);
		
		// Bolt holes
		for (j=[0:3]) rotate([0,0,90*j]) {
			
		translate([-MB_X/2+10,-MB_Y/2,Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([-MB_X/2+10,-MB_Y/2,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([MB_X/2-10,-MB_Y/2,Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([MB_X/2-10,-MB_Y/2,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		}
		
	} // difference
	
	// motor mount
	Motor_X=69.8; // 69.3; works but belt is loose
	MotorShaftHole_d=16;
	MotorSetback=8;
	Motor_BC_d=22.5;
	MotorBig_d=37;
	MotorFace_d=32;
	MM_t=6;
	
	difference(){
		hull(){
			translate([Motor_X,0,Gear_w/2-MotorSetback]) cylinder(d=MotorBig_d,h=MotorSetback);
			translate([MB_X/2-Overlap,-(MotorBig_d+2)/2,-Gear_w/2]) cube([Overlap,MotorBig_d+2,Gear_w]);
		} // hull
		
		translate([Motor_X,0,-Gear_w/2-Overlap]) cylinder(d=MotorFace_d,h=Gear_w-MotorSetback);
		translate([Motor_X,0,-Gear_w/2-Overlap]) cylinder(d=MotorShaftHole_d,h=Gear_w+Overlap*2);
		
		translate([Motor_X,0,Gear_w/2-MotorSetback+MM_t])
		for (j=[0:3]) rotate([0,0,90*j]) translate([Motor_BC_d/2,0,0]) Bolt8ButtonHeadHole(); //Bolt8ClearHole();
			
		// hex key access
		translate([Motor_X,0,Gear_w/2-3]) rotate([0,90,45]) cylinder(d=3,h=30);
	} // difference
	
} // RingC


//RingC();
// ***********************************************************************************************
//  ***** Lifter Parts *****
// ***********************************************************************************************

module ShowLifter(){
	CenterDistance=-90;
	
	translate([CenterDistance,0,6]) LifterSpacer(nSpokes=7);
	translate([0,0,6]) LifterLock(nSpokes=7);
	translate([0,0,20]) LifterLockCover(nSpokes=7);
	LifterDogLeg();
	translate([0,0,-2.2]) LifterSpline();
	translate([CenterDistance,0,28]) LifterBearingCover(nSpokes=7);
} // ShowLifter

//ShowLifter();

module LifterSpacer(nSpokes=7){
	LC_h=14;
	Skirt_t=2;

	difference(){
		union(){
			// Bolt bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=LC_h);
			
			// skirt
			difference(){
				cylinder(d=RingA_Bearing_ID+2.5,h=LC_h);		
				
				translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LC_h+Overlap*2);
			} // difference
		} // union
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,LC_h]) Bolt4ClearHole(depth=LC_h+1);
		
	} // difference
} // LifterSpacer

//LifterSpacer();

Lock_Ball_d=3/8*25.4;

module LifterLock(nSpokes=7){
	// twist version
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

module LifterLockingRing(nSpokes=7){
	// Push-Pull version
	
	Lock_Ball_Circle_d=RingA_Bearing_ID+Lock_Ball_d;
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLR_h=Lock_Ball_d;
	
	difference(){
		union(){
			cylinder(d=Major_d,h=LLR_h);
			
			translate([0,0,LLR_h-4]) cylinder(d1=Major_d,d2=Major_d+2,h=3+Overlap);
			translate([0,0,LLR_h-1]) cylinder(d=Major_d+2,h=1);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=Lock_Ball_Circle_d+Lock_Ball_d-2,h=LLR_h+Overlap*2);
		
		// Bolts bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
					translate([Major_d/2-Bolt4Inset-2,0,-Overlap]) cylinder(r=Bolt4Inset+IDXtra,h=LLR_h+Overlap*4);
					translate([Major_d/2-Bolt4Inset*2,0,-Overlap]) cylinder(r=Bolt4Inset+1+IDXtra,h=LLR_h+Overlap*4);
			}
			
		// Ball detents
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) 
			translate([Lock_Ball_Circle_d/2,0,LLR_h/2]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
		
		// Ball releases
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
			translate([Lock_Ball_Circle_d/2,0,LLR_h/2-2]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
			translate([Lock_Ball_Circle_d/2+2,0,LLR_h/2-5]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
		} // hull
	} // difference
	
} // LifterLockingRing

//translate([0,0,10-Lock_Ball_d/2+5]) LifterLockingRing(); // unlocked
//rotate([180,0,0]) LifterLockingRing(); // for STL
//translate([0,0,10-Lock_Ball_d/2]) LifterLockingRing(); // locked

Dogbone_L=90;

module LifterLockCover(nSpokes=7){
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLC_h=8;
	Skirt_t=5;
	WirePath_w=25;
	
	difference(){
		union(){
			cylinder(d=Major_d-Bolt4Inset*2,h=2);
			
			translate([-Dogbone_L,0,0]){
				// skirt
				difference(){
					union(){
						cylinder(d=RingA_Bearing_ID+2.5,h=LLC_h);
						cylinder(d=RingA_Bearing_ID-8,h=LLC_h);
							
					}
					
					translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LLC_h+Overlap*2);
					
					hull(){
						translate([0,0,2]) cylinder(d=RingA_Bearing_ID-42,h=LLC_h+Overlap*2);
						translate([50,0,2]) cylinder(d=RingA_Bearing_ID-42,h=LLC_h+Overlap*2);
					} // hull
				} // difference
				
				// Bolt bosses
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
						translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=LLC_h);
			} // translate
			
			//wire path
			difference(){
				hull(){
					translate([15,WirePath_w/2,0]) cylinder(d=10,h=Overlap);
					translate([15,WirePath_w/2,4]) sphere(d=8);
					
					translate([15,-WirePath_w/2,0]) cylinder(d=10,h=Overlap);
					translate([15,-WirePath_w/2,4]) sphere(d=8);
					
					translate([-75,WirePath_w/2,0]) cylinder(d=10,h=Overlap);
					translate([-75,WirePath_w/2,4]) sphere(d=8);
					
					translate([-75,-WirePath_w/2,0]) cylinder(d=10,h=Overlap);
					translate([-75,-WirePath_w/2,4]) sphere(d=8);
				} // hull
				
				hull(){
					translate([15,WirePath_w/2,2]) cylinder(d=6,h=Overlap);
					translate([15,WirePath_w/2,4]) sphere(d=4);
					
					translate([15,-WirePath_w/2,2]) cylinder(d=6,h=Overlap);
					translate([15,-WirePath_w/2,4]) sphere(d=4);
					
					translate([-75,WirePath_w/2,2]) cylinder(d=6,h=Overlap);
					translate([-75,WirePath_w/2,4]) sphere(d=4);
					
					translate([-75,-WirePath_w/2,2]) cylinder(d=6,h=Overlap);
					translate([-75,-WirePath_w/2,4]) sphere(d=4);
				} // hull
			} // difference
				
			// Bolts bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
					translate([Major_d/2-Bolt4Inset-2,0,0]) cylinder(r=Bolt4Inset,h=LLC_h);
					translate([Major_d/2-Bolt4Inset*2,0,0]) cylinder(r=Bolt4Inset+1,h=LLC_h);
			}
		} // union
		
		translate([-Dogbone_L,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LLC_h+Overlap*2);
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) translate([Major_d/2-Bolt4Inset-2,0,LLC_h]) Bolt4HeadHole();
		
		translate([-Dogbone_L,0,0])
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,LLC_h]) Bolt4ClearHole();
		
		hull(){
			translate([15,WirePath_w/2,-Overlap]) cylinder(d=6,h=Overlap);
			translate([15,WirePath_w/2,4]) sphere(d=4);
			
			translate([15,-WirePath_w/2,-Overlap]) cylinder(d=6,h=Overlap);
			translate([15,-WirePath_w/2,4]) sphere(d=4);
			
			translate([-25,WirePath_w/2,-Overlap]) cylinder(d=6,h=Overlap);
			translate([-25,WirePath_w/2,4]) sphere(d=4);
			
			translate([-25,-WirePath_w/2,-Overlap]) cylinder(d=6,h=Overlap);
			translate([-25,-WirePath_w/2,4]) sphere(d=4);
		} // hull
			
	} // difference
} // LifterLockCover

//translate([0,0,20]) LifterLockCover();

module LifterOneRing(nSpokes=7){
	Skirt_h=8;
	Skirt_t=5;
	
	difference(){
		union(){
			// skirt
			difference(){
				cylinder(d=RingA_Bearing_ID+2.5,h=Skirt_h);
				
				translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=Skirt_h+Overlap*2);
				
				hull(){
					translate([0,0,2]) cylinder(d=RingA_Bearing_ID-12-Skirt_t*2,h=Skirt_h+Overlap*2);
					translate([50,0,2]) cylinder(d=RingA_Bearing_ID-12-Skirt_t*2,h=Skirt_h+Overlap*2);
				} // hull
			} // difference
			
			// Bolt bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=Skirt_h);
			
		} // union
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,Skirt_h]) Bolt4ClearHole();
	} // difference
} // LifterOneRing

//translate([-90,0,20]) LifterOneRing();

module LifterDogLeg(nSpokes=7){
	Spline_h=20;
	Lock_Ball_Circle_d=RingA_Bearing_ID+Lock_Ball_d;
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLC_h=6;
	Skirt_t=5;
	
	difference(){
		union(){
			cylinder(d=Major_d,h=Spline_h);
			
			translate([-Dogbone_L,0,0]){
				// skirt
				difference(){
					union(){
						cylinder(d=RingA_Bearing_ID+2.5,h=LLC_h);
						hull(){
							cylinder(d=RingA_Bearing_ID,h=5);
							translate([Dogbone_L,0,0]) cylinder(d=RingA_Bearing_ID,h=5);
						} // hull
					} // union
					
					translate([0,0,2]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LLC_h+Overlap*2);
					
				} // difference
				
				// Bolt bosses
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
						translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=LLC_h);
			} // translate
		} // union
		
		translate([-Dogbone_L,0,0])
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) rotate([180,0,0]) Bolt4HeadHole();
		
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
} // LifterDogLeg

//translate([0,0,2+Overlap]) LifterDogLeg();

//LifterDogLeg();
//translate([100,0,30]) rotate([0,180,0]) LifterBearingCover(); 

module LifterSpline(nSpokes=7){
	Spline_h=20;
	Lock_Ball_Circle_d=RingA_Bearing_ID/2+Lock_Ball_d/2;
	
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
			translate([Lock_Ball_Circle_d,0,2+Spline_h/2]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
	} // difference
	
} // LifterSpline

//translate([0,0,-2.2]) LifterSpline();

module LifterBearingCover(nSpokes=7){
	difference(){
		union(){
			// bearing cover
			difference(){
				cylinder(d=RingA_Bearing_BallCircle+Ball_d+4,h=2);
				translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_BallCircle-Ball_d-8,h=2+Overlap*2);
			} // difference
			
			// Bolt bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=2);
		} // union
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,2]) Bolt4ClearHole();
	} // difference
} // LifterBearingCover

//translate([0,0,-2.2]) 
//LifterBearingCover();

module LifterRing(nSpokes=7){
	// old version
	
	Skirt_h=6;
	Skirt_t=5;
	
	difference(){
		union(){
			
			// skirt
			difference(){
				union(){
					cylinder(d=RingA_Bearing_ID+2.5,h=Skirt_h);
					difference(){
						translate([50,0,0]) cylinder(d=RingA_Bearing_ID+2.5,h=Skirt_h);
						translate([50,0,2]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=Skirt_h);
					} // difference
					
					hull(){
						cylinder(d=RingA_Bearing_ID-8,h=Skirt_h);
						translate([50,0,0]) cylinder(d=RingA_Bearing_ID-8,h=Skirt_h);
					} // hull
				}
				
				translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=Skirt_h+Overlap*2);
				translate([50,0,2]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=Skirt_h+Overlap*2);
				hull(){
					translate([0,0,2]) cylinder(d=RingA_Bearing_ID-12-Skirt_t*2,h=Skirt_h+Overlap*2);
					translate([50,0,2]) cylinder(d=RingA_Bearing_ID-12-Skirt_t*2,h=Skirt_h+Overlap*2);
				} // hull
			} // difference
			
			// Bolt bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=Skirt_h);
			
			translate([50,0,0]) rotate([0,0,180])
			for (j=[0:nSpokes-2]) rotate([0,0,360/nSpokes*(j+1)])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=Skirt_h);
			
		} // union
		
		// Bolts
		for (j=[0:nSpokes-4]) rotate([0,0,360/nSpokes*(j+2)])
					translate([RingA_Bearing_ID/2,0,Skirt_h]) Bolt4ClearHole();
		
		for (j=[0:nSpokes-5]) rotate([0,0,360/nSpokes*(j+6)])
					translate([RingA_Bearing_ID/2,0,Skirt_h]) Bolt4HeadHole();
		
		translate([50,0,0]) rotate([0,0,180])
		for (j=[0:nSpokes-4]) rotate([0,0,360/nSpokes*(j+2)])
					translate([RingA_Bearing_ID/2,0,0]) rotate([180,0,0]) Bolt4HeadHole();
	} // difference
} // LifterRing

//translate([0,0,-RingA_Bearing_Race_w-0.5]) RingABearing();
//translate([0,0,-Gear_w/2-RingA_Bearing_Race_w-6-Overlap*2]) rotate([180,0,0]) RingA();
//LifterRing();
//translate([50,0,18.4]) rotate([180,0,180]) LifterRing();

// **************************************************************************************
//  ***** Test and old below here *****
// **************************************************************************************

module TestFixture(){
	MB_X=90;
	MB_Y=MB_X;
	MB2_X=95;
	MB2_Y=MB2_X;
	MB_Rim_t=2.5-IDXtra;
	C_L=25;
	
	module Corners(){
		
		difference(){
			difference(){
				translate([-MB2_X/2,-MB2_Y/2,0]) cube([MB2_X,MB2_Y,Gear_w]);
				translate([-MB2_X/2+MB_Rim_t,-MB2_Y/2+MB_Rim_t,-Overlap]) cube([MB2_X-MB_Rim_t*2,MB2_Y-MB_Rim_t*2,Gear_w+Overlap*2]);
				
				for (j=[0:3]) rotate([0,0,90*j]) translate([-MB2_X/2+C_L,-MB2_Y/2-Overlap,-Overlap])
					cube([MB2_X-C_L*2,10,Gear_w+Overlap*2]);
			} // difference
			
			// Bolt holes
		for (j=[0:3]) rotate([0,0,90*j]) {
			translate([-MB_X/2+10,-MB_Y/2-5,Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
			translate([-MB_X/2+10,-MB_Y/2-5,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
			translate([MB_X/2-10,-MB_Y/2-5,Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
			translate([MB_X/2-10,-MB_Y/2-5,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
			}
	} // difference
	} // Corners
	
	translate([0,0,32]) Corners();
	translate([0,0,32+18+20]) Corners();
	
	for (j=[0:3]) rotate([0,0,90*j]){
		// Inner planet carrier Bearing holder to hull mount (Ring B)
		hull(){
			translate([-MB2_X/2,-MB2_Y/2,32+18+20]) 
				cube([MB_Rim_t,C_L,Overlap]);
				
			translate([-MB2_X/2,-MB2_Y/2,32+18-Overlap]) 
				cube([MB_Rim_t,C_L,Overlap]);
		}
		
		hull(){
			translate([-MB2_X/2,-MB2_Y/2,32+18+20]) 
				cube([C_L,MB_Rim_t,Overlap]);
			
			translate([-MB2_X/2,-MB2_Y/2,32+18-Overlap]) 
				cube([C_L,MB_Rim_t,Overlap]);
		}
		
		hull(){
			translate([-MB2_X/2,-MB2_Y/2,32]) 
				cube([MB_Rim_t,C_L,Overlap]);
				
			rotate([0,0,45]) translate([-(RingABearingMountingRing_BC_d+15)/2+1,0,5]) cylinder(r=1,h=Overlap);
			
			intersection(){
				difference(){
					translate([0,0,20-Overlap]) cylinder(d=RingABearingMountingRing_BC_d+15,h=Overlap);
					translate([0,0,20-Overlap*2]) cylinder(d=RingABearingMountingRing_BC_d+10,h=Overlap*5);
				} // difference
				translate([-MB2_X/2-5,-MB2_Y/2-5,20-Overlap]) cube([16,28,1]);
			} // intersection
			
		} // hull
		
		hull(){
			translate([-MB2_X/2,-MB2_Y/2,32]) 
				cube([C_L,MB_Rim_t,Overlap]);
			
			rotate([0,0,45]) translate([-(RingABearingMountingRing_BC_d+15)/2+1,0,5]) cylinder(r=1,h=Overlap);
			
			intersection(){
				difference(){
					translate([0,0,20-Overlap]) cylinder(d=RingABearingMountingRing_BC_d+15,h=Overlap);
					translate([0,0,20-Overlap*2]) cylinder(d=RingABearingMountingRing_BC_d+10,h=Overlap*5);
				} // difference
				translate([-MB2_X/2-5,-MB2_Y/2-5,20-Overlap]) cube([28,16,1]);
			} // intersection
			
			
			//translate([-MB2_X/2,-MB2_Y/2,19]) 
			//	cube([C_L,MB_Rim_t,Overlap]);
		}

	}
	
	RingABearingMountingRing_t=3;
	Skirt_h=20;
	RingABearingMountingRing_BC_d=100;
	RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;
	nBolts=8;
	
	difference(){
		union(){
			cylinder(d=RingABearingMountingRing_BC_d+15,h=Skirt_h);
			
	
		} // union
		
		translate([0,0,3]) cylinder(d=RingABearingMountingRing_BC_d+10,h=Skirt_h);
		
		translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_OD+IDXtra*2,h=RingABearingMountingRing_t+Overlap*2);
		
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j])
			translate([RingABearingMountingRing_BC_d/2,0,RingABearingMountingRing_t+3])
				Bolt4ClearHole();
	} // difference
} // TestFixture

//TestFixture();
//translate([0,0,6]) rotate([180,0,0]) RingABearing();





