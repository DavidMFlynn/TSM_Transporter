// **************************************
// Head Lamp w/ Pan & Tilt
// Project: TSM_Transporter
// by David M. Flynn
// Filename: TSM_HeadLamp.scad
// Created: 3/9/2021
// Revision: 0.9.2  3/11/2021 Servo Mounts
// Units: mm
// **************************************
//  ***** History *****
// 0.9.2  3/11/2021 Servo Mounts
// 0.9.1  3/10/2021 Sized for small flashlight, cut globe in half.
// 0.9.0  3/9/2021 First Code
// **************************************
//  ***** for STL output *****
// rotate([90,0,0]) Globe(IsFront=true);
// rotate([-90,0,0]) Globe(IsFront=false);
// rotate([90,0,0]) ForwardMount();
// rotate([-90,0,0]) BackFingers();
// **************************************
//  ***** for Viewing *****
 ViewHeadLampAssy(Pan_a=7,Tilt_a=2); // ±7°
// **************************************

include <SG90ServoLib.scad>
include <CommonStuffSAEmm.scad>

$fn=$preview? 36:180;
Overlap=0.05;
IDXtra=0.2;

Globe_d=40;

Rim_Anulus=2;
Lamp_d=25;

module ViewHeadLampAssy(Pan_a=0,Tilt_a=0){
	color("LightBlue") rotate([Pan_a,0,Tilt_a]){
		Globe();
		Globe(IsFront=false);}
	
	color("Gray") ForwardMount();
	
	translate([0,-Overlap*2,0]) color("tan") BackFingers();
} // ViewHeadLampAssy

// ViewHeadLampAssy(Pan_a=4,Tilt_a=2); // ±7°

module Globe(IsFront=true){
	ControlHornLen=8;
	ControlHornWidth=3;
	ControlHornThickness=2.4;
	nBolts=3;
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

module ForwardMount(){
	CupWall_t=2;
	Flange_t=3;
	Flange_d=Globe_d+13;
	
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
		rotate([-90,0,0]) for (j=[0:7]) rotate([0,0,45*j+22.5]) translate([0,Globe_d/2+4,Flange_t]) Bolt4ClearHole();
			//Bolt4Hole();
	} // difference
	
} // ForwardMount

//ForwardMount();

module BackFingers(){
	CupWall_t=3;
	Flange_t=4;
	Flange_d=Globe_d+13;
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
		rotate([-90,0,0]) for (j=[0:7]) rotate([0,0,45*j+22.5]) translate([0,Globe_d/2+4,Flange_t]) Bolt4Hole();
			
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


























