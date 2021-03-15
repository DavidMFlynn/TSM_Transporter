// **************************************
// Head Lamp w/ Pan & Tilt
// Project: TSM_Transporter
// by David M. Flynn
// Filename: TSM_HeadLamp.scad
// Created: 3/9/2021
// Revision: 1.0.1  3/14/2021
// Units: mm
// **************************************
//  ***** History *****
// 1.0.1  3/14/2021 Lamp Power Plug.
// 1.0.0  3/13/2021 FC1, Added BC and difference routines
// 0.9.2  3/11/2021 Servo Mounts
// 0.9.1  3/10/2021 Sized for small flashlight, cut globe in half.
// 0.9.0  3/9/2021  First Code
// **************************************
//  ***** for STL output *****
// rotate([90,0,0]) Globe(IsFront=true);
// rotate([-90,0,0]) Globe(IsFront=false);
// rotate([90,0,0]) ForwardMount();
// rotate([-90,0,0]) BackFingers();
// **************************************
//  ***** Routines *****
// HeadLampBC(FrontOffset=HL_Flange_t) Bolt4HeadHole();
// HL_Mount(); // used as difference
// **************************************
//  ***** for Viewing *****
// ViewHeadLampAssy(Pan_a=7,Tilt_a=2); // ±7°
// **************************************

include <SG90ServoLib.scad>
include <CommonStuffSAEmm.scad>

$fn=$preview? 36:180;
Overlap=0.05;
IDXtra=0.2;

// Global constants
Globe_d=40; // Diameter of globe
HL_CupWall_t=2; // Thickness of front mount
HL_Cup_d=Globe_d+HL_CupWall_t*2; // Diameter of front mount
HL_Flange_d=Globe_d+13; // Diameter of mounting flange

Rim_Anulus=2; // Ring on front
Lamp_d=25; // Diameter of flashlight, hole thru globe
HL_Globe_nBolts=3; // Bolts to hold the globe together
HL_Flange_t=3; // Front flange thickness

module ViewHeadLampAssy(Pan_a=0,Tilt_a=0){
	color("LightBlue") rotate([Pan_a,0,Tilt_a]){
		Globe();
		Globe(IsFront=false);}
	
	color("Gray") ForwardMount();
	
	translate([0,-Overlap*2,0]) color("tan") BackFingers();
} // ViewHeadLampAssy

// ViewHeadLampAssy(Pan_a=4,Tilt_a=2); // ±7°

module LampPowerPlug(){
	LampID=17; // check this...
	LampDepth=15;
	
	BackPlate_t=2;
	
	difference(){
		union(){
			cylinder(d=Lamp_d-1, h=BackPlate_t);
			cylinder(d=LampID, h=BackPlate_t+LampDepth);
		} // union
		
		//Wires
		translate([0,0,-Overlap]) cylinder(d=3, h=BackPlate_t+LampDepth+Overlap*2);
		translate([0,0,3]) rotate([90,0,0]) cylinder(d=3, h=LampID);
		
		// Sping
		translate([0,0,BackPlate_t+LampDepth-2]) cylinder(d=6,h=4);
	} // difference
} // LampPowerPlug

LampPowerPlug();

module HeadLampBC(FrontOffset=HL_Flange_t){	
	rotate([-90,0,0]) for (j=[0:7]) rotate([0,0,45*j+22.5]) translate([0,Globe_d/2+4,FrontOffset]) children();
} // HeadLampBC

//HeadLampBC() Bolt4HeadHole();

module Globe(IsFront=true){
	ControlHornLen=8;
	ControlHornWidth=3;
	ControlHornThickness=2.4;
	nBolts=HL_Globe_nBolts;
	Core_d=IsFront? Lamp_d+IDXtra:Lamp_d+1;
	
	difference(){
		union(){
			sphere(d=Globe_d);
			
			rotate([-90,0,0]) cylinder(d=Core_d+Rim_Anulus*2,h=Globe_d/2-3);
			
			/*
			// control horns
			rotate([12,0,0]) hull(){
				cylinder(d=ControlHornThickness, h=Globe_d/2+ControlHornLen);
				translate([0,-ControlHornWidth,0]) cylinder(d=ControlHornThickness, h=Globe_d/2+ControlHornLen);}
			
			rotate([0,0,-12]) hull(){
				rotate([0,90,0]) cylinder(d=ControlHornThickness, h=Globe_d/2+ControlHornLen);
				translate([0,-ControlHornWidth,0]) rotate([0,90,0]) 
					cylinder(d=ControlHornThickness, h=Globe_d/2+ControlHornLen);}
			/**/
		} // union
		
		if (IsFront==true){
			rotate([90,0,0]) cylinder(d=Globe_d+ControlHornLen*2+2, h=Globe_d);
			for (j=[0:nBolts-1]) rotate([0,360/nBolts*(j+0.25),0]) translate([0,0,Globe_d/2-4]) rotate([90,0,0]) Bolt4Hole(depth=8);
		}else{
			rotate([-90,0,0]) cylinder(d=Globe_d+2, h=Globe_d);
			for (j=[0:nBolts-1]) rotate([0,360/nBolts*(j+0.25),0]) translate([0,-6,Globe_d/2-4]) rotate([90,0,0]) Bolt4HeadHole(depth=8);
		}
		
		// core hole
		//sphere(d=Globe_d-6);
		rotate([-90,0,0]) cylinder(d=Core_d, h=Globe_d+Overlap*2, center=true);
		
		// control horn bolts
		rotate([12,0,0]) translate([0,0,Globe_d/2]) Bolt4Hole();
		rotate([12,90,0]) translate([0,0,Globe_d/2]) Bolt4Hole();
		/*
		// control horn bolts
		rotate([12,0,0]) translate([-ControlHornThickness,-ControlHornWidth/2,Globe_d/2+ControlHornLen-3]) 
			rotate([0,-90,0]) Bolt2Hole();
		rotate([0,0,-12]) translate([Globe_d/2+ControlHornLen-3,-ControlHornWidth/2,ControlHornThickness]) 
			 Bolt2Hole();
		/**/
	} // difference
} // Globe

