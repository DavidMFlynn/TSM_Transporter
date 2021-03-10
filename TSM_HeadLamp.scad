// **************************************
// Head Lamp w/ Pan & Tilt
// Project: TSM_Transporter
// by David M. Flynn
// Filename: TSM_HeadLamp.scad
// Created: 3/9/2021
// Revision: 0.9.0  3/9/2021 First Code
// Units: mm
// **************************************
//  ***** History *****
// 0.9.0  3/9/2021 First Code
// **************************************
//  ***** for STL output *****
//
// rotate([90,0,0]) ForwardMount();
// rotate([-90,0,0]) BackFingers();
// **************************************
//  ***** for Viewing *****
//
// ViewHeadLampAssy(Pan_a=4,Tilt_a=2); // ±7°
// **************************************

include <CommonStuffSAEmm.scad>

$fn=$preview? 36:90;
Overlap=0.05;
IDXtra=0.2;

Globe_d=40;

Rim_Anulus=2;
Lamp_d=20;

module ViewHeadLampAssy(Pan_a=0,Tilt_a=0){
	color("LightBlue") rotate([Pan_a,0,Tilt_a]) Globe();
	
	color("Gray") ForwardMount();
	
	translate([0,-Overlap*2,0]) color("tan") BackFingers();
} // ViewHeadLampAssy

// ViewHeadLampAssy(Pan_a=4,Tilt_a=2); // ±7°

module Globe(){
	ControlHornLen=12;
	ControlHornWidth=3;
	ControlHornThickness=2.4;
	
	difference(){
		union(){
			sphere(d=Globe_d);
			
			rotate([-90,0,0]) cylinder(d=Lamp_d+Rim_Anulus*2,h=Globe_d, center=true);
			
			// control horns
			rotate([12,0,0]) hull(){
				cylinder(d=ControlHornThickness, h=Globe_d/2+ControlHornLen);
				translate([0,-ControlHornWidth,0]) cylinder(d=ControlHornThickness, h=Globe_d/2+ControlHornLen);}
			
			rotate([0,0,-12]) hull(){
				rotate([0,90,0]) cylinder(d=ControlHornThickness, h=Globe_d/2+ControlHornLen);
				translate([0,-ControlHornWidth,0]) rotate([0,90,0]) 
					cylinder(d=ControlHornThickness, h=Globe_d/2+ControlHornLen);}
		} // union
		
		// core hole
		sphere(d=Globe_d-6);
		rotate([-90,0,0]) cylinder(d=Lamp_d,h=Globe_d+Overlap*2, center=true);
		
		// control horn bolts
		rotate([12,0,0]) translate([-ControlHornThickness,-ControlHornWidth/2,Globe_d/2+ControlHornLen-3]) 
			rotate([0,-90,0]) Bolt2Hole();
		rotate([0,0,-12]) translate([Globe_d/2+ControlHornLen-3,-ControlHornWidth/2,ControlHornThickness]) 
			 Bolt2Hole();
	} // difference
} // Globe

//color("LightBlue") rotate([-7,0,7]) Globe();

module ForwardMount(){
	CupWall_t=2;
	Flange_t=3;
	
	difference(){
		union(){
			sphere(d=Globe_d+CupWall_t*2);
			// Mounting face
			rotate([-90,0,0]) cylinder(d=Globe_d+CupWall_t*2+9,h=Flange_t);
		} // union
		
		sphere(d=Globe_d+IDXtra*2);
		rotate([-90,0,0]) cylinder(d1=Rim_Anulus*2, d2=Globe_d+Rim_Anulus*2, h=Globe_d/2+CupWall_t+Overlap*2);
		translate([0,-Globe_d,0]) cube([Globe_d*2,Globe_d*2,Globe_d*2],center=true);
		
		// Bolts
		rotate([-90,0,0]) for (j=[0:7]) rotate([0,0,45*j+22.5]) translate([0,Globe_d/2+4,Flange_t]) Bolt4Hole();
	} // difference
	
} // ForwardMount

//ForwardMount();

module BackFingers(){
	CupWall_t=2;
	Flange_t=3;
	FingerWidth=4;
	FingerSpread=10;
	
	difference(){
		union(){
			sphere(d=Globe_d+CupWall_t*2);
			// Mounting face
			rotate([90,0,0]) cylinder(d=Globe_d+CupWall_t*2+9,h=Flange_t);
		} // union
		
		sphere(d=Globe_d+IDXtra*2);
		rotate([90,0,0]) cylinder(d1=Rim_Anulus*2, d2=Globe_d+Rim_Anulus*2, h=Globe_d/2+CupWall_t+Overlap*2);
		
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
	} // difference
	
} // BackFingers

//BackFingers();


























