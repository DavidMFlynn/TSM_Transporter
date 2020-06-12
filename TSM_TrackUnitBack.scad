// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// This is the track unit's ply-wood parts.
//
// Filename: TSM_TrackUnitBack.scad
// By: David M. Flynn
// Created: 10/31/2019
// Revision: 0.9.0 10/31/2019
// Units: mm
// *************************************************
//  ***** Notes *****
// Todo: Add encoders or limit switches and hard stops?
// *************************************************
//  ***** History ******
// 0.9.0 10/31/2019 First code.
// *************************************************
//  ***** for STL output *****
//
// *************************************************
//  ***** for Viewing *****
// *************************************************


$fn=$preview? 24:90;
Overlap=0.05;
IDXtra=0.2;
Ball_d=5/16*25.4;
Bolt4Inset=4;

module DriveMountHoles(IsDrive=true){
	RingBTeeth=75;
	GearBPitch=282.0338983050847;
	BSkirt_OD=RingBTeeth*GearBPitch/180+5+5;
	BSkirtBC_d=BSkirt_OD-Bolt4Inset*2;
	nRingBSkirtBolts=8;
	MotorBC_d=57.5;
	
	if (IsDrive==true) {
			rotate([0,0,90]) circle(d=17,$fn=6);
			for (j=[0:3]) rotate([0,0,90*j+45]) translate([MotorBC_d/2,0,0]) circle(d=4);
		} else {
			circle(d=100);
		}
	
	// Bolts
		for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j+22.5]) 
				translate([BSkirtBC_d/2,0,0]) circle(d=3);
} // DriveMountHoles

//translate([140,-50,0]) DriveMountHoles();



// TrackRturnIdlerMount(); 
	RingABearingMountingRing_BC_d=104;
	RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;

	RingA_Bearing_BallCircle=84;
	RingA_Bearing_OD=RingA_Bearing_BallCircle+Ball_d+5;

module RingABearingHoles(){
	nBolts=8;
	
	circle(d=RingA_Bearing_OD,$fn=$preview? 90:360);
	
	// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)])
			translate([RingABearingMountingRing_BC_d/2,0,0])
				circle(d=3);
} // RingABearingHoles

//RingABearingHoles();

DriveWheel_OD=164;
DriveWheel_Back_OD=130;
Tooth_h=9;
Tooth_w=9;


//BodyJack position from drive center
BJ_Offset_x=-DriveWheel_OD/2-RingABearingMountingRing_d/2-Tooth_h-Bolt4Inset*2;
BJ_Offset_y=DriveWheel_OD/2-RingABearingMountingRing_d/2-8;

module TrackPlate(){
	
	IdleSprocket_x=-343;
	
	
	difference(){
		hull(){
			translate([BJ_Offset_x,BJ_Offset_y,0]) circle(d=120);
			
			translate([0,0,0]) circle(d=DriveWheel_Back_OD);
			
			translate([IdleSprocket_x,0,0]) circle(d=DriveWheel_Back_OD);
		} // hull
		
		translate([BJ_Offset_x,BJ_Offset_y,0]) RingABearingHoles();
		translate([0,0,0]) DriveMountHoles();
		translate([IdleSprocket_x,0,0]) DriveMountHoles(IsDrive=false);
		
		
		
		//wire path
		rotate([0,0,90]) translate([0,15,0]) hull(){
			circle(d=6);
			translate([0,20,0]) circle(d=6);
		}
		translate([IdleSprocket_x/2,-50,0]) text("<<-- Front <<--",size=6,halign="center");
		translate([IdleSprocket_x/2,-60,0]) text("TSM-T1, DMFE 2020",size=6,halign="center");
		
	} // difference
} // TrackPlate

TrackPlate();





















