// ***************************************************
// Pressure Door
// Project: Terran Space Marine Transporter
// Filename: TSM_PressureDoor.scad
// Created: 3/25/2021
// Revision: 1.0.1  3/26/2021
// Units: mm
// ***************************************************
//  ***** History *****
//
// 1.0.1  3/26/2021 Began working on door locking mechanics.
// 1.0.0  3/25/2021 First code.
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

Ball_d = 3/8 * 25.4;
BallRetainer_d=Ball_d+4;
LockMagnet_d = 1/8 * 25.4;
LockMagnet_h = 1/4 * 25.4;
LockingPin_w=6;
LockingPin_t=6;
StopPin_d=1/8 * 25.4;

module Ball(){
	color("Red") sphere(d=Ball_d, $fn=18);
} // Ball

ControlShaft_d=6.35;
LockingDiskOffset_x=ControlShaft_d/2+LockMagnet_d/2+1;
LockingDisk_d=LockingDiskOffset_x*2+LockingPin_t+1;
//echo(LockingDisk_d=LockingDisk_d);

module LockingDisk(ShowBallRetracted=true){
	Rot_a=ShowBallRetracted? 0:-90;
	
	rotate([0,0,Rot_a])
	difference(){
		cylinder(d=LockingDisk_d,h=LockMagnet_h);
		
		// Magnets
		translate([LockingDiskOffset_x,0,-Overlap]) cylinder(d=LockMagnet_d, h=LockMagnet_h+Overlap*2);
		translate([0,LockingDiskOffset_x,-Overlap]) cylinder(d=LockMagnet_d, h=LockMagnet_h+Overlap*2);
		// Shaft
		translate([0,0,-Overlap]) cylinder(d=ControlShaft_d+IDXtra, h=LockMagnet_h+Overlap*2);
		
		// Stops
		difference(){
			union(){
				translate([0,0,-Overlap]) rotate([0,0,135]) cube([LockingDisk_d,LockingDisk_d,LockMagnet_h+Overlap*2]);
				translate([0,0,-Overlap]) rotate([0,0,135+26]) cube([LockingDisk_d,LockingDisk_d,LockMagnet_h+Overlap*2]);
			} // union
			
			translate([0,0,-Overlap*2]) cylinder(d=ControlShaft_d+4, h=LockMagnet_h+Overlap*4);
		} // difference
	} // difference
	
}// LockingDisk

module ShowStopPin(){
	rotate([0,0,58]) translate([0,ControlShaft_d/2+LockMagnet_d/2+2.5,-2])
		color("Red") cylinder(d=StopPin_d, h=LockMagnet_h+4);
} // ShowStopPin

module StopPinHole(XtraLen=5){
	rotate([0,0,58])
	translate([0,ControlShaft_d/2+LockMagnet_d/2+2.5,-2-XtraLen]) cylinder(d=StopPin_d+IDXtra, h=LockMagnet_h+4.2+XtraLen);
} // StopPinHole

/*
translate([-LockingDiskOffset_x,0,-LockMagnet_h-Overlap]){
	StopPinHole(XtraLen=5);
	LockingDisk(ShowBallRetracted=false);}
/**/

module LockingBar(){
	difference(){
		cylinder(d=Ball_d, h=20, center=true);
		
		translate([-Ball_d/2-Overlap,0,0]) rotate([0,90,0]) cylinder(d=LockMagnet_d+IDXtra, h=Ball_d+Overlap*2);
	} // difference
} // LockingBar

//translate([-Ball_d-LockMagnet_h-1,0,Ball_d*1.5-2]) rotate([90,0,0]) LockingBar();


module LockingPin(){
	H1=LockMagnet_h+1;
	H2=10;
	H3=H2+Ball_d;
	Pin_w=LockingPin_w;
	Pin_t=LockingPin_t;
	
