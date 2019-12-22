// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// This is the connection between the chassis and a track unit.
//
// Filename: TSM_BodyJack.scad
// By: David M. Flynn
// Created: 10/16/2019
// Revision: 0.9.8 12/20/2019
// Units: mm
// *************************************************
//  ***** Notes *****
// Todo: Add encoders or limit switches and hard stops?
// *************************************************
//  ***** History ******
// 0.9.8 12/20/2019 Everything but the optical switch mount. Added GearBacklash to planets. FC1
// 0.9.7 12/19/2019 Changed RingABearing bolt circle
// 0.9.6 12/17/2019 Little fixes, Stop on RingA
// 0.9.5 10/30/2019 Reduced teeth on pulley from 36 to 32
// 0.9.4 10/26/2019 Added RingC() Inner planet carrier support bearing
// 0.9.3 10/20/2019 Added Lifter parts.
// 0.9.2 10/19/2019 Fixed planet gear, added PlanetCarrierDrivePulley,
// 0.9.1 10/18/2019 Ready to print? no
// 0.9.0 10/16/2019 First code.
// *************************************************
//  ***** for STL output *****
// RingA();
// RingA_HomeFinderDisk();
// RingA_Stop(HasSkirt=false); // shortened to 24.5mm 12/20/2019
// ScrewMountRingB(); // Fixed ring. flange mount version.
// RingB(); // Fixed ring. Square version.
// RingABearing();
// rotate([180,0,0]) RoundRingC();
//
// PlanetCarrierOuter();
// PlanetCarrierSpacer();
// PlanetCarrierInner();
// rotate([180,0,0]) Planet();
//
// PlanetCarrierDrivePulley(nTeeth=32); // print 2 /jack
//
// LifterRing();
// LifterBearingCover();
// LifterConnector();
//
// TestFixture();
// *************************************************
//  ***** for Viewing *****
//  ShowBodyJack(Rot_a=20);
// *************************************************

include<Pulleys.scad>
include<BearingLib.scad>
include<ring_gear.scad>
include<involute_gears.scad>
include<SplineLib.scad>
include<TubeConnectorLib.scad>
include<CommonStuffSAEmm.scad>

$fn=$preview? 24:90;
Overlap=0.05;
IDXtra=0.2;
Bolt4Inset=4;


nPlanets=3;
GearAPitch=260;
GearBPitch=286.8965517241379;
Pressure_a=20;
PlanetATeeth=16;
PlanetBTeeth=16;
RingATeeth=48;
RingBTeeth=45;

Gear_w=18;
GearBacklash=0.2;

RingA_pd=RingATeeth*GearAPitch/180;
PC_BC_d=RingA_pd-PlanetATeeth*GearAPitch/180;
Ring_B_cpd=PC_BC_d+PlanetBTeeth*GearBPitch/180;
//RingBTeeth=floor(Ring_B_cpd*180/GearBPitch);

// Planet rotations per motor rotations, aka planet carrier
P_Ratio=RingATeeth/PlanetATeeth;
// Planet B teeth per motor rotation
PBt=P_Ratio*PlanetBTeeth;
// Ring A rotations per motor rotation
Rf=1/(1-RingBTeeth/PBt);
echo("Ratio = ",Rf);

// big bearing 1/2 x 1-1/8 x 5/16
Bearing_OD=1.125*25.4;
Bearing_ID=0.500*25.4;
Bearing_w=0.3125*25.4;

/*
// little bearing 6 x 13 x 5
sBearing_OD=13;
sBearing_ID=6;
sBearing_w=5;
/**/

// little bearing 6.35 x 12.7 x 4.7
sBearing_OD=12.7;
sBearing_ID=6.35;
sBearing_w=4.7;



Tube_OD=12.7; // 1/2" Aluminum tubing

Ball_d=5/16*25.4;
BearingPreload=-0.3; // easy to back drive

twist=200;

	RingA_OD=RingATeeth*GearAPitch/180+GearAPitch/60;
	RingA_Bearing_ID=RingA_OD-7;
	RingA_Bearing_BallCircle=RingA_OD+Ball_d;
	RingA_Bearing_Race_w=10;

RingA_Bearing_OD=RingA_Bearing_BallCircle+Ball_d+5;
RingB_Bearing_Race_w=10;
RingA_Gear_OD=RingATeeth*GearAPitch/180+6;

PC_Axil_L=1.5*25.4;
PC_End_d=Bolt4Inset*2+2;
PC_Spacer_d=25;
PC_spacer_l=40;

LeverOffset=47;
LeverMount_L=50;
RingB_OD=RingBTeeth*GearBPitch/180+GearBPitch/60+1;
RingB_OD_Xtra=3;

RingB_BC_d=100;

RingC_BC_d=RingB_OD+Bolt4Inset*2;


module ShowBodyJack(Rot_a=180/RingATeeth){
	translate([0,0,-14.5]) rotate([180,0,0]) RingABearing();
	rotate([0,0,Rot_a]) RingA();
	
	translate([0,0,-14.5]) RingA_Stop(HasSkirt=false);
	
	translate([0,0,Gear_w+1])  ScrewMountRingB();
	
	translate([0,0,33])PlanetCarrierDrivePulley(nTeeth=32);
	translate([0,0,58]) rotate([180,0,0]) RoundRingC();
	//*
	
	for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,0]) Planet();
		
	translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+PC_spacer_l/2+Overlap]) PlanetCarrierInner();
	translate([0,0,Gear_w/2+0.5-PC_Axil_L/2]) PlanetCarrierSpacer();
	translate([0,0,Gear_w/2+0.5-PC_Axil_L/2-Overlap]) rotate([180,0,0]) PlanetCarrierOuter();
	/**/
} // ShowBodyJack

//rotate([90,0,0]) ShowBodyJack(Rot_a=20);
//translate([0,0,-110]) rotate([90,0,0]) ShowBodyJack(Rot_a=20);
// rotate([0,-90,0]) ShowBodyJack(Rot_a=0);
//translate([0,0,50-16]) PlanetCarrierDrivePulley();

PC_Drv_L=15;

module PlanetCarrierDrivePulley(nTeeth=32){
	nSpokes=7;
	Spoke_Thickness=1.6;
	BeltPitch=0.2*25.4;
	Belt_Thickness=2.36;
	Wall_Thickness=2;
	PulleyBore_d=nTeeth*BeltPitch/PI-Belt_Thickness*2-Wall_Thickness*2; //52;
	Belt_w=10;
	Pulley_w=Belt_w+1.2*4;
	
	
	difference(){
		union(){
			cylinder(d=PC_Spacer_d+5,h=PC_Drv_L);
			IdlePulley(Belt_w = Belt_w ,Teeth = nTeeth, Bore_d=PulleyBore_d);
			
			// spokes
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
				rotate([0,0,45]) cylinder(d=Spoke_Thickness,h=Pulley_w,$fn=4);
				translate([0,PulleyBore_d/2,0]) rotate([0,0,45]) cylinder(d=Spoke_Thickness,h=Pulley_w,$fn=4);
			} // hull
		} // union
		
		translate([0,0,-Overlap])
			SplineHole(d=PC_Spacer_d,l=PC_Drv_L+Overlap*2,nSplines=6,Spline_w=30,Gap=IDXtra,Key=false);
	} // difference
	
} // PlanetCarrierDrivePulley

//translate([0,0,50-16]) PlanetCarrierDrivePulley(nTeeth=32);


module PlanetCarrierInner(){
	translate([0,0,-PC_spacer_l/2]) PlanetCarrierOuter();
	//translate([0,0,PC_spacer_l/2]) rotate([180,0,0]) PlanetCarrierOuter();
	
	translate([0,0,-PC_spacer_l/2])
	SplineShaft(d=PC_Spacer_d,l=PC_spacer_l/2,nSplines=6,Spline_w=30,Hole=Tube_OD+IDXtra,Key=false);
} // PlanetCarrierInner