//color("LightBlue") rotate([-7,0,7]) Globe(IsFront=true);
//Globe(IsFront=false);

module HL_Mount(){ // used as difference
	sphere(d=HL_Cup_d+IDXtra*2);
	// Mounting face
	rotate([-90,0,0]) translate([0,0,-HL_Flange_t]) cylinder(d=HL_Flange_d+IDXtra*2,h=HL_Flange_t*2);
} // HL_Mount

module ForwardMount(){
	CupWall_t=HL_CupWall_t;
	Flange_t=HL_Flange_t;
	Flange_d=HL_Flange_d;
	
	difference(){
		union(){
			sphere(d=Globe_d+CupWall_t*2);
			// Mounting face
			rotate([-90,0,0]) cylinder(d=Flange_d,h=Flange_t);
		} // union
		
		// hollow out interior
		sphere(d=Globe_d+IDXtra); // Front bearing surface
		difference(){
			sphere(d=Globe_d+IDXtra*3);
			translate([0,Globe_d/2*0.4,0]) rotate([-90,0,0]) cylinder(d=Globe_d, h=Globe_d/2);
		} // difference
		
		// Front opening
		rotate([-90,0,0]) translate([0,0,-Globe_d/2]) cylinder(d1=Rim_Anulus*2, d2=Globe_d+Rim_Anulus*2, h=Globe_d+CupWall_t);
		
		// Remove back half
		translate([0,-Globe_d,0]) cube([Globe_d*2,Globe_d*2,Globe_d*2],center=true);
		
		// Bolts
		HeadLampBC(FrontOffset=HL_Flange_t) Bolt4ClearHole();
			//Bolt4Hole();
	} // difference
	
} // ForwardMount

//ForwardMount();

module BackFingers(){
	CupWall_t=3;
	Flange_t=4;
	Flange_d=HL_Flange_d;
	FingerWidth=4;
	FingerSpread=10;
	
	difference(){
		union(){
			sphere(d=Globe_d+CupWall_t*2);
			// Mounting face
			rotate([90,0,0]) cylinder(d=Flange_d,h=Flange_t);
			
			// Servo mount
			translate([14.5,-38,11]) rotate([0,-45,0]) cube([20,38,5]);
			hull(){
				translate([14.5,-3,11]) rotate([0,-45,0]) cube([20,Flange_t,5]);
				translate([Globe_d/2+3,0,0]) rotate([90,0,0]) cylinder(d=3, h=Flange_t);
			} // hull
			
			rotate([0,90,0]){
			translate([14.5,-38,11]) rotate([0,-45,0]) cube([20,38,5]);
			hull(){
				translate([14.5,-3,11]) rotate([0,-45,0]) cube([20,Flange_t,5]);
				translate([Globe_d/2+3,0,0]) rotate([90,0,0]) cylinder(d=3, h=Flange_t);
			}} // hull
		} // union
		
		// hollow out interior
		sphere(d=Globe_d+IDXtra);
		difference(){
			sphere(d=Globe_d+IDXtra*3);
			translate([0,-Globe_d/2*0.4,0]) rotate([90,0,0]) cylinder(d=Globe_d, h=Globe_d/2);
		} // difference
		
		// Rear opening
		rotate([90,0,0]) translate([0,0,-Globe_d/2]) cylinder(d1=Rim_Anulus*2, d2=Globe_d-4, h=Globe_d);
		rotate([90,0,0]) cylinder(d=28, h=Globe_d);
		
		translate([0,Globe_d,0]) cube([Globe_d*2,Globe_d*2,Globe_d*2],center=true);
		hull(){
			translate([0,0,0]) cube([FingerWidth,0.01,Globe_d*2],center=true);
			translate([0,-Globe_d/2,0]) cube([FingerSpread,1,Globe_d*2],center=true);
		} // hull
		hull(){
			translate([0,0,0]) cube([Globe_d*2,0.01,FingerWidth],center=true);
			translate([0,-Globe_d/2,0]) cube([Globe_d*2,1,FingerSpread],center=true);
		} // hull
		
		// Bolts
		HeadLampBC(FrontOffset=0) Bolt4Hole();
			
		// Servo
		translate([18,-26,22]) rotate([-45,0,90]) ServoSG90(TopMount=false);
		rotate([0,90,0]) translate([18,-26,22]) rotate([-45,0,90]) ServoSG90(TopMount=false);
	} // difference
	
	if ($preview==true){
		translate([18,-26,22]) rotate([-45,0,90]) color("Red") ServoSG90(TopMount=false);
		rotate([0,90,0]) translate([18,-26,22]) rotate([-45,0,90]) color("Red") ServoSG90(TopMount=false);
	}
	
} // BackFingers

// BackFingers();


























