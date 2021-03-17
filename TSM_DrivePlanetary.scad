// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// Filename: TSM_DrivePlanetary.scad
// By: David M. Flynn
// Created: 10/1/2019
// Revision: 1.0.4 3/16/2021
// Units: mm
// *************************************************
//  ***** History ******
// 1.0.4 3/16/2021 Drive sprocket decoration.
// 1.0.3 3/14/2021 Worked on OuterSprocketDecor
// 1.0.2 2/14/2021 Adjusted Idle spocket.
// 1.0.1 2/12/2021 Moved spockets inboard.
// 1.0.0 6/7/2020 Added Idle version
// 0.9.9 11/16/2019 Encoder mount.
// 0.9.8 11/8/2019 Added RingB spacer and encoder mount. Added 5mm and Enc to RingB.
// 0.9.7 10/9/2019 Updated mounting plate.
// 0.9.6 10/7/2019 Added InnerSprocketMountSpacer.
// 0.9.5 10/6/2019 Moved RingB +1mm, bolts to inside.
// 0.9.4 10/5/2019 Ready for printing.
// 0.9.3 10/4/2019 Longer encoder ring.
// 0.9.2 10/3/2019 Worked on ring A.
// 0.9.1 10/2/2019 Added planet carriers and encoder.
// 0.9.0 10/1/2019 First code.
// *************************************************
//  ***** for STL output *****
// rotate([180,0,0]) Planet(); // print 5
//
// PlanetCarrier(FullCover=true); // outer
// rotate([180,0,0]) MotorSleeve();
// InnerPlanetCarrier();
// rotate([180,0,0]) EncoderDisc();
// EncoderDisc(HasEnc=false); // drive ring only
//
// RingBSpacer(); // add to RingB
// RingB(); // Stator, FC1
// RingB(HasGear=false);
// EncoderMount();
// rotate([180,0,0]) RingA();
// rotate([180,0,0]) RingA(HasGear=false);
//
// RevOuterSprocket(ShowTeeth=false, IsIdleEnd=false);
// RevOuterSprocket(ShowTeeth=false, IsIdleEnd=true);
// InnerTrackSprocket();
// InnerSprocketMount(SpacerHeight=14-kTrackBackSpace);
// InnerSprocketMountSpacer(); // obsolete
//
// Decoration
// OuterSprocketDecor(IsIdleEnd=true);
//
// MountingPlate(); // for testing
// *************************************************
//  ***** for Viewing *****
// ShowPlanetCarrier();
// ShowPlanetCarrierExp();
// *************************************************

include<CommonStuffSAEmm.scad>
include<BearingLib.scad>
include<ring_gear.scad>
include<involute_gears.scad>
include<LynxTrackLib.scad>

$fn=$preview? 24:90;
Overlap=0.05;
IDXtra=0.2;
Bolt4Inset=4;

DrvMtr_OD=58.35; // straight part
DvMtr_S1_l=40.8;// Straight part
DrvMtr_l=53.5; // mounting surface length
DrvMtrBackPlate_d=66.5;

nPlanets=5;
GearAPitch=260;
GearBPitch=282.0338983050847;
Pressure_a=20;
PlanetATeeth=16; // 4.6875:1
PlanetBTeeth=16; // 65.625t/Rev
RingATeeth=80;
RingBTeeth=75;
Backlash=0.2;

RingA_pd=RingATeeth*GearAPitch/180;
PC_BC_d=RingA_pd-PlanetATeeth*GearAPitch/180;
Ring_B_cpd=PC_BC_d+PlanetBTeeth*GearBPitch/180;
//RingBTeeth=floor(Ring_B_cpd*180/GearBPitch);

// Planet rotations per motor rotations
P_Ratio=RingATeeth/PlanetATeeth;
// Planet B teeth per motor rotation
PBt=P_Ratio*PlanetBTeeth;
// Ring A rotations per motor rotation
Rf=1/(1-RingBTeeth/PBt);
echo("Ratio = ",Rf);

Bearing_OD=1.125*25.4;
Bearing_ID=0.500*25.4;
BEaring_w=0.3125*25.4;

Ball_d=5/16*25.4;
BearingPreload=-0.3;
MotorBolt_BC_d=60;
Mtr_End_OD=72;
Enc_h=12.7+1; // same as motor end Plus 1mm overlap with the planet carrier

// motor
//cylinder(d=DrvMtr_OD,h=2);
// track sproket
//translate([0,0,-3]) cylinder(d=118,h=2);
twist=200;
BSkirt_h=20+5+Enc_h+5.5+5-kTrackBackSpace;
// Ring Gear + PC + Enc + motor end
	BSkirt_OD=RingBTeeth*GearBPitch/180+5+5;
	nRingBSkirtBolts=8;
nTrkSproketBolts=10;
RingB_Bering_BallCircle=137.5;
RingB_Bering_ID=BSkirt_OD-2;
RingA_Bearing_OD=RingB_Bering_BallCircle+Ball_d+5;
RingB_Bearing_Race_w=10;
RingA_Gear_OD=RingATeeth*GearAPitch/180+6;

ToothSpacing=kTrackBackSpace*7; // 3 inch track tooth spacing
nTrackTeeth=20;

module ShowPlanetCarrier(){
	
	translate([0,0,-10]) rotate([0,0,180/RingBTeeth]){
		RingB();
		//translate([0,0,-10+BSkirt_h-7.75-5]) rotate([0,0,15]) EncoderMount();
		}
	
	translate([0,0,-31]) RingA();
	
	translate([0,0,5+Overlap*2]) EncoderDisc(HasEnc=false);
	//translate([0,0,Overlap]) InnerPlanetCarrier();
	//translate([0,0,-Sleeve_l]) rotate([0,0,180/nPlanets]) MotorSleeve();
	//translate([0,0,-Overlap]) mirror([0,0,1]) translate([0,0,1.625*25.4]) PlanetCarrier();
	