//translate([0,0,Gear_w/2+0.5+PC_Axil_L/2+PC_spacer_l/2+Overlap]) PlanetCarrierInner();

module PlanetCarrierOuter(){
	difference(){
		union(){
			
			for (j=[0:nPlanets*2-1]) rotate([0,0,180/nPlanets*j]) hull(){
				translate([-PC_BC_d/2,0,0]) cylinder(d=PC_End_d,h=3);
				cylinder(d=20,h=5);
				
				
			} // hull
			
		} // union
		
		// Tube
		translate([0,0,-Overlap]) cylinder(d=Tube_OD+IDXtra,h=6+Overlap*2);
		
		// Planet bolts
		for (j=[0:nPlanets*2-1]) rotate([0,0,180/nPlanets*j]) translate([-PC_BC_d/2,0,4]) Bolt4ButtonHeadHole();
			
		
	} // difference
	
} // PlanetCarrierOuter

//translate([0,0,Gear_w/2+0.5-PC_Axil_L/2-Overlap]) rotate([180,0,0]) PlanetCarrierOuter();


module PlanetCarrierSpacer(){
	difference(){
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) hull(){
				translate([-PC_BC_d/2,0,0]) cylinder(d=PC_End_d,h=PC_Axil_L);
				cylinder(d=20,h=PC_Axil_L);
				
				
			} // hull
		
		// Cut-outs for planet gears
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,-Overlap]) 
			cylinder(d=30,h=PC_Axil_L+Overlap*2);
			
		// Bolt holes
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) translate([-PC_BC_d/2,0,0]) {
			rotate([180,0,0]) Bolt4Hole();
			translate([0,0,PC_Axil_L]) Bolt4Hole();
		}
		
		// Tube
		translate([0,0,-Overlap])  cylinder(d=Tube_OD+IDXtra,h=PC_Axil_L+Overlap*2);
		
		
	} // difference
} // PlanetCarrierSpacer

//translate([0,0,Gear_w/2+0.5-PC_Axil_L/2]) PlanetCarrierSpacer();

module Planet(){
	
	difference(){
		union(){
			gear(number_of_teeth=PlanetATeeth,
				circular_pitch=GearAPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Gear_w/2,
				rim_thickness=Gear_w/2,
				rim_width=5,
				hub_thickness=Gear_w/2,
				hub_diameter=15,
				bore_diameter=sBearing_OD-1,
				circles=0,
				backlash=GearBacklash,
				twist=twist/PlanetATeeth,
				involute_facets=0,
				flat=false);
			
			mirror([0,0,1])
			gear(number_of_teeth=PlanetATeeth,
				circular_pitch=GearAPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=Gear_w/2,
				rim_thickness=Gear_w/2,
				rim_width=5,
				hub_thickness=Gear_w/2,
				hub_diameter=15,
				bore_diameter=sBearing_OD-1,
				circles=0,
				backlash=GearBacklash,
				twist=twist/PlanetATeeth,
				involute_facets=0,
				flat=false);
			
			translate([0,0,Gear_w/2-Overlap]) rotate([0,0,180/PlanetATeeth-1.20])
			gear(number_of_teeth=PlanetATeeth,
				circular_pitch=GearAPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=1+Overlap*2,
				rim_thickness=1+Overlap*2,
				rim_width=5,
				hub_thickness=1+Overlap*2,
				hub_diameter=15,
				bore_diameter=sBearing_OD-1,
				circles=0,
				backlash=GearBacklash,
				twist=20/PlanetATeeth,
				involute_facets=0,
				flat=false);
			
			translate([0,0,Gear_w+1]){
				gear(number_of_teeth=PlanetBTeeth,
					circular_pitch=GearBPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=Gear_w/2,
					rim_thickness=Gear_w/2,
					rim_width=5,
					hub_thickness=Gear_w/2,
					hub_diameter=15,
					bore_diameter=sBearing_OD-1,
					circles=0,
					backlash=GearBacklash,
					twist=twist/PlanetBTeeth,
					involute_facets=0,
					flat=false);

				mirror([0,0,1])
					gear(number_of_teeth=PlanetBTeeth,
					circular_pitch=GearBPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=Gear_w/2,
					rim_thickness=Gear_w/2,
					rim_width=5,
					hub_thickness=Gear_w/2,
					hub_diameter=15,
					bore_diameter=sBearing_OD-1,
					circles=0,
					backlash=GearBacklash,
					twist=twist/PlanetBTeeth,
					involute_facets=0,
					flat=false);
			}
		} // union


		translate([0,0,-Gear_w/2-Overlap]) cylinder(d=sBearing_OD,h=sBearing_w+Overlap);
		translate([0,0,Gear_w+Gear_w/2+1-sBearing_w]) cylinder(d=sBearing_OD,h=sBearing_w+Overlap);
	} // difference
} // Planet

//for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,0]) rotate([0,0,180/PlanetBTeeth]) Planet();
//cylinder(d=13,h=50);
	

module RingABearing(){
	OnePieceOuterRace(BallCircle_d=RingA_Bearing_BallCircle, Race_OD=RingA_Bearing_OD, Ball_d=Ball_d, 
			Race_w=RingA_Bearing_Race_w, PreLoadAdj=BearingPreload, VOffset=0.50, BI=true, myFn=$preview? 60:720);
	
	RingABearingMountingRing_t=3;
	RingABearingMountingRing_BC_d=104;
	RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;
	nBolts=8;
	
	difference(){
		union(){
			cylinder(d=RingABearingMountingRing_d,h=RingABearingMountingRing_t);
			
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				
				translate([RingABearingMountingRing_BC_d/2-Bolt4Inset,0,0])
					cylinder(d=Bolt4Inset*2+2,h=RingABearingMountingRing_t);
				translate([RingABearingMountingRing_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=RingABearingMountingRing_t);
			}
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_OD-1,h=RingABearingMountingRing_t+Overlap*2);
		
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j])
			translate([RingABearingMountingRing_BC_d/2,0,RingABearingMountingRing_t+3])
				Bolt4Hole();
	} // difference
} // RingABearing

//translate([15-0.5,0,0]) rotate([0,90,0]) RingABearing();

RingA_Major_OD=80;

module RingA_Stop(HasSkirt=false){
	RingABearingMountingRing_t=3;
	RingABearingMountingRing_BC_d=104;
	RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;
	nBolts=8;
	PostToRingB_h=24.5;
	
	difference(){
		union(){
			
			// lower ring
			cylinder(d=RingABearingMountingRing_d-6,h=RingABearingMountingRing_t);
			
			//skirt
			if (HasSkirt==true)
			difference(){
				cylinder(d=RingB_BC_d,h=PostToRingB_h);
				
				translate([0,0,-Overlap]) cylinder(d=RingB_BC_d-4,h=PostToRingB_h+Overlap*2);
			} // difference
			
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				
				translate([RingB_BC_d/2,0,PostToRingB_h-7])
					cylinder(d=Bolt4Inset*2,h=7);
				translate([RingABearingMountingRing_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=7);
			} // for
			
			// Optical sensor mount
			rotate([0,0,22.5]){
				translate([-RingABearingMountingRing_d/2+6,-20,0]) cube([3,40,PostToRingB_h]);
			}
			
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingA_Major_OD+8,h=RingABearingMountingRing_t+Overlap*2);
		
		// Optical sensor mount
			rotate([0,0,22.5]){
				hull(){
					translate([-RingABearingMountingRing_d/2+6-Overlap,0,8]) rotate([0,90,0]) cylinder(d=7,h=3+Overlap*2);
					translate([-RingABearingMountingRing_d/2+6-Overlap,0,25]) rotate([0,90,0]) cylinder(d=7,h=3+Overlap*2);
				}
				translate([-RingABearingMountingRing_d/2+6-Overlap,-7.5,10]) rotate([0,-90,0]) Bolt4Hole();
				translate([-RingABearingMountingRing_d/2+6-Overlap,7.5,10]) rotate([0,-90,0]) Bolt4Hole();
				translate([-RingABearingMountingRing_d/2+6-Overlap,-7.5,20]) rotate([0,-90,0]) Bolt4Hole();
				translate([-RingABearingMountingRing_d/2+6-Overlap,7.5,20]) rotate([0,-90,0]) Bolt4Hole();
			}
			
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]){
			translate([RingABearingMountingRing_BC_d/2,0,0])
				rotate([180,0,0]) Bolt4Hole();
			translate([RingB_BC_d/2,0,PostToRingB_h]) Bolt4Hole();
		}
	} // difference
	
	// hard stop
	rotate([0,0,22.5])
	difference(){
		union(){
			hull(){
				translate([RingA_Major_OD/2+7,-14,0]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,14,0]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,-2,10]) cylinder(d=3,h=1);
				translate([RingA_Major_OD/2+7,2,10]) cylinder(d=3,h=1);
			}
			
			hull(){
				translate([RingA_Major_OD/2+5,0,5]) cylinder(d=8,h=6);
				translate([RingA_Major_OD/2+7,0,5]) cylinder(d=8,h=6);
				translate([RingA_Major_OD/2+9,0,0]) cylinder(d=8,h=1);
			} // hull
		} // union
		
		translate([0,0,-15]) cylinder(d=RingA_Major_OD-4,h=16);
	} // difference
	
} // RingA_Stop

