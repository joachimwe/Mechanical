/*
Medium sized (sub 250g) copter

(c) 2017 Fabian Huslik

https://github.com/fabianhu/
*/ 

use <libCopterParts.scad>

$fn=24;

campos = [0,10,27];

lower_angle = 30;
upper_angle = 50;

CoverThickness = 0.6;

module Standoffs (sq,h){

	l = sq/2;
	for(i = [ 
	        // [  l,   l,  0],
	         [ l, -l, 0],
	        // [-l,  l, 0],
	         [-l,  -l, 0] ])
	{
		difference()
		   {     
			translate (i) cylinder(h,d=7, $fn=30);
			translate (i) cylinder(h,d=2.1, $fn=30);
		   }
	}   

}

module copy_mirror(vec=[0,1,0])
{
    children();
    mirror(vec) children();
}

module LowerStandoff(){
    h=3.5;
    hull()
    {
        for(i = [ 
                 [  10,   10,  0],
                 [ 10, -10, 0],
                 [-10,  10, 0],
                 [-10,  -10, 0] ])
        {
            difference()
               {     
                translate (i) cylinder(h,d=15, $fn=30);
                translate (i) cylinder(h,d=2.1, $fn=30);
               }
        }   
    }
    
    dh=5;
    // translate ([15.75,0,dh/2]) cube([3.5,27,dh],center=true);
    // translate ([-15.75,0,dh/2]) cube([3.5,27,dh],center=true);

}



module BODY2() 
{
	lb= 23; // top piece length
	wb= 23; // top piece width
	h=7; // top piece height offset
	r= 4; // top piece radius
    ht= 5; // top piece thickness

	difference()
    {
        union()
        {
            hull() // inner top piece
            {
                w= (wb-r)/2;
                d = (lb-r)/2;
                for(i = [ 
                         [  w,   d,  8.5],
                         [ w, -d, 8.5],
                         [-w,  d, 8.5],
                         [-w,  -d, 8.5] ])
                {
                    translate (i) cylinder(h=ht,r=r, $fn=30);
                }  
                translate(campos) rotate([0,90,0]) cylinder(d=6,h=26,center=true);
               
            }
        
                
            
            translate([0,0,2.5+1])  Standoffs(20,5);  // rear upper
            translate([0,20,2.5+1])  Standoffs(20,5); // front upper
            translate([0,0,0])  LowerStandoff();
            
        } // end body		
		
		STUFF(true); // remove all inner stuff
		
		// bolt holes (thread)
		for(i = [ 
		         [  10,   10,  0],
		         [ 10, -10, 0],
		         [-10,  10, 0],
		         [-10,  -10, 0] ])
		{
			translate (i) cylinder(h=9+7,d=1.75, $fn=30);
		}
        
        		// bolt holes (free)
		for(i = [ 
		         [  10,   10,  0],
		         [ 10, -10, 0],
		         [-10,  10, 0],
		         [-10,  -10, 0] ])
		{
			translate (i) cylinder(9.5,d=2.25, $fn=30);
		}
        
        //cylinder(h=12,d=22); // inner lightness
	
       
    }
}

module ProtectorRing()
{
    translate(campos)  rotate([-90+(lower_angle+upper_angle)/2,0,0]) translate([0,0,9]) cylinder(d=20,h=5,center=true); // Protector ring
}


module innerCover()
{
    lr=7.5+7.5; 
    
    hull() // cam support
            {
              LowerStandoff();  
                translate(campos) rotate([0,90,0]) cylinder(d=6,h=26,center=true);
                ProtectorRing();
                
                 translate(campos)  rotate([30,0,0]) translate([0,-10,1]) minkowski(){cube([17,21,15],center=true);sphere(3);} // cam extension
                
            }
}

module COVER()
{
    //color("lightblue")
    difference(){
    union()
    {difference()
    { minkowski()
        {innerCover();
            sphere(CoverThickness);}
            innerCover();
            translate([0,0,-1.5])cube([100,100,3],center=true); // remove lower skin
           
            //LowerStandoff(); // already in?
        }
        ProtectorRing();
    }
         STUFF(true);
            BODY2(); 
}
}

module FRAME()
{
    translate([0,0,-1])
   union(){ 
    difference(){
        cube([37+10,37+10,2],center=true);
        r=10;
        for(i=[0,90,180,270])
        {
            rotate([0,0,i]) translate([0,-37/2-r,0]) cylinder(r=r,h=3,center=true);
        }
    }
        for(i=[0,90,180,270])
        {
            
            rotate([0,0,i+45]) 
            translate([50,0,0]) cube([70,20,2],center=true);
        }
    }
}


module STUFF(exp=false)
{
    translate([0,0,3.5]) ESC20x20(exp);
    translate([0,0,8.5]) OMNIBUS20x20(exp);

    union(){
        for(i=[lower_angle:10:upper_angle])
            {
                translate(campos)  rotate([-90+i,0,0]) RUNCAM_SWIFT(exp);
        }       
    }
    if(exp)
    {
        //translate(campos) rotate([(lower_angle+upper_angle)/2,0,0]) translate([0,-10,0])  cube([19,25,19],center=true); // cam access
//        translate(campos) rotate([0,0,0]) translate([0,-(campos.y),-10])  cube([19,19,19],center=true); // cam access
    }
    //translate([-5,-5,13])  rotate([0,0,0])TX_MM213TL(); // runcam has TX !
    translate([0,-7,17]) rotate([45,0,0]) BEEPER(exp);

    translate([-2,-4,12.8]) rotate([0,0,90]) RX_XMPLUS(exp);

    for(i=[45:90:360])
    {
          //rotate([0,0,i])  translate([75,0,0]) motor1807();
    }

     // lower bolts
    translate([0,0,1.75])
    copy_mirror([1,0,0]) 
    for(i = [ 
     [  17.5,   8,  0],
     [ 17.5, -8, 0]])
    {
        translate (i) rotate([0,90,0]) cylinder(h=15,d=1.75, $fn=30,center=true);
        translate (i) rotate([0,90,0]) translate([0,0,3]) cylinder(h=6,d=2.2, $fn=30,center=true);
    }
    
    color("grey") translate([0,0,1]) cube([60,12,2],center=true); // Velcro


}

//STUFF(false);

//rotate([-90-(lower_angle+upper_angle)/2,0,0])
BODY2();  

//color("lightblue") 
translate([50,0,0]) COVER();

//FRAME();


