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
//
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

module GimbalMotor4008(){
	color("Gray")
			difference(){
				cylinder(d=GM4008_d,h=GM4008_h);
				translate([0,0,-Overlap]) cylinder(d=8,h=GM4008_h+Overlap*2);
			} // difference
} // GimbalMotor5208

GimbalMotor4008();

GM4008MP_h=5; // Mounting Plate thickness

module GM4008MountingPlate(HasCommutatorDisk=true, ShowMotor=true){
	Spline_d=GM4008_Spline_d;
	nSplines=GM4008_nSplines;
	nPolePairs=GM4008_nPolePairs;
	CommDisk_h=1.5;
	nNotchStep=30;
	
	WireTube_d=WT_OD+1;
	
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
	if ($preview==true && ShowMotor==true) rotate([180,0,0]) GimbalMotor4008();
		
	// Commutation sensor positions
	if ($preview==true) 
	for (j=[0:2]) rotate([0,0,360/nPolePairs/3*j]) translate([GM4008Comm_d/2+1,0,0]) cylinder(d=2,h=2);
} // GM4008MountingPlate

//GM4008MountingPlate(HasCommutatorDisk=true);

RingATeeth=61;
GearAPitch=260;
Pressure_a=28;
RingGearClearance=0.5;
Gear_w=5;
GearBacklash=0.2;
twist=0;

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

nPlanets=5;
PlanetATeeth=13;
GearClearance=0.4;
sBearing_OD=5;
PlanetToothOffset_a=360/PlanetATeeth/nPlanets;

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

for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j])
translate([GearAPitch*RingATeeth/360-GearAPitch*PlanetATeeth/360,0,0]) rotate([0,0,-PlanetToothOffset_a*j]) rotate([0,0,180/PlanetATeeth]) Planet();
