//RingA_Stop(HasSkirt=true);


//*
//RingA_Stop(HasSkirt=false);
//translate([0,0,Gear_w/2+6]) rotate([0,0,10]) RingA();
//translate([0,0,Gear_w+16]) ScrewMountRingB();
//translate([0,0,Gear_w/2+6+2]) RingA_HomeFinderDisk();
//translate([0,0,60]) rotate([180,0,0]) RoundRingC();
/**/


module ScrewMountRingB(){
	
	nBolts=8;
	
	RingB_Gear();
	
	translate([0,0,-Gear_w/2])
	difference(){
		union(){
			
			// bolt bosses to ring C
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingB_OD/2,0,Gear_w/2])
					cylinder(d=Bolt4Inset*2+2,h=Gear_w/2);
				translate([RingC_BC_d/2,0,Gear_w/2])
					cylinder(d=Bolt4Inset*2,h=Gear_w/2);
				
			}
			
			// bolt bosses to ring A
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				
				translate([RingB_OD/2,0,0])
					cylinder(d=Bolt4Inset*2+2,h=Gear_w/2);
				translate([RingB_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=Gear_w/2);
			}
		} // union
		
		// remove inside
		translate([0,0,-Overlap]) cylinder(d=RingB_OD,h=Gear_w+Overlap*2);
		
		// bolts to ring A
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) 
			translate([RingB_BC_d/2,0,Gear_w/2]) Bolt4HeadHole(depth=Gear_w);
		
		// bolts to Ring C
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) 
			translate([RingC_BC_d/2,0,Gear_w]) Bolt4Hole(depth=Gear_w);
	} // difference
	
} // ScrewMountRingB

//ScrewMountRingB();

module RingA_HomeFinderDisk(){
	Thickness=1.5;
	difference(){
		cylinder(d=RingA_Major_OD+10,h=Thickness);
		
		difference(){
			translate([-RingA_Major_OD/2-10,0,-Overlap]) cube([RingA_Major_OD+20,RingA_Major_OD+20,Thickness+Overlap*2]);
			translate([0,0,-Overlap*2]) cylinder(d=RingA_Major_OD+4,h=Thickness+Overlap*4);
		} // difference
		
		translate([0,0,-Overlap]) cylinder(d=RingA_Major_OD-2,h=Thickness+Overlap*2);
	} // difference
	
	
	
} // RingA_HomeFinderDisk

//translate([0,0,2]) RingA_HomeFinderDisk();


module RingA(){
	ring_gear(number_of_teeth=RingATeeth,
		circular_pitch=GearAPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.2,
		gear_thickness=Gear_w/2,
		rim_thickness=Gear_w/2,
		rim_width=2,
		backlash=GearBacklash,
		twist=twist/RingATeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
	
	mirror([0,0,1])
		ring_gear(number_of_teeth=RingATeeth,
			circular_pitch=GearAPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Gear_w/2,
			rim_thickness=Gear_w/2,
			rim_width=2,
			backlash=GearBacklash,
			twist=twist/RingATeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
	
	RingA_Teeth_ID=RingATeeth*GearAPitch/180-GearAPitch/90;
	
	
	nSpokes=7;
	
	translate([0,0,-Gear_w/2])
	difference(){
		union(){
			cylinder(d=RingA_Major_OD,h=Gear_w-7);
			cylinder(d=RingA_Major_OD-2,h=Gear_w);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingA_OD,h=Gear_w+Overlap*2);
	} // difference
	

	// Skirt connecting bearing to gear
	translate([0,0,-Gear_w/2-6-Overlap])
	difference(){
		cylinder(d1=RingA_Bearing_BallCircle-Ball_d*0.7,d2=RingA_Major_OD,h=6+Overlap*2);
		
		translate([0,0,-Overlap]) cylinder(d1=RingA_Bearing_BallCircle-Ball_d*0.7-5,d2=RingA_Teeth_ID,h=6+Overlap*4);
	} // difference
	
	// Planet carrier bearing mount
	translate([0,0,-Gear_w/2-6-RingA_Bearing_Race_w])
	difference(){
		union(){
			translate([0,0,RingA_Bearing_Race_w]) rotate([180,0,0])
			OnePieceInnerRace(BallCircle_d=RingA_Bearing_BallCircle,	Race_ID=RingA_Bearing_ID,	
				Ball_d=Ball_d, Race_w=RingA_Bearing_Race_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=$preview? 60:720);

			 cylinder(d=Bearing_OD+6,h=Bearing_w+2);
			
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]){
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=6,h=RingA_Bearing_Race_w);
				
					hull(){
					translate([Bearing_OD/2+3,0,0]) rotate([0,0,45]) cylinder(d=2,h=Bearing_w+2,$fn=4);
					translate([RingA_Bearing_ID/2+1,0,0]) rotate([0,0,45]) cylinder(d=2,h=Bearing_w+2,$fn=4);
				} // hull
			} // for
		} // union
		//Bearing_OD=1.125*25.4;
		//Bearing_ID=0.500*25.4;
		//Bearing_w=0.3125*25.4;

		translate([0,0,-Overlap]) cylinder(d=Bearing_OD-1,h=3);
		translate([0,0,2]) cylinder(d=Bearing_OD,h=Bearing_w+1);
		
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) 
			translate([RingA_Bearing_ID/2,0,0]) rotate([180,0,0]) Bolt4Hole();
	} // difference
	
	// hard stop
	difference(){
		hull(){
			translate([RingA_Major_OD/2+2,0,-8]) cylinder(d=8,h=4);
			translate([RingA_Major_OD/2-2,0,-8]) cylinder(d=8,h=4);
			translate([RingA_Major_OD/2-4,0,-15]) cylinder(d=4,h=1);
		} // hull
		
		translate([0,0,-15]) cylinder(d=RingA_Major_OD-4,h=16);
	} // difference
	
} // RingA

// RingA();

module LifterConnector(nSpokes=7){
	LC_h=6;
	Skirt_t=5;

