/*
Indoor Copter
1103 motors

(c) 2018 Fabian Huslik

https://github.com/fabianhu/
*/ 

$fn = 60;
radius = 2 * (25.4/2)+0.5; // propeller radius
echo("Prop radius: ",radius);
thick = 0.8; // rest body thickness
fthick = 0.8; // fin thickness
trad = 3.0; // intake aerodynamic radius
height = 13; //height of tunnel

dx=radius*2+2*thick+13+0.4;
dy=radius*2+2*trad-2*thick+0.3+2;



campos=[0,42,-5.3+3];

ang = 20; // fin angle
dlt=2.5; // fin height

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
            // outer cylinder
            translate([0,0,-height])
            difference()
            {
                translate([0,0,height])torus();
                translate([0,-radius,4-3]) rotate([90,0,0]) cylinder(d=3,h=3,center=true); // cable bore
            }

            translate([0,0,-height+cos(ang)*dlt+thick/2-0.3]) 
            for(i=[0:360/rdiv:359])
            {
                rotate([0,0,i+zer]) translate([rot>0?4:-4,0,0]) rotate([90,90-rot,0]) Fin();
            }
            translate([0,0,-height]) cylinder(d=15+thick*2,h=5); // motor carrier (bell diameter from motor)
            
        }
        translate([0,0,-height+thick]) rotate([0,0,zer-90]) motor1103(true);
        
    }
}


module Fin(){
    hull()    
    {
        translate([dlt,0,0]) cylinder(d=fthick,h=radius);
        translate([-dlt,0,0]) cylinder(d=fthick,h=radius);
    }
} 

module torus() // might not work for every thickness and trad.
{
    topdia = thick+0.7+0.5;
    
    rotate_extrude(convexity = 5 )
    translate([radius+trad, 0, 0])
    hull() // roundness at top
    {
        translate([-trad,-height])square([thick,height]);
        circle(r = trad);
    }
}

FCpos= [-3,13+6,-3.2-height + 14];

module STUFF(exp=false)
{
    translate(campos) rotate([-90+30,0,0]) 
    union()
    {
        CAMERA(exp);
        if(exp)
        translate([0,0,-11]) cube([13,13,10],center=true); // room to install cam
    }
    dwn = height - 14;
        
    if(true) // star - stack config
    {
        copy_mirror([1,0,0]) translate([15+1,-0.5+3+0.5,-3.5-dwn]) rotate([90,0,180-15]) ESC15x15(exp);
        translate(FCpos) rotate([0,-90,180]) REVO16x16(exp);
        translate([-10,10,-5-dwn]) rotate([-90,0,90-35]) RX_XM(exp);
    }
    else
    {
        translate([0,0,-11-dwn])   rotate([0,0,0]) ESC16x16(exp);
        translate([0,0,-6.5-dwn]) rotate([0,0,180]) ESC16x16(exp);
        translate([0,0,-2-dwn])  rotate([0,0,180]) REVO16x16(exp);
        translate([0,0,2.5-dwn]) rotate([0,0,0]) RX_XM(exp); 
    }
    translate([2,15+5.5,-3]) rotate([0,-90,180]) TX_MM213TL(exp);

    
     if(exp)
     {   
        copy_mirror([1,0,0]) copy_mirror([0,1,0]) translate([dx/2,dy/2,-height+thick*2]) rotate([0,0,-90]) motor1103(exp);
     } 
}

BattSize=[13,42+8,17.5];

module Battery()
{
    BattRad=1.5;
    minkowski(){
    translate([0,-4,0])cube(BattSize-[BattRad,BattRad,BattRad],center=true);
    sphere(BattRad/2);
        }
    
}


module BattHld()
{
    
    difference()
    {
        minkowski(){
            Battery();
            sphere(thick+0.2,center=true);
        }
        Battery();
        translate([0,-21-5,-0.5]) cube([15,12,21],center=true); // minus end
        
        translate([0,15,0]) cylinder(d=10,h=20,center=true);        
        translate([0,1,0])cylinder(d=10,h=20,center=true);
        translate([0,-13,0])cylinder(d=10,h=20,center=true);
        
        
        translate([0,15,0]) rotate ([90,0,0]) cylinder(d=11,h=20,center=true);
        
        translate([0,12,0])rotate ([90,0,90])cylinder(d=13,h=20,center=true);
    }
    
}

BattPos = [0,-19,-height+17.5/2+thick+0.2]; // BattSize z !

module body()
{
    // 4 fans
    difference()
    {
        copy_mirror([1,0,0]) copy_mirror([0,1,0]) translate([dx/2,dy/2,0]) completeRing(ang,0);
       translate(BattPos) Battery();
        
    }
    // outer side connection
    copy_mirror([1,0,0]) translate([dx/1.8,0,-height/2]) 
    union(){
        cube([thick,trad*1.8+2,height],center=true);
        translate([0,0,height/2-1])rotate([0,90,0]) cylinder(d=trad*1.8+2,h=thick,center=true);
    }
    
    // front support
    //translate([0,dy/1.75,-height/2]) cube([trad*1.65+10,thick,height],center=true);
    
    translate(BattPos)BattHld();
    
    // batt side support
    copy_mirror([1,0,0]) translate([-15.7-2,-1-2,-height/2+2.0]) rotate([0,0,0]) difference() 
    {
        cube([22,thick,height+4],true);
        translate([0,0,1.5]) rotate([90,0,0]) cylinder(d=11,h=thick+2,center=true);
    }
    
    
    