	difference(){
		union(){
			RoundRect(X=Pin_t,Y=Pin_w,Z=H1,R=1);
			hull(){
				translate([0,0,H1-Overlap]) RoundRect(X=Pin_t,Y=Pin_w,Z=Overlap,R=1);
				translate([-1,0,H2]) RoundRect(X=Pin_t-2,Y=Pin_w,Z=Overlap,R=1);
			} // hull
			translate([-1,0,0]) RoundRect(X=Pin_t-2,Y=Pin_w,Z=H3,R=1);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=LockMagnet_d+IDXtra,h=LockMagnet_h+Overlap*2);
	} // difference
	
} // LockingPin

// LockingPin();

module LockingPinHole(Entry_h=10){
	H1=LockMagnet_h+1;
	H2=10;
	H3=H2+Ball_d;
	
	Pin_w=LockingPin_w;
	Pin_t=LockingPin_t;

	translate([0,0,-Entry_h]) RoundRect(X=Pin_t+IDXtra*2,Y=Pin_w+IDXtra*2,Z=H1+Entry_h,R=1);
	hull(){
		translate([0,0,H1-Overlap]) RoundRect(X=Pin_t+IDXtra*2,Y=Pin_w+IDXtra*2,Z=Overlap,R=1);
		translate([-1,0,H2]) RoundRect(X=Pin_t-2+IDXtra*2,Y=Pin_w+IDXtra*2,Z=Overlap,R=1);
	} // hull
	translate([-1,0,0]) RoundRect(X=Pin_t-2+IDXtra*2,Y=Pin_w+IDXtra*2,Z=H3,R=1);
		
} // LockingPinHole

//LockingPinHole();

module BallRetainerHole(){
	translate([0,0,-Overlap]) cylinder(d=BallRetainer_d+IDXtra, h=Ball_d/4+IDXtra*2);
	cylinder(d=Ball_d+IDXtra*2, h=Ball_d);
} // BallRetainerHole

module BallRetainer(ShowBall=true, ShowBallRetracted=true){
	difference(){
		cylinder(d=BallRetainer_d, h=Ball_d/4);
		
		translate([0,0,2]) cylinder(d=Ball_d+IDXtra*2,h=Ball_d/4);
		translate([0,0,Ball_d/2-2]) sphere(d=Ball_d+IDXtra);
	} // difference
	

	if (ShowBall==true && $preview==true){
			if (ShowBallRetracted==true){
				translate([0,0,Ball_d/2]) Ball();
			}else{
				translate([0,0,Ball_d/2-2]) Ball();
			}}
} // BallRetainer

//BallRetainer(ShowBall=true, ShowBallRetracted=true);

module Lock(ShowBall=true, ShowBallRetracted=true){
	BallRetainer(ShowBall=ShowBall, ShowBallRetracted=ShowBallRetracted);
	
	translate([-Ball_d/2,0,Ball_d+LockingPin_t/2-2]) rotate([0,90,0]) #LockingPinHole(Entry_h=10);
	
	#BallRetainerHole();
	
	if (ShowBallRetracted==true){
		translate([-Ball_d-2.5,0,Ball_d+LockingPin_t/2-2]) rotate([0,90,0]) LockingPin();
	}else{
		translate([-Ball_d/2-1,0,Ball_d+LockingPin_t/2-2]) rotate([0,90,0]) LockingPin();
	}
	
	translate([-Ball_d/2-1-LockMagnet_h,0,Ball_d+LockingPin_t/2-2]) rotate([0,90,0])
		translate([-LockingDiskOffset_x,0,-LockMagnet_h-Overlap]){ #StopPinHole(XtraLen=5);
			ShowStopPin();}
	
	translate([-Ball_d/2-1-LockMagnet_h,0,Ball_d+LockingPin_t/2-2]) rotate([0,90,0]) 
		translate([-LockingDiskOffset_x,0,-LockMagnet_h-Overlap]) LockingDisk(ShowBallRetracted=ShowBallRetracted);

	//translate([-Ball_d-LockMagnet_h-1,0,Ball_d*1.5-2]) rotate([90,0,0]) LockingBar();
} // Lock

//translate([72.7,0,11]) rotate([0,104,0]) 
//Lock(ShowBall=true, ShowBallRetracted=false);
//Lock(ShowBall=true, ShowBallRetracted=true);

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

 //HatchComing();










































