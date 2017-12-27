/*
90 mm Copter

(c) 2017 Fabian Huslik

https://github.com/fabianhu/
*/ 

use <libCopterParts.scad>

$fn=30;
camangle = 30;
campos = [0,21,14];

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


module Standoffs (sq,h)
{
    difference()
	{     
			copy_mirror(vec=[1,0,0]) copy_mirror(vec=[0,1,0]) translate ( [  sq/2,   sq/2,  0]) cylinder(h,d=6, $fn=30);
			copy_mirror(vec=[1,0,0]) copy_mirror(vec=[0,1,0]) translate ( [  sq/2,   sq/2,  0]) cylinder(h,d=2.1, $fn=30);
    }

}


module BODY() {
	l = 20/2;
	lb= 27;
	wb= 31;
	h=10.5;
	r= 6;
	w= 10;
	d = 10;
	difference()
    {
		union()
        {
			translate([0,0,7.5+0.5])
					//center body hull
			hull()
            {
					copy_mirror(vec=[1,0,0]) copy_mirror(vec=[0,1,0])translate ( [  w,   d,  0]) cylinder(h,d=r, $fn=30);
			}

			// antenna support hull
			hull()
			{
				translate([0,-11,16.5])rotate([90,0,0]) cylinder(h=6,d=3); 

				for(i = [ [  w,   -d,  3.5+4.5+4.5],  [-w,  -d, 3.5+4.5+4.5],  ])
				{
					translate (i) cylinder(h=6,d=r, $fn=30);    
				}
			}


			// cam protector hull
			hull()
			{
				translate(campos)  rotate([-90+camangle,0,0]) translate([0,0,2]) 
            		//cube([12,12,5],true);
				cylinder(d=12,h=10,center=true);

				for(i = [ [  w,   d,  3.5],  [-w,  d, 3.5],  ])
				{
					translate (i) cylinder(h=15.0,d=r, $fn=30);    
				}
			}
			translate([0,0,0.3]) Standoffs(20,2.3);
			translate([0,0,2.5+1])  Standoffs(20,4);

		} // union main body

		STUFF(true);

		// holes
		for(i = [ 
		         [  10,   10,  0],
		         [ 10, -10, 0],
		         [-10,  10, 0],
		         [-10,  -10, 0] ])
		{
			translate (i) cylinder(8+5,d=1.8, $fn=30);
			translate (i) cylinder(8.5,d=2.2, $fn=30);
		}

		cylinder(h=15,d=22);

        // 

	}


}







module STUFF(clr=false)
{
	translate([0,0,2.5]) ESC20x20(clr);
	translate([0,0,7.2]) OMNIBUS20x20(clr);

	translate([2,0,12]) rotate([0,180,0])RX_XMPLUS(clr);

	translate(campos)  rotate([-90+camangle,0,0]) CAMERA(clr);
	//translate(campos)  rotate([-90+30,0,0]) RUNCAM();

	translate([0,4,15.5])  rotate([0,0,180])TX03(clr);
	translate([-9,-9.5,13.5])  rotate([0,0,0])     BEEPER(clr);
    
    copy_mirror([1,0,0]) translate([63/2,63/2,0]) motor1105();
    
}

//STUFF(true);


BODY();  

