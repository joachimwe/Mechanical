$fn= 60;

difference()
{

cylinder (h=3.2,d=5,center=true);

cylinder (h=3.2,d=1.85,center=true);

x=0.8;
    
translate([5+2.5-x,0,0]) cube(10,center=true);
translate([0,5+2.5-x,0]) cube(10,center=true);

}