	//for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,-1.625*25.4+10]) rotate([0,0,180/PlanetBTeeth]) Planet();

	//Motor();
	
	//translate([0,0,-31-10-5]) rotate([180,0,0]) OuterTrackSprocket();
	
	translate([0,0,-4.4]) InnerSprocketMount(SpacerHeight=14-kTrackBackSpace);
	translate([0,0,-31+ToothSpacing-5-4.3]) InnerTrackSprocket();
	
	//translate([0,0,29.5]) rotate([0,0,180/RingBTeeth]) rotate([180,0,0])  MountingPlate();
	
} // ShowPlanetCarrier

  ShowPlanetCarrier();

module ShowPlanetCarrierExp(){
	
	translate([0,0,90]) rotate([0,0,180/RingBTeeth]) color("LightBlue") RingB();
	
	translate([0,0,-80]) color("Tan") RingA();
	
	translate([0,0,50]) color("Orange") EncoderDisc();
	translate([0,0,30]) color("Orange") InnerPlanetCarrier();
	translate([0,0,-Sleeve_l]) rotate([0,0,180/nPlanets]) color("Orange") MotorSleeve();
	translate([0,0,-15]) mirror([0,0,1]) translate([0,0,1.625*25.4]) color("Orange") PlanetCarrier();
	
	for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2-30,0,-1.625*25.4+10]) rotate([0,0,180/PlanetBTeeth])
		color("Green") Planet();

	translate([0,0,20]) color("Tan") InnerSprocketMount();
	translate([0,0,50]) color("Tan") InnerTrackSprocket(ShowTeeth=false);
	translate([0,0,-100]) rotate([180,0,0]) color("Tan") OuterTrackSprocket(ShowTeeth=false);
	//Motor();
} // ShowPlanetCarrierExp

 //ShowPlanetCarrierExp();


module Motor(){
if ($preview==true) translate([0,0,-DrvMtr_l+4+Enc_h]) color("Red"){
		translate([0,0,-3.7]) cylinder(d1=46.5,d2=48.5,h=3.7);
	
		difference(){
			union(){
				// body
				cylinder(d=DrvMtr_OD,h=DvMtr_S1_l);
				translate([0,0,DvMtr_S1_l]) cylinder(d1=60.85,d2=61.35,h=12.7);
			} // union
			
			translate([0,0,-Overlap]) cylinder(d=8,h=DvMtr_S1_l+12.7+Overlap*2);
		} // difference
		// motor end
		translate([0,0,DvMtr_S1_l]){
		
		for (j=[0:5]) rotate([0,0,60*j+10]) translate([MotorBolt_BC_d/2,0,0]) 
			cylinder(d=8,h=Enc_h+Overlap);
		}
		translate([0,0,DrvMtr_l])
			difference(){
				union(){
					cylinder(d=DrvMtrBackPlate_d,h=3);
					cylinder(d=42,h=5);
				} // union
				
				translate([0,0,4.2]) cylinder(d=35,h=2);
				translate([0,0,4]) cube([12,12,9],center=true);
			} // difference
	
	}}
	
module PlanetCarrier(FullCover=true){
	difference(){
		union(){
			if (FullCover==true){
				cylinder(d=RingATeeth*GearAPitch/180+4,h=1.2);
			}
			// Motor sleve/spacer bolt bosses
			for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) hull(){
				translate([-DrvMtr_OD/2-4,0,0]) cylinder(d=8,h=6);
				translate([-DrvMtr_OD/2,0,0]) cylinder(d=9,h=6);
			}
				
			
			for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) hull(){
				translate([-PC_BC_d/2,0,0]) cylinder(d=12,h=3);
				cylinder(d=30,h=6);
				
			} // hull
			
			cylinder(d=DrvMtr_OD+6,h=4);
			translate([0,0,4-Overlap]) cylinder(d1=DrvMtr_OD+6,d2=DrvMtr_OD+4,h=2+Overlap);
		} // union
		
		// center art
		translate([0,0,1]) cylinder(d1=DrvMtr_OD-2,d2=DrvMtr_OD+2,h=5+Overlap);
		
		//translate([0,0,-Overlap]) cylinder(d=DrvMtr_OD+IDXtra,h=6+Overlap*2);
		
		// Planet bolts
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,4]) Bolt4ButtonHeadHole();
			
		// Motor sleve/spacer bolts
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) translate([-DrvMtr_OD/2-4,0,6])
			Bolt4HeadHole();
	} // difference
	
	
} // PlanetCarrier

//PlanetCarrier();
//mirror([0,0,1]) translate([0,0,1.625*25.4]) PlanetCarrier();

module InnerPlanetCarrier(){
	difference(){
		union(){
			// Motor sleve/spacer bolt bosses
			for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) hull(){
				translate([-DrvMtr_OD/2-4-5,0,0]) cylinder(d=8,h=5);
				translate([-DrvMtr_OD/2,0,0]) cylinder(d=9,h=5);
			}
			
			for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) hull(){
				translate([-PC_BC_d/2,0,0]) cylinder(d=12,h=3);
				cylinder(d=30,h=5);
				
				
			} // hull
			
			cylinder(d=DrvMtr_OD+6,h=5);
			translate([0,0,5-Overlap]) cylinder(d=DrvMtr_OD+4,h=1);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=DrvMtr_OD+IDXtra,h=6+Overlap*2);
		
		// Planet bolts
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,4]) Bolt4ButtonHeadHole();
			
		// Motor sleve/spacer bolts
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) translate([-DrvMtr_OD/2-4-5,0,6])
			Bolt4ClearHole();
	} // difference
	
} // InnerPlanetCarrier