	difference(){
		union(){
			// Bolt bosses
			for (j=[0:nSpokes-2]) rotate([0,0,360/nSpokes*(j+1)])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=LC_h);
			
			translate([50,0,0]) rotate([0,0,180])
			for (j=[0:nSpokes-2]) rotate([0,0,360/nSpokes*(j+1)])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=LC_h);
			
			
			// skirt
			difference(){
				union(){
					cylinder(d=RingA_Bearing_ID+2.5,h=LC_h);
					translate([50,0,0]) cylinder(d=RingA_Bearing_ID+2.5,h=LC_h);
					
					hull(){
						cylinder(d=RingA_Bearing_ID-7,h=LC_h);
						translate([50,0,0]) cylinder(d=RingA_Bearing_ID-8,h=LC_h);
					} // hull
				} // union
				
				translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LC_h+Overlap*2);
				translate([50,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LC_h+Overlap*2);
				hull(){
					translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID-20,h=LC_h+Overlap*2);
					translate([50,0,-Overlap]) cylinder(d=RingA_Bearing_ID-20,h=LC_h+Overlap*2);
				} // hull
			} // difference
		} // union
		
		
		// Bolts
		for (j=[0:nSpokes-4]) rotate([0,0,360/nSpokes*(j+2)])
					translate([RingA_Bearing_ID/2,0,LC_h]) Bolt4ClearHole();
		
		translate([50,0,0]) rotate([0,0,180])
		for (j=[0:nSpokes-4]) rotate([0,0,360/nSpokes*(j+2)])
					translate([RingA_Bearing_ID/2,0,LC_h]) Bolt4ClearHole();
	} // difference
} // LifterConnector

//translate([0,0,6.2]) LifterConnector();

Lock_Ball_d=3/8*25.4;

module LifterLockingRing(nSpokes=7){
	
	Lock_Ball_Circle_d=RingA_Bearing_ID+Lock_Ball_d;
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLR_h=Lock_Ball_d;
	
	difference(){
		union(){
			cylinder(d=Major_d,h=LLR_h);
			
			translate([0,0,LLR_h-4]) cylinder(d1=Major_d,d2=Major_d+2,h=3+Overlap);
			translate([0,0,LLR_h-1]) cylinder(d=Major_d+2,h=1);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=Lock_Ball_Circle_d+Lock_Ball_d-2,h=LLR_h+Overlap*2);
		
		// Bolts bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
					translate([Major_d/2-Bolt4Inset-2,0,-Overlap]) cylinder(r=Bolt4Inset+IDXtra,h=LLR_h+Overlap*4);
					translate([Major_d/2-Bolt4Inset*2,0,-Overlap]) cylinder(r=Bolt4Inset+1+IDXtra,h=LLR_h+Overlap*4);
			}
			
		// Ball detents
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) 
			translate([Lock_Ball_Circle_d/2,0,LLR_h/2]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
		
		// Ball releases
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
			translate([Lock_Ball_Circle_d/2,0,LLR_h/2-2]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
			translate([Lock_Ball_Circle_d/2+2,0,LLR_h/2-5]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
		} // hull
	} // difference
	
} // LifterLockingRing

//translate([0,0,10-Lock_Ball_d/2+5]) LifterLockingRing(); // unlocked
//rotate([180,0,0]) LifterLockingRing(); // for STL
//translate([0,0,10-Lock_Ball_d/2]) LifterLockingRing(); // locked

Dogbone_L=90;

module LifterLockCover(nSpokes=7){
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLC_h=8;
	Skirt_t=5;
	WirePath_w=25;
	
	
	difference(){
		union(){
			cylinder(d=Major_d-Bolt4Inset*2,h=2);
			
			translate([-Dogbone_L,0,0]){
				// skirt
				difference(){
					union(){
						cylinder(d=RingA_Bearing_ID+2.5,h=LLC_h);
						cylinder(d=RingA_Bearing_ID-8,h=LLC_h);
							
					}
					
					translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LLC_h+Overlap*2);
					
					hull(){
						translate([0,0,2]) cylinder(d=RingA_Bearing_ID-42,h=LLC_h+Overlap*2);
						translate([50,0,2]) cylinder(d=RingA_Bearing_ID-42,h=LLC_h+Overlap*2);
					} // hull
				} // difference
				
				// Bolt bosses
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
						translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=LLC_h);
			} // translate
			
			//wire path
			difference(){
				hull(){
					translate([15,WirePath_w/2,0]) cylinder(d=10,h=Overlap);
					translate([15,WirePath_w/2,4]) sphere(d=8);
					
					translate([15,-WirePath_w/2,0]) cylinder(d=10,h=Overlap);
					translate([15,-WirePath_w/2,4]) sphere(d=8);
					
					translate([-75,WirePath_w/2,0]) cylinder(d=10,h=Overlap);
					translate([-75,WirePath_w/2,4]) sphere(d=8);
					
					translate([-75,-WirePath_w/2,0]) cylinder(d=10,h=Overlap);
					translate([-75,-WirePath_w/2,4]) sphere(d=8);
				} // hull
				
				hull(){
					translate([15,WirePath_w/2,2]) cylinder(d=6,h=Overlap);
					translate([15,WirePath_w/2,4]) sphere(d=4);
					
					translate([15,-WirePath_w/2,2]) cylinder(d=6,h=Overlap);
					translate([15,-WirePath_w/2,4]) sphere(d=4);
					
					translate([-75,WirePath_w/2,2]) cylinder(d=6,h=Overlap);
					translate([-75,WirePath_w/2,4]) sphere(d=4);
					
					translate([-75,-WirePath_w/2,2]) cylinder(d=6,h=Overlap);
					translate([-75,-WirePath_w/2,4]) sphere(d=4);
				} // hull
			} // difference
				
			// Bolts bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
					translate([Major_d/2-Bolt4Inset-2,0,0]) cylinder(r=Bolt4Inset,h=LLC_h);
					translate([Major_d/2-Bolt4Inset*2,0,0]) cylinder(r=Bolt4Inset+1,h=LLC_h);
			}
		} // union
		
		translate([-Dogbone_L,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LLC_h+Overlap*2);
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) translate([Major_d/2-Bolt4Inset-2,0,LLC_h]) Bolt4HeadHole();
		
		translate([-Dogbone_L,0,0])
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,LLC_h]) Bolt4ClearHole();
		
		
		hull(){
					translate([15,WirePath_w/2,-Overlap]) cylinder(d=6,h=Overlap);
					translate([15,WirePath_w/2,4]) sphere(d=4);
					
					translate([15,-WirePath_w/2,-Overlap]) cylinder(d=6,h=Overlap);
					translate([15,-WirePath_w/2,4]) sphere(d=4);
					
					translate([-25,WirePath_w/2,-Overlap]) cylinder(d=6,h=Overlap);
					translate([-25,WirePath_w/2,4]) sphere(d=4);
					
					translate([-25,-WirePath_w/2,-Overlap]) cylinder(d=6,h=Overlap);
					translate([-25,-WirePath_w/2,4]) sphere(d=4);
				} // hull
			
	} // difference
} // LifterLockCover

//translate([0,0,20]) LifterLockCover();

module LifterOneRing(nSpokes=7){
	Skirt_h=8;
	Skirt_t=5;
	
	difference(){
		union(){
			
			// skirt
			difference(){
				union(){
					cylinder(d=RingA_Bearing_ID+2.5,h=Skirt_h);
					cylinder(d=RingA_Bearing_ID-8,h=Skirt_h);
						
				}
				
				translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=Skirt_h+Overlap*2);
				hull(){
					translate([0,0,2]) cylinder(d=RingA_Bearing_ID-12-Skirt_t*2,h=Skirt_h+Overlap*2);
					translate([50,0,2]) cylinder(d=RingA_Bearing_ID-12-Skirt_t*2,h=Skirt_h+Overlap*2);
				} // hull
			} // difference
			
			// Bolt bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=Skirt_h);
			
		} // union
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,Skirt_h]) Bolt4ClearHole();
		
	
	} // difference
				
		
	
} // LifterOneRing

//translate([-90,0,20]) LifterOneRing();

module LifterDogLeg(nSpokes=7){
	Spline_h=20;
	Lock_Ball_Circle_d=RingA_Bearing_ID+Lock_Ball_d;
	Major_d=RingA_Bearing_BallCircle+Ball_d+4;
	LLC_h=6;
	Skirt_t=5;
	
