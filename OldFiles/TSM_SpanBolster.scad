// *************************************************
// TSM-Transporter, a large tracked vehicle
//
// Filename: TSM_SpanBolster.scad
// By: David M. Flynn
// Created: 10/5/2019
// Revision: 0.9.5 11/30/2019
// Units: mm
// *************************************************
//  ***** History ******
// 0.9.5 11/30/2019 Added stops to RockerArmMount, longer TrackTensionerArm.
// 0.9.4 11/17/2019 Track return idler 5mm taller.
// 0.9.3 11/14/2019 Fixes to BolsterMount.
// 0.9.2 11/8/2019 Added SpanBolsterMount.
// 0.9.1 10/12/2019 Wider RockerArm. Longer.
// 0.9.0 10/5/2019 First code.
// *************************************************
//  ***** for STL output *****
// TrackSprocket(); // 10 teeth, print 8
// RockerArmMount(); // print 2
// RockerArm(Len=110,Angle=30); // for 10 tooth sprockets
//
// TrackRturnIdlerHub(IsOuter=true); // FC1
// TrackRturnIdlerHub(IsOuter=false);
// TrackRturnIdlerMount();
//
// TrackTensionerArm(Len=60); // print 2
// TrackTensionerReceiver();
// TrackTensionerMount();
//
// Sprocket9Hub(Back_h=5); // not used
// RockerArm(Len=104,Angle=30); // not used
// CenterSpan(Span_l=182); // not used
// SpanBolsterMount();  // not used
// *************************************************
//  ***** for Viewing *****
// ShowIdleHub();
// *************************************************

include<CommonStuffSAEmm.scad>
include<BearingLib.scad>
include<LynxTrackLib.scad>

$fn=$preview? 24:90;
Overlap=0.05;
IDXtra=0.2;
Bolt4Inset=4;

// big bearing
Bearing_OD=1.125*25.4;
Bearing_ID=0.500*25.4;
BEaring_w=0.3125*25.4;

// Small bearing
Bearing_d=12.7; // inp 6x13x5
Bearing_w=4.7;

//Bearing_d=13; // metric 6x13x5
//Bearing_w=5;

Ball_d=5/16*25.4;
BearingPreload=-0.3;

ToothSpacing=kTrackBackSpace*7; // 3 inch track tooth spacing
//echo(ToothSpacing=ToothSpacing);
AxilLen=25.4*2;
nTrackTeeth=20;
	
module ShowIdleHub(){
	//translate([0,kTrackBackSpace*4,0]) rotate([-90,0,0]) Sprocket9Hub(Back_h=5);
	//rotate([90,0,0]) Sprocket9Hub(Back_h=5);
	// color("Gray") Spocket9();
	//translate([0,kTrackBackSpace*4,0]) color("Gray") rotate([0,0,180]) Spocket9();
	
	//translate([-90,0,0]){
	//	translate([0,kTrackBackSpace*4,0]) rotate([-90,0,0]) Sprocket9Hub(Back_h=5);
//		rotate([90,0,0]) Sprocket9Hub(Back_h=5);
//		color("Gray") Spocket9();
//		translate([0,kTrackBackSpace*4,0]) color("Gray") rotate([0,0,180]) Spocket9();
//}
	
	translate([0,5,0]) rotate([90,0,0]) RockerArm(Len=110,Angle=30);
	translate([0,5+24,0]) rotate([90,0,0]) mirror([0,0,1]) RockerArm(Len=110,Angle=30);
	
	echo("Axil Len = ",kTrackBackSpace*4);
	//translate([20,0,0]) cube([1,kTrackBackSpace*4,1]);
} // ShowIdleHub
	
//ShowIdleHub();

module TrackRturnIdlerHub(IsOuter=true){
	// Assy: Sprocket9Hub2,
	//			Bearing, 
	// 				1/2" tubing spacer,
	//			shaft collar,
	// 			bearing, 
	// Sprocket9Hub2
	
	nBolts=4;
	BC_d=16;
	HalfWidth=ToothSpacing/2-9;
	Shaft_d=6.35+IDXtra;
	
	Bearing_d=13;  //12.7; // inp 6x13x5
	Bearing_w=5; //4.7;

	difference(){
		union(){
			cylinder(d=22,h=HalfWidth);
			cylinder(d=38,h=6);
		} // union
		
		if (IsOuter==true){
			for (j=[0:3]) rotate([0,0,90*j+45])
				translate([15,0,6]) Bolt4Hole();
		} else {
			for (j=[0:3]) rotate([0,0,90*j+45])
				translate([15,0,6]) Bolt4ClearHole();
		}
		translate([0,0,-Overlap]) cylinder(d=12.7,h=HalfWidth-11+Overlap*2);
		translate([0,0,HalfWidth-11]) cylinder(d1=12.7,d2=Shaft_d,h=2);
		cylinder(d=Shaft_d,h=HalfWidth+Overlap);
		
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) 
			translate([BC_d/2,0,HalfWidth]) Bolt4Hole(depth=8);
	} // difference
} // TrackRturnIdlerHub