//InnerPlanetCarrier();

Enc_d=100;
nEncoderPulses=floor((Enc_d-8)*PI/4);
//echo(nEncoderPulses=nEncoderPulses);

module EncoderDisc(HasEnc=true){ // aka Motor spline, the motor pushes on this part.
	Boss_h=6;
	
	difference(){
		union(){
			// Bolt bosses
			for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) hull(){
				translate([-DrvMtr_OD/2,0,0]) cylinder(d=12,h=Enc_h);
				translate([-DrvMtr_OD/2-4-5,0,0]) cylinder(d=8,h=Enc_h);
			}
				
			cylinder(d=Mtr_End_OD,h=Enc_h,$fn=$preview? 60:360);
			
			 // encoder disc
			if (HasEnc==true){
			translate([0,0,Enc_h-2]) cylinder(d=Enc_d-14,h=2,$fn=$preview? 60:360);
			translate([0,0,Enc_h-1]) cylinder(d=Enc_d,h=1,$fn=$preview? 60:360);}
		} // union
	
		// Motor sleve/spacer bolts
		for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*(j+0.5)]) translate([-DrvMtr_OD/2-4-5,0,6])
			Bolt4HeadHole();
		
		translate([0,0,-Overlap]) cylinder(d=DrvMtr_OD+4+IDXtra,h=Enc_h+Overlap*2);
		
		// motor end
		cylinder(d1=60.85,d2=61.35,h=12.7);
		for (j=[0:5]) rotate([0,0,60*j+10]) translate([MotorBolt_BC_d/2,0,-Overlap]) 
			hull(){
				cylinder(d=8,h=Enc_h+Overlap+2);
				translate([2.5,0,0]) scale([0.4,1,1]) cylinder(d=8,h=Enc_h+Overlap+2);
			} // hull
		
		// Encoder holes
		if (HasEnc==true)
		for (j=[0:nEncoderPulses-1]) rotate([0,0,360/nEncoderPulses*j]) translate([-Enc_d/2+2,-1,Enc_h-1-Overlap])
			cube([4,2,2]);
	} // difference
} // EncoderDisc

// translate([0,0,5+Overlap]) EncoderDisc(HasEnc=false);

module EncoderMount(){
	
	module Opto(){
		O_w=6.6;
		
		hull(){
			cylinder(d=O_w,h=12);
			translate([-O_w/2,15.4,0]) cube([O_w,Overlap,12]);
		} // hull
		translate([-O_w/2,3.5,-8+Overlap]) cube([O_w,12,8]);
		Bolt4Hole();
	} // Opto
	
	RingBlock_h=18;
	
	translate([0,0,-4-9.6])
	difference(){
		cylinder(d=BSkirt_OD,h=RingBlock_h);
		
		// trim outside
		difference(){
			translate([0,0,-Overlap]) cylinder(d=BSkirt_OD+10,h=RingBlock_h+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=BSkirt_OD-5,h=RingBlock_h+Overlap*4);
		} // differencecylinder(d=BSkirt_OD,h=BSkirt_h);
		
		
		translate([0,0,-Overlap]){
			cylinder(d=Enc_d+4,h=RingBlock_h+Overlap*2);
			rotate([0,0,-8]) cube([100,100,RingBlock_h+Overlap*2]);
			rotate([0,0,-90-7]) cube([100,100,RingBlock_h+Overlap*2]);
			rotate([0,0,-180-6]) cube([100,100,RingBlock_h+Overlap*2]);
			rotate([0,0,-270+20]) cube([100,100,RingBlock_h+Overlap*2]);
		}
		
		translate([0,Enc_d/2+3.5,4]) rotate([90,0,0]) Opto();
		translate([0,0,4]) rotate([0,0,360/nEncoderPulses*2.5]) translate([0,Enc_d/2+3.5,0]) rotate([90,0,0]) Opto();

	} // difference
		
	// mounting ears
	
	difference(){
		translate([0,0,-6])
		union(){
			hull(){
				rotate([0,0,360/nEncoderPulses*2.5+10])
					translate([0,(BSkirt_OD-5)/2-6,0]) 
						rotate([-90,0,0]) cylinder(d=8,h=8);
				rotate([0,0,360/nEncoderPulses*2.5+7])
					translate([0,(BSkirt_OD-5)/2-6,-7.5])
					cube([Overlap,6,15]);
				} // hull
				
			hull(){
				rotate([0,0,-10])
					translate([0,(BSkirt_OD-5)/2-6,0]) 
						rotate([-90,0,0]) cylinder(d=8,h=8);
				rotate([0,0,-7])
					translate([0,(BSkirt_OD-5)/2-6,-7.5])
					cube([Overlap,6,15]);
				} // hull

		} // union
			
		EncoderMountHoles() Bolt4Hole();
			
	// trim outside
		translate([0,0,-8])
		difference(){
			translate([0,0,-6-Overlap]) cylinder(d=BSkirt_OD+10,h=RingBlock_h+Overlap*2);
			translate([0,0,-6-Overlap*2]) cylinder(d=BSkirt_OD-5,h=RingBlock_h+Overlap*4);
		} // differencecylinder(d=BSkirt_OD,h=BSkirt_h);
		
	} // difference
} // EncoderMount

//EncoderMount();

module EncoderMountHoles(){
	translate([0,0,-6]){
		rotate([0,0,360/nEncoderPulses*2.5+10])
			translate([0,(BSkirt_OD-5)/2-7,0]) rotate([90,0,0]) children();
		rotate([0,0,-10])
			translate([0,(BSkirt_OD-5)/2-7,0]) rotate([90,0,0]) children();
	}
} // EncoderMountHoles

