// ******************************************
// Articulated Middle Section Testing
// Project: TSM_Transporter
// Filename: TSM_Walls.scad
// Created: 12/20/2019
// Revision: 0.9.0  3/14/2021
// Units: mm
// ******************************************
//  ***** Notes *****
//
// ******************************************
//  ***** History *****
// 
// ******************************************
//  ***** for STL output *****
//
// InnerBearing(); // 6mm bearing tests
// MiddleBearing();
// OuterBearing();
//
// ******************************************

include<CommonStuffSAEmm.scad>
include<BearingLib.scad>
// OnePieceInnerRace(BallCircle_d=100,	Race_ID=50,	Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, BI=false, myFn=360);
// OnePieceOuterRace(BallCircle_d=60, Race_OD=75, Ball_d=9.525, Race_w=10, PreLoadAdj=0.00, VOffset=0.00, BI=false, myFn=360);

$fn=$preview? 24:90;
Overlap=0.05;
IDXtra=0.2;

Width=300;

OuterRace_OD=140;


Thickness=5;
Gap=7;
Rot_a=0; //-22.5;

Wall_r=Width/2;
FloorThickness=5;
	GrooveDepth=2;
	GrooveWidth=3;
	
Bolt4Inset=4.5;

// Bearing
Ball_d=6;
BearingPreload=-0.3;
RaceThickness=1;
BearingShield_t=2;
Race_w=Ball_d+2+BearingShield_t;
Ball_VOffset=1;

OuterBallCircle_d=OuterRace_OD-Bolt4Inset*4-RaceThickness*2-Ball_d;
InnerBallCircle_d=OuterBallCircle_d-Bolt4Inset*4-RaceThickness*2-Ball_d*2;
InnerRace_ID=InnerBallCircle_d-Ball_d*2-RaceThickness*2-Bolt4Inset*2;
echo(InnerRace_ID=InnerRace_ID);

OuterBC_d=OuterRace_OD-Bolt4Inset*2;
MiddleBC_d=OuterBallCircle_d-Ball_d-Bolt4Inset*2-RaceThickness*2;
InnerBC_d=InnerBallCircle_d-Ball_d-Bolt4Inset*2-RaceThickness*2;

module InnerBearing(){
	nBolts=8;
	
	difference(){
		union(){
			// Shield
			cylinder(d=InnerBallCircle_d-1, h=BearingShield_t);
			
			OnePieceInnerRace(BallCircle_d=InnerBallCircle_d,
					Race_ID=InnerRace_ID,
					Ball_d=Ball_d,
					Race_w=Race_w,
					PreLoadAdj=BearingPreload,
					VOffset=Ball_VOffset, BI=true, myFn=$preview? 90:720);
		} // union
		
		// Shield ID
		translate([0,0,-Overlap]) cylinder(d=InnerRace_ID, h=BearingShield_t+Overlap*2);
		
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([0,InnerBC_d/2,0])
			rotate([180,0,0]) Bolt4Hole(depth=Race_w-1);
	} // difference
	
} // OuterBearing

//InnerBearing();

module MiddleBearing(){
	nBolts=12;
	
	difference(){
		union(){
			// Shield
			cylinder(d=OuterBallCircle_d-1, h=BearingShield_t);
			
			OnePieceInnerRace(BallCircle_d=OuterBallCircle_d,
					Race_ID=MiddleBC_d-Overlap,
					Ball_d=Ball_d,
					Race_w=Race_w,
					PreLoadAdj=BearingPreload,
					VOffset=Ball_VOffset, BI=true, myFn=$preview? 90:720);
			
			OnePieceOuterRace(BallCircle_d=InnerBallCircle_d, 
					Race_OD=MiddleBC_d+Overlap, 
					Ball_d=Ball_d,
					Race_w=Race_w, 
					PreLoadAdj=BearingPreload, 
					VOffset=Ball_VOffset, BI=true, myFn=$preview? 90:720);
		} // union
		
		// Shield ID
		translate([0,0,-Overlap]) cylinder(d=InnerBallCircle_d+1, h=BearingShield_t+Overlap*2);
		
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([0,MiddleBC_d/2,0])
			rotate([180,0,0]) Bolt4Hole(depth=Race_w-1);
	} // difference
} // MiddleBearing

//MiddleBearing();

module OuterBearing(){
	nBolts=16;
	
	difference(){
		union(){
			// Shield
			cylinder(d=OuterRace_OD, h=BearingShield_t);
			
			OnePieceOuterRace(BallCircle_d=OuterBallCircle_d, 
					Race_OD=OuterRace_OD, 
					Ball_d=Ball_d,
					Race_w=Race_w, 
					PreLoadAdj=BearingPreload, 
					VOffset=Ball_VOffset, BI=true, myFn=$preview? 90:720);
		} // union
		
		// Shield ID
		translate([0,0,-Overlap]) cylinder(d=OuterBallCircle_d+1, h=BearingShield_t+Overlap*2);
		
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([0,OuterBC_d/2,0])
			rotate([180,0,0]) Bolt4Hole(depth=Race_w-1);
	} // difference
	
} // OuterBearing

//OuterBearing();
//translate([0,0,-Race_w-FloorThickness-Overlap]) OuterRace();




module Wall(X1=10,Y1=10,X2=10,Y2=20,Z=10,T=1){
	hull(){
		translate([X1,Y1,0]) cylinder(d=T,h=Z);
		translate([X2,Y2,0]) cylinder(d=T,h=Z);
	}
} // Wall

module CurvedWall(Start_a=-10, Stop_a=10, R=50, Z=10, T=1, E1=1, E2=1, HasGrooveTail=false){
	Inc_a=1;
	
