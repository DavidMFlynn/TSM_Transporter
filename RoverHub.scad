// *************************************************
// Powered Hub
//
// Filename: RoverHub.scad
// By: David M. Flynn
// Created: 1/15/2021
// Revision: 1.0.0 1/15/2021 First Code.
// Units: mm
// *************************************************
//  ***** Notes *****
// Just a test
// *************************************************
//  ***** History ******
// 1.0.0 1/15/2021 First Code.
// *************************************************
//  ***** for STL output *****
// 
// *************************************************
//  ***** for Viewing *****
//
// *************************************************
include<BearingLib.scad>
include<ring_gear.scad>
include<involute_gears.scad>
include<SplineLib.scad>
include<CommonStuffSAEmm.scad>

$fn=$preview? 24:90;
Overlap=0.05;
IDXtra=0.2;
Bolt4Inset=4;


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

WT_OD=8; // Wire Tube OD

RingATeeth=75;
RingBTeeth=70;
GearAPitch=280;
GearBPitch=300;
Pressure_a=22;
RingGearClearance=0.5;
Gear_w=5;
GearBacklash=0.2;
twist=0;

nPlanets=5;
PlanetATeeth=20;
PlanetBTeeth=20;
GearClearance=0.4;
sBearing_OD=5;
PlanetAToothOffset_a=360/PlanetATeeth/nPlanets;
PlanetBToothOffset_a=360/PlanetBTeeth/nPlanets;


PlanetA_Center=GearAPitch*RingATeeth/360-GearAPitch*PlanetATeeth/360;
//PlanetB_Center=GearBPitch*RingBTeeth/360-GearBPitch*PlanetBTeeth/360;
//echo(PlanetA_Center=PlanetA_Center);
//echo(PlanetB_Center=PlanetB_Center);


module GimbalMotor4008(){
	color("Gray")
			difference(){
				cylinder(d=GM4008_d,h=GM4008_h);
				translate([0,0,-Overlap]) cylinder(d=8,h=GM4008_h+Overlap*2);
			} // difference
} // GimbalMotor5208

GimbalMotor4008();

GM4008MP_h=5; // Mounting Plate thickness

module GM4008CommutatorDisk(CommDisk_h=1.5){
	nPolePairs=GM4008_nPolePairs;
	nNotchStep=30;
	
	difference(){
		cylinder(d=GM4008Comm_d,h=CommDisk_h);			
		
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
	
	// Commutation sensor positions
	if ($preview==true) 
	for (j=[0:2]) rotate([0,0,360/nPolePairs/3*j]) translate([GM4008Comm_d/2+1,0,0]) cylinder(d=2,h=2);
} // GM4008CommutatorDisk

//GM4008CommutatorDisk();

module GM4008MountingPlate(HasCommutatorDisk=true, ShowMotor=true){
	Spline_d=GM4008_Spline_d;
	nSplines=GM4008_nSplines;
	nPolePairs=GM4008_nPolePairs;
	CommDisk_h=1.5;
	nNotchStep=30;
	Hub_h=2.5;
	
	WireTube_d=WT_OD+1;
	
	difference(){
		union(){
			cylinder(d=GM4008RBC2_d+Bolt4Inset*2,h=Hub_h);
			//cylinder(d=Spline_d+5,h=GM4008MP_h);
			
			if (HasCommutatorDisk==true) GM4008CommutatorDisk();
		} // union
		
		//translate([0,0,-Overlap]) rotate([0,0,45]) SplineHole(d=Spline_d,l=GM4008MP_h+Overlap*2,nSplines=nSplines,Spline_w=30,Gap=IDXtra,Key=false);
		
		translate([0,0,-Overlap]) cylinder(d=WireTube_d, h=Hub_h+Overlap*2);
		for (j=[0:3]) rotate([0,0,90*j]) translate([GM4008RBC2_d/2,0,3.5]) Bolt4ButtonHeadHole();
			
		
	} // difference
	
	// motor
	if ($preview==true && ShowMotor==true) rotate([180,0,0]) GimbalMotor4008();
		
} // GM4008MountingPlate

//GM4008MountingPlate(HasCommutatorDisk=false);

// OnePieceInnerRace(BallCircle_d=100,	Race_ID=50,	Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, BI=false, myFn=360);
// OnePieceOuterRace(BallCircle_d=60, Race_OD=75, Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, BI=false, myFn=360);

Ball_d=3/8*25.4;
BC_d=GearAPitch*RingATeeth/180+GearAPitch/16+Ball_d;
Race_w=10;

module RingA(){
	ring_gear(number_of_teeth=RingATeeth,
		circular_pitch=GearAPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = RingGearClearance,
		gear_thickness=Gear_w,
		rim_thickness=Gear_w,
		rim_width=2,
		backlash=GearBacklash,
		twist=twist/RingATeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
	
	OnePieceInnerRace(BallCircle_d=BC_d, Race_ID=BC_d-Ball_d-6,	Ball_d=Ball_d, Race_w=Race_w, PreLoadAdj=0.00, VOffset=0.00, BI=true, myFn=$preview? 360:90);
} // RingA

RingA();

module RingB(){
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
	
	OnePieceOuterRace(BallCircle_d=BC_d, Race_OD=BC_d+Ball_d+6, Ball_d=Ball_d, Race_w=Race_w, PreLoadAdj=0.00, VOffset=0.00, BI=true, myFn=$preview? 360:90);
} // RingB

//translate([0,0,Gear_w+1]) RingB();

module Planet(){
	
	gear(number_of_teeth=PlanetATeeth,
				circular_pitch=GearAPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = GearClearance,
				gear_thickness=Gear_w,
				rim_thickness=Gear_w,
				rim_width=5,
				hub_thickness=Gear_w,
				hub_diameter=10,
				bore_diameter=sBearing_OD-IDXtra,
				circles=0,
				backlash=GearBacklash,
				twist=twist/PlanetATeeth,
				involute_facets=0,
				flat=false);
} // Planet

RingATeethPerPlanet=RingATeeth/nPlanets; // 12.2t
RingBTeethPerPlanet=RingBTeeth/nPlanets;
//echo(RingATeethPerPlanet=RingATeethPerPlanet);
PlanetADegPerTooth=360/PlanetATeeth; // 27.69
PlanetBDegPerTooth=360/PlanetBTeeth;
//echo(RingATeethPerPlanet*PlanetADegPerTooth);
PlanetADegPerPlanet=RingATeethPerPlanet*PlanetADegPerTooth;
PlanetBDegPerPlanet=RingBTeethPerPlanet*PlanetBDegPerTooth;
//echo(DegPerPlanet=DegPerPlanet);
PlanetOffset_a=PlanetADegPerPlanet-PlanetBDegPerPlanet;

for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j])
	translate([PlanetA_Center,0,0])  rotate([0,0,-PlanetADegPerPlanet*j+180/PlanetATeeth]) Planet();


//for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j])
//	translate([PlanetA_Center,0,Gear_w+1]) rotate([0,0,-PlanetADegPerPlanet*j+PlanetOffset_a*j+180/PlanetBTeeth]) Planet();