EncoderMountHoles();

Sleeve_l=1.625*25.4;

module MotorSleeve(){
	Boss_h=8;
	
	difference(){
		union(){
			cylinder(d=DrvMtr_OD+5,h=Sleeve_l);
			
			for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) hull(){
				translate([-DrvMtr_OD/2,0,0]) cylinder(d=9,h=Boss_h+1);
				translate([-DrvMtr_OD/2,0,Boss_h+1]) sphere(d=9);
				translate([-DrvMtr_OD/2-4,0,0]) cylinder(d=8,h=Boss_h);
				translate([-DrvMtr_OD/2-4,0,Boss_h]) sphere(d=8);
			}
			
			mirror([0,0,1]) translate([0,0,-Sleeve_l])
			for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) hull(){
				translate([-DrvMtr_OD/2,0,0]) cylinder(d=9,h=Boss_h+1);
				translate([-DrvMtr_OD/2,0,Boss_h+1]) sphere(d=9);
				translate([-DrvMtr_OD/2-4-5,0,0]) cylinder(d=8,h=Boss_h);
				translate([-DrvMtr_OD/2-4-5,0,Boss_h]) sphere(d=8);
			}
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=DrvMtr_OD+IDXtra*2,h=Sleeve_l+Overlap*2);
		
		// Motor sleve/spacer bolts
		for (j=[0:nPlanets*2-1]) rotate([0,0,180/nPlanets*j]) translate([-DrvMtr_OD/2-4,0,0])
			rotate([180,0,0]) Bolt4Hole(depth=10);
		for (j=[0:nPlanets*2-1]) rotate([0,0,180/nPlanets*j]) translate([-DrvMtr_OD/2-4-5,0,Sleeve_l])
			Bolt4Hole(depth=10);
		
		// vent holes
		for (j=[0:nPlanets*2-1]) rotate([0,0,180/nPlanets*(j+0.5)]) translate([DrvMtr_OD/2-4,0,0]) hull(){
			translate([0,0,Sleeve_l/6]) rotate([0,90,0]) cylinder(d=4,h=10);
			translate([0,0,Sleeve_l/2]) rotate([0,90,0]) cylinder(d=12,h=10);
			translate([0,0,Sleeve_l-Sleeve_l/6]) rotate([0,90,0]) cylinder(d=4,h=10);
		}
	} // difference
	
	
} // MotorSleeve

//translate([0,0,-Sleeve_l]) rotate([0,0,180/nPlanets]) MotorSleeve();



InnerTrackSpocketBolt_BC=RingA_Bearing_OD/2+1.5;


module RingA(HasGear=true, BodyOnly=false){
	// 3/16/2021 Added ball remoal hole, add 0.5mm clearance for RingB
	Bearing_a=10;
	
	if (HasGear==true){

	ring_gear(number_of_teeth=RingATeeth,
		circular_pitch=GearAPitch, diametral_pitch=false,
		pressure_angle=Pressure_a,
		clearance = 0.2,
		gear_thickness=10,
		rim_thickness=10,
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
			gear_thickness=10,
			rim_thickness=10,
			rim_width=2,
			backlash=Backlash,
			twist=twist/RingATeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
		} else {
			
			difference(){
				translate([0,0,-10]) cylinder(d=RingA_Gear_OD+1,h=20);
				translate([0,0,-10-Overlap]) cylinder(d=RingA_Gear_OD-3,h=20+Overlap*2);
			}}
	Boss_h=10;
	
	translate([0,0,-10])
	difference(){
		union(){
			// connect bearing to base
			hull(){
				cylinder(d=RingA_Gear_OD+2,h=Overlap,$fn=$preview? 60:360);
				translate([0,0,21]) cylinder(d=RingA_Bearing_OD,h=Overlap,$fn=$preview? 90:360);
			} // hull
			
		for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*(j+0.5)]) hull(){
			translate([InnerTrackSpocketBolt_BC,0,21+RingB_Bearing_Race_w-Boss_h]) cylinder(d=8,h=Boss_h);
			translate([InnerTrackSpocketBolt_BC,0,21+RingB_Bearing_Race_w-Boss_h]) sphere(d=8);
			translate([RingA_Bearing_OD/2,0,21+RingB_Bearing_Race_w-Boss_h]) cylinder(d=9,h=Boss_h);
			translate([RingA_Bearing_OD/2-10,0,21+RingB_Bearing_Race_w-Boss_h-9]) sphere(d=9);
		} // hull
			
		for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*j]) hull(){
			translate([-RingA_Gear_OD/2,0,0]) cylinder(d=9,h=Boss_h+1);
				translate([-RingA_Gear_OD/2,0,Boss_h+1]) sphere(d=9);
				translate([-RingA_Gear_OD/2-4,0,0]) cylinder(d=8,h=Boss_h);
				translate([-RingA_Gear_OD/2-4,0,Boss_h]) sphere(d=8);
		} // hull
	} // union
	
	if (BodyOnly!=true)
		translate([0,0,21-Overlap]) cylinder(d=RingA_Bearing_OD-1,h=RingB_Bearing_Race_w+Overlap*2,$fn=$preview? 90:360);
	
	if (BodyOnly!=true)
	for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*(j+0.5)])
			translate([InnerTrackSpocketBolt_BC,0,21+RingB_Bearing_Race_w]) Bolt4Hole();
	
		// connect bearing to base
			hull(){
				translate([0,0,19.5]) cylinder(d=RingA_Gear_OD, h=Overlap,$fn=$preview? 90:360);
				translate([0,0,20.5]) cylinder(d=RingA_Bearing_OD-8, h=1+Overlap*2,$fn=$preview? 90:360);
			} // hull
			
		if (BodyOnly!=true)
			translate([0,0,-Overlap]) cylinder(d=RingA_Gear_OD,h=20+Overlap*2,$fn=$preview? 90:360);
			
		// center hole
		if (BodyOnly!=true)
			translate([0,0,-Overlap]) cylinder(d=RingA_Gear_OD-1,h=20,$fn=$preview? 90:360);
		
		if (BodyOnly!=true)
		for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*j]) translate([-RingA_Gear_OD/2-4,0,0])
			rotate([180,0,0]) Bolt4Hole(depth=Boss_h+1);
		
		// Ball Removal Hole
		rotate([0,0,Bearing_a]) translate([0,RingB_Bering_BallCircle/2,0]) cylinder(d=3.5, h=30);
	} // difference
	
	if (BodyOnly!=true)
	translate([0,0,11]) rotate([0,0,Bearing_a])
		OnePieceOuterRace(BallCircle_d=RingB_Bering_BallCircle, Race_OD=RingA_Bearing_OD, Ball_d=Ball_d, 
			Race_w=RingB_Bearing_Race_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=$preview? 90:720);
} // RingA

 //RingA(HasGear=true);
