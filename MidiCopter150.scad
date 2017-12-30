/*
Medium sized (sub 250g) copter

(c) 2017 Fabian Huslik

https://github.com/fabianhu/
*/ 

use <libCopterParts.scad>

$fn=24;

campos = [0,12,28];

lower_angle = 30;
upper_angle = 30;

CoverThickness = 0.6;

module copy_mirror(vec=[0,1,0])
{
    children();
    mirror(vec) children();
}

module copy_rotate(vec=[0,90,0])
{
    children();
    rotate(vec) children();
}

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



module LowerStandoff(){
    h=3.5;
 
    for(i = [ 
             [  10,   10,  0],
             [ 10, -10, 0],
             [-10,  10, 0],
             [-10,  -10, 0] ])
    {
        difference()
           {     
            translate (i) cylinder(h,d=7, $fn=30);
            translate (i) cylinder(h,d=2.1, $fn=30);
           }
    }   
    
    
    dh=5;
    // translate ([15.75,0,dh/2]) cube([3.5,27,dh],center=true);
    // translate ([-15.75,0,dh/2]) cube([3.5,27,dh],center=true);

}


module BODY() 
{
	lb= 23; // top piece length
	wb= 23; // top piece width
	h=7; // top piece height offset
	r= 3; // top piece radius
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
                translate(campos) rotate([0,90,0]) cylinder(d=6,h=24,center=true);
               
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


InnerCoverPillarDia = 12;

module innerCover(rem=false)
{
    h=10;
    
    hull() 
        {
                translate(campos) rotate([0,90,0]) cylinder(d=6,h=10+10+9,center=true); // cam support cylinder
                translate(campos)  rotate([-90+(lower_angle+upper_angle)/2,0,0]) translate([0,0,7.5-1]) cylinder(d=16,h=4,center=true); // Protector ring
                
                 translate(campos)  rotate([(lower_angle+upper_angle)/2-10,0,0]) translate([0,-10,-0.5]) 
            minkowski(){
            cube([18,24,18],center=true);
            cube(2);
            } // cam extension

        copy_mirror([0,1,0]) copy_mirror([1,0,0]) translate ([10, 10, 0]) cylinder(h=h,d=rem?8:InnerCoverPillarDia, $fn=12);


        }
        if(rem)
        {
               rotate([0,0,45]) copy_rotate([0,0,90]) copy_mirror([0,1,0]) translate([0,52.6/2+2.4,0]) cylinder(h=6,d=2.6, $fn=12);  
                rotate([0,0,45]) copy_rotate([0,0,90]) copy_mirror([0,1,0]) translate([0,52.6/2+2.4,3.0]) cylinder(h=6,d=5.5, $fn=6);  
            rotate([0,0,45]) copy_rotate([0,0,90]) copy_mirror([0,1,0]) translate([0,52.6/2+2.4,4.0]) cylinder(h=6,d1=5.5,d2=16, $fn=30);
            
        }
}

module CoverBase()
{
    hzyl = 10;
    dzyl = InnerCoverPillarDia;
    
    union() 
    {                  
        hull() // four cylinders
        {
            copy_mirror([0,1,0]) copy_mirror([1,0,0]) translate ([10, 10, 0]) cylinder(h=hzyl,d=dzyl, $fn=12);
        }
        copy_rotate([0,0,90]) copy_rotate([0,0,90]) copy_rotate([0,0,90]) 
        hull()
        {
            translate ([10, 10, 0]) cylinder(h=hzyl,d=dzyl, $fn=12);
     
            rotate([0,0,-45]) translate([0,52.6/2+2.4,0]) cylinder(h=3,d=5, $fn=12);
        }
            }
  
}

module COVER()
{
    difference()
    {
        union()
        {
            CoverBase();
            minkowski()
            {
                innerCover(false);
                sphere(1);
            }
            translate([0,18,7.5]) rotate([0,90,0]) cylinder(d=5,h=32,center=true); // front stiffener
            translate([0,-15.5,7.5]) rotate([0,90,0]) cylinder(d=5,h=31,center=true); // back stiffener
            
            translate(campos)  rotate([-90+(lower_angle+upper_angle)/2,0,0]) translate([0,0,7.5+2.75]) cylinder(d1=19,d2=19,h=3,center=true); // Protector ring
        }   
        innerCover(true);
        STUFF(true); 
        translate([0,0,-2+0.001]) cube([100,100,4],true); // remove lower skin
        translate([0,0,3])cube([19,100,6],center=true); // remove space for wiring

    }
}

module FRAME()
{
    translate([0,0,-1])
   union(){ 
    difference()
    {
        cube([37+10,37+10,2],center=true);
        union()
        {
                rad=10;
                copy_rotate([0,0,90]) copy_mirror([1,0,0]) translate([(36.7+rad*2)/2,0,0]) cylinder(r=rad,h=2.1,center=true);
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
    translate([0,0,3.5]) rotate([0,0,0]) ESC20x20(exp);
    translate([0,0,8.5]) OMNIBUS20x20(exp);

    union(){
        for(i=[lower_angle:5:upper_angle])
            {
                translate(campos)  rotate([-90-i,180,0]) RUNCAM_SWIFT(exp);
        }       
    }
    
    translate([-4,-8,16]) rotate([45,0,0]) BEEPER(exp);

    translate([-2.1,-2,12.5]) rotate([180,0,90]) RX_XMPLUS(exp);

    for(i=[45:90:360])
    {
          //rotate([0,0,i])  translate([75,0,0]) motor1807();
    }

  
    
    color("grey") translate([0,0,1]) cube([60,12,2],center=true); // Velcro
    
    cylinder(d=19,h=25,center=false);

}


difference()
{
    union()
    {


//translate([50,0,0]) STUFF(false);
//FRAME();

//rotate([-90-(lower_angle+upper_angle)/2,0,0])

translate([50,0,0]) BODY();  

//color("lightblue")
COVER();
    }
    
        //color("blue") translate([50,0,0]) cube([100,100,100],center=true); // Velcro
    
    }
//