//TrackRturnIdlerHub(IsOuter=true);
//TrackRturnIdlerHub(IsOuter=false);


module TrackRturnIdlerMount(){
	nBolts=6;
	Base_h=8;
	BackPlateToWheel=23;
	
	difference(){
		union(){
			cylinder(d=50,h=Base_h);
			translate([0,0,Base_h-Overlap]) cylinder(d1=30,d2=16,h=BackPlateToWheel-Base_h-3);
			cylinder(d=11,h=BackPlateToWheel);
		} // union		
		
		translate([0,0,-Overlap]) cylinder(d=6.35,h=BackPlateToWheel+Overlap*2);
	
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([20,0,Base_h]) Bolt4Hole();
	} // difference
	
} // TrackRturnIdlerMount

//  TrackRturnIdlerMount();

module RockerArm(Len=85,Angle=30){
	BearingPushOut=4.1;
	HalfWidth=ToothSpacing/2-SP10_Inset-0.5-BearingPushOut;
	Center_w=AxilLen/2-7;
	CenterShaft_d=6.35;
	

	module BearingHole(){
		translate([0,0,-Overlap]) cylinder(d=12.7,h=13+Overlap*2);
		translate([0,0,13]) cylinder(d1=12.7,d2=10.7,h=2+Overlap);
		translate([0,0,15]) cylinder(d=10.7,h=HalfWidth);
		translate([0,0,HalfWidth-Bearing_w+BearingPushOut]) cylinder(d=Bearing_d,h=Bearing_w+Overlap*2);
	} // BearingHole
	
	translate([0,0,-HalfWidth]) 
	difference(){
		union(){
			hull(){
				cylinder(d=Bearing_d+5,h=HalfWidth);
				rotate([0,0,-Angle]) translate([-Len/2,0,0])
					cylinder(d=Bearing_d+5,h=HalfWidth);
			}
			
			
			hull(){
				rotate([0,0,-Angle]) translate([-Len/2,0,0]){
					cylinder(d=Bearing_d+5,h=HalfWidth);
					
					rotate([0,0,Angle*2]) translate([-Len/2,0,0])
						cylinder(d=Bearing_d+5,h=HalfWidth);
			}
			}
			
			rotate([0,0,-Angle]) translate([-Len/2,0,0])
					cylinder(d=CenterShaft_d+4,h=Center_w);
		} // union
		
		// Right Bearing hole
		BearingHole();
		
		// Lightening cuts, slots
		rotate([0,0,-Angle])
		hull(){
			translate([-Bearing_d/2-4,0,-Overlap]) cylinder(d=4,h=HalfWidth+Overlap*2);
			translate([-Len/2+Bearing_d/2+4,0,-Overlap]) cylinder(d=4,h=HalfWidth+Overlap*2);	
			}
			
		rotate([0,0,-Angle]) translate([-Len/2,0,0]) rotate([0,0,Angle*2])
		hull(){
			translate([-Bearing_d/2-4,0,-Overlap]) cylinder(d=4,h=HalfWidth+Overlap*2);
			translate([-Len/2+Bearing_d/2+4,0,-Overlap]) cylinder(d=4,h=HalfWidth+Overlap*2);	
			}
			
		// Lightening cuts, thinning
		rotate([0,0,-Angle]) translate([-Len/4,0,Len/4+HalfWidth/2]) rotate([90,0,0])
			cylinder(d=Len/2,h=Bearing_d+5+Overlap*2,center=true);
		
		rotate([0,0,-Angle]) translate([-Len/2,0,0]) rotate([0,0,Angle*2])
			translate([-Len/4,0,Len/4+HalfWidth/2]) rotate([90,0,0])
			cylinder(d=Len/2,h=Bearing_d+5+Overlap*2,center=true);
			
		// center pivot
		rotate([0,0,-Angle]) translate([-Len/2,0,0]){
			translate([0,0,-Overlap]) cylinder(d=CenterShaft_d,h=Center_w+Overlap*2);
			
			rotate([0,0,Angle*2]) translate([-Len/2,0,0])
				// Left Bearing hole
				BearingHole();
			
		} // center pivot, left bearing
		
	} // difference
	
	// Bearing holders
	translate([0,0,-HalfWidth])
	difference(){
		union(){
			cylinder(d=Bearing_d+4,h=HalfWidth+BearingPushOut);
			
			rotate([0,0,-Angle]) translate([-Len/2,0,0])
				rotate([0,0,Angle*2]) translate([-Len/2,0,0])
					cylinder(d=Bearing_d+4,h=HalfWidth+BearingPushOut);
		} // union
		
		// Bearing hole
		BearingHole();
		
		rotate([0,0,-Angle]) translate([-Len/2,0,0])
			rotate([0,0,Angle*2]) translate([-Len/2,0,0]){
				// Left bearing
				// Bearing hole
				BearingHole();
			}
		
	} // difference
		
} // RockerArm

//RockerArm(Len=110,Angle=30);