// RingA(HasGear=false, BodyOnly=false);
// RingA(HasGear=false, BodyOnly=true);

module OuterSprocketDecor(IsIdleEnd=true){
	InnerDia=IsIdleEnd? RingA_Gear_OD-3:RingATeeth*GearAPitch/180-9;
	OuterRad=TrackSurficeRad(nTeeth=nTrackTeeth)-0.5;
	
	difference(){
		union(){
			cylinder(r=OuterRad,h=2,$fn=nTrackTeeth);
			
			// Bolt bosses
			for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*j]) translate([-RingA_Gear_OD/2-4,0,0])
				cylinder(d1=11,d2=8,h=4);
			
			// Decorations
			//*
			for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*j])
			difference(){
				union(){
					translate([0,RingA_Gear_OD/2+12,3]) rotate([0,90,-8]) cylinder(d=10,h=15);
					translate([0,RingA_Gear_OD/2+12,3]) rotate([0,90,-8]) translate([0,0,-1.5]) cylinder(d=3,h=18);
					
					// Pipes
					hull(){
						translate([0,RingA_Gear_OD/2+12,3]) rotate([0,90,-8]) translate([0,0,-7.5]) cylinder(d=2,h=10);
						translate([0,RingA_Gear_OD/2+12,2]) rotate([0,90,-8]) translate([0,0,-7.5]) cylinder(d=2,h=10);
					} // hull
					
					hull(){
						translate([0,RingA_Gear_OD/2+12,2.5]) rotate([0,90,-98]) translate([0,6,3]) cylinder(d=1.2,h=5);
						translate([0,RingA_Gear_OD/2+12,2]) rotate([0,90,-98]) translate([0,6,3]) cylinder(d=1.2,h=5);
					} // hull
					
					hull(){
						translate([0,RingA_Gear_OD/2+4,2.5]) rotate([0,90,-8]) translate([0,0,-10]) cylinder(d=1.2,h=27);
						translate([0,RingA_Gear_OD/2+4,2]) rotate([0,90,-8]) translate([0,0,-10]) cylinder(d=1.2,h=27);
					} // hull
					
					translate([-10,RingA_Gear_OD/2+10,1]) cylinder(d1=12,d2=10, h=5);
					
					if(IsIdleEnd==false){
						translate([-10,RingA_Gear_OD/2-1,1]) cylinder(d1=10,d2=8, h=4);
						
						// Pipes
						hull(){
							translate([-5,RingA_Gear_OD/2+7.75,2.5]) rotate([0,90,-98]) translate([0,6,3]) cylinder(d=1.2,h=6.5);
							translate([-5,RingA_Gear_OD/2+7.75,2]) rotate([0,90,-98]) translate([0,6,3]) cylinder(d=1.2,h=6.5);
						} // hull
							
						hull(){
							translate([0,RingA_Gear_OD/2-2.5,2.5]) rotate([0,90,-8]) translate([0,0,-10]) cylinder(d=1.2,h=10.25);
							translate([0,RingA_Gear_OD/2-2.5,2]) rotate([0,90,-8]) translate([0,0,-10]) cylinder(d=1.2,h=10.25);
						} // hull
						
					} // if drive end
				} // union
				
				translate([-10,RingA_Gear_OD/2+10,2]) cylinder(d1=2,d2=9, h=5);
				
				if(IsIdleEnd==false){
						translate([-10,RingA_Gear_OD/2-1,2]) cylinder(d1=2,d2=7, h=4);
					} // if drive end
			} // difference
			/**/
			
			// inner ridge
			cylinder(d1=InnerDia+7,d2=InnerDia+4,h=5, $fn=$preview? 90:360);
			
			// outer ridge
			difference(){
				translate([0,0,2-Overlap]) cylinder(r1=OuterRad,r2=OuterRad-2,h=3,$fn=nTrackTeeth);
				translate([0,0,2-Overlap*2]) cylinder(r1=OuterRad-5,r2=OuterRad-3,h=3+Overlap*4,$fn=nTrackTeeth);
			}// difference
		} // union
		
		// Bolt holes
		for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*j]) translate([-RingA_Gear_OD/2-4,0,4.5])
			Bolt4HeadHole();

		// center hole 
		translate([0,0,-Overlap]) cylinder(d=InnerDia,h=2,$fn=$preview? 90:360);
		translate([0,0,2-Overlap]) cylinder(d1=InnerDia,d2=InnerDia+2,h=3+Overlap*2,$fn=$preview? 90:360);
		
		// bottom
		translate([0,0,-10]) cylinder(r=TrackSurficeRad(nTeeth=nTrackTeeth),h=10,$fn=nTrackTeeth);
	} // difference
	
} // OuterSprocketDecor

