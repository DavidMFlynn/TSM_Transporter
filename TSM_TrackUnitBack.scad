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

module DriveMountHoles(){
	RingBTeeth=75;
	GearBPitch=282.0338983050847;
	BSkirt_OD=RingBTeeth*GearBPitch/180+5+5;
	BSkirtBC_d=BSkirt_OD-Bolt4Inset*2;
	nRingBSkirtBolts=8;
	MotorBC_d=57.5;
	
	circle(d=17,$fn=6);
	for (j=[0:3]) rotate([0,0,90*j+45]) translate([MotorBC_d/2,0,0]) circle(d=4);
	
	// Bolts
		for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j]) 
				translate([BSkirtBC_d/2,0,0]) circle(d=3);
} // DriveMountHoles

//translate([140,-50,0]) DriveMountHoles();

module SpanBolsterMount(){
	
		circle(d=12.7);
	
	for (j=[0:3]){
		rotate([0,0,-30]) translate([12.7,20*j-10,0]) circle(d=3);
		rotate([0,0,30]) translate([-12.7,20*j-10,0]) circle(d=3);
	}
	
} // SpanBolsterMount

//SpanBolsterMount();

module BolsterMount(){
	
	
	for (j=[0:3]){
		rotate([0,0,-30]) translate([12.7,20*j-10,0]) circle(d=3);
		rotate([0,0,30]) translate([-12.7,20*j-10,0]) circle(d=3);
	}
	
} // BolsterMount

module TrackRturnIdlerMount(){
	nBolts=6;
	circle(d=12.7);
	
	for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([20,0,0]) circle(d=3);
	
} // TrackRturnIdlerMount

// TrackRturnIdlerMount(); 

module RingABearingHoles(){
	nBolts=8;
	RingABearingMountingRing_BC_d=100;
	RingATeeth=48;
	GearAPitch=260;
	RingA_OD=RingATeeth*GearAPitch/180+GearAPitch/60;
	RingA_Bearing_BallCircle=RingA_OD+Ball_d;
	RingA_Bearing_OD=RingA_Bearing_BallCircle+Ball_d+5;
	
	circle(d=RingA_Bearing_OD,$fn=$preview? 90:360);
	
	// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)])
			translate([RingABearingMountingRing_BC_d/2,0,0])
				circle(d=3);
} // RingABearingHoles

//RingABearingHoles();

module TrackPlate(){
	
	Tensioner_X=-130;
	Drive_X=180;
	Drive_Y=40;
	
	//Drive_X=220;
	//Drive_Y=0;
	//SpanBolster_Y=-80;
	Bolster_Y=-90;
	Bolster_X=105;
	
	difference(){
		hull(){
			circle(d=140);
			
			translate([Bolster_X,Bolster_Y,0]) circle(d=50);
			translate([-Bolster_X,Bolster_Y,0]) circle(d=50);
			translate([Drive_X,Drive_Y,0]) circle(d=140);
			translate([-80,44,0]) circle(d=50);
			translate([Tensioner_X,0,0]) circle(d=130);
		} // hull
		
		RingABearingHoles();
		translate([Bolster_X,Bolster_Y,0]) BolsterMount();
		translate([-Bolster_X,Bolster_Y,0]) BolsterMount();
		translate([Drive_X,Drive_Y,0]) DriveMountHoles();
		//translate([80,44,0]) TrackRturnIdlerMount(); 
		//translate([-80,44,0]) TrackRturnIdlerMount();
	
		//tensioner
		translate([Tensioner_X,0,0]) rotate([0,0,90]) BolsterMount();
		//TrackRturnIdlerMount(); 
		
		//Stiffenner slots
		//translate([-75,0,0]) square([25,6],center=true);
		//translate([-165,0,0]) square([25,6],center=true);
		//translate([75,0,0]) square([25,6],center=true);
		//translate([130,0,0]) square([25,6],center=true);
		
		//wire path
		translate([Drive_X,Drive_Y+15,0]) hull(){
			circle(d=6);
			translate([0,20,0]) circle(d=6);
		}
		translate([0,-90,0]) text("<<-- Front <<--",size=6,halign="center");
		translate([0,-100,0]) text("TSM-T1, DMFE 2019",size=6,halign="center");
		
	} // difference
} // TrackPlate

TrackPlate();





















