/*
Indoor Copter
1103 motors

(c) 2017 Fabian Huslik

https://github.com/fabianhu/
*/ 

$fn = 60;
radius = 25.7+0.25; // propeller radius
thick = 0.8; // rest body thickness
fthick = 0.8; // fin thickness
trad = 3; // intake aerodynamic radius
height = 18-4; //height of tunnel
//dxy = 60/2;
dx=63;
dy=60;

star = true; // star - stack config

campos=[0,55,-2];

ang = 25; // fin angle
dlt=2.5; // fin height

drawstuff=false;

use <libCopterParts.scad>;

// helper to morror while keeping the original.
module copy_mirror(vec=[0,1,0])
{
    children();
    mirror(vec) children();
}

module thinwall_out(n=2)
{
    difference()
    {
        minkowski()
        {
            children();
            sphere(n);
        }
        children();
    }
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
            }

            translate([0,0,-height+cos(ang)*dlt+thick/2]) 
            for(i=[0:360/rdiv:359])
            {
                rotate([0,0,i+zer]) translate([rot>0?4:-4,0,0]) rotate([90,90-rot,0]) Fin();
            }
            translate([0,0,-height]) cylinder(d=15+thick,h=5); // motor carrier
            
            
        }
        translate([0,0,-height+thick]) rotate([0,0,zer-90]) motor1103(true);
        
        
    }
    //translate([0,0,-height+thick*2]) rotate([0,0,zer-90]) motor1103(true);
}

module Fin()
{
    hull()    
    {
        translate([dlt,0,0]) cylinder(d=fthick,h=radius);
        translate([-dlt,0,0]) cylinder(d=fthick,h=radius);
    }
} 

module torus()
{
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

module STUFF(exp=false)
{
    translate(campos) rotate([-90+30,0,0]) CAMERA(exp);

    dwn = height - 14;
        
    if(star) // star - stack config
    {
        translate([-16,0,-3.5-dwn]) rotate([90,0,0]) ESC16x16(exp);
        translate([16,0,-3.5-dwn]) rotate([90,0,180]) ESC16x16(exp);
        translate([-1,13,-3.5-dwn]) rotate([0,-90,180]) REVO16x16(exp);
        translate([0,-10,-5-dwn]) rotate([-90,0,90]) RX_XM(exp);
    }
    else
    {
        translate([0,0,-11-dwn])   rotate([0,0,0]) ESC16x16(exp);
        translate([0,0,-6.5-dwn]) rotate([0,0,180]) ESC16x16(exp);
        translate([0,0,-2-dwn])  rotate([0,0,180]) REVO16x16(exp);
        translate([0,0,2.5-dwn]) rotate([0,0,0]) RX_XM(exp); 
    }
    translate([0,-30,-4]) rotate([-90,-90,90]) TX_MM213TL(exp);

   
    
     if(drawstuff)
     {   
        translate([dxy,dxy,0]) translate([0,0,-height+thick*2]) rotate([0,0,0]) motor1103(exp);
        translate([-dxy,dxy,0]) translate([0,0,-height+thick*2]) rotate([0,0,0]) motor1103(exp);
        translate([dxy,-dxy,0]) translate([0,0,-height+thick*2]) rotate([0,0,0]) motor1103(exp);
        translate([-dxy,-dxy,0]) translate([0,0,-height+thick*2]) rotate([0,0,0]) motor1103(exp);
     } 
}

//cylinder(d=95,h=10);

hcap = 8;

module InnerCenter()
{
    !difference()
    {
        union()
        {
            translate([0,0,-height/2]) cube([dx+10,dy,height],center=true); // floor
            translate([dx/2+3,0,-height/2]) cube([5,8,height],center=true); // right
            translate([-dx/2-3,0,-height/2]) cube([5,8,height],center=true); // left
            
            translate([0,dy/2+15,-height/2]) cube([15,30,height],center=true); // front end
            translate([0,-dy/2-6,-height/2]) cube([12,12,height],center=true); // back end
            
            translate([0,0,hcap/2-thick]) rotate([0,0,0]) cylinder(d2=53-thick*2,d1=70,h=hcap-thick,center=true,$fn=4); // top
                
      
            //translate([0,-52,6.5]) rotate([30,0,0]) translate([0,0,-10]) cylinder(d=6,h=10); // antenna supp
            //translate([0,-50,0]) rotate([0,0,0]) translate([0,0,0]) cylinder(d=7,h=8,center=true); // TX cap supp
            //translate([0,dxy+5,2]) rotate([90,0,0]) translate([0,0,0]) cylinder(d=8,h=24,center=true);  // front

            //translate([0,-dxy-4.5,2+0.5]) rotate([90,0,0]) translate([0,0,-2]) cylinder(d=9,h=20,center=true); //back
            
            //translate([dxy,0,0]) rotate([0,90,0]) translate([0,0,0]) cylinder(d=8,h=10,center=true); 
            //translate([-dxy,0,0]) rotate([0,90,0]) translate([0,0,0]) cylinder(d=8,h=10,center=true); 
        }
        
         // clear out prop range
         translate([0,0,-height-1]) 
         copy_mirror([1,0,0]) copy_mirror([0,1,0]) translate([dx/2,dy/2,0]) cylinder(r=radius+thick,h=30);
    
        
      
    }
}

module CapRemover()
{
    translate([0,0,25+2+1]) rotate([0,0,0]) cube(50,center=true); // main cap
    translate([0,25,5+3]) rotate([0,0,0]) cube([6,40,10],center=true); // front mini extension
    