	difference(){
		union(){
			cylinder(d=Major_d,h=Spline_h);
			
			
			
			translate([-Dogbone_L,0,0]){
				// skirt
				difference(){
					union(){
						cylinder(d=RingA_Bearing_ID+2.5,h=LLC_h);
					hull(){
						cylinder(d=RingA_Bearing_ID,h=5);
						translate([Dogbone_L,0,0]) cylinder(d=RingA_Bearing_ID,h=5);
					}
							
				}
					
					translate([0,0,2]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=LLC_h+Overlap*2);
					
				} // difference
				
				// Bolt bosses
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
						translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=LLC_h);
			} // translate
		} // union
		
		translate([-Dogbone_L,0,0])
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) rotate([180,0,0]) Bolt4HeadHole();
		
		translate([0,0,-Overlap]) SplineHole(d=RingA_Bearing_ID+Bolt4Inset*2,l=Spline_h+Overlap*2,nSplines=nSpokes,Spline_w=25,Gap=IDXtra,Key=true);
		
		// lock ring
		difference(){
			translate([0,0,Spline_h/2-Lock_Ball_d/2-IDXtra]) cylinder(d=Major_d+Overlap,h=Spline_h);
			
			translate([0,0,Spline_h/2-Lock_Ball_d/2-IDXtra-Overlap])
				cylinder(d=Lock_Ball_Circle_d+Lock_Ball_d-2,h=Spline_h+Overlap*2);
			
			// Bolts bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
					translate([Major_d/2-Bolt4Inset-2,0,-Overlap]) cylinder(r=Bolt4Inset,h=Spline_h+Overlap*4);
					translate([Major_d/2-Bolt4Inset*2,0,-Overlap]) cylinder(r=Bolt4Inset+1,h=Spline_h+Overlap*4);
			}
		} // difference
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) translate([Major_d/2-Bolt4Inset-2,0,Spline_h]) Bolt4Hole();
		
		// Ball detents
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
			translate([Lock_Ball_Circle_d/2,0,Spline_h/2]) sphere(d=Lock_Ball_d+IDXtra, $fn=$preview? 18:90);
			translate([Lock_Ball_Circle_d/2,0,Spline_h/2]) rotate([0,90,0]) cylinder(d=Lock_Ball_d+IDXtra,h=15, $fn=$preview? 18:90);
		} // hull
	} // difference
	
	// Balls
	if ($preview==true)
	for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)])
			translate([Lock_Ball_Circle_d/2,0,Spline_h/2]) color("Red") sphere(d=Lock_Ball_d, $fn=18);
} // LifterDogLeg

//translate([0,0,2+Overlap]) LifterDogLeg();

//LifterDogLeg();
//translate([100,0,30]) rotate([0,180,0]) LifterBearingCover(); 

module LifterSpline(nSpokes=7){
	Spline_h=20;
	Lock_Ball_Circle_d=RingA_Bearing_ID/2+Lock_Ball_d/2;
	
	difference(){
		union(){
			cylinder(d=RingA_Bearing_BallCircle+Ball_d+4,h=2);
			
			SplineShaft(d=RingA_Bearing_ID+Bolt4Inset*2,l=Spline_h+2,nSplines=nSpokes,Spline_w=25,Hole=Spline_Hole_d,Key=true);
		} // union
		
		// Center hole
		translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID-Bolt4Inset*2,h=Spline_h+2+Overlap*2);
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,12]) Bolt4HeadHole(depth=Spline_h,lHead=Spline_h);
		
		/*
		// wire path
		translate([-RingA_Bearing_ID/2+10,0,2+Spline_h/2]) rotate([0,-90,0]) hull(){
			cylinder(d=10,h=20);
			translate([7,0,0]) cylinder(d=2,h=20);
			translate([-7,0,0]) cylinder(d=2,h=20);
		} // hull
		/**/
		
		// Ball detents
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)])
			translate([Lock_Ball_Circle_d,0,2+Spline_h/2]) sphere(d=Lock_Ball_d, $fn=$preview? 18:90);
	} // difference
	
} // LifterSpline

//translate([0,0,-2.2]) LifterSpline();

module LifterBearingCover(nSpokes=7){
	difference(){
		union(){
			// bearing cover
			difference(){
				cylinder(d=RingA_Bearing_BallCircle+Ball_d+4,h=2);
				translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_BallCircle-Ball_d-8,h=2+Overlap*2);
			} // difference
			
			// Bolt bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=2);
		} // union
		
		// Bolts
		for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,2]) Bolt4ClearHole();
	} // difference
			
	
} // LifterBearingCover

//translate([0,0,-2.2]) 
//LifterBearingCover();

module LifterRing(nSpokes=7){
	Skirt_h=6;
	Skirt_t=5;
	
	difference(){
		union(){
			
			// skirt
			difference(){
				union(){
					cylinder(d=RingA_Bearing_ID+2.5,h=Skirt_h);
					difference(){
						translate([50,0,0]) cylinder(d=RingA_Bearing_ID+2.5,h=Skirt_h);
						translate([50,0,2]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=Skirt_h);
					} // difference
					
					hull(){
						cylinder(d=RingA_Bearing_ID-8,h=Skirt_h);
						translate([50,0,0]) cylinder(d=RingA_Bearing_ID-8,h=Skirt_h);
					} // hull
				}
				
				translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=Skirt_h+Overlap*2);
				translate([50,0,2]) cylinder(d=RingA_Bearing_ID+2.5-Skirt_t*2,h=Skirt_h+Overlap*2);
				hull(){
					translate([0,0,2]) cylinder(d=RingA_Bearing_ID-12-Skirt_t*2,h=Skirt_h+Overlap*2);
					translate([50,0,2]) cylinder(d=RingA_Bearing_ID-12-Skirt_t*2,h=Skirt_h+Overlap*2);
				} // hull
			} // difference
			
			// Bolt bosses
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=Skirt_h);
			
			translate([50,0,0]) rotate([0,0,180])
			for (j=[0:nSpokes-2]) rotate([0,0,360/nSpokes*(j+1)])
					translate([RingA_Bearing_ID/2,0,0]) cylinder(d=Bolt4Inset*2,h=Skirt_h);
			
		} // union
		
		// Bolts
		for (j=[0:nSpokes-4]) rotate([0,0,360/nSpokes*(j+2)])
					translate([RingA_Bearing_ID/2,0,Skirt_h]) Bolt4ClearHole();
		
		for (j=[0:nSpokes-5]) rotate([0,0,360/nSpokes*(j+6)])
					translate([RingA_Bearing_ID/2,0,Skirt_h]) Bolt4HeadHole();
		
		translate([50,0,0]) rotate([0,0,180])
		for (j=[0:nSpokes-4]) rotate([0,0,360/nSpokes*(j+2)])
					translate([RingA_Bearing_ID/2,0,0]) rotate([180,0,0]) Bolt4HeadHole();
		
	} // difference
				
		
	
} // LifterRing

//translate([0,0,-RingA_Bearing_Race_w-0.5]) RingABearing();
//translate([0,0,-Gear_w/2-RingA_Bearing_Race_w-6-Overlap*2]) rotate([180,0,0]) RingA();
//LifterRing();
//translate([50,0,18.4]) rotate([180,0,180]) LifterRing();


module RingB_Gear(){
	// Stationary Ring Gear
	// 12/17/2019 added RingB_OD_Xtra to thicken ring gear
	
	ring_gear(number_of_teeth=RingBTeeth,
		circular_pitch=GearBPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.2,
		gear_thickness=Gear_w/2,
		rim_thickness=Gear_w/2,
		rim_width=2,
		backlash=GearBacklash,
		twist=twist/RingBTeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
	
	mirror([0,0,1])
	ring_gear(number_of_teeth=RingBTeeth,
		circular_pitch=GearBPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.2,
		gear_thickness=Gear_w/2,
		rim_thickness=Gear_w/2,
		rim_width=2,
		backlash=GearBacklash,
		twist=twist/RingBTeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);

	translate([0,0,-Gear_w/2])
	difference(){
		cylinder(d=RingB_OD+RingB_OD_Xtra,h=Gear_w);
		
		translate([0,0,-Overlap]) cylinder(d=RingB_OD,h=Gear_w+Overlap*2);
	} // difference
} // RingB_Gear

//translate([0,0,Gear_w+16]) RingB_Gear();

module RingB(){
	// Stationary Ring Gear
	// 12/17/2019 added RingB_OD_Xtra to thicken ring gear
	RingB_Gear();

