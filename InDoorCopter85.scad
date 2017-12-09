/*
Indoor Copter
1103 motors

(c) 2017 Fabian Huslik

https://github.com/fabianhu/
*/ 

$fn = 60;
radius = 2 * (25.4/2)+0.5; // propeller radius
echo("Prop radius: ",radius);
thick = 0.7; // rest body thickness
fthick = 0.7; // fin thickness
trad = 3.0; // intake aerodynamic radius
height = 16; //height of tunnel

dx=radius*2+2*thick+13;
dy=radius*2+2*trad-2*thick+0.3;



campos=[0,42,-5.3];

ang = 25; // fin angle
dlt=2.5; // fin height

drawstuff=true;

use <libCopterParts.scad>;

// helper to morror while keeping the original.
module copy_mirror(vec=[0,1,0])
{
    children();
    mirror(vec) children();
}


module completeRing(rot=0,zer=17){
rdiv =5;
    difference()
    {
        union()
        {
            torus();
            
            // outer cylinder
            translate([0,0,-height])
            difference()
            {
                union()
                {
                    cylinder(r=radius+thick,h=height);  // upper frame // 1=unten
                }
                translate([0,0,-1]) cylinder(r=radius,h=height+2);
                translate([0,-radius,4]) rotate([90,0,0]) cylinder(d=4,h=3,center=true); // cable bore
            }

            translate([0,0,-height+cos(ang)*dlt+thick/2]) 
            for(i=[0:360/rdiv:359])
            {
                rotate([0,0,i+zer]) translate([rot>0?4:-4,0,0]) rotate([90,90-rot,0]) Fin();
            }
            translate([0,0,-height]) cylinder(d=15+thick,h=5); // motor carrier
            
            
        }
        translate([0,0,-height+thick]) rotate([0,0,zer-90]) motor1103(true);
        
       /* for(i=[0:360/rdiv:359])
        {
            rotate([0,0,i+360/rdiv/2-8]) translate([radius,0,-height-10]) rotate([0,90,0]) cylinder(d=32,h=8,center=true);
        }*/
        
        // motor holder cutout
        for(i=[0:360/rdiv:359])
        {
            rotate([0,0,i+360/rdiv/2+5]) translate([6,0,-height+6]) rotate([0,90,0]) cylinder(d=7.5,h=5,center=true);
        }
        
    }
    //translate([0,0,-height+thick*2]) rotate([0,0,zer-90]) motor1103(true);
}


module Fin(){
    hull()    
    {
        translate([dlt,0,0]) cylinder(d=fthick,h=radius);
        translate([-dlt,0,0]) cylinder(d=fthick,h=radius);
    }
} 

module torus(){
    rotate_extrude(convexity = 5 )
    translate([radius+trad, 0, 0])
    difference()
    {
        circle(r = trad);
        translate([0,0]) circle(r = trad-thick);
        translate([-0.5,0]) square([5,5]);
        translate([-5,-10]) square([10,10]);
    }
}

FCpos= [-3,13+6,-3.2-height + 14];

module STUFF(exp=false)
{
    translate(campos) rotate([-90+30,0,0]) CAMERA(exp);

    dwn = height - 14;
        
    if(true) // star - stack config
    {
        //translate([-16,0,-3.5-dwn]) rotate([90,0,0]) ESC16x16(exp);
        copy_mirror([1,0,0]) translate([15,-0.5+3,-3.5-dwn]) rotate([90,0,180-17]) ESC16x16(exp);
        translate(FCpos) rotate([0,-90,180]) REVO16x16(exp);
        translate([-10,11,-5-dwn]) rotate([90,0,90-35]) RX_XM(exp);
    }
    else
    {
        translate([0,0,-11-dwn])   rotate([0,0,0]) ESC16x16(exp);
        translate([0,0,-6.5-dwn]) rotate([0,0,180]) ESC16x16(exp);
        translate([0,0,-2-dwn])  rotate([0,0,180]) REVO16x16(exp);
        translate([0,0,2.5-dwn]) rotate([0,0,0]) RX_XM(exp); 
    }
    translate([3,15+5,-4]) rotate([-90,-90,90]) TX_MM213TL(exp);

    
     if(drawstuff)
     {   
        copy_mirror([1,0,0]) copy_mirror([0,1,0]) translate([dx/2,dy/2,-height+thick*2]) rotate([0,0,-90]) motor1103(exp);
     } 
}

module BattHld()
{
    bs=[13,42,17.5];
    difference()
    {
        minkowski(){
            cube(bs,center=true);
            cube(thick*2,center=true);
        }
        cube(bs,center=true);
        translate([0,-22,0]) cube([15,2,19],center=true); // minus end
        
        translate([0,15,0])cylinder(d=10,h=20,center=true);        
        translate([0,1,0])cylinder(d=10,h=20,center=true);
        translate([0,-13,0])cylinder(d=10,h=20,center=true);

        
        translate([0,15,0]) rotate ([90,0,0]) cylinder(d=11,h=20,center=true);
        
        //translate([0,-12,0])rotate ([90,0,90])cylinder(d=15,h=20,center=true);
        translate([0,12,0])rotate ([90,0,90])cylinder(d=13,h=20,center=true);
    }
    
}

module body()
{
    // 4 fans
    copy_mirror([1,0,0]) copy_mirror([0,1,0]) translate([dx/2,dy/2,0]) completeRing(ang,0);
    
    // side support
    copy_mirror([1,0,0]) translate([dx/1.8,0,-height/2]) 
    union(){
        cube([thick,trad*1.8,height],center=true);
        translate([0,0,height/2])rotate([0,90,0]) cylinder(d=trad*1.8,h=thick,center=true);
    }
    
    // front support
    //translate([0,dy/1.75,-height/2]) cube([trad*1.65+10,thick,height],center=true);
    
    translate([0,-18,-6.8+0.25])BattHld();

    // floor
    difference()
    {
            translate([0,16,-height+thick/2-0.1]) cube([dx+8,dy-18,0.5],center=true);
            copy_mirror([1,0,0]) copy_mirror([0,1,0]) translate([dx/2,dy/2,-height-1])   cylinder(r=radius,h=2);
            translate([0,19,-height]) cylinder(h=2,d=13,center=true);
            translate([10,5,-height]) cylinder(h=2,d=11,center=true);
            translate([-10,5,-height]) cylinder(h=2,d=11,center=true);
    }
    
    // FC holder
    
    translate(FCpos)
    difference()
    {
    union()
    {
        translate([0.5,9,-8.5]) cube([4,4,4],true);
        translate([0.5,-9,-8.5]) cube([4,4,4],true);
        
        translate([-1,10.25,6]) rotate ([0,0,0]) cube([4,7,6],true);
        
    }
         translate([-1+2,10.25,7-2]) rotate ([0,45,0]) cube([4,7,10],true); 
            rotate([0,-90,180]) REVO16x16(true);
         translate([0.5,0,-8.5]) cube([1.2,20.6,4],true);
    }
    
    // cam holder
    translate(campos) rotate([-90+30,0,0]) 
    difference()
    {
       union()
       {
           translate([0,0,-5]) cube([15.2,14,4],true);
           translate([0,2,-8]) rotate([0,90,0]) cylinder(d=10,h=14.5,center=true);
           
       }
       CAMERA(true);
       
    }
    
    
    //STUFF(false);    

}




body();
    


