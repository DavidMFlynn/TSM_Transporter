
$fn=$preview? 24:90;
Overlap=0.05;

module Wall(X1=10,Y1=10,X2=10,Y2=20,Z=10,T=1){
	hull(){
		translate([X1,Y1,0]) cylinder(d=T,h=Z);
		translate([X2,Y2,0]) cylinder(d=T,h=Z);
	}
} // Wall

module CurvedWall(Start_a=-10, Stop_a=10, R=50, Z=10, T=1){
	Inc_a=1;
	for (j=[Start_a:Inc_a:Stop_a-Inc_a]) hull(){
		rotate([0,0,j]) translate([-R,0,0]) cylinder(d=T,h=Z);
		rotate([0,0,j+Inc_a]) translate([-R,0,0]) cylinder(d=T,h=Z);
	}
}
Width=100;
Thickness=1;
Rot_a=0; //-22.5;

CurvedWall(Start_a=-12, Stop_a=12, R=Width/2, Z=10, T=Thickness);
rotate([0,0,min(max(-Rot_a/2,-5),5)]) CurvedWall(Start_a=6, Stop_a=26, R=Width/2+1.5*Thickness, Z=10, T=Thickness);
rotate([0,0,max(min(Rot_a/2,5),-5)]) CurvedWall(Start_a=-26, Stop_a=-6, R=Width/2+1.5*Thickness, Z=10, T=Thickness);
rotate([0,0,min(max(-Rot_a/1.4,-13),13)]) CurvedWall(Start_a=16, Stop_a=36, R=Width/2+3*Thickness, Z=10, T=Thickness);
rotate([0,0,max(min(Rot_a/1.4,13),-13)]) CurvedWall(Start_a=-36, Stop_a=-16, R=Width/2+3*Thickness, Z=10, T=Thickness);

module End1(){
	Wall(X1=-Width/2,Y1=0,X2=-Width/2,Y2=20,Z=10,T=1);
	Wall(X1=Width/2,Y1=0,X2=Width/2,Y2=20,Z=10,T=1);
} 


 rotate([0,0,Rot_a]) translate([0,22,0]) End1();
mirror([0,1,0]) rotate([0,0,Rot_a]) translate([0,22,0]) End1();