// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// This is the connection between the chassis and a track unit.
//
// Filename: TSM_TrackShoe.scad
// By: David M. Flynn
// Created: 6/7/2020
// Revision: 1.0.0 6/7/2020
// Units: mm
// *************************************************
//  ***** Notes *****
// *************************************************
//  ***** History ******
// 1.0.0 6/7/2020 First Code
// *************************************************
//  ***** for STL output *****
// *************************************************
include<CommonStuffSAEmm.scad>

$fn=$preview? 48:90;
Overlap=0.05;
IDXtra=0.2;
Bolt4Inset=4;

DriveWheel_OD=164;
Tooth_h=9;
Tooth_w=9;


RingABearingMountingRing_BC_d=104;
RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;
nBolts_BodyJack=8;

//BodyJack position from drive center
BJ_Offset_x=-DriveWheel_OD/2-RingABearingMountingRing_d/2-Tooth_h-Bolt4Inset*2;
BJ_Offset_z=DriveWheel_OD/2-RingABearingMountingRing_d/2-8;

module TrackShoe_Spacer(){
	ShortOfCenter=32;
	
	difference(){
		// bulk fill
			translate([-DriveWheel_OD/2-20,0,-DriveWheel_OD/2]) cube([DriveWheel_OD/2-ShortOfCenter+Tooth_h,Tooth_w,DriveWheel_OD]);
		
		// Body Jack
		translate([BJ_Offset_x,-Overlap,BJ_Offset_z]) rotate([-90,0,0]) cylinder(d=RingABearingMountingRing_d+IDXtra*2,h=Tooth_w+Overlap*2);
		
		// teeth
		translate([0,-Overlap,0]) rotate([-90,0,0]) cylinder(d=DriveWheel_OD+Tooth_h*2,h=Tooth_w+Overlap*2);
		
		// Bolts
		translate([-ShortOfCenter-Bolt4Inset-18,0,DriveWheel_OD/2-Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
		translate([BJ_Offset_x+Bolt4Inset,0,DriveWheel_OD/2-Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
		translate([BJ_Offset_x+RingABearingMountingRing_d/2+Bolt4Inset,0,Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
		translate([-ShortOfCenter-Bolt4Inset-18,0,-DriveWheel_OD/2+Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
		translate([BJ_Offset_x+Bolt4Inset,0,-DriveWheel_OD/2+Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
		translate([BJ_Offset_x+RingABearingMountingRing_d/2+Bolt4Inset,0,-Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
		
		// Lightening
		rotate([0,35,0]) translate([-DriveWheel_OD/2-Tooth_h-15,-Overlap,0]) rotate([-90,0,0]) cylinder(d=20,h=Tooth_w+Overlap*2);
		rotate([0,-35,0]) translate([-DriveWheel_OD/2-Tooth_h-15,-Overlap,0]) rotate([-90,0,0]) cylinder(d=20,h=Tooth_w+Overlap*2);
	} // difference
	
} // TrackShoe_Spacer

TrackShoe_Spacer();

module TrackShoe_EndOuterTop(){
	ShortOfCenter=32;
	Plate_t=4;
	
	// teeth
	//translate([0,Plate_t+1,0]) rotate([90,0,0]) cylinder(d=DriveWheel_OD+Tooth_h*2,h=Plate_t);
	
	difference(){
		union(){
			
			hull(){
				translate([-ShortOfCenter-Bolt4Inset,0,DriveWheel_OD/2-2]) rotate([90,0,0]) cylinder(d=4,h=Plate_t);
				translate([BJ_Offset_x+Bolt4Inset,0,DriveWheel_OD/2-Bolt4Inset]) rotate([90,0,0]) cylinder(d=Bolt4Inset*2,h=Plate_t);
				translate([-DriveWheel_OD/2-Bolt4Inset,0,Bolt4Inset]) rotate([90,0,0]) cylinder(d=Bolt4Inset*2,h=Plate_t);
				translate([BJ_Offset_x+RingABearingMountingRing_d/2+Bolt4Inset,0,Bolt4Inset]) rotate([90,0,0]) cylinder(d=Bolt4Inset*2,h=Plate_t);
			} // hull
			
			// bulk fill
			translate([-DriveWheel_OD/2-20,-Plate_t,0]) cube([DriveWheel_OD/2-ShortOfCenter,Plate_t,DriveWheel_OD/2]);
		} // union
		
		
		// Bolts
		translate([-ShortOfCenter-Bolt4Inset-18,-Plate_t,DriveWheel_OD/2-Bolt4Inset]) rotate([90,0,0]) Bolt4ButtonHeadHole();
		translate([BJ_Offset_x+Bolt4Inset,-Plate_t,DriveWheel_OD/2-Bolt4Inset]) rotate([90,0,0]) Bolt4ButtonHeadHole();
		translate([BJ_Offset_x+RingABearingMountingRing_d/2+Bolt4Inset,-Plate_t,Bolt4Inset]) rotate([90,0,0]) Bolt4ButtonHeadHole();
		

		
		// Body Jack
		translate([BJ_Offset_x,Overlap,BJ_Offset_z]) rotate([90,0,0]) cylinder(d=RingABearingMountingRing_d+IDXtra*2,h=Plate_t+Overlap*2);
		
		// Drive wheel
		translate([0,Overlap,0]) rotate([90,0,0]) cylinder(d=DriveWheel_OD+IDXtra*2,h=Plate_t+Overlap*2);
	} // difference
} // TrackShoe_EndOuterTop

//TrackShoe_EndOuterTop();

module TrackShoe_EndOuterBot(){
	ShortOfCenter=32;
	Plate_t=4;
	
	// teeth
	//translate([0,Plate_t+1,0]) rotate([90,0,0]) cylinder(d=DriveWheel_OD+Tooth_h*2,h=Plate_t);
	
	difference(){
		union(){
			
			hull(){
				translate([-ShortOfCenter-Bolt4Inset,0,-DriveWheel_OD/2+2]) rotate([90,0,0]) cylinder(d=4,h=Plate_t);
				translate([BJ_Offset_x+Bolt4Inset,0,-DriveWheel_OD/2+Bolt4Inset]) rotate([90,0,0]) cylinder(d=Bolt4Inset*2,h=Plate_t);
				translate([-DriveWheel_OD/2-Bolt4Inset,0,-Bolt4Inset]) rotate([90,0,0]) cylinder(d=Bolt4Inset*2,h=Plate_t);
				translate([BJ_Offset_x+RingABearingMountingRing_d/2+Bolt4Inset,0,-Bolt4Inset]) rotate([90,0,0]) cylinder(d=Bolt4Inset*2,h=Plate_t);
			} // hull
			
			// bulk fill
			translate([-DriveWheel_OD/2-25,-Plate_t,-DriveWheel_OD/2]) cube([DriveWheel_OD/2-ShortOfCenter,Plate_t,DriveWheel_OD/2]);
		} // union
		
		
		// Bolts
		translate([-ShortOfCenter-Bolt4Inset-18,-Plate_t,-DriveWheel_OD/2+Bolt4Inset]) rotate([90,0,0]) Bolt4ButtonHeadHole();
		translate([BJ_Offset_x+Bolt4Inset,-Plate_t,-DriveWheel_OD/2+Bolt4Inset]) rotate([90,0,0]) Bolt4ButtonHeadHole();
		translate([BJ_Offset_x+RingABearingMountingRing_d/2+Bolt4Inset,-Plate_t,-Bolt4Inset]) rotate([90,0,0]) Bolt4ButtonHeadHole();
		
		// Body Jack
		translate([BJ_Offset_x,Overlap,BJ_Offset_z]) rotate([90,0,0]) cylinder(d=RingABearingMountingRing_d+IDXtra*2,h=Plate_t+Overlap*2);
		
		// Drive wheel
		translate([0,Overlap,0]) rotate([90,0,0]) cylinder(d=DriveWheel_OD+IDXtra*2,h=Plate_t+Overlap*2);
	} // difference
} // TrackShoe_EndOuterBot

//TrackShoe_EndOuterBot();




