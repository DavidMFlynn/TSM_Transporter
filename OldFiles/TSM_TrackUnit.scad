// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// Filename: TSM_TrackUnit.scad
// By: David M. Flynn
// Created: 9/14/2019
// Revision: 0.9.0 9/14/2019
// Units: mm
// *************************************************
//  ***** for STL output
//
// rotate([-90,0,0]) LowerIdleSpocketInner2();
// rotate([-90,0,0]) LowerIdleSpocketOuter2();
// *************************************************
include<CommonStuffSAEmm.scad>
include<BearingLib.scad>
//include<ring_gear.scad>
include<LynxTrackLib.scad>

$fn=$preview? 24:90;
Overlap=0.05;
IDXtra=0.2;
Bolt4Inset=4;

LowerWheelbase=135;
UpperWheelbase=LowerWheelbase+185;
UpperWheelOffset=60;
nLowerWheelTeeth=14;
nUpperWheelTeeth=9;
SproketSpacing=50;

Bearing_OD=1.125*25.4;
Bearing_ID=0.500*25.4;
BEaring_w=0.3125*25.4;
Ball_d=5/16*25.4;
BearingPreload=-0.3;

module ShowAll(){
	
	translate([0,-SproketSpacing/2,0]){
	translate([-LowerWheelbase/2,0,0]) LowerIdleSpocketInner2();
	translate([-LowerWheelbase/2,0,0]) rotate([0,0,180]) LowerIdleSpocketOuter2();
	}
	
	rotate([90,0,0]) translate([-LowerWheelbase/2,0,SproketSpacing/2-13/2-1.5]) IdleWheelInnerBearing();
	
	translate([0,SproketSpacing/2,0]){
	translate([-LowerWheelbase/2,0,0]) rotate([0,0,180]) LowerIdleSpocketInner2();
	translate([-LowerWheelbase/2,0,0])  LowerIdleSpocketOuter2();
	}
	rotate([-90,0,0]) translate([-LowerWheelbase/2,0,SproketSpacing/2-13/2-1.5]) IdleWheelInnerBearing();
	
	translate([0,-SproketSpacing/2,0]){
	translate([LowerWheelbase/2,0,0]) LowerDriveSpocketInner();
	translate([LowerWheelbase/2,0,0]) rotate([0,0,180]) LowerDriveSpocketOuter();}
	translate([0,SproketSpacing/2,0]){
	translate([LowerWheelbase/2,0,0]) rotate([0,0,180]) LowerDriveSpocketInner();
	translate([LowerWheelbase/2,0,0])  LowerDriveSpocketOuter();
	}
	translate([0,-SproketSpacing/2,0]){
	translate([-UpperWheelbase/2,0,UpperWheelOffset]) UpperIdleSpocketInner();
	translate([-UpperWheelbase/2,0,UpperWheelOffset]) rotate([0,0,180]) UpperIdleSpocketOuter();}
	
	translate([0,SproketSpacing/2,0]){
		translate([-UpperWheelbase/2,0,UpperWheelOffset])rotate([0,0,180]) UpperIdleSpocketInner();
	translate([-UpperWheelbase/2,0,UpperWheelOffset])  UpperIdleSpocketOuter();}

translate([0,-SproketSpacing/2,0]){
	translate([UpperWheelbase/2,0,UpperWheelOffset]) UpperIdleSpocketInner();
	translate([UpperWheelbase/2,0,UpperWheelOffset]) rotate([0,0,180]) UpperIdleSpocketOuter();}

	translate([0,SproketSpacing/2,0]){
	translate([UpperWheelbase/2,0,UpperWheelOffset])  rotate([0,0,180]) UpperIdleSpocketInner();
	translate([UpperWheelbase/2,0,UpperWheelOffset])UpperIdleSpocketOuter();}

	FrameSectionA();
	FrameSectionB();
	BearingOuterMotor();
} // ShowAll

ShowAll();

nSpokes=7;
IdleWF_w=SproketSpacing-16;

Bearing2_OD=78;
Bearing2_BC=Bearing2_OD-Ball_d-6;
Bearing2_ID=Bearing2_BC-Ball_d-6;
Bearing2_w=15;

Bearing3_ID=70;
Bearing3_BC=Bearing3_ID+Ball_d+6;
Bearing3_OD=Bearing3_BC+Ball_d+6;
Bearing3_w=IdleWF_w/2;

GearPitch=300;
GearPitch_a=20;
GearBacklash=0.2;
Motor_OD=70;

module LowerDriveSpocketInner(){
	Width=7;
	
