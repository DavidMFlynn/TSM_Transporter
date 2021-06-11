// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// This is the front of two body sections.
//
// Filename: TSM_FrontBody.scad
// By: David M. Flynn
// Created: 5/29/2021
// Revision: 1.0.0  5/29/2021
// Units: mm
// *************************************************
//  ***** Notes *****
//
// *************************************************
//  ***** History ******
//
// 1.0.0  5/29/2021 First code.
// *************************************************
//  ***** for STL output *****
//
// *************************************************
//  ***** for Viewing *****
//
// *************************************************

include<TSM_BodyJack2.scad>


BodyOAWidth=400;
BodyWallThickness=6;

Rod_d=12.7;
SocketWall_t=1.8;

module ShowBodyJacks(){
	translate([-BodyOAWidth/2+BodyWallThickness,0,0]) rotate([0,90,0]) translate([0,0,17.5]) ShowBodyJackComplete();
	translate([BodyOAWidth/2-BodyWallThickness,0,0]) rotate([0,-90,0]) translate([0,0,17.5]) ShowBodyJackComplete();
} // ShowBodyJacks

//ShowBodyJacks();

module BodyJackMountingRing(){
	BJMR_t=6;
	
	difference(){
		cylinder(d=RingABearingMountingRing_d+8, h=BJMR_t);
		
		translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_OD+IDXtra*2, h=BJMR_t+Overlap*2);
		
		translate([0,0,BJMR_t]) RingABearingBoltCircle() Bolt4HeadHole();
	} // difference
} // BodyJackMountingRing

//rotate([0,-90,0]) rotate([0,0,22.5]) translate([0,0,-6]) BodyJackMountingRing();

module BJ_Mount(){
	BC_r=80;
	
	rotate([180,0,0]) translate([0,0,-6]) rotate([0,0,22.5]) BodyJackMountingRing();
	
	
	
	difference(){
		for (j=[0:2]) rotate([0,0,j*120])
		union(){
			translate([0,BC_r,0]) cylinder(d=Rod_d+SocketWall_t*2, h=Rod_d*2);
			
			difference(){
				hull(){
					translate([0,BC_r,0]) cylinder(d=Rod_d+SocketWall_t*2+20, h=2);
					cylinder(d=RingABearingMountingRing_d+38, h=2);
				} // hull
				
				translate([0,0,-Overlap]) cylinder(d=RingABearingMountingRing_d, h=2+Overlap*2);
			} // difference
			
			hull(){
				translate([0,BC_r+Rod_d/2,0]) cylinder(r=SocketWall_t, h=Rod_d*2);
				rotate([0,0,15]) translate([0,RingABearingMountingRing_d/2+2,0]) cylinder(r=SocketWall_t, h=6);
			} // hull
			hull(){
				translate([0,BC_r+Rod_d/2,0]) cylinder(r=SocketWall_t, h=Rod_d*2);
				rotate([0,0,-15]) translate([0,RingABearingMountingRing_d/2+2,0]) cylinder(r=SocketWall_t, h=6);
			} // hull
			hull(){
				translate([0,BC_r+Rod_d/2,0]) cylinder(r=SocketWall_t, h=Rod_d*2);
				rotate([0,0,45]) translate([0,RingABearingMountingRing_d/2+2,0]) cylinder(r=SocketWall_t, h=6);
			} // hull
			hull(){
				translate([0,BC_r+Rod_d/2,0]) cylinder(r=SocketWall_t, h=Rod_d*2);
				rotate([0,0,-45]) translate([0,RingABearingMountingRing_d/2+2,0]) cylinder(r=SocketWall_t, h=6);
			} // hull
		} // union
		
		for (j=[0:2]) rotate([0,0,j*120]) translate([0,BC_r,2]) cylinder(d=Rod_d+IDXtra, h=Rod_d*2 );
		
		for (j=[0:2]) rotate([0,0,j*120]){
			translate([0,BC_r,0]) rotate([0,0,-45]) 
				translate([0,Rod_d/2+SocketWall_t+5,0]) for (j=[0:3]) translate([20*j,0,2]) Bolt4ClearHole();
			translate([0,BC_r,0]) rotate([0,0,45]) 
				translate([0,Rod_d/2+SocketWall_t+5,0]) for (j=[0:3]) translate([-20*j,0,2]) Bolt4ClearHole();
		}
		
	} // difference
	
} // BJ_Mount

BJ_Mount();

//translate([BodyOAWidth/2-BodyWallThickness,0,0]) rotate([0,90,0]) BodyJackMountingRing();

//translate([-BodyOAWidth/2+BodyWallThickness,0,0]) rotate([0,-90,0]) BodyJackMountingRing();







