module RockerArmMount(){
	kSpanBOffset=26;
	kSpanBThickness=31+8;
	kPlate_w=16;
	kOAH=kSpanBOffset-2+kSpanBThickness;
	
	difference(){
		union(){
			// base
			cylinder(d=44,h=8);
			//cylinder(d=25,h=kSpanBOffset-2);
			
			hull(){
				cylinder(d=16,h=kSpanBOffset);
				translate([0,14,0]) cylinder(d=16,h=kSpanBOffset);
			}
			
			hull(){
				translate([0,10,0]) cylinder(d=16,h=kOAH-10);
				translate([0,14,0]) cylinder(d=16,h=kOAH-10);
				translate([0,22,kOAH-Overlap]) cylinder(d=16,h=Overlap);
				
				translate([-10,8,31]) cylinder(d=8,h=20);
				translate([10,8,31]) cylinder(d=8,h=20);
			}
			
			hull(){
				rotate([0,0,-30]) translate([12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,-30]) translate([12.7,0,0]) cylinder(d=18,h=8);
				//cylinder(d=36,h=8);
			} // hull
			hull(){
				rotate([0,0,30]) translate([-12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,30]) translate([-12.7,0,0]) cylinder(d=18,h=8);
				//cylinder(d=36,h=8);
			} // hull
			
			//*
			
			// left arm
			hull(){
				rotate([0,0,30]) translate([-12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,30]) translate([-12.7,20*3-16,0]) cylinder(d=10,h=8);
				
				translate([-kPlate_w/2+4,24,kSpanBOffset-2+kSpanBThickness-8]) cylinder(d=10,h=8);
				translate([-kPlate_w/2+4,30,kSpanBOffset-2+kSpanBThickness-8]) cylinder(d=10,h=8);
			} // hull
			/**/
			
			// Right arm
			hull(){
				rotate([0,0,-30]) translate([12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,-30]) translate([12.7,20*3-16,0]) cylinder(d=10,h=8);
				
				translate([kPlate_w/2-4,24,kSpanBOffset-2+kSpanBThickness-8]) cylinder(d=10,h=8);
				translate([kPlate_w/2-4,30,kSpanBOffset-2+kSpanBThickness-8]) cylinder(d=10,h=8);
			} // hull
			
			translate([0,0,kSpanBOffset-2+kSpanBThickness-8])
			hull(){
				translate([-kPlate_w/2+4,24,0]) cylinder(d=10,h=8);
				translate([-kPlate_w/2+4,30,0]) cylinder(d=10,h=8);
				translate([kPlate_w/2-4,24,0]) cylinder(d=10,h=8);
				translate([kPlate_w/2-4,30,0]) cylinder(d=10,h=8);
			} // hull
		} // union
		
		//translate([0,0,kSpanBOffset-2+kSpanBThickness-10]) rotate([-90,0,0]) cylinder(d=14.5,h=50);
		
		// Stops
		dd=Bearing_d+5.5;
		hull(){
			translate([0,0,kSpanBOffset]) cylinder(d=dd+IDXtra,h=kOAH-kSpanBOffset+Overlap);
			translate([0,0,kSpanBOffset]) rotate([0,0,22.5]) translate([-10,0,0]) cylinder(d=dd+IDXtra,h=kOAH-kSpanBOffset+Overlap);
		}
		
		hull(){
			translate([0,0,kSpanBOffset]) cylinder(d=dd+IDXtra,h=kOAH-kSpanBOffset+Overlap);
			translate([0,0,kSpanBOffset]) rotate([0,0,-22.5]) translate([10,0,0]) cylinder(d=dd+IDXtra,h=kOAH-kSpanBOffset+Overlap);
		}
		
		translate([0,0,kSpanBOffset-2+kSpanBThickness])
			{
				translate([-kPlate_w/2+4,24,0]) Bolt4Hole(depth=8);
				translate([-kPlate_w/2+4,30,0]) Bolt4Hole(depth=8);
				translate([kPlate_w/2-4,24,0]) Bolt4Hole(depth=8);
				translate([kPlate_w/2-4,30,0]) Bolt4Hole(depth=8);
			}
			
		for (j=[0:3]){
			rotate([0,0,-30]) translate([12.7,20*j-10,0]) rotate([0,180,0]) Bolt4Hole();
			rotate([0,0,30]) translate([-12.7,20*j-10,0]) rotate([0,180,0]) Bolt4Hole();}
			
			
		translate([0,0,-Overlap]) cylinder(d=10,h=kSpanBOffset-6+Overlap*2);
		translate([0,0,kSpanBOffset-6]) cylinder(d1=10,d2=6.35,h=1+Overlap*2);
		translate([0,0,kSpanBOffset-6]) cylinder(d=6.35,h=10);
	} // difference

} // RockerArmMount

//translate([-47.5,57.5,27.5]) rotate([90,0,0]) RockerArmMount();


module TrackTensionerArm(Len=50){
	BearingPushOut=4.1;
	HalfWidth=ToothSpacing/2-SP10_Inset-0.5-BearingPushOut;
	Shank_w=25;
	Shank_h=16;
	Spring_d=5/16*25.4;

