// ****************************************
// Front with headlamps
// by David M. Flynn
// Filename: TSM_Nose.scad
// Created: 3/13/2021
// Revision: 0.9.0  3/13/2021
// Units: mm
// ****************************************
//  ***** Notes *****
//
// ****************************************
//  ***** History *****
// 
// ****************************************

include<TSM_HeadLamp.scad>
// HeadLampBC(FrontOffset=HL_Flange_t) Bolt4HeadHole();
// HL_Mount(); // used as difference

Overlap = 0.05;
IDXtra = 0.2;
$fn = $preview? 24:90;

RueBar_d=5/16*25.4;
RueBar_r=RueBar_d/2;

NoseOutsideWidth=440;
NoseOutsideHeight=88;
NoseCorner_r=20;

Bolt4Inset=4.5;
BarMountBase_y=Bolt4Inset*2+RueBar_d+5;

module BarMountBolts(){
	translate([0,BarMountBase_y/2-Bolt4Inset,0]) children();
	translate([0,-BarMountBase_y/2+Bolt4Inset,0]) children();
} // BarMountBolts

module BarMount(Height=10){
	Ring_Len=RueBar_d-1;
	
	difference(){
		union(){
			// Base
			RoundRect(X=Bolt4Inset*2,Y=BarMountBase_y,Z=2,R=3);
			
			// Post
			RoundRect(X=RueBar_d-2,Y=RueBar_d-2,Z=Height,R=2);
			
			// Tube Mount
			translate([0,0,Height]) rotate([0,90,0]) cylinder(d=RueBar_d+2.8, h=Ring_Len, center=true);
		} // union
		
		// Tube Mount
		translate([0,0,Height]) rotate([0,90,0]) cylinder(d=RueBar_d+IDXtra*2, h=Ring_Len+Overlap*2, center=true);
		
		translate([0,0,2]) BarMountBolts() Bolt4ClearHole();
	} // difference
} // BarMount

//BarMount();

module RoundRect(X=10,Y=10,Z=3,R=3){
	hull(){
		translate([-X/2+R,-Y/2+R,0]) cylinder(r=R, h=Z);
		translate([-X/2+R,Y/2-R,0]) cylinder(r=R, h=Z);
		translate([X/2-R,-Y/2+R,0]) cylinder(r=R, h=Z);
		translate([X/2-R,Y/2-R,0]) cylinder(r=R, h=Z);
	} // hull
} // RoundRect

module Nose(){
	