    translate(campos) rotate([30,0,0]) translate([0,0,7.5]) cube([12.5,18,15],center=true); // cam cap
    
    translate([0,-25,5+3]) rotate([0,0,0]) cube([6,40,10],center=true); // back mini extension
}

module body_old()
{
    difference()
    {
        union()
        {
            translate([dxy,dxy,0]) completeRing(ang,0);
            translate([-dxy,dxy,0]) completeRing(-ang,0);
            translate([dxy,-dxy,0]) completeRing(-ang,180);
            translate([-dxy,-dxy,0]) completeRing(ang,180);
            
            Center();
            
            translate(campos) rotate([-90+30,0,0]) cylinder(h=7.5,d=13);// reinforce cam cylinder
            translate(campos) translate([0,-5,1]) rotate([0,0,0]) cylinder(h=5,d=15);// reinforce cam
            
            
        }
        STUFF(true);    
        
        Cabling();
    }
    
    
}

module body()
{
    difference()
    {
        union()
        {
             copy_mirror([1,0,0]) copy_mirror([0,1,0]) translate([dx/2,dy/2,0]) completeRing(ang,0);
             minkowski()
            {
                InnerCenter();
                cube(thick);
                }
            
        }
        InnerCenter();
        STUFF(true);    
        
        //Cabling();
    }
    
    
}


module Cabling()
{
    translate([dxy,0,-height+4]) rotate([90,0,0]) cylinder(d=4,h=dxy*2-30,center=true);
    translate([-dxy,0,-height+4]) rotate([90,0,0]) cylinder(d=4,h=dxy*2-30,center=true);
    translate([0,1,-height+3]) rotate([90,0,0]) translate([0,0,-1]) cylinder(d=5,h=43); // back
    translate([0,0,-height+2]) rotate([-90+10,0,0]) translate([0,0,-1]) cylinder(d=5,h=50); // front
    
    translate([0,35,-5]) rotate([0,0,0]) translate([0,0,0]) cube([4,25,height],true); // front
    
    
    //translate([0,-50,6.5]) rotate([30,0,0]) cylinder(d=32,h=17); // antenna
    //translate([0,-50,6.5]) rotate([30,0,0]) translate([0,0,-10]) cylinder(d=4,h=12); // antenna wire
    //translate([0,-50,6.5-4]) rotate([60,0,0]) translate([0,0,-15]) cylinder(d=4,h=12); // antenna wire
}

if(drawstuff)
{
union()
{
STUFF(true);
Cabling();
}
}
//

//color("lightgreen",0.3) translate([0,0,-height-15/2]) rotate([0,0,0]) cube([16,40,15],center=true);
/*
difference()
{
    body();
    CapRemover();
}
    
translate([100,0,5])
rotate([180,0,0])
intersection()
{
    body();
    CapRemover();
}

*/

body();
//STUFF(true);