	module BearingHole(){
		translate([0,0,-Overlap]) cylinder(d=12.7,h=13+Overlap*2);
		translate([0,0,13]) cylinder(d1=12.7,d2=10.7,h=2+Overlap);
		translate([0,0,15]) cylinder(d=10.7,h=HalfWidth);
		translate([0,0,HalfWidth-Bearing_w+BearingPushOut]) cylinder(d=Bearing_d,h=Bearing_w+Overlap*2);
	} // BearingHole
	
	translate([0,0,-HalfWidth]) 
	difference(){
		union(){
			cylinder(d=Bearing_d+4,h=HalfWidth+BearingPushOut);
			cylinder(d=Bearing_d+5,h=HalfWidth);
			
			translate([-Len,-Shank_h/2,0])
					cube([Len,Shank_h,Shank_w/2]);
			
		} // union
		
		// Right Bearing hole
		BearingHole();
		
		// Lightening cuts, slots
		
		hull(){
			translate([-Bearing_d/2-5,0,-Overlap]) cylinder(d=4,h=HalfWidth+Overlap*2);
			translate([-Len+6,0,-Overlap]) cylinder(d=4,h=HalfWidth+Overlap*2);	
			}
		
		// sping guides
		translate([-Len-Overlap,0,Shank_w/4]) rotate([0,90,0]) cylinder(d1=Spring_d+1,d2=Spring_d,h=1);
	} // difference
	
} // TrackTensionerArm

//TrackTensionerArm(Len=60);

/*
translate([10,0,0]){
translate([0,0,16+44]) TrackTensionerArm();
translate([0,0,-16+44]) rotate([180,0,0]) TrackTensionerArm();}
/**/

module TrackTensionerReceiver(){
	Spring_d=5/16*25.4;
	Slide_L=60;
	Shank_w=25+IDXtra*2;
	Shank_h=16+IDXtra*2;
	Wall_t=2.5;
	
	difference(){
		translate([0,-Shank_h/2-Wall_t,-Shank_w/2-Wall_t])
			cube([Slide_L,Shank_h+Wall_t*2,Shank_w+Wall_t*2]);
		
		translate([Wall_t*2,0,0]){
				translate([-Overlap,-Shank_h/2,-Shank_w/2]) cube([Slide_L+Overlap*2,Shank_h,Shank_w]);
				translate([Slide_L/2,0,-Shank_w/2-Wall_t-Overlap]) cylinder(d=3,h=Shank_w+Wall_t*2+Overlap*2);
				translate([Slide_L/2+10,0,-Shank_w/2-Wall_t-Overlap]) cylinder(d=3,h=Shank_w+Wall_t*2+Overlap*2);
				
				translate([0,0,Shank_w/4]) rotate([0,-90,0]) cylinder(d1=Spring_d+1,d2=Spring_d,h=1);
				translate([0,0,-Shank_w/4]) rotate([0,-90,0]) cylinder(d1=Spring_d+1,d2=Spring_d,h=1);
		}
	} // difference
} // TrackTensionerReceiver

//rotate([0,-90,0]) TrackTensionerReceiver();


module TrackTensionerMount(){
	Spring_d=5/16*25.4;
	
	Shank_w=25+IDXtra*2;
	Shank_h=16+IDXtra*2;
	Wall_t=2.5;
	Slide_L=60;
	
	kSpanBOffset=26;
	kSpanBThickness=31+8;
	kPlate_w=16;
	