//OuterSprocketDecor(IsIdleEnd=true);
//OuterSprocketDecor(IsIdleEnd=false);

module RevOuterSprocket(ShowTeeth=$preview, IsIdleEnd=false){
	Sprocket_h=6.5;
	FrontXtra=3.1;
	DustShield_T=3;
	
	// Track teeth
	difference(){
		rotate([-90,0,0])
			ToothHoldingDisk(nTeeth=nTrackTeeth, Thickness=Sprocket_h, FrontXtra=FrontXtra, ShowTeeth=ShowTeeth)
				Bolt4Hole();
		
		// center hole 
		if (IsIdleEnd==true){
			translate([0,0,-Sprocket_h-Overlap]) cylinder(d=RingA_Gear_OD-3,h=Sprocket_h+FrontXtra+Overlap*2,$fn=$preview? 90:360);
		} else {
			translate([0,0,-Sprocket_h-Overlap]) cylinder(d=RingATeeth*GearAPitch/180+6,h=Sprocket_h+FrontXtra+Overlap*2,$fn=$preview? 90:360);
		}
		
		for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*j]) translate([-RingA_Gear_OD/2-4,0,-Sprocket_h])
			rotate([180,0,0]) Bolt4ClearHole(depth=FrontXtra+Sprocket_h); //Bolt4ButtonHeadHole(depth=FrontXtra+Sprocket_h);
		
		// -Sprocket_h+10.10 = bottom surface
		translate([0,0,-Sprocket_h+10.10+3]) scale(1.01) RingA(HasGear=false, BodyOnly=true);
	} // difference
	
	// Dist shield
	if (IsIdleEnd==false)
	difference(){
		translate([0,0,-Sprocket_h]) cylinder(d=RingATeeth*GearAPitch/180+7,h=DustShield_T,$fn=$preview? 90:360);
		
		// Gear teeth clearance
		translate([0,0,-Sprocket_h+2]) cylinder(d=RingATeeth*GearAPitch/180+4,h=DustShield_T+Overlap*2,$fn=$preview? 90:360);
		
		// Thru hole
		translate([0,0,-Sprocket_h-Overlap]) cylinder(d=RingATeeth*GearAPitch/180-9,h=DustShield_T+Overlap*2,$fn=$preview? 90:360);
	} // difference
	
} // RevOuterSprocket
	
//translate([0,0,-7]) RevOuterSprocket(ShowTeeth=false, IsIdleEnd=false);
//translate([0,0,-7]) rotate([180,0,0]) RevOuterSprocket(ShowTeeth=false, IsIdleEnd=true);

module OuterTrackSprocket(ShowTeeth=$preview){
	Sprocket_h=5.0;
	FrontXtra=4;
	
	// Track teeth
	difference(){
		rotate([-90,0,0])
			ToothHoldingDisk(nTeeth=nTrackTeeth, Thickness=Sprocket_h, FrontXtra=FrontXtra, ShowTeeth=ShowTeeth)
				Bolt4Hole();
		
		translate([0,0,-Sprocket_h-Overlap]) cylinder(d=RingATeeth*GearAPitch/180+6,h=8,$fn=$preview? 90:360);
		
		for (j=[0:nTrkSproketBolts-1]) rotate([0,0,360/nTrkSproketBolts*j]) translate([-RingA_Gear_OD/2-4,0,0])
			Bolt4ClearHole();
	} // difference
	
} // OuterTrackSprocket
	
//translate([0,0,-10-5]) rotate([180,0,0]) OuterTrackSprocket();

module InnerTrackSprocket(ShowTeeth=$preview){
	nBolts=nTrackTeeth/2;
	Sprocket_h=5.0;
	FrontXtra=5.0;
	
	difference(){
		translate([0,0,-FrontXtra]) rotate([-90,0,0])
			ToothHoldingDisk(nTeeth=nTrackTeeth, Thickness=Sprocket_h, FrontXtra=FrontXtra, ShowTeeth=ShowTeeth)
				Bolt4Hole();
		
		translate([0,0,-Sprocket_h-FrontXtra-Overlap]) cylinder(d=BSkirt_OD+1,h=Sprocket_h+FrontXtra+Overlap*2);
		
		// Bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BSkirt_OD/2+5,0,-1])
			Bolt4HeadHole();
	} // difference
} // InnerTrackSprocket
	
//translate([0,0,ToothSpacing-5-10]) InnerTrackSprocket();

module InnerSprocketMountSpacer(Height=6){
	nBolts=nTrackTeeth/2;
	
	difference(){
		union(){
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) hull(){
				translate([InnerTrackSpocketBolt_BC,0,0]) cylinder(d=Bolt4Inset*2,h=Height);
				translate([RingA_Bearing_OD/2-4,0,0]) cylinder(d=Bolt4Inset*2+2,h=Height);}
				
			cylinder(d=RingA_Bearing_OD,h=Height);
		} // union
		
		// Bolts to connect to Ring A
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) translate([InnerTrackSpocketBolt_BC,0,Height])
			Bolt4ClearHole();
		
		// cut out inside
		translate([0,0,-Overlap]) cylinder(d=RingB_Bering_BallCircle-2,h=Height+Overlap*2);
	} // difference
	
} // InnerSprocketMountSpacer

//translate([0,0,-6]) InnerSprocketMountSpacer();

module InnerSprocketMount(SpacerHeight=6){
	nBolts=nTrackTeeth/2;
	Height=13;
	RingABoltInset=8-SpacerHeight;
	