	// mount
	
	//*
	
	MB_X=90;
	MB_Y=MB_X;
	MB_Rim_t=2;
	nSpokes=16;
	Spoke_w=2;
	//echo(MB_X=MB_X);
	
	translate([0,0,-Gear_w/2])
	difference(){
		union(){
			
			
			difference(){
				translate([-MB_X/2,-MB_Y/2,0]) cube([MB_X,MB_Y,Gear_w]);
				translate([-MB_X/2+MB_Rim_t,-MB_Y/2+MB_Rim_t,-Overlap]) cube([MB_X-MB_Rim_t*2,MB_Y-MB_Rim_t*2,Gear_w+Overlap*2]);
			} // difference
			
			for (j=[0:3]) rotate([0,0,90*j]){
				hull(){
					translate([-MB_X/2+10-Bolt4Inset*1.5,-MB_Y/2,0]) cube([Bolt4Inset*3,Overlap,Gear_w]);
					translate([-MB_X/2+10-Bolt4Inset,-MB_Y/2+5,0]) cube([Bolt4Inset*2,Overlap,Gear_w]);
				} // hull
				hull(){
					translate([MB_X/2-10-Bolt4Inset*1.5,-MB_Y/2,0]) cube([Bolt4Inset*3,Overlap,Gear_w]);
					translate([MB_X/2-10-Bolt4Inset,-MB_Y/2+5,0]) cube([Bolt4Inset*2,Overlap,Gear_w]);
				} // hull
			} // for
			
			// Spokes
			difference(){
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
					translate([RingB_OD/2,0,0]) cylinder(d=Spoke_w,h=Gear_w);
					translate([MB_X*0.7,0,0]) cylinder(d=Spoke_w,h=Gear_w);
				} // hull
				
				difference(){
					translate([-MB_X/2-30,-MB_Y/2-30,-Overlap]) cube([MB_X+60,MB_Y+60,Gear_w+Overlap*2]);
					translate([-MB_X/2+1,-MB_Y/2+1,-Overlap*2]) cube([MB_X-2,MB_Y-2,Gear_w+Overlap*4]);
				} // difference
			} // difference
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingB_OD,h=Gear_w+Overlap*2);
		