	rotate([0,0,-90])
	difference(){
		union(){
			cylinder(d=44,h=8);
			
			//rotate([0,0,90])
			//translate([0,0,44]) translate([0,-Shank_h/2-Wall_t,-Shank_w/2-Wall_t]) cube([Slide_L,Shank_h+Wall_t*2,Shank_w+Wall_t*2]);
			
			cylinder(d=Shank_h+Wall_t*2,h=Shank_w+Wall_t*2+28.8);
			
			hull(){
				rotate([0,0,-30]) translate([12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,-30]) translate([12.7,0,0]) cylinder(d=18,h=8);
				//cylinder(d=36,h=8);
			} // hull
			hull(){
				rotate([0,0,30]) translate([-12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,30]) translate([-12.7,0,0]) cylinder(d=18,h=8);
				//cylinder(d=36,h=8);
			} // hull
			
			//*
			
			// left arm
			hull(){
				rotate([0,0,30]) translate([-12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,30]) translate([-12.7,20*3-16,0]) cylinder(d=10,h=8);
				
				translate([-kPlate_w/2+4,24,50]) cylinder(d=10,h=8);
				translate([-kPlate_w/2+4,30,50]) cylinder(d=10,h=8);
			} // hull
			/**/
			
			// Right arm
			hull(){
				rotate([0,0,-30]) translate([12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,-30]) translate([12.7,20*3-16,0]) cylinder(d=10,h=8);
				
				translate([kPlate_w/2-4,24,50]) cylinder(d=10,h=8);
				translate([kPlate_w/2-4,30,50]) cylinder(d=10,h=8);
			} // hull
			
		} // union
			
		for (j=[0:3]){
			rotate([0,0,-30]) translate([12.7,20*j-10,0]) rotate([0,180,0]) Bolt4Hole();
			rotate([0,0,30]) translate([-12.7,20*j-10,0]) rotate([0,180,0]) Bolt4Hole();}
			
			
		rotate([0,0,90])
			translate([0,0,44]) translate([0,-Shank_h/2-Wall_t,-Shank_w/2-Wall_t]) cube([Slide_L,Shank_h+Wall_t*2,Shank_w+Wall_t*2+Overlap]);
			
			/*
		rotate([0,0,90])
			translate([0,0,44]) {
				translate([-Overlap,-Shank_h/2,-Shank_w/2]) cube([Slide_L+Overlap*2,Shank_h,Shank_w]);
		
				translate([Slide_L/2,0,-Shank_w/2-Wall_t-Overlap]) cylinder(d=3,h=Shank_w+Wall_t*2+Overlap*2);
				translate([Slide_L/2+10,0,-Shank_w/2-Wall_t-Overlap]) cylinder(d=3,h=Shank_w+Wall_t*2+Overlap*2);
				
				translate([0,0,Shank_w/4]) rotate([0,-90,0]) cylinder(d1=Spring_d+1,d2=Spring_d,h=1);
				translate([0,0,-Shank_w/4]) rotate([0,-90,0]) cylinder(d1=Spring_d+1,d2=Spring_d,h=1);
			}
			/**/
			
		
	} // difference

} // TrackTensionerMount

//translate([-64,0,0]) TrackTensionerMount();

module RockerEndSupport(){
	kPlate_w=16;
	
	difference(){
			
		hull(){
			cylinder(d=16,h=6);
			translate([-kPlate_w/2+4,24,0]) cylinder(d=10,h=6);
			translate([-kPlate_w/2+4,30,0]) cylinder(d=10,h=6);
			translate([kPlate_w/2-4,24,0]) cylinder(d=10,h=6);
			translate([kPlate_w/2-4,30,0]) cylinder(d=10,h=6);
		} // hull
		
		translate([0,0,6]){
				translate([-kPlate_w/2+4,24,0]) Bolt4ButtonHeadHole(depth=8);
				translate([-kPlate_w/2+4,30,0]) Bolt4ButtonHeadHole(depth=8);
				translate([kPlate_w/2-4,24,0]) Bolt4ButtonHeadHole(depth=8);
				translate([kPlate_w/2-4,30,0]) Bolt4ButtonHeadHole(depth=8);
			}
			
		translate([0,0,-Overlap]) cylinder(d=6.35,h=10);
	} // difference

} // RockerEndSupport

//RockerEndSupport();

// old code
module SpanBolsterMount(){
	kSpanBOffset=20;
	kSpanBThickness=46;
	
	difference(){
		union(){
			cylinder(d=40,h=kSpanBOffset-10);
			cylinder(d=25,h=kSpanBOffset-2);
			
			cylinder(d=16,h=kSpanBOffset);
			
			hull(){
				rotate([0,0,-30]) translate([12.7,20*3-10,0]) cylinder(d=10,h=8);
				cylinder(d=40,h=8);
			} // hull
			hull(){
				rotate([0,0,30]) translate([-12.7,20*3-10,0]) cylinder(d=10,h=8);
				cylinder(d=40,h=8);
			} // hull
			
			//*
			hull(){
				rotate([0,0,30]) translate([-12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,30]) translate([-12.7,20*2-10,0]) cylinder(d=10,h=8);
				
				translate([-10,20,kSpanBOffset-2+kSpanBThickness-Overlap]) cylinder(d=10,h=Overlap);
				translate([-10,30,kSpanBOffset-2+kSpanBThickness-Overlap]) cylinder(d=10,h=Overlap);
			} // hull
			/**/
			
			hull(){
				rotate([0,0,-30]) translate([12.7,20*3-10,0]) cylinder(d=10,h=8);
				rotate([0,0,-30]) translate([12.7,20*2-10,0]) cylinder(d=10,h=8);
				
				translate([10,20,kSpanBOffset-2+kSpanBThickness-Overlap]) cylinder(d=10,h=Overlap);
				translate([10,30,kSpanBOffset-2+kSpanBThickness-Overlap]) cylinder(d=10,h=Overlap);
			} // hull
			
			translate([0,0,kSpanBOffset-2+kSpanBThickness-8])
			hull(){
				translate([-10,20,0]) cylinder(d=10,h=8);
				translate([-10,30,0]) cylinder(d=10,h=8);
				translate([10,20,0]) cylinder(d=10,h=8);
				translate([10,30,0]) cylinder(d=10,h=8);
			} // hull
		} // union
		
		//translate([0,0,kSpanBOffset-2+kSpanBThickness-10]) rotate([-90,0,0]) cylinder(d=14.5,h=50);
		
		
		translate([0,0,kSpanBOffset-2+kSpanBThickness])
			{
				translate([-10,20,0]) Bolt4Hole();
				translate([-10,30,0]) Bolt4Hole();
				translate([10,20,0]) Bolt4Hole();
				translate([10,30,0]) Bolt4Hole();
			}
			
		for (j=[0:3]){
			rotate([0,0,-30]) translate([12.7,20*j-10,0]) rotate([0,180,0]) Bolt4Hole();
			rotate([0,0,30]) translate([-12.7,20*j-10,0]) rotate([0,180,0]) Bolt4Hole();}
			
		translate([0,0,-Overlap]) cylinder(d=12.7,h=kSpanBOffset+Overlap*2);
	} // difference

} // SpanBolsterMount