	difference(){
		// Main plate
		rotate([-90,0,0]){
			RoundRect(X=NoseOutsideWidth,Y=NoseOutsideHeight,Z=RueBar_r,R=NoseCorner_r+RueBar_r);
			
			// Corners
			translate([NoseOutsideWidth/2-NoseCorner_r-RueBar_r,NoseOutsideHeight/2-NoseCorner_r-RueBar_r,RueBar_r])
				rotate_extrude(angle=90) translate([NoseCorner_r,0,0]) circle(RueBar_r);
			translate([NoseOutsideWidth/2-NoseCorner_r-RueBar_r,-NoseOutsideHeight/2+NoseCorner_r+RueBar_r,RueBar_r])
				rotate([0,0,-90]) rotate_extrude(angle=90) translate([NoseCorner_r,0,0]) circle(RueBar_r);
			translate([-NoseOutsideWidth/2+NoseCorner_r+RueBar_r,NoseOutsideHeight/2-NoseCorner_r-RueBar_r,RueBar_r])
				rotate([0,0,90]) rotate_extrude(angle=90) translate([NoseCorner_r,0,0]) circle(RueBar_r);
			translate([-NoseOutsideWidth/2+NoseCorner_r+RueBar_r,-NoseOutsideHeight/2+NoseCorner_r+RueBar_r,RueBar_r])
				rotate([0,0,180]) rotate_extrude(angle=90) translate([NoseCorner_r,0,0]) circle(RueBar_r);

			// Edges
			translate([-NoseOutsideWidth/2+NoseCorner_r+RueBar_r-Overlap,-NoseOutsideHeight/2+RueBar_r,RueBar_r])
				rotate([0,90,0]) cylinder(r=RueBar_r, h=NoseOutsideWidth-NoseCorner_r*2-RueBar_d+Overlap*2);
			translate([-NoseOutsideWidth/2+NoseCorner_r+RueBar_r-Overlap,NoseOutsideHeight/2-RueBar_r,RueBar_r])
				rotate([0,90,0]) cylinder(r=RueBar_r, h=NoseOutsideWidth-NoseCorner_r*2-RueBar_d+Overlap*2);
			translate([-NoseOutsideWidth/2+RueBar_r,-NoseOutsideHeight/2+NoseCorner_r+RueBar_r-Overlap,RueBar_r])
				rotate([-90,0,0]) cylinder(r=RueBar_r, h=NoseOutsideHeight-NoseCorner_r*2-RueBar_d+Overlap*2);
			translate([NoseOutsideWidth/2-RueBar_r,-NoseOutsideHeight/2+NoseCorner_r+RueBar_r-Overlap,RueBar_r])
				rotate([-90,0,0]) cylinder(r=RueBar_r, h=NoseOutsideHeight-NoseCorner_r*2-RueBar_d+Overlap*2);
			
		} // rotate
		
		// Edge groove
		rotate([-90,0,0]) difference(){
			translate([0,0,-Overlap]) RoundRect(X=NoseOutsideWidth-4,Y=NoseOutsideHeight-4,Z=2.5,R=NoseCorner_r+RueBar_r-2);
			
			translate([0,0,-Overlap*2]) RoundRect(X=NoseOutsideWidth-8,Y=NoseOutsideHeight-8,Z=2.5+Overlap*4,R=NoseCorner_r+RueBar_r-4);
			
		} // difference
		
		// Headlamp holes
		for (j=[0:2]) translate([-(NoseOutsideWidth-RueBar_d*4)/2+(NoseOutsideWidth-RueBar_d*4)/7*(j+0.5), 0, 6]) {
			translate([0,2,0]) HeadLampBC(FrontOffset=HL_Flange_t) Bolt4HeadHole();
			translate([0,-3-Overlap,0]) HL_Mount();
		}
		
		mirror([1,0,0])
		for (j=[0:2]) translate([-(NoseOutsideWidth-RueBar_d*4)/2+(NoseOutsideWidth-RueBar_d*4)/7*(j+0.5), 0, 6]) {
			translate([0,2,0]) HeadLampBC(FrontOffset=HL_Flange_t) Bolt4HeadHole();
			translate([0,-3-Overlap,0]) HL_Mount();
		}
		
		// Rue Bar Bolts
		translate([RueBar_x,4,-NoseOutsideHeight/2+RueBar_z]) rotate([-90,0,0]) BarMountBolts() Bolt4Hole();
		translate([-RueBar_x,4,-NoseOutsideHeight/2+RueBar_z]) rotate([-90,0,0]) BarMountBolts() Bolt4Hole();
		translate([0,4,-NoseOutsideHeight/2+RueBar_z]) rotate([-90,0,0]) BarMountBolts() Bolt4Hole();
	} // difference
} // Nose

rotate([90,0,0])
difference(){
	Nose();
	translate([-86,-Overlap,-75]) cube([500,30,150]);
}

RueBar_z=20;
RueBar_h=10;
RueBar_x=NoseOutsideWidth/2-20;
/*
translate([0,4+Overlap,-NoseOutsideHeight/2+RueBar_z]) rotate([-90,0,0]) BarMount(Height=RueBar_h);
translate([RueBar_x,4+Overlap,-NoseOutsideHeight/2+RueBar_z]) rotate([-90,0,0]) BarMount(Height=RueBar_h);
translate([-RueBar_x,4+Overlap,-NoseOutsideHeight/2+RueBar_z]) rotate([-90,0,0]) BarMount(Height=RueBar_h);
translate([0,4+Overlap+RueBar_h,-NoseOutsideHeight/2+RueBar_z]) rotate([0,90,0]) color("LightGray") cylinder(r=RueBar_r, h=NoseOutsideWidth, center=true);
/**/






























