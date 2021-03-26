// ***************************************************
// Pressure Door
// Project: Terran Space Marine Transporter
// Filename: TSM_PressureDoor.scad
// Created: 3/25/2021
// Revision: 1.0.0  3/25/2021
// Units: mm
// ***************************************************
//  ***** Notes *****
//
// ***************************************************
//  ***** for STL output *****
//
// ***************************************************
//  ***** for Viewing *****
//
// ***************************************************

Overlap = 0.05;
IDXtra = 0.2;
$fn = $preview? 24:90;

module RoundRect(X=10,Y=10,Z=10,R=3){
	hull(){
		translate([-X/2+R,-Y/2+R,0]) cylinder(r=R, h=Z);
		translate([-X/2+R,Y/2-R,0]) cylinder(r=R, h=Z);
		translate([X/2-R,-Y/2+R,0]) cylinder(r=R, h=Z);
		translate([X/2-R,Y/2-R,0]) cylinder(r=R, h=Z);
	} // hull
} // RoundRect


module HatchComing(Width=160, Height=330, H=20){
	// Width,Height are center of coming
	
	Edge_r=Width/40;
	Frame_w=12;
	
	R1=Width/4+Frame_w/2+Edge_r; // Lower outside
	R2=Width/4+Frame_w/2; // Upper outside
	R3=Width/4+Frame_w/2-Edge_r; // Top outside
	R4=Width/4-Frame_w/2+Edge_r;
	R5=Width/4-Frame_w/2; // Upper inside
	R6=Width/4-Frame_w/2-Edge_r; // Lower inside
	
	translate([Width/2-Width/4,Height/2-Width/4,H-Edge_r])
		rotate_extrude(angle=90) translate([R3,0,0]) circle(r=Edge_r+Overlap, $fn=$preview? 18:36);
	translate([Width/2-Width/4,-Height/2+Width/4,H-Edge_r])
		rotate([0,0,-90]) rotate_extrude(angle=90) translate([R3,0,0]) circle(r=Edge_r+Overlap, $fn=$preview? 18:36);
	
	translate([-Width/2+Width/4,Height/2-Width/4,H-Edge_r])
		rotate([0,0,90]) rotate_extrude(angle=90) translate([R3,0,0]) circle(r=Edge_r+Overlap, $fn=$preview? 18:36);
	translate([-Width/2+Width/4,-Height/2+Width/4,H-Edge_r])
		rotate([0,0,-180]) rotate_extrude(angle=90) translate([R3,0,0]) circle(r=Edge_r+Overlap, $fn=$preview? 18:36);

	translate([Width/2-Width/4, Height/2-Width/4, H-Edge_r])
		rotate_extrude(angle=90) translate([R4,0,0]) circle(r=Edge_r+Overlap, $fn=$preview? 18:36);
	translate([Width/2-Width/4,-Height/2+Width/4,H-Edge_r])
		rotate([0,0,-90]) rotate_extrude(angle=90) translate([R4,0,0]) circle(r=Edge_r+Overlap, $fn=$preview? 18:36);
	translate([-Width/2+Width/4,Height/2-Width/4,H-Edge_r])
		rotate([0,0,90]) rotate_extrude(angle=90) translate([R4,0,0]) circle(r=Edge_r+Overlap, $fn=$preview? 18:36);
	translate([-Width/2+Width/4,-Height/2+Width/4,H-Edge_r])
		rotate([0,0,-180]) rotate_extrude(angle=90) translate([R4,0,0]) circle(r=Edge_r+Overlap, $fn=$preview? 18:36);
	
	hull(){
		translate([-Width/2+Width/4,-Height/2-Frame_w/2+Edge_r,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
		translate([Width/2-Width/4,-Height/2-Frame_w/2+Edge_r,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
	} // hull
	hull(){
		translate([-Width/2+Width/4, Height/2+Frame_w/2-Edge_r, H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
		translate([Width/2-Width/4, Height/2+Frame_w/2-Edge_r, H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
	} // hull
	hull(){
		translate([-Width/2+Width/4,-Height/2+Frame_w/2-Edge_r,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
		translate([Width/2-Width/4,-Height/2+Frame_w/2-Edge_r,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
	} // hull
	hull(){
		translate([-Width/2+Width/4, Height/2-Frame_w/2+Edge_r, H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
		translate([Width/2-Width/4, Height/2-Frame_w/2+Edge_r, H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
	} // hull

	hull(){
		translate([-Width/2-Frame_w/2+Edge_r,-Height/2+Width/4,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
		translate([-Width/2-Frame_w/2+Edge_r,Height/2-Width/4,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
	} // hull
	hull(){
		translate([-Width/2+Frame_w/2-Edge_r,-Height/2+Width/4,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
		translate([-Width/2+Frame_w/2-Edge_r,Height/2-Width/4,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
	} // hull

	hull(){
		translate([Width/2+Frame_w/2-Edge_r,-Height/2+Width/4,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
		translate([Width/2+Frame_w/2-Edge_r,Height/2-Width/4,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
	} // hull
	hull(){
		translate([Width/2-Frame_w/2+Edge_r,-Height/2+Width/4,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
		translate([Width/2-Frame_w/2+Edge_r,Height/2-Width/4,H-Edge_r]) sphere(r=Edge_r+Overlap, $fn=$preview? 18:36);
	} // hull
	
	difference(){
		union(){
			hull(){
				// Lower outside
				RoundRect(X=Width+Frame_w+Edge_r*2, Y=Height+Frame_w+Edge_r*2, Z=Overlap, R=R1);
				
				// Upper outside
				translate([0,0,H-Edge_r-Overlap]) RoundRect(X=Width+Frame_w, Y=Height+Frame_w, Z=Overlap, R=R2);
			} // hull
			
			// Top outside
			RoundRect(X=Width+Frame_w-Edge_r*2, Y=Height+Frame_w-Edge_r*2, Z=H, R=R3);
			
		} // union
	
		// Top inside
		translate([0,0,H-Edge_r]) RoundRect(X=Width-Frame_w+Edge_r*2, Y=Height-Frame_w+Edge_r*2, Z=Edge_r+Overlap, R=R4);
	
		hull(){
			// Lower inside
			translate([0,0,-Overlap]) RoundRect(X=Width-Frame_w-Edge_r*2, Y=Height-Frame_w-Edge_r*2, Z=Overlap, 
				R=R6);
			
			// Upper inside
			translate([0,0,H-Edge_r]) RoundRect(X=Width-Frame_w, Y=Height-Frame_w, Z=Overlap, R=R5);
		} // hull
		
	} // difference
	
} // HatchComing

HatchComing();










