//SpanBolsterMount();

module Spocket9(){
	nBolts=4;
	BC_d=16;
	
	translate([0,-8.5,0])  // put back of wheel on zero
	difference(){
		union(){
			Teeth(nTeeth=9);
			rotate([90,0,0]) translate([0,0,-8.5]) cylinder(d=65.3,h=15.4);
		} // union
		
		rotate([90,0,0]) translate([0,0,-6.0]) cylinder(d=60.5,h=15.4);
		rotate([90,0,0]) translate([0,0,-9.0]) cylinder(d=9.5,h=5);
		
		rotate([90,0,0])
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BC_d/2,0,0]) Bolt4ClearHole();
	} // difference
} // Spocket9

//Spocket9();
	
SP10_Inset=9;

module TrackSprocket(ShowTeeth=$preview){
	Sprocket_h=SP10_Inset;
	nTeeth=10;
	
	AxilInset=(ToothSpacing-AxilLen)/2;
	


	// Track teeth
	difference(){
		rotate([-90,0,0])
			ToothHoldingDisk(nTeeth=nTeeth,Thickness=Sprocket_h,ShowTeeth=ShowTeeth)
				Bolt4Hole();
		
		translate([0,0,-Sprocket_h-Overlap]) cylinder(d1=38,d2=42,h=Sprocket_h+Overlap*2);
		
	} // difference
	
	difference(){
		union(){
			translate([0,0,-Sprocket_h]) cylinder(d1=14,d2=12,h=Sprocket_h);
			for (j=[0:nTeeth-1]) rotate([0,0,360/nTeeth*j]) hull(){
				translate([0,0,-Sprocket_h]) cylinder(d=3,h=1);
				translate([0,0,-1]) sphere(d=2);
				
				translate([21,0,-Sprocket_h]) cylinder(d=3,h=1);
				translate([21,0,-1]) sphere(d=2);
			} // hull
		} // union
		
			translate([0,0,-AxilInset-Overlap]) cylinder(d1=6.35,d2=3,h=1);
			translate([0,0,-AxilInset]) rotate([180,0,0]) cylinder(d=6.35,h=Sprocket_h);
				Bolt4ClearHole();
	} // difference
} // TrackSprocket

//TrackSprocket();

module ShowRocker(){
translate([0,ToothSpacing/2,0]) rotate([-90,0,0]) TrackSprocket();
translate([0,-ToothSpacing/2,0]) rotate([90,0,0]) TrackSprocket();
translate([0,-ToothSpacing/2+SP10_Inset+0.5+4.1,0]) rotate([90,0,0]) RockerArm(Len=110,Angle=30);
translate([-95.2,ToothSpacing/2-SP10_Inset-0.5-4.1,0]) rotate([0,0,180]) rotate([90,0,0]) RockerArm(Len=110,Angle=30);
}

module CenterSpan(Span_l=182){
	
	Bolster_w=9;
	Arches_w=8;
	EndBearingInset=2;
	Pivot_z=36;
	
	/*
	module Arches(){
		// 170mm
		// upper Arch
				translate([78,Pivot_z-55,Arches_w/2])
				rotate([0,0,86]) translate([-23,0,0]) rotate_extrude(angle=62,$fn=$preview? 90:360) translate([90,0,0]){
					circle(d=Arches_w,$fn=$preview? 36:90);
					translate([-Arches_w/2,-Arches_w/2,0]) square([Arches_w,Arches_w/2]);
				}
				
				// lower Arch
				translate([70,Pivot_z-55,Arches_w/2])
				rotate([0,0,80]) translate([-34,0,0]) rotate_extrude(angle=62,$fn=$preview? 90:360) translate([80,0,0]){
					circle(d=Arches_w,$fn=$preview? 36:90);
					translate([-Arches_w/2,-Arches_w/2,0]) square([Arches_w,Arches_w/2]);
				}
	} // Arches
	/**/
	
	module Arches(){
		// upper Arch
			translate([82,Pivot_z-65,Arches_w/2])
			rotate([0,0,86]) translate([-24,0,0]) rotate_extrude(angle=62,$fn=$preview? 90:360) translate([100,0,0]){
				circle(d=Arches_w,$fn=$preview? 36:90);
				translate([-Arches_w/2,-Arches_w/2,0]) square([Arches_w,Arches_w/2]);
			}
			