	difference(){
		ToothHoldingDisk(nTeeth=nLowerWheelTeeth,Thickness=Width,ShowTeeth=$preview)
			Bolt4Hole();
		
		rotate([-90,0,0]) translate([0,0,-Overlap])
			cylinder(d=Motor_OD,h=Width+Overlap*2);
	} // difference
	
	/*
	rotate([-90,0,0]) translate([0,0,-Bearing2_w+Width])
	OnePieceOuterRace(BallCircle_d=Bearing2_BC, Race_OD=Bearing2_OD, Ball_d=Ball_d, Race_w=Bearing2_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=$preview? 36:360);
	/**/
} // LowerDriveSpocketInner

//LowerDriveSpocketInner();

module LowerDriveSpocketOuter(){
	Width=8;
	
	difference(){
		ToothHoldingDisk(nTeeth=nLowerWheelTeeth,Thickness=Width,ShowTeeth=$preview)
			Bolt4HeadHole();
		
		rotate([-90,0,0]) translate([0,0,-Overlap])
			cylinder(d=Motor_OD,h=Width+Overlap*2);
	} // difference
	
	/*
	rotate([-90,0,0]) translate([0,0,-Bearing2_w+Width])
	OnePieceOuterRace(BallCircle_d=Bearing2_BC, Race_OD=Bearing2_OD, Ball_d=Ball_d, Race_w=Bearing2_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=$preview? 36:360);
	/**/
} // LowerDriveSpocketOuter

//LowerDriveSpocketOuter();

module LowerIdleSpocketInner2(){
	Width=7;
	
	difference(){
		ToothHoldingDisk(nTeeth=nLowerWheelTeeth,Thickness=Width,ShowTeeth=$preview)
			Bolt4Hole();
		
		rotate([-90,0,0]) translate([0,0,-Overlap])
			cylinder(d=Bearing2_OD-Overlap,h=Width+Overlap*2);
	} // difference
	
	rotate([-90,0,0]) translate([0,0,-Bearing2_w+Width])
	OnePieceOuterRace(BallCircle_d=Bearing2_BC, Race_OD=Bearing2_OD, Ball_d=Ball_d, Race_w=Bearing2_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=$preview? 36:360);
} // LowerIdleSpocketInner2

//translate([0,-SproketSpacing/2,0]) LowerIdleSpocketInner2();

module LowerIdleSpocketOuter2(){
	Width=8;
	nSpokes=7;
	
	difference(){
		ToothHoldingDisk(nTeeth=nLowerWheelTeeth,Thickness=Width,ShowTeeth=$preview)
			Bolt4HeadHole();
		
		rotate([-90,0,0]) translate([0,0,-Overlap])
			cylinder(d=Bearing2_OD+IDXtra*2,h=Width+Overlap*2,$fn=$preview? 36:360);
		
	} // difference
} // LowerIdleSpocketOuter2

//LowerIdleSpocketOuter2();

module IdleWheelInnerBearing(){
	Race_w=13;
	nBolts=8;
	
	translate([0,0,Race_w]) rotate([180,0,0])
	OnePieceInnerRace(BallCircle_d=Bearing2_BC,	Race_ID=Bearing2_ID,	Ball_d=Ball_d, Race_w=Race_w, PreLoadAdj=BearingPreload, VOffset=-1.50, BI=true, myFn=$preview? 36:360);
	
	difference(){
		cylinder(d=Bearing2_ID+Overlap,h=3);
		
		translate([0,0,-Overlap]) cylinder(d=Bearing2_ID-Bolt4Inset*4, h=3+Overlap*2);
		
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j])
			translate([Bearing2_ID/2-Bolt4Inset,0,3])
				Bolt4ClearHole();
	} // difference
	
	for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) hull(){
		translate([Bearing2_ID/2,0,0]) cylinder(d=3,h=Race_w);
		translate([Bearing2_ID/2-Bolt4Inset-2,0,0]) cylinder(d=3,h=3);
	}
} // IdleWheelInnerBearing

//rotate([90,0,0]) translate([0,0,SproketSpacing/2-13/2-1.5]) 
//IdleWheelInnerBearing();

module FrameSectionB(){
	
	
	translate([LowerWheelbase/2,0,0])
	rotate([-90,0,0])
	OnePieceOuterRace(BallCircle_d=Bearing3_BC, Race_OD=Bearing3_OD, Ball_d=Ball_d, Race_w=Bearing3_w, PreLoadAdj=BearingPreload, VOffset=2.00, BI=true, myFn=$preview? 36:360);

