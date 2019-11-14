// *************************************************
// Belt Pulleys
// by David M. Flynn
//
// Created: 10/3/2017
// Revision: 1.0.1 10/19/2019
// units: mm
// *************************************************
// History:
// 1.0.1 10/19/2019 Updates...
// 1.0 10/6/2017 Added DogPlateCover. Added Slotted or not to DogPlate.
// *************************************************
// for STL output
//
// IdlePulley(Belt_w = 14 ,Teeth = 24, Bore_d=21, center=false);
// IdlePulley(Belt_w = 11 ,Teeth = 14, Bore_d=0); // (6id x 13od bearings)
// MotorPulley(Belt_w = 11 ,Teeth = 14); // 5mm shaft, #8 set screws
// ServoBeltPulley();
// DogPlate(Slotted=false);
// DogPlateCover();
// *************************************************
include <CommonStuffSAEmm.scad>
include <cogsndogs.scad>

IDXtra = 0.2;
$fn=$preview? 24:90;
Overlap = 0.05;
ThinWall=1.2;

module DogPlateCover(){
	// right angle XP belt mounting plate
	Plate_l=27.2;
	Plate_h=24;
	
	Plate_t=5;
	
	difference(){
		cube([Plate_l,Plate_h,Plate_t]);
		
		// bolt holes
		translate([0,0,Plate_t]){
			translate([4,4,0])BoltClearHole();
			translate([Plate_l-4,4,0])BoltClearHole();
			translate([4,Plate_h-4,0])BoltClearHole();
			translate([Plate_l-4,Plate_h-4,0])BoltClearHole();}
	} // diff
	
} // DogPlateCover

//DogPlateCover();

module DogPlate(Slotted=true){
	// right angle XP belt mounting plate
	Plate_l=27.2;
	Plate_h=24;
	Plate_w=20;
	Belt_w=11;
	
	translate([0,0,Plate_h/2-Belt_w/2])scale(1.016)dog_linear(profile=T5, teeth=5, height=Belt_w, t_dog=4);
	
	difference(){
		union(){
			cube([Plate_l,6,Plate_h]);
			// base
			cube([Plate_l,Plate_w,6]);
			// gusset
			translate([Plate_l/2-2,5,1])
			hull(){
				cube([4,Plate_w-5,3]);
				cube([4,1,Plate_h-2]);
			} // hull
		} // union
		
		translate([-Overlap,-Overlap,Plate_h/2-Belt_w/2]) cube([Plate_l+Overlap*2,3,Belt_w]);
		// bolt holes
		translate([4,0,4])rotate([90,0,0])BoltHole();
		translate([Plate_l-4,0,4])rotate([90,0,0])BoltHole();
		translate([4,0,Plate_h-4])rotate([90,0,0])BoltHole();
		translate([Plate_l-4,0,Plate_h-4])rotate([90,0,0])BoltHole();
		
		
		translate([6,Plate_w/2+3,6]) 
		if (Slotted==true)
			hull(){
				translate([-2,0,0])scale(25.4)Bolt6ClearHole();
				translate([2,0,0])scale(25.4)Bolt6ClearHole();
			}
			else scale(25.4)Bolt6ClearHole();
				
		translate([Plate_l-6,Plate_w/2+3,6]) 
			if (Slotted==true)
			hull(){
				translate([2,0,0])scale(25.4)Bolt6ClearHole();
				translate([-2,0,0])scale(25.4)Bolt6ClearHole();
			}
			else scale(25.4)Bolt6ClearHole();
	} // diff
	
} // DogPlate

//DogPlate();


module IdlePulley(Belt_w = 11 ,Teeth = 10, Bore_d=0, center=false){
	Bearing_h=5;
	Bearing_od=13;
	
	InverseScaleFactor=1/1.016;
	h_teeth=Belt_w*InverseScaleFactor;
	Pulley_h=4;
	CenterHole_d=7.6;
	
	Pitch_d=Teeth*5/PI; //This is scalled
	Pulley_OD=Pitch_d+2;
	ZOffset=center==false? 0:-ThinWall*2-Belt_w/2;
	