			// lower Arch
			translate([76,Pivot_z-65,Arches_w/2])
			rotate([0,0,80]) translate([-33,0,0]) rotate_extrude(angle=62,$fn=$preview? 90:360) translate([90,0,0]){
				circle(d=Arches_w,$fn=$preview? 36:90);
				translate([-Arches_w/2,-Arches_w/2,0]) square([Arches_w,Arches_w/2]);
			}
	} // Arches
	
	difference(){
		union(){
			
			Arches();
	
			translate([Span_l,0,0]) mirror([1,0,0]) Arches();
					
			cylinder(d=Bearing_d+5,h=Bolster_w);
				translate([Span_l/2,Pivot_z,0]) cylinder(d=Bearing_OD+5,h=Bolster_w);
			translate([Span_l,0,0]) cylinder(d=Bearing_d+5,h=Bolster_w);
		} // union
		
		translate([0,0,-Overlap]) cylinder(d=Bearing_d,h=Bearing_w+EndBearingInset);
		cylinder(d=Bearing_d-1,h=Bolster_w+Overlap);
		
		
		translate([Span_l/2,Pivot_z,0]){
			translate([0,0,-Overlap]) cylinder(d=Bearing_OD,h=BEaring_w);
			cylinder(d=Bearing_OD-1,h=Bolster_w+Overlap);
		}
		
		translate([Span_l,0,0]){
			translate([0,0,-Overlap]) cylinder(d=Bearing_d,h=Bearing_w+EndBearingInset);
			cylinder(d=Bearing_d-1,h=Bolster_w+Overlap);
		}
	} // difference
	
	
	
	
} // CenterSpan

//CenterSpan();

//translate([0,4,0]) rotate([0,30,0]) translate([-97/2,0,0]) rotate([0,-30,0]) rotate([90,0,0]) CenterSpan();

module TensionArm(ArmLen=100,Outside=true){
	HalfWidth=12;
	BearingPushOut=4.1;
	Top_d=3;
	
	ArmBackHeight=2;
	ArmWidth=25;
	ArmHWidth=8;
	ArmHHeight=HalfWidth;
	
	Shaft_d=12.7;
	
	translate([0,0,-HalfWidth]) 
	difference(){
		union(){
			cylinder(d=Bearing_d+5,h=HalfWidth);
				
			translate([ArmLen,0,0]) cylinder(d=12.7+5,h=ArmHHeight);
			
			// base plate
			translate([Bearing_d/2+5,-ArmWidth/2,0]) cube([ArmLen-Bearing_d/2-5-Shaft_d/2-5,ArmWidth,ArmBackHeight]);
			
			// extend plate to the left
			hull(){
				translate([0,ArmHWidth/2,0]) cylinder(d=ArmHWidth,h=ArmBackHeight);
						
				translate([0,-ArmHWidth/2,0]) cylinder(d=ArmHWidth,h=ArmBackHeight);
				
				translate([Bearing_d/2+5,-ArmWidth/2,0]) cube([Overlap,ArmWidth,ArmBackHeight]);
			} // hull
			
			// extend plate to the right
			hull(){
				translate([ArmLen,ArmHWidth/2,0]) cylinder(d=ArmHWidth,h=ArmBackHeight);
						
				translate([ArmLen,-ArmHWidth/2,0]) cylinder(d=ArmHWidth,h=ArmBackHeight);
				
				translate([ArmLen-Shaft_d/2-5-Overlap,-ArmWidth/2,0]) cube([Overlap,ArmWidth,ArmBackHeight]);
			} // hull
			
			//*
			
			// Rail, -Y
			translate([Bearing_d/2+5,-ArmWidth/2+ArmHWidth/2,0]) {
				// connect to bearing at tension roller end
				hull(){
					 cylinder(d=ArmHWidth,h=ArmBackHeight);
					translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);
					
					translate([-Bearing_d/2-5,ArmWidth/2-(Bearing_d+5)/2,0]){
						cylinder(d=ArmHWidth,h=ArmBackHeight);
						translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);}
				} // hull
				
				// the rail
				hull(){
					cylinder(d=ArmHWidth,h=ArmBackHeight);
					translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);
					
					translate([ArmLen-Bearing_d/2-5-Shaft_d/2-5,0,0]) cylinder(d=ArmHWidth,h=ArmBackHeight);
					translate([ArmLen-Bearing_d/2-5-Shaft_d/2-5,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);
					} // hull
					
			} // translate
			
			// connect to bolster end
			translate([ArmLen-Shaft_d/2-5,-ArmWidth/2+ArmHWidth/2,0])
				hull(){
					cylinder(d=ArmHWidth,h=ArmBackHeight);
					translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);
					