	translate([LowerWheelbase/2,0,0])
	rotate([90,0,0])translate([0,0,-Overlap])
	OnePieceOuterRace(BallCircle_d=Bearing3_BC, Race_OD=Bearing3_OD, Ball_d=Ball_d, Race_w=Bearing3_w, PreLoadAdj=BearingPreload, VOffset=2.00+Overlap, BI=true, myFn=$preview? 36:360);

	difference(){
		union(){
			translate([LowerWheelbase/2,-IdleWF_w/2,0]) rotate([-90,0,0]) 
				cylinder(d=Bearing3_OD,h=IdleWF_w);
			
			translate([UpperWheelbase/2,-IdleWF_w/2,UpperWheelOffset])
				rotate([-90,0,0]) cylinder(d=26,h=IdleWF_w);
			
			hull(){
				translate([LowerWheelbase/2,-IdleWF_w/2,0]) rotate([-90,0,0]) 
				cylinder(d=54,h=IdleWF_w);
				translate([UpperWheelbase/2,-IdleWF_w/2,UpperWheelOffset])
				rotate([-90,0,0]) cylinder(d=12,h=IdleWF_w);
			} // hull
		} // union
		/*
		hull(){
				translate([-LowerWheelbase/2,-IdleWF_w/2,0]) rotate([-90,0,0]) 
				translate([0,0,-Overlap]) cylinder(d=23,h=IdleWF_w+Overlap*2);
				translate([-UpperWheelbase/2,-IdleWF_w/2,UpperWheelOffset])
				rotate([-90,0,0]) translate([0,0,-Overlap]) cylinder(d=1,h=IdleWF_w+Overlap*2);
			} // hull
		/**/
			
		translate([LowerWheelbase/2,0,0])
		translate([0,-IdleWF_w/2-Overlap,0]) rotate([-90,0,0])
			cylinder(d=Bearing3_OD-1,h=IdleWF_w+Overlap*2);
		
		
			
		
					
		translate([UpperWheelbase/2,0,UpperWheelOffset])
					translate([0,-IdleWF_w/2-Overlap,0]) rotate([-90,0,0])
			cylinder(d=12.7,h=IdleWF_w+Overlap*2);
	} // difference
	
	
} // FrameSectionB

//FrameSectionB();

module FrameSectionA(){
	
	nBolts=8;
	
	
	difference(){
		union(){
			translate([-LowerWheelbase/2,-IdleWF_w/2,0]) rotate([-90,0,0]) 
				cylinder(d=Bearing2_ID,h=IdleWF_w);
			
			translate([-UpperWheelbase/2,-IdleWF_w/2,UpperWheelOffset])
				rotate([-90,0,0]) cylinder(d=26,h=IdleWF_w);
			
			hull(){
				translate([-LowerWheelbase/2,-IdleWF_w/2,0]) rotate([-90,0,0]) 
				cylinder(d=34,h=IdleWF_w);
				translate([-UpperWheelbase/2,-IdleWF_w/2,UpperWheelOffset])
				rotate([-90,0,0]) cylinder(d=12,h=IdleWF_w);
			} // hull
		} // union
		/*
		hull(){
				translate([-LowerWheelbase/2,-IdleWF_w/2,0]) rotate([-90,0,0]) 
				translate([0,0,-Overlap]) cylinder(d=23,h=IdleWF_w+Overlap*2);
				translate([-UpperWheelbase/2,-IdleWF_w/2,UpperWheelOffset])
				rotate([-90,0,0]) translate([0,0,-Overlap]) cylinder(d=1,h=IdleWF_w+Overlap*2);
			} // hull
		/**/
			
		translate([-LowerWheelbase/2,0,0]){
		translate([0,-IdleWF_w/2-Overlap,0]) rotate([-90,0,0])
			cylinder(d=Bearing2_ID-Bolt4Inset*4,h=IdleWF_w+Overlap*2);
		
		translate([0,-IdleWF_w/2,0]) rotate([90,0,0]) 
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j])
				translate([Bearing2_ID/2-Bolt4Inset,0,0])
					Bolt4Hole();
			
		translate([0,IdleWF_w/2,0]) rotate([-90,0,0]) 
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j])
				translate([Bearing2_ID/2-Bolt4Inset,0,0])
					Bolt4Hole();}
					
		translate([-UpperWheelbase/2,0,UpperWheelOffset])
					translate([0,-IdleWF_w/2-Overlap,0]) rotate([-90,0,0])
			cylinder(d=12.7,h=IdleWF_w+Overlap*2);
	} // difference
	
	
} // FrameSectionA

//FrameSectionA();