    // top
difference()
    {
        union()
        {
      
        // 
        minkowski()
        {
            innertop();
            cube(thick*2,center=true);
        }
        translate([2,31,0]) cylinder(h=11,d=8); // TX antenna supp
        }
        innertop(); 
        cube([100,100,5],center=true);
            
        copy_mirror([1,0,0]) copy_mirror([0,1,0]) translate([dx/2,dy/2,-height-1])   cylinder(r=radius,h=2); // clean out main bores
        translate([0,19,-height]) cylinder(h=30,d=12); // front center
        
        translate([-11,6,-height]) cylinder(h=30,d=8); 
        hull() //connector opening for battery
        {
            translate([11,6,-height]) cylinder(h=30,d=8); 
            translate([3,6,-height]) cylinder(h=30,d=5.5); 
        }
        
        translate([2,31,-height]) cylinder(h=31-4,d=4); // TX antenna hole
        translate([2,31,-height+31-10]) cylinder(h=3,d1=4,d2=8); // TX antenna hole
        
        translate(BattPos) Battery();
            
    }
    
    // FC holder
    
    translate(FCpos)
    difference()
    {
    union()
    {
        translate([0.5-2.5/2+0.5,9,8.5]) cube([5.5,4,4],true); // upper front
        translate([0.5,-9,8.5]) cube([4,4,4],true); // upper back
  
        //reinforce stuff
        translate([-0.4,-11,9]) rotate([0,0,60]) cube([3,9,1]);
        translate([1,-8.5,9]) rotate([0,0,-65]) cube([3,12.5,1]);
        translate([-0.4,-18,9]) rotate([0,0,0]) cube([3,10,1]);
        
    }
        // translate([-1+2,10.25,7-5]) rotate ([0,45,0]) cube([4,7,10],true); 
         rotate([0,-90,180]) REVO16x16(true);
         translate([0.5,0,8.5]) cube([1.2,20.6,4],true);
    }
    
    // cam holder
    translate(campos) rotate([-90+30,0,0]) 
    difference()
    {
       union()
       {
           translate([0,-2,-4]) cube([15.2,14.0,4],true);
           translate([0,6.0,-6]) rotate([0,90,0]) cylinder(d=5,h=17.5,center=true);
           
       }
       CAMERA(true);
       
    }
    
    // reinforcements for bolts from bottom cover
    ItfPlace() cylinder(d=3.5,h=4);
    

}

// pacement module for interface to lower cover.
module ItfPlace()
{
    copy_mirror([1,0,0]) translate([7.5,39.5,-height]) children();
    copy_mirror([1,0,0]) translate([36.5,1.5,-height]) children();
    copy_mirror([1,0,0]) translate([8.25,-1.5,-height]) children();
}

module innertop()
{
     translate([0,0,1.5]) 
    difference()
    {
        linear_extrude(height = 6.5,scale = 0.9)
        {
        polygon([[-8,35],[8,35],[38,-2],[-38,-2]]);
        }
        copy_mirror([1,0,0]) translate([dx/2,dy/2,0]) cylinder(r=radius+trad-thick,h=20);
        translate([0,-4,-height]) cylinder(d=12,h=30); //free batt hole
    }
    
}


module bottombolt()
{
        translate([0,0,-3-thick]) cylinder(d=4,h=3);
        translate([0,0,-thick]) cylinder(d=2.2,h=thick);
        translate([0,0,0]) cylinder(d=1.75,h=6);
}

module bottom_old()
{
     
    difference()
    {
        translate([0,0,-height-thick]) linear_extrude(height = thick,scale = 1.0)
        {
        polygon([[-8,41],[8,41],[38,+3],[38,-3],[-38,-3],[-38,+3]]);
        }
        copy_mirror([1,0,0]) translate([dx/2,dy/2,-0.5-height-thick]) cylinder(r=radius+thick,h=20);
        translate([0,-4,-height]) cylinder(d=12,h=30); //free batt hole
        ItfPlace() bottombolt();
    }
    
}

module innerbottom()
{
    difference()
        {
            polygon([[-8,41],[8,41],[38,+3.5],[38,-3.5],[-38,-3.5],[-38,+3.5]]);
            copy_mirror([1,0]) translate([dx/2,dy/2])  circle(r=radius);
            translate([0,-4]) circle(d=12); //free batt hole
        }
}

module bottom()
{
     
    difference()
    {
        union()
        {
            translate([0,0,-height-thick]) linear_extrude(height = thick*2.5,scale = 1.0)
            {
                innerbottom();
            }
            
        }
        translate([0,0,-height]) linear_extrude(height = thick+1,scale = 1.0)
        {
            offset(r=-2) innerbottom();
        }
        ItfPlace() bottombolt();
        body();
        STUFF(false); 
        
        copy_mirror([1,0,0]) translate([18,2,-height-1.5]) cylinder(d=7,h=3);
        copy_mirror([1,0,0]) translate([27,0,-height-1.5]) cylinder(d=4,h=3);
        copy_mirror([1,0,0]) translate([8,7,-height-1.5]) cylinder(d=9,h=3);
        translate([0,19,-height-1.5]) cylinder(d=10,h=3);
        translate([0,32,-height-1.5]) cylinder(d=10,h=3);
    }
    
    difference() {
        union()
            {
                translate(FCpos) translate([0.5,9,-9-thick+0.2]) cube([4,4,4],true); // lower front
                translate(FCpos) translate([0.5,-9,-9-thick+0.2]) cube([4,4,4],true); // lower back
            }
            translate(FCpos) translate([0.5,0,0]) cube([1.2,20.6,20.6],true);
        }
}




difference()
{
body();
STUFF(true);   
ItfPlace() bottombolt();
color("red")translate([0,0,-height-5+0.02]) cube([150,150,10],center=true); // test limitation for a even bottom
}  

 translate([100,0,10]) rotate([0,0,90]) bottom(); // elevate Z to make clear that the stl needs to be split in Slic3r

//STUFF(true);   