	difference(){
		union(){
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) hull(){
				translate([InnerTrackSpocketBolt_BC,0,0]) cylinder(d=Bolt4Inset*2,h=6);
				translate([RingA_Bearing_OD/2-4,0,0]) cylinder(d=Bolt4Inset*2+2,h=6);}
				
				
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BSkirt_OD/2+5,0,Height-10])
				cylinder(d=Bolt4Inset*2,h=10);
				
			
			cylinder(d1=RingA_Bearing_OD,d2=BSkirt_OD+10,h=Height);
			
			// Spacer
			for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) hull(){
				translate([InnerTrackSpocketBolt_BC,0,-SpacerHeight]) cylinder(d=Bolt4Inset*2,h=SpacerHeight+Overlap);
				translate([RingA_Bearing_OD/2-4,0,-SpacerHeight]) cylinder(d=Bolt4Inset*2+2,h=SpacerHeight+Overlap);}
				
			translate([0,0,-SpacerHeight]) cylinder(d=RingA_Bearing_OD,h=SpacerHeight+Overlap);
		} // union
		
		// Bolts to connect to Ring A
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*(j+0.5)]) translate([InnerTrackSpocketBolt_BC,0,RingABoltInset])
			Bolt4HeadHole(depth=Height+SpacerHeight, lHead=12+SpacerHeight);
		
		// Bolts to connect to Spocket
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BSkirt_OD/2+5,0,Height])
			Bolt4Hole();
		
		// cut out inside
		translate([0,0,-Overlap]) cylinder(d1=RingB_Bering_BallCircle-2,d2=BSkirt_OD+1,h=10);
		translate([0,0,-Overlap]) cylinder(d=BSkirt_OD+1,h=Height+Overlap*2);
		translate([0,0,-SpacerHeight-Overlap]) cylinder(d=RingB_Bering_BallCircle-2,h=SpacerHeight+Overlap*2);
	} // difference
} // InnerSprocketMount

//translate([0,0,-10]) InnerSprocketMount(SpacerHeight=14-kTrackBackSpace);

BSkirtBC_d=BSkirt_OD-Bolt4Inset*2;

module RingB(HasGear=true, HasEnc=false){
	if (HasGear==true){
		ring_gear(number_of_teeth=RingBTeeth,
			circular_pitch=GearBPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=10,
			rim_thickness=10,
			rim_width=2,
			backlash=Backlash,
			twist=twist/RingBTeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
		
		mirror([0,0,1])
		ring_gear(number_of_teeth=RingBTeeth,
			circular_pitch=GearBPitch, diametral_pitch=false,
			pressure_angle=Pressure_a,
			clearance = 0.2,
			gear_thickness=10,
			rim_thickness=10,
			rim_width=2,
			backlash=Backlash,
			twist=twist/RingBTeeth,
			involute_facets=0, // 1 = triangle, default is 5
			flat=false);
		} // if HasGear

	// mount
		
	translate([0,0,-10])
	difference(){
		union(){
			for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j]) 
				translate([BSkirtBC_d/2,0,BSkirt_h-10]) hull(){
					sphere(d=Bolt4Inset*2);
					cylinder(d=Bolt4Inset*2,h=10);
					translate([2.5,0,-2]) sphere(d=Bolt4Inset*2+1);
					translate([2.5,0,-2]) cylinder(d=Bolt4Inset*2+1,h=12);
				}
			
			cylinder(d=BSkirt_OD,h=BSkirt_h);
		} // union
		
		// trim outside
		difference(){
			translate([0,0,BSkirt_h-18]) cylinder(d=BSkirt_OD+10,h=19);
			translate([0,0,BSkirt_h-18-Overlap]) cylinder(d=BSkirt_OD,h=19+Overlap*2);
		} // difference
		
		// inside
		difference(){
			translate([0,0,-Overlap]) cylinder(d=BSkirt_OD-5,h=BSkirt_h+Overlap*2);
			
			for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j]) 
				translate([BSkirtBC_d/2,0,BSkirt_h-10]) hull(){
					sphere(d=Bolt4Inset*2);
					cylinder(d=Bolt4Inset*2,h=10);
					translate([2.5,0,-2]) sphere(d=Bolt4Inset*2+1);
					translate([2.5,0,-2]) cylinder(d=Bolt4Inset*2+1,h=12);
				}
		} // difference
		
		// Bolts
		for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j]) 
				translate([BSkirtBC_d/2,0,BSkirt_h]) Bolt4Hole();
		
		// Encoder Mounting bolts
		if (HasEnc==true)
		translate([0,0,BSkirt_h-7.75-5])
			rotate([0,0,16]) EncoderMountHoles() rotate([180,0,0])
				translate([0,0,10]) Bolt4ButtonHeadHole();
		
		// wire path, sprocket was moved too close the back plate for wire to exit here
		/*
		rotate([0,0,-16]) translate([0,0,BSkirt_h-4]) hull(){
			rotate([-90,0,0]) cylinder(d=6,h=100);
			translate([0,0,10]) rotate([-90,0,0]) cylinder(d=6,h=100);}
		/**/
		
	} // difference
	
	//translate([0,0,-10+BSkirt_h-7.75-5]) rotate([0,0,15]) EncoderMount();
	
	translate([0,0,-10])
	OnePieceInnerRace(BallCircle_d=RingB_Bering_BallCircle,	Race_ID=RingB_Bering_ID,	
		Ball_d=Ball_d, Race_w=RingB_Bearing_Race_w, PreLoadAdj=BearingPreload, VOffset=0.00, BI=true, myFn=$preview? 60:720);
} // RingB

//translate([0,0,21]) rotate([0,0,180/RingBTeeth]) RingB(HasGear=true);
// RingB(HasGear=false);