		// Bolt holes
		for (j=[0:3]) rotate([0,0,90*j]) {
			
		translate([-MB_X/2+10,-MB_Y/2,Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([-MB_X/2+10,-MB_Y/2,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([MB_X/2-10,-MB_Y/2,Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([MB_X/2-10,-MB_Y/2,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		}
		
	} // difference
	
	
	
		/**/
} // RingB

//translate([0,0,Gear_w+16]) RingB();
//translate([0,0,Gear_w+1]) RingB();
//rotate([0,0,180/RingBTeeth])

module RoundRect(X=10,Y=10,Z=5,R=3){
	hull(){
		translate([-X/2+R,-Y/2+R,0]) cylinder(r=R,h=Z);
		translate([-X/2+R,Y/2-R,0]) cylinder(r=R,h=Z);
		translate([X/2-R,-Y/2+R,0]) cylinder(r=R,h=Z);
		translate([X/2-R,Y/2-R,0]) cylinder(r=R,h=Z);
	} // hull
} // RoundRect

module RoundRingC(){
	nBolts=8;
	MB_X=90;
	MB_Y=MB_X;
	nSpokes=8;
	Spoke_w=2;
	Motor_a=0;
	
	// Planet carrier bearing mount
	translate([0,0,Gear_w/2-(Bearing_w+2)])
	difference(){	

		cylinder(d=Bearing_OD+6,h=Bearing_w+2);
			
		//Bearing_OD=1.125*25.4;
		//Bearing_ID=0.500*25.4;
		//Bearing_w=0.3125*25.4;

		translate([0,0,-Overlap]) cylinder(d=Bearing_OD-1,h=3);
		translate([0,0,2]) cylinder(d=Bearing_OD,h=Bearing_w+1);
		
	} // difference
	
	rotate([0,0,Motor_a])
	difference(){
		union(){
			cylinder(d=RingC_BC_d-8,h=Gear_w/2);
		// bolt bosses to ring C
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) hull(){
				translate([RingB_OD/2-4,0,0])
					cylinder(d=Bolt4Inset*2+2,h=Gear_w/2);
				translate([RingC_BC_d/2,0,0])
					cylinder(d=Bolt4Inset*2,h=Gear_w/2);
				
			}
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=RingC_BC_d-8-4,h=Gear_w/2+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,0])
			rotate([180,0,0]) Bolt4HeadHole();
	} // difference
			
	
	// Spokes
			difference(){
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
					translate([Bearing_OD/2+2,0,0]) cylinder(d=Spoke_w,h=Gear_w/2);
					translate([RingC_BC_d/2-6,0,0]) cylinder(d=Spoke_w,h=Gear_w/2);
				} // hull
				
				difference(){
					translate([-MB_X/2-30,-MB_Y/2-30,-Overlap]) cube([MB_X+60,MB_Y+60,Gear_w+Overlap*2]);
					translate([-MB_X/2+1,-MB_Y/2+1,-Overlap*2]) cube([MB_X-2,MB_Y-2,Gear_w+Overlap*4]);
				} // difference
			} // difference
			
			// motor mount
			
			
		/*	
	//belt
			translate([0,0,12])
		difference(){
			hull(){
				cylinder(d=54,h=10);
				translate([Motor_X,0,0]) cylinder(d=21,h=10);
			}
			translate([0,0,-Overlap])
			hull(){
				cylinder(d=54-5,h=10+Overlap*2);
				translate([Motor_X,0,0]) cylinder(d=21-5,h=10+Overlap*2);
			}
		}
			/**/
			
	Motor_X=69.6; // 69.8 is OK but tight, 69.3; works but belt is loose
	MotorShaftHole_d=16;
	MotorSetback=8;
	Motor_BC_d=22.5;
	MotorBig_d=37;
	MotorFace_d=32;
	MM_t=6;
		Extra_W=22;
	
	difference(){
		hull(){
			translate([Motor_X,0,0]) cylinder(d=MotorBig_d,h=Gear_w/2);
			translate([RingB_OD/2-10,-(MotorBig_d+Extra_W)/2,0]) cube([Overlap,MotorBig_d+Extra_W,Gear_w/2]);
		} // hull
		
		hull(){
			rotate([0,0,32]) translate([RingB_OD/2+4,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,10]) translate([RingB_OD/2+4,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,7]) translate([RingB_OD/2+12,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,16.5]) translate([RingB_OD/2+22,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
		}
		
		mirror([0,1,0])
		hull(){
			rotate([0,0,32]) translate([RingB_OD/2+4,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,10]) translate([RingB_OD/2+4,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,7]) translate([RingB_OD/2+12,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
			rotate([0,0,16.5]) translate([RingB_OD/2+22,0,-Overlap]) cylinder(d=4,h=Gear_w/2+Overlap*2);
		}
		
		translate([Motor_X,0,-Gear_w/2-Overlap]) cylinder(d=MotorFace_d,h=Gear_w-MotorSetback);
		translate([Motor_X,0,-Gear_w/2-Overlap]) cylinder(d=MotorShaftHole_d,h=Gear_w+Overlap*2);
		
		translate([Motor_X,0,Gear_w/2-MotorSetback+MM_t])
		for (j=[0:3]) rotate([0,0,90*j]) translate([Motor_BC_d/2,0,0]) Bolt8ButtonHeadHole(); //Bolt8ClearHole();
			
		// hex key access
		translate([Motor_X,0,Gear_w/2-3]) rotate([0,90,45]) cylinder(d=3,h=30);
		
		translate([0,0,-Overlap]) cylinder(d=RingC_BC_d-8-4,h=Gear_w/2+Overlap*2);
		
		// Bolts
		rotate([0,0,Motor_a])
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([RingC_BC_d/2,0,0])
			rotate([180,0,0]) Bolt4HeadHole();
	} // difference
	
} // RoundRingC

//RoundRingC();
//translate([0,0,10]) PlanetCarrierDrivePulley(nTeeth=32);

module RingC(){
	// Inner planet carrier support bearing
	
	
	//*
	RingB_OD=RingBTeeth*GearBPitch/180+GearBPitch/60;
	MB_X=90;
	MB_Y=MB_X;
	MB_Rim_t=2;
	nSpokes=8;
	Spoke_w=2;
	//echo(MB_X=MB_X);
	
	// Planet carrier bearing mount
	translate([0,0,Gear_w/2-(Bearing_w+2)])
	difference(){	

		cylinder(d=Bearing_OD+6,h=Bearing_w+2);
			
		//Bearing_OD=1.125*25.4;
		//Bearing_ID=0.500*25.4;
		//Bearing_w=0.3125*25.4;

		translate([0,0,-Overlap]) cylinder(d=Bearing_OD-1,h=3);
		translate([0,0,2]) cylinder(d=Bearing_OD,h=Bearing_w+1);
		
	} // difference
	
	translate([0,0,-Gear_w/2])
	difference(){
		union(){
			difference(){
				Rad=4;
				RoundRect(X=MB_X,Y=MB_Y,Z=Gear_w,R=Rad);
				translate([0,0,-Overlap]) RoundRect(X=MB_X-MB_Rim_t*2,Y=MB_Y-MB_Rim_t*2,Z=Gear_w+Overlap*2,R=Rad-MB_Rim_t);
			} // difference
			
			//difference(){
			//	translate([-MB_X/2,-MB_Y/2,0]) cube([MB_X,MB_Y,Gear_w]);
			//	translate([-MB_X/2+MB_Rim_t,-MB_Y/2+MB_Rim_t,-Overlap]) cube([MB_X-MB_Rim_t*2,MB_Y-MB_Rim_t*2,Gear_w+Overlap*2]);
			//} // difference
			
			// Bolt bosses
			for (j=[0:3]) rotate([0,0,90*j]){
				hull(){
					translate([-MB_X/2+10-Bolt4Inset*1.5,-MB_Y/2,0]) cube([Bolt4Inset*3,Overlap,Gear_w]);
					translate([-MB_X/2+10-Bolt4Inset,-MB_Y/2+5,0]) cube([Bolt4Inset*2,Overlap,Gear_w]);
				} // hull
				hull(){
					translate([MB_X/2-10-Bolt4Inset*1.5,-MB_Y/2,0]) cube([Bolt4Inset*3,Overlap,Gear_w]);
					translate([MB_X/2-10-Bolt4Inset,-MB_Y/2+5,0]) cube([Bolt4Inset*2,Overlap,Gear_w]);
				} // hull
			} // for
			
			// Spokes
			difference(){
				for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*(j+0.5)]) hull(){
					translate([Bearing_OD/2+2,0,Gear_w-(Bearing_w+2)]) cylinder(d=Spoke_w,h=Bearing_w+2);
					translate([MB_X*0.7,0,0]) cylinder(d=Spoke_w,h=Gear_w);
				} // hull
				
				difference(){
					translate([-MB_X/2-30,-MB_Y/2-30,-Overlap]) cube([MB_X+60,MB_Y+60,Gear_w+Overlap*2]);
					translate([-MB_X/2+1,-MB_Y/2+1,-Overlap*2]) cube([MB_X-2,MB_Y-2,Gear_w+Overlap*4]);
				} // difference
			} // difference
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=Bearing_OD+1,h=Gear_w+Overlap*2);
		
		// Bolt holes
		for (j=[0:3]) rotate([0,0,90*j]) {
			
		translate([-MB_X/2+10,-MB_Y/2,Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([-MB_X/2+10,-MB_Y/2,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([MB_X/2-10,-MB_Y/2,Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		translate([MB_X/2-10,-MB_Y/2,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4Hole(depth=6);
		}
		
	} // difference
	
	// motor mount
	Motor_X=69.8; // 69.3; works but belt is loose
	MotorShaftHole_d=16;
	MotorSetback=8;
	Motor_BC_d=22.5;
	MotorBig_d=37;
	MotorFace_d=32;
	MM_t=6;
	
	difference(){
		hull(){
			translate([Motor_X,0,Gear_w/2-MotorSetback]) cylinder(d=MotorBig_d,h=MotorSetback);
			translate([MB_X/2-Overlap,-(MotorBig_d+2)/2,-Gear_w/2]) cube([Overlap,MotorBig_d+2,Gear_w]);
		} // hull
		
		translate([Motor_X,0,-Gear_w/2-Overlap]) cylinder(d=MotorFace_d,h=Gear_w-MotorSetback);
		translate([Motor_X,0,-Gear_w/2-Overlap]) cylinder(d=MotorShaftHole_d,h=Gear_w+Overlap*2);
		
		translate([Motor_X,0,Gear_w/2-MotorSetback+MM_t])
		for (j=[0:3]) rotate([0,0,90*j]) translate([Motor_BC_d/2,0,0]) Bolt8ButtonHeadHole(); //Bolt8ClearHole();
			
		// hex key access
		translate([Motor_X,0,Gear_w/2-3]) rotate([0,90,45]) cylinder(d=3,h=30);
	} // difference
	
} // RingC


//RingC();

module TestFixture(){
	MB_X=90;
	MB_Y=MB_X;
	MB2_X=95;
	MB2_Y=MB2_X;
	MB_Rim_t=2.5-IDXtra;
	C_L=25;
	
	module Corners(){
		
		difference(){
			difference(){
				translate([-MB2_X/2,-MB2_Y/2,0]) cube([MB2_X,MB2_Y,Gear_w]);
				translate([-MB2_X/2+MB_Rim_t,-MB2_Y/2+MB_Rim_t,-Overlap]) cube([MB2_X-MB_Rim_t*2,MB2_Y-MB_Rim_t*2,Gear_w+Overlap*2]);
				
				for (j=[0:3]) rotate([0,0,90*j]) translate([-MB2_X/2+C_L,-MB2_Y/2-Overlap,-Overlap])
					cube([MB2_X-C_L*2,10,Gear_w+Overlap*2]);
			} // difference
			
			// Bolt holes
		for (j=[0:3]) rotate([0,0,90*j]) {
			translate([-MB_X/2+10,-MB_Y/2-5,Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
			translate([-MB_X/2+10,-MB_Y/2-5,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
			translate([MB_X/2-10,-MB_Y/2-5,Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
			translate([MB_X/2-10,-MB_Y/2-5,Gear_w-Bolt4Inset]) rotate([90,0,0]) Bolt4ClearHole();
			}
	} // difference
	} // Corners
	
	translate([0,0,32]) Corners();
	translate([0,0,32+18+20]) Corners();
	
	for (j=[0:3]) rotate([0,0,90*j]){
		// Inner planet carrier Bearing holder to hull mount (Ring B)
		hull(){
			translate([-MB2_X/2,-MB2_Y/2,32+18+20]) 
				cube([MB_Rim_t,C_L,Overlap]);
				
			translate([-MB2_X/2,-MB2_Y/2,32+18-Overlap]) 
				cube([MB_Rim_t,C_L,Overlap]);
		}
		
		hull(){
			translate([-MB2_X/2,-MB2_Y/2,32+18+20]) 
				cube([C_L,MB_Rim_t,Overlap]);
			
			translate([-MB2_X/2,-MB2_Y/2,32+18-Overlap]) 
				cube([C_L,MB_Rim_t,Overlap]);
		}
		
		hull(){
			translate([-MB2_X/2,-MB2_Y/2,32]) 
				cube([MB_Rim_t,C_L,Overlap]);
				
			rotate([0,0,45]) translate([-(RingABearingMountingRing_BC_d+15)/2+1,0,5]) cylinder(r=1,h=Overlap);
			
			intersection(){
				difference(){
					translate([0,0,20-Overlap]) cylinder(d=RingABearingMountingRing_BC_d+15,h=Overlap);
					translate([0,0,20-Overlap*2]) cylinder(d=RingABearingMountingRing_BC_d+10,h=Overlap*5);
				} // difference
				translate([-MB2_X/2-5,-MB2_Y/2-5,20-Overlap]) cube([16,28,1]);
			} // intersection
			
		} // hull
		
		hull(){
			translate([-MB2_X/2,-MB2_Y/2,32]) 
				cube([C_L,MB_Rim_t,Overlap]);
			
			rotate([0,0,45]) translate([-(RingABearingMountingRing_BC_d+15)/2+1,0,5]) cylinder(r=1,h=Overlap);
			
			intersection(){
				difference(){
					translate([0,0,20-Overlap]) cylinder(d=RingABearingMountingRing_BC_d+15,h=Overlap);
					translate([0,0,20-Overlap*2]) cylinder(d=RingABearingMountingRing_BC_d+10,h=Overlap*5);
				} // difference
				translate([-MB2_X/2-5,-MB2_Y/2-5,20-Overlap]) cube([28,16,1]);
			} // intersection
			
			
			//translate([-MB2_X/2,-MB2_Y/2,19]) 
			//	cube([C_L,MB_Rim_t,Overlap]);
		}

	}
	
	RingABearingMountingRing_t=3;
	Skirt_h=20;
	RingABearingMountingRing_BC_d=100;
	RingABearingMountingRing_d=RingABearingMountingRing_BC_d+Bolt4Inset*2;
	nBolts=8;
	
	difference(){
		union(){
			cylinder(d=RingABearingMountingRing_BC_d+15,h=Skirt_h);
			
	
		} // union
		
		translate([0,0,3]) cylinder(d=RingABearingMountingRing_BC_d+10,h=Skirt_h);
		
		translate([0,0,-Overlap]) cylinder(d=RingA_Bearing_OD+IDXtra*2,h=RingABearingMountingRing_t+Overlap*2);
		
		// bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j])
			translate([RingABearingMountingRing_BC_d/2,0,RingABearingMountingRing_t+3])
				Bolt4ClearHole();
	} // difference
} // TestFixture

//TestFixture();
//translate([0,0,6]) rotate([180,0,0]) RingABearing();

echo("Ring A PD = ",RingA_pd);
echo("PC BC Dia = ",PC_BC_d);
echo("Calc'd Ring B PD = ",Ring_B_cpd/2);
echo("Ring B PD error =",Ring_B_cpd-RingBTeeth*GearBPitch/180);

/*
// old code

module RingA(){
	ring_gear(number_of_teeth=RingATeeth,
		circular_pitch=GearAPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.2,
		gear_thickness=Gear_w/2,
		rim_thickness=Gear_w/2,
		rim_width=2,
		backlash=Backlash,
		twist=twist/RingATeeth,
		involute_facets=0, // 1 = triangle, default is 5
		flat=false);
	
	mirror([0,0,1])
		ring_gear(number_of_teeth=RingATeeth,
			circular_pitch=GearAPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=Gear_w/2,
			rim_thickness=Gear_w/2,
			rim_width=2,
			backlash=Backlash,
			twist=twist/RingATeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
	
	RingA_Teeth_ID=RingATeeth*GearAPitch/180-GearAPitch/90;
	RingA_Major_OD=80;
	
	nSpokes=7;
	
	translate([0,0,-Gear_w/2])
	difference(){
		cylinder(d=RingA_Major_OD,h=Gear_w);
		
		translate([0,0,-Overlap]) cylinder(d=RingA_OD,h=Gear_w+Overlap*2);
	} // difference
	
	translate([0,0,-Gear_w/2-6]) rotate([180,0,0])
	OnePieceInnerRace(BallCircle_d=RingA_Bearing_BallCircle,	Race_ID=RingA_Bearing_ID,	
		Ball_d=Ball_d, Race_w=RingA_Bearing_Race_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=$preview? 60:720);

	// Skirt connecting bearing to gear
	translate([0,0,-Gear_w/2-6-Overlap])
	difference(){
		cylinder(d1=RingA_Bearing_BallCircle-Ball_d*0.7,d2=RingA_Major_OD,h=6+Overlap*2);
		
		translate([0,0,-Overlap]) cylinder(d1=RingA_Bearing_BallCircle-Ball_d*0.7-5,d2=RingA_Teeth_ID,h=6+Overlap*4);
	} // difference
	
	// Planet carrier bearing mount
	translate([0,0,-Gear_w/2-6-RingA_Bearing_Race_w])
	difference(){
		union(){
			 cylinder(d=Bearing_OD+6,h=Bearing_w+2);
			
			for (j=[0:nSpokes-1]) rotate([0,0,360/nSpokes*j]) hull(){
				translate([Bearing_OD/2+3,0,0]) cylinder(d=2,h=Bearing_w+2);
				translate([RingA_Bearing_ID/2+1,0,0]) cylinder(d=2,h=Bearing_w+2);
			} // hull
		} // union
		//Bearing_OD=1.125*25.4;
		//Bearing_ID=0.500*25.4;
		//Bearing_w=0.3125*25.4;

		translate([0,0,-Overlap]) cylinder(d=Bearing_OD-1,h=3);
		translate([0,0,2]) cylinder(d=Bearing_OD,h=Bearing_w+1);
	} // difference
	
	// Lever mount
	
	LeverMount_d=Gear_w; //Tube_OD+8;
	translate([0,0,0])
	difference(){
		hull(){
			translate([-LeverMount_L/2,LeverOffset,0]) rotate([0,90,0]) cylinder(d=LeverMount_d,h=LeverMount_L);
			translate([-LeverMount_L/2,LeverOffset-20,0]) rotate([0,90,0]) cylinder(d=LeverMount_d,h=LeverMount_L);
		} // hull
		
		MidCut_l=24;
		
		// cut out middle
		hull(){
			translate([-LeverMount_L/2+MidCut_l/2,LeverOffset,0]) rotate([0,90,0]) cylinder(d=LeverMount_d+Overlap*2,h=LeverMount_L-MidCut_l);
			translate([-LeverMount_L/2+MidCut_l/2,LeverOffset-20,0]) rotate([0,90,0]) cylinder(d=LeverMount_d+Overlap*2,h=LeverMount_L-MidCut_l);
		} // hull
		
		translate([0,0,-LeverMount_d/2-Overlap]) cylinder(d=RingA_OD,h=LeverMount_d+Overlap*2);
		translate([-LeverMount_L/2-Overlap,LeverOffset,0]) rotate([0,90,0]) cylinder(d=Tube_OD,h=LeverMount_L+Overlap*2);
	} // difference
	
	// output lever
	if ($preview==true){
		translate([LeverMount_L/2,LeverOffset,0]) rotate([0,-90,0]) color("Red") cylinder(d=Tube_OD,h=160);
		translate([LeverMount_L/2,LeverOffset,0]) rotate([0,-90,0]) translate([0,0,160]) rotate([180,0,0]) RodEnd();
	}
} // RingA


module RodEnd(){
	Tube_d=12.7;
	WristPin_d=6.35;
	
	TubeEnd(TubeOD=Tube_d, Wall_t=0.89, Hole_d=3, Stop_l=TubeStop_l, GlueAllowance=0.40);
	
	difference(){
		hull(){
			translate([-Tube_d/2,0,-Tube_d/2-1]) rotate([0,90,0]) cylinder(d=Tube_d,h=Tube_d);
			translate([0,0,-Overlap]) cylinder(d=Tube_d,h=Overlap);
		} // hull
		
		translate([-Tube_d/2-Overlap,0,-Tube_d/2-1]) rotate([0,90,0]) cylinder(d=WristPin_d,h=Tube_d+Overlap*2);
	} // difference
} // RodEnd

//RodEnd();



/**/