	if (E1==1 || E1==3) rotate([0,0,Start_a]) hull(){
		translate([-R,0,0]) cylinder(d=T,h=Z);
		translate([-R+Gap-T/2-IDXtra,-T/2,0]) cube([Overlap,T,Z]); //cylinder(d=T,h=Z);
		
	}
	if (E1==-1 || E1==3) rotate([0,0,Start_a]) hull(){
		translate([-R,0,0]) cylinder(d=T,h=Z);
		translate([-R-Gap+T/2+IDXtra,-T/2,0]) cube([Overlap,T,Z]);
		
	}
	
	if (E2==1 || E2==3) rotate([0,0,Stop_a]) hull(){
		translate([-R,0,0]) cylinder(d=T,h=Z);
		translate([-R+Gap-T/2-IDXtra,-T/2,0]) cube([Overlap,T,Z]);
		
	}
	if (E2==-1 || E2==3) rotate([0,0,Stop_a]) hull(){
		translate([-R,0,0]) cylinder(d=T,h=Z);
		translate([-R-Gap+T/2+IDXtra,-T/2,0]) cube([Overlap,T,Z]);
		
	}
	
	for (j=[Start_a:Inc_a:Stop_a-Inc_a]){
		hull(){
			rotate([0,0,j]) translate([-R,0,0]) cylinder(d=T,h=Z);
			rotate([0,0,j+Inc_a]) translate([-R,0,0]) cylinder(d=T,h=Z);
		} // hull
	
		if (HasGrooveTail==true)
		hull(){
			rotate([0,0,j]) translate([-R,0,-GrooveDepth]) cylinder(d=GrooveWidth-0.5,h=Z+GrooveDepth*2);
			rotate([0,0,j+Inc_a]) translate([-R,0,-GrooveDepth]) cylinder(d=GrooveWidth-0.5,h=Z+GrooveDepth*2);
		} // hull
	} // for
} // CurvedWall


module FloorPlate(){
	
	
	difference(){
		translate([0,0,-FloorThickness]) cylinder(d=Width+Gap,h=FloorThickness);
		
		translate([0,0,-GrooveDepth]) difference(){
			cylinder(d=Width-Gap*2+GrooveWidth,h=GrooveDepth+Overlap);
			translate([0,0,-Overlap]) cylinder(d=Width-Gap*2-GrooveWidth,h=GrooveDepth+Overlap*2);
		} // difference
			
		translate([0,0,-GrooveDepth]) difference(){
			cylinder(d=Width-Gap*4+GrooveWidth,h=GrooveDepth+Overlap);
			translate([0,0,-Overlap]) cylinder(d=Width-Gap*4-GrooveWidth,h=GrooveDepth+Overlap*2);
		} // difference
		
		translate([0,0,-FloorThickness-Overlap]) cylinder(d=OuterRace_OD-6,h=FloorThickness+Overlap*2);
	} // difference
} // FloorPlate

// FloorPlate();

module ShowCurvedWalls(Rot_a=0){
	color("Tan") CurvedWall(Start_a=-13, Stop_a=13, R=Wall_r-Gap*3, Z=10, T=Thickness,E1=-1,E2=-1); // center
	
	rotate([0,0,min(max(-Rot_a/2,-5),5)]) color("LightBlue") CurvedWall(Start_a=6, Stop_a=26, R=Wall_r-Gap*2, Z=10,
		T=Thickness,E1=1,E2=-1,HasGrooveTail=true);
	
	rotate([0,0,max(min(Rot_a/2,5),-5)]) color("LightBlue") CurvedWall(Start_a=-26, Stop_a=-6, R=Wall_r-Gap*2, Z=10, 
		T=Thickness,E1=-1,E2=1,HasGrooveTail=true);
	
	rotate([0,0,min(max(-Rot_a,-14.5),13)]) color("Tan") CurvedWall(Start_a=16, Stop_a=38, R=Wall_r-Gap, Z=10, 
		T=Thickness,E1=3,E2=3,HasGrooveTail=true);
	
	rotate([0,0,max(min(Rot_a,14.5),-13)]) color("Tan") CurvedWall(Start_a=-38, Stop_a=-16, R=Wall_r-Gap, Z=10, 
		T=Thickness,E1=3,E2=3,HasGrooveTail=true);
} // CurvedWalls

//ShowCurvedWalls(Rot_a=Rot_a);
//mirror([1,0,0]) ShowCurvedWalls(Rot_a=-Rot_a);

module End1(){
	Wall(X1=-Width/2,Y1=65,X2=-Width/2,Y2=160,Z=10,T=Thickness);
	Wall(X1=-Width/2,Y1=65,X2=-Width/2+17,Y2=65,Z=10,T=Thickness);
	CurvedWall(Start_a=-30, Stop_a=-26, R=Wall_r, Z=10, T=Thickness,E1=0,E2=3);
} 

module ShowEndWalls(){
	//translate([-Gap,Width/2*sin(22.5),0])
	rotate([0,0,Rot_a])  color("LightBlue") End1();
	mirror([0,1,0]) rotate([0,0,Rot_a]) color("LightBlue") End1();
	
	mirror([1,0,0]){
		rotate([0,0,-Rot_a])  color("LightBlue") End1();
		mirror([0,1,0]) rotate([0,0,-Rot_a]) color("LightBlue") End1();}

} // ShowEndWalls


//ShowEndWalls();


module InnerRace(){
	difference(){
		cylinder(d=InnerRace_ID+16+Ball_d/2,h=Race_w);
		translate([0,0,-Overlap]) cylinder(d=InnerRace_ID,h=Race_w+Overlap*2);
	}
} // InnerRace

//translate([0,0,-Race_w-FloorThickness-Overlap]) InnerRace();