module BearingOuterMotor(){
	translate([LowerWheelbase/2,0,0])rotate([-90,0,0])
		OnePieceInnerRace(BallCircle_d=Bearing3_BC,	Race_ID=Bearing3_ID,	Ball_d=Ball_d, Race_w=Bearing3_w, PreLoadAdj=BearingPreload, VOffset=2.00, BI=true, myFn=$preview? 36:360);
	
	translate([LowerWheelbase/2,0,0])rotate([90,0,0]) translate([0,0,-Overlap])
		OnePieceInnerRace(BallCircle_d=Bearing3_BC,	Race_ID=Bearing3_ID,	Ball_d=Ball_d, Race_w=Bearing3_w, PreLoadAdj=BearingPreload, VOffset=2.00+Overlap, BI=true, myFn=$preview? 36:360);
	
} // BearingOuterMotor

//BearingOuterMotor();
	
module UpperIdleSpocketInner(){
	Width=7;
	
	difference(){
		ToothHoldingDisk(nTeeth=nUpperWheelTeeth,Thickness=Width,ShowTeeth=$preview)
			Bolt4Hole();
		
		rotate([-90,0,0]) translate([0,0,-Overlap])
			cylinder(d=Bearing_OD,h=Width+Overlap*2);
		
		
	} // difference
} // UpperIdleSpocketInner

//UpperIdleSpocketInner();

module UpperIdleSpocketOuter(){
	Width=8;
	
	difference(){
		ToothHoldingDisk(nTeeth=nUpperWheelTeeth,Thickness=Width,ShowTeeth=$preview)
			Bolt4HeadHole();
		
		rotate([-90,0,0]) translate([0,0,-Overlap]){
			cylinder(d=Bearing_OD,h=Width-2);
			cylinder(d=Bearing_OD-3,h=Width-1);
		}
		
	} // difference
} // UpperIdleSpocketOuter

//UpperIdleSpocketOuter();

module LowerIdleSpocketInner(){
	Width=7;
	nSpokes=7;
	
	difference(){
		ToothHoldingDisk(nTeeth=nLowerWheelTeeth,Thickness=Width,ShowTeeth=$preview)
			Bolt4Hole();
		
		rotate([-90,0,0]) translate([0,0,-Overlap])
			cylinder(d=Bearing_OD,h=Width+Overlap*2);
		
		for (j=[0:nSpokes-1]) rotate([-90,0,0]){
			rotate([0,0,360/nSpokes*(j-0.25)]) hull(){
				translate([Bearing_OD/2+Bolt4Inset,0,-Overlap])
					cylinder(d=4,h=Width+Overlap*2);
				translate([34,10,-Overlap])
					cylinder(d=4,h=Width+Overlap*2);
				translate([34,-10,-Overlap])
					cylinder(d=4,h=Width+Overlap*2);
			}
			
			rotate([0,0,360/nSpokes*(j+0.25)])
				translate([Bearing_OD/2+Bolt4Inset,0,Width]) Bolt4Hole();
		}
	} // difference
} // LowerIdleSpocketInner

//LowerIdleSpocketInner();


module LowerIdleSpocketOuter(){
	Width=8;
	nSpokes=7;
	
	difference(){
		ToothHoldingDisk(nTeeth=nLowerWheelTeeth,Thickness=Width,ShowTeeth=$preview)
			Bolt4HeadHole();
		
		rotate([-90,0,0]) translate([0,0,-Overlap]){
			cylinder(d=Bearing_OD,h=Width-2);
			cylinder(d=Bearing_OD-3,h=Width-1);
		}
			
		for (j=[0:nSpokes-1]) rotate([-90,0,0]){
			rotate([0,0,360/nSpokes*(j-0.25)]) hull(){
				translate([Bearing_OD/2+Bolt4Inset,0,-Overlap])
					cylinder(d=4,h=Width+Overlap*2);
				translate([34,10,-Overlap])
					cylinder(d=4,h=Width+Overlap*2);
				translate([34,-10,-Overlap])
					cylinder(d=4,h=Width+Overlap*2);
			}
			
			rotate([0,0,360/nSpokes*(j+0.25)])
				translate([Bearing_OD/2+Bolt4Inset,0,Width]) Bolt4HeadHole();
		}
	} // difference
} // LowerIdleSpocketOuter

//LowerIdleSpocketOuter();


/*
ring_gear(number_of_teeth=43,
	circular_pitch=GearPitch, diametral_pitch=false,
	pressure_angle=GearPitch_a,
	clearance = 0.2,
	gear_thickness=15,
	rim_thickness=15,
	rim_width=2,
	backlash=GearBacklash,
	twist=0,
	involute_facets=0, // 1 = triangle, default is 5
	flat=false);

cylinder(d=70,h=52); // motor
/**/





