module RingBSpacer(){
	kThickness=5;
	
	
	difference(){
		union(){
			for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j]) 
				translate([BSkirtBC_d/2,0,0]) hull(){
					cylinder(d=Bolt4Inset*2,h=kThickness);
					translate([2.5,0,0]) cylinder(d=Bolt4Inset*2+1,h=kThickness);
				}
			
			cylinder(d=BSkirt_OD,h=kThickness);
		} // union
		
		// trim outside
		difference(){
			translate([0,0,-Overlap]) cylinder(d=BSkirt_OD+10,h=kThickness+Overlap*2);
			translate([0,0,-Overlap*2]) cylinder(d=BSkirt_OD,h=kThickness+Overlap*4);
		} // difference
		
		// inside
		difference(){
			translate([0,0,-Overlap]) cylinder(d=BSkirt_OD-5,h=kThickness+Overlap*2);
			
			for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j]) 
				translate([BSkirtBC_d/2,0,0]) hull(){
					cylinder(d=Bolt4Inset*2,h=kThickness);
					translate([2.5,0,0]) cylinder(d=Bolt4Inset*2+1,h=kThickness);
				}
		} // difference
		
		// Bolts
		for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j]) 
				translate([BSkirtBC_d/2,0,kThickness]) Bolt4ClearHole();
	} // difference
	
} // RingBSpacer

//RingBSpacer();

module MountingPlate(){
	Plate_h=5;
	MotorBoss_h=1.5;
	
	difference(){
		union(){
			cylinder(d=BSkirt_OD,h=Plate_h);
			
			cylinder(d=29,h=Plate_h+MotorBoss_h);
		} // union
			
		// RingB skirt bolts
		for (j=[0:nRingBSkirtBolts-1]) rotate([0,0,360/nRingBSkirtBolts*j]) 
				translate([BSkirtBC_d/2,0,Plate_h]) Bolt4ClearHole();
		
		// Axil
		translate([0,0,-Overlap]) cylinder(d=8,h=Plate_h+MotorBoss_h+Overlap*2);
		
		// square lock
		translate([-6,-6,Plate_h]) cube([12,12,MotorBoss_h+Overlap]);
		
		// Wire
		translate([6+2.5,0,-Overlap]) hull(){
			cylinder(d=6,h=Plate_h+MotorBoss_h+Overlap*2);
			translate([5,0,0]) cylinder(d=6,h=Plate_h+MotorBoss_h+Overlap*2);
		} // hull
	} // difference
	
} // MountingPlate

//MountingPlate();


module Planet(){
	
	difference(){
		union(){
			gear(number_of_teeth=PlanetATeeth,
				circular_pitch=GearAPitch, diametral_pitch=false,
				pressure_angle=Pressure_a,
				clearance = 0.2,
				gear_thickness=10,
				rim_thickness=10,
				rim_width=5,
				hub_thickness=10,
				hub_diameter=15,
				bore_diameter=PlanetBearing_d-1,
				circles=0,
				backlash=0,
				twist=twist/PlanetATeeth,
				involute_facets=0,
				flat=false);
	
			mirror([0,0,1])
				gear(number_of_teeth=PlanetATeeth,
					circular_pitch=GearAPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=10,
					rim_thickness=10,
					rim_width=5,
					hub_thickness=10,
					hub_diameter=15,
					bore_diameter=PlanetBearing_d-1,
					circles=0,
					backlash=0,
					twist=twist/PlanetATeeth,
					involute_facets=0,
					flat=false);
	
			translate([0,0,10-Overlap]) rotate([0,0,180/PlanetATeeth-1.20])
				gear(number_of_teeth=PlanetATeeth,
					circular_pitch=GearAPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=1+Overlap*2,
					rim_thickness=1+Overlap*2,
					rim_width=5,
					hub_thickness=1+Overlap*2,
					hub_diameter=15,
					bore_diameter=PlanetBearing_d-1,
					circles=0,
					backlash=0,
					twist=20/PlanetATeeth,
					involute_facets=0,
					flat=false);
	
			translate([0,0,21]){
				gear(number_of_teeth=PlanetBTeeth,
					circular_pitch=GearBPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=10,
					rim_thickness=10,
					rim_width=5,
					hub_thickness=10,
					hub_diameter=15,
					bore_diameter=PlanetBearing_d-1,
					circles=0,
					backlash=0,
					twist=twist/PlanetBTeeth,
					involute_facets=0,
					flat=false);

			mirror([0,0,1])
				gear(number_of_teeth=PlanetBTeeth,
					circular_pitch=GearBPitch, diametral_pitch=false,
					pressure_angle=Pressure_a,
					clearance = 0.2,
					gear_thickness=10,
					rim_thickness=10,
					rim_width=5,
					hub_thickness=10,
					hub_diameter=15,
					bore_diameter=PlanetBearing_d-1,
					circles=0,
					backlash=0,
					twist=twist/PlanetBTeeth,
					involute_facets=0,
					flat=false);
			}
		} // union

		PlanetBearing_d=12.7;
		PlanetBearing_h=6;

		translate([0,0,-10-Overlap]) cylinder(d=PlanetBearing_d,h=PlanetBearing_h+Overlap);
		translate([0,0,31-PlanetBearing_h]) cylinder(d=PlanetBearing_d,h=PlanetBearing_h+Overlap);
	} // difference

	
} // Planet

//for (j=[0:nPlanets-1]) rotate([0,0,360/nPlanets*j]) translate([-PC_BC_d/2,0,0]) rotate([0,0,180/PlanetBTeeth]) Planet();

	

echo("Ring A PD = ",RingA_pd);
echo("PC BC Dia = ",PC_BC_d);
echo("Calc'd Ring B PD = ",Ring_B_cpd/2);
echo("Ring B PD error =",Ring_B_cpd-RingBTeeth*GearBPitch/180);
