					translate([Shaft_d/2+5,ArmWidth/2-(Bearing_d+5)/2,0]){
						cylinder(d=ArmHWidth,h=ArmBackHeight);
						translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);}
				} // hull
				
			/**/
			
			// Rail, +Y
			translate([Bearing_d/2+5,ArmWidth/2-ArmHWidth/2,0]) {
				// connect to bearing at tension roller end
				hull(){
					cylinder(d=ArmHWidth,h=ArmBackHeight);
					translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);
					
					translate([-Bearing_d/2-5,-ArmWidth/2+(Bearing_d+5)/2,0]){
						cylinder(d=ArmHWidth,h=ArmBackHeight);
						translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);}
				} // hull
				
				// the rail
				hull(){
					cylinder(d=ArmHWidth,h=ArmBackHeight);
					translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);
					
					translate([ArmLen-Bearing_d/2-5-Shaft_d/2-5,0,0]) cylinder(d=ArmHWidth,h=ArmBackHeight);
					translate([ArmLen-Bearing_d/2-5-Shaft_d/2-5,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);
				} // hull
			} // translate
			
			// connect to bolster end
			translate([ArmLen-Shaft_d/2-5,ArmWidth/2-ArmHWidth/2,0])
				hull(){
					cylinder(d=ArmHWidth,h=ArmBackHeight);
					translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);
					
					translate([Shaft_d/2+5,-ArmWidth/2+(Bearing_d+5)/2,0]){
						cylinder(d=ArmHWidth,h=ArmBackHeight);
						translate([0,0,ArmHHeight-Top_d/2]) sphere(d=Top_d);}
				} // hull
			
		} // union
		
		// Bearing hole
		translate([0,0,-Overlap]) cylinder(d=Bearing_d-1,h=HalfWidth-Bearing_w+BearingPushOut+Overlap*2);
		translate([0,0,HalfWidth-Bearing_w+BearingPushOut]) cylinder(d=Bearing_d,h=Bearing_w+Overlap*2);
		
		// 1/2" Tube hole, rocker bogie
		translate([ArmLen,0,-Overlap]) cylinder(d=12.7,h=ArmHHeight+Overlap*2);
		
		BoltSpacing=30;
		
		if (Outside==true){
			for (j=[0:floor((ArmLen-25)/BoltSpacing)]) translate([Bearing_d/2+10+BoltSpacing*j,0,0]){
				translate([0,-ArmWidth/2+ArmHWidth/2,0]) rotate([180,0,0]) Bolt4Hole(depth=6);
				translate([0,ArmWidth/2-ArmHWidth/2,0]) rotate([180,0,0]) Bolt4Hole(depth=6);}
		} else {
			for (j=[0:floor((ArmLen-25)/BoltSpacing)]) translate([Bearing_d/2+10+BoltSpacing*j,0,0]){
				translate([0,-ArmWidth/2+ArmHWidth/2,ArmHHeight]) Bolt4HeadHole(depth=16);
				translate([0,ArmWidth/2-ArmHWidth/2,ArmHHeight]) Bolt4HeadHole(depth=16);}
		}
	} // difference
	
	translate([0,0,-HalfWidth]) 
	difference(){
		
		cylinder(d=Bearing_d+4,h=HalfWidth+BearingPushOut);
			
	
		// Bearing hole
		translate([0,0,-Overlap]) cylinder(d=Bearing_d-1,h=HalfWidth-Bearing_w+BearingPushOut+Overlap*2);
		translate([0,0,HalfWidth-Bearing_w+BearingPushOut]) cylinder(d=Bearing_d,h=Bearing_w+Overlap*2);
		
		
		
	} // difference
			
	
	
} // TensionArm
//TensionArm(ArmLen=220,Outside=true);
//TensionArm(ArmLen=220,Outside=false);

//translate([-148,5,96]) rotate([90,0,0]) rotate([0,0,-10]) TensionArm(ArmLen=200,Outside=true);
//translate([-148,29,96]) rotate([-90,0,0]) rotate([0,0,10]) TensionArm(ArmLen=200,Outside=false);

module MainBearing(){
	difference(){
		rotate([90,0,0]) cylinder(d=94,h=1);
		rotate([90,0,0]) translate([0,0,-Overlap]) cylinder(d=4,h=2);
	}
} // MainBearing

//translate([50,18+37.5,60+70]) MainBearing();


module Sprocket9Hub(Back_h=6){
	nBolts=4;
	BC_d=16;
	Sprocket_ID=9.4;
	Axil_d=6.35;
	
	translate([0,0,-Back_h])
	difference(){
		union(){
			cylinder(d=Sprocket_ID,h=Back_h+3);
			cylinder(d=BC_d+Bolt4Inset*2,h=Back_h);
		} // union
		
		// hub bolts
		for (j=[0:nBolts-1]) rotate([0,0,360/nBolts*j]) translate([BC_d/2,0,Back_h]) Bolt4Hole();
			
		// Axil
		translate([0,0,-Overlap]) cylinder(d=Axil_d,h=Back_h-1+Overlap);
		// taper for prinability
		translate([0,0,Back_h-1-Overlap]) cylinder(d1=Axil_d,d2=2,h=1);
		
		translate([0,0,Back_h+3]) Bolt4ClearHole();
	} // difference
	
} // Sprocket9Hub

//Sprocket9Hub();