	translate([0,0,ZOffset])
	difference(){
		union(){
			// base
			cylinder(d=Pulley_OD, h=ThinWall+Overlap);
			// taper base to pulley
			translate([0,0,ThinWall]) cylinder(d1=Pulley_OD, d2=Pulley_OD-ThinWall, h=ThinWall+Overlap);
			// teeth
			translate([0,0,ThinWall*2])scale(1.016) Cog_Pulley(profile=T5, radius=Pitch_d/2, subtends=370, height=h_teeth, t_dog=5);
			// taper teeth to top
			translate([0,0,ThinWall*2+Belt_w])
				cylinder(d2=Pulley_OD, d1=Pulley_OD-ThinWall, h=ThinWall+Overlap);
			// top
			translate([0,0,ThinWall*3+Belt_w]) cylinder(d=Pulley_OD, h=ThinWall);
			
		} // union
		
		// bore
		if (Bore_d==0){
			translate([0,0,-Overlap]) cylinder(d=Bearing_od-IDXtra,h=30);
			translate([0,0,-Overlap]) cylinder(d=Bearing_od+IDXtra,h=Bearing_h);
			translate([0,0,ThinWall*4+Belt_w-Bearing_h]) cylinder(d=Bearing_od+IDXtra,h=Bearing_h+Overlap);
		} else {
			translate([0,0,-Overlap]) cylinder(d=Bore_d,h=ThinWall*4+Belt_w+Overlap*2);
		}
		
	} // diff
} // IdlePulley

//IdlePulley(Belt_w = 11 ,Teeth = 14, Bore_d=0);
//IdlePulley(Belt_w = 14 ,Teeth = 24, Bore_d=21, center=true);


module MotorPulley(Belt_w = 11 ,Teeth = 10){
	InverseScaleFactor=1/1.016;
	h_teeth=Belt_w*InverseScaleFactor;
	Pulley_h=4;
	CenterHole_d=7.6;
	
	Pitch_d=Teeth*5/3.14159; //This is scalled
	Pulley_OD=Pitch_d+1.5;
	
	difference(){
		union(){
			cylinder(d=Pulley_OD, h=ThinWall+Overlap);
			translate([0,0,ThinWall]) cylinder(d1=Pulley_OD, d2=Pulley_OD-ThinWall, h=ThinWall+Overlap);
			translate([0,0,ThinWall*2])scale(1.016)Cog_Pulley(profile=T5, radius=Pitch_d/2, subtends=370, height=h_teeth, t_dog=5);
			translate([0,0,ThinWall*2+Belt_w])
				cylinder(d2=Pulley_OD, d1=Pulley_OD-ThinWall, h=ThinWall+Overlap);
			translate([0,0,ThinWall*3+Belt_w]) cylinder(d=Pulley_OD, h=ThinWall);
			
			// hub
			translate([0,0,ThinWall*4+Belt_w-Overlap]) cylinder(d=16,h=10);
		} // union
		
		// bore
		translate([0,0,-Overlap]) cylinder(d=5,h=30);
		// set screws
		translate([0,0,ThinWall*4+Belt_w+5]) rotate([90,0,0]) scale(25.4) Bolt8Hole();
		translate([0,0,ThinWall*4+Belt_w+5]) rotate([90,0,90]) scale(25.4) Bolt8Hole();
	} // diff
} // MotorPulley

//MotorPulley(Belt_w = 11 ,Teeth = 14);

module ServoBeltPulley(Belt_w =7 ,Teeth=46){
	h_teeth=Belt_w*2.5;
	Pulley_h=4;
	CenterHole_d=7.6;
	BoltCenter1=14;
	BoltCenter2=17;
	Pitch_d=Teeth*2.5/3.14159; //This is scalled
	Pulley_OD=Pitch_d*0.8+1;

	difference(){
		union(){
			cylinder(r=Pulley_OD/2, h=0.51);
			translate([0,0,0.5]) cylinder(r1=Pulley_OD/2, r2=Pulley_OD/2-0.5, h=0.5+Overlap);
			translate([0,0,1]) scale([0.4,0.4,0.4]) Cog_Pulley(T5, Pitch_d, 370, h_teeth, 5); // 23 teeth
			
			translate([0,0,1+h_teeth*0.4])
				cylinder(r2=Pulley_OD/2, r1=Pulley_OD/2-0.5, h=0.5+Overlap);
			translate([0,0,1.5+h_teeth*0.4]) cylinder(r=Pulley_OD/2, h=Pulley_h-3.5);
			
		} // union
		
			// Hub clearance
			translate([0,0,-Overlap]) cylinder(r=CenterHole_d/2+IDXtra,h=Pulley_h+10);
		
			// servo wheel mounting holes
			translate([0,0,Pulley_h+2]) rotate([0,0,45]){
			translate([BoltCenter1/2,0,0]) BoltHole();
			translate([-BoltCenter1/2,0,0]) BoltHole();
			translate([0,BoltCenter2/2,0]) BoltHole();
			translate([0,-BoltCenter2/2,0]) BoltHole();}
				
			// Dishout
			translate([0,0,2]) cylinder(r=12.5, h=Pulley_h+10);
	} // diff
	
} // ServoBeltPulley

//ServoBeltPulley();