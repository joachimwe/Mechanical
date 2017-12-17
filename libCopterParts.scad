

/*
Copter parts library

(c) 2017 Fabian Huslik

https://github.com/fabianhu/
*/ 


translate([-80,0,0]) REVO16x16(); 
translate([-40,0,0]) ESC16x16();
translate([-5,0,0]) ESC20x20();
translate([30,0,0]) OMNIBUS20x20();
translate([65,0,0]) CAMERA();
translate([85,0,0]) RX_XM();
translate([100,0,0]) RX_XMPLUS();
translate([120,0,0]) TX_MM213TL();
translate([140,0,0]) BEEPER();
translate([160,0,0]) RUNCAM_SWIFT();
translate([200,0,0]) motor1103();
translate([260,0,0]) motor1807();


translate([-80,40,0]) REVO16x16(true); 
translate([-40,40,0]) ESC16x16(true);
translate([-5,40,0]) ESC20x20(true);
translate([30,40,0]) OMNIBUS20x20(true);
translate([65,40,0]) CAMERA(true);
translate([85,40,0]) RX_XM(true);
translate([100,40,0]) RX_XMPLUS(true);
translate([120,40,0]) TX_MM213TL(true);
translate([140,40,0]) BEEPER(true);
translate([160,40,0]) RUNCAM_SWIFT(true);
translate([200,40,0]) motor1103(true);
translate([260,40,0]) motor1807(true);



module ESC16x16(clr=false) 
{
    l = 15;
    PCB_x = 22.8;	
    PCB_y = 20.45;
    PCB_r = 3.5;
	hp=1.0; // PCB thickness
	
    difference()
    {
        
		color("green") hull()
        {
			for(i = [ 
			         [ (PCB_x-PCB_r)/2,   (PCB_y-PCB_r)/2,  0],
			         [ (PCB_x-PCB_r)/2, -(PCB_y-PCB_r)/2, 0],
			         [ -(PCB_x-PCB_r)/2,  (PCB_y-PCB_r)/2, 0],
			         [ -(PCB_x-PCB_r)/2,  -(PCB_y-PCB_r)/2, 0] ])
			{
				translate (i) cylinder(h=hp,r=PCB_r/2,$fn = 12);
			}
		}

		for(i = [ 
		         [  l/2,   l/2,  0],
		         [ l/2, -l/2, 0],
		         [-l/2,  l/2, 0],
		         [-l/2,  -l/2, 0] ])
		{   
			translate (i) cylinder(h=hp,d=2.15,$fn = 12);
		}
	}
	ttop=1.6;
	color("grey") translate([0,0,ttop/2+hp]) cube([19.8,10.7,ttop],true); // upper alongside block
	color("grey") translate([0,0,ttop/2+hp]) cube([6,17.8,ttop],true); // upper across block	
    tlow=0.6;
    color("grey") translate([0,0,-tlow/2]) cube([23,12,tlow],true); // lower alongside block
	color("grey") translate([0,0,-tlow/2]) cube([9.5,20,tlow],true); // lower across block


    if(clr)
    {
        color("red") translate([-11,0,-0.5]) cube([8,12,1],true); // upper connector space 
        color("red") translate([11,0,-0.5]) cube([8,12,1],true); // connector space
        for(i = [ [  l/2,   l/2,  0], [ l/2, -l/2, 0], [-l/2,  l/2, 0], [-l/2,  -l/2, 0] ])
        {   
			//color("red") translate (i) cylinder(h=1.6,d=4);
		} 
    }

}



module REVO16x16(clr=false) 
{
    l = 16;
	PCB_x = 20.3;
    PCB_y = 20.3;
    PCB_r = 3.5;
	h=1; // PCB thickness
	
    difference()
    {
        
		color("green") hull()
        {
			for(i = [ 
			         [ (PCB_x-PCB_r)/2,   (PCB_y-PCB_r)/2,  0],
			         [ (PCB_x-PCB_r)/2, -(PCB_y-PCB_r)/2, 0],
			         [ -(PCB_x-PCB_r)/2,  (PCB_y-PCB_r)/2, 0],
			         [ -(PCB_x-PCB_r)/2,  -(PCB_y-PCB_r)/2, 0] ])
			{
				translate (i) cylinder(h,r=PCB_r/2,$fn = 12);
			}
		}

		for(i = [ [  l/2,   l/2,  0], [ l/2, -l/2, 0], [-l/2,  l/2, 0], [-l/2,  -l/2, 0] ])
		{   
			translate (i) cylinder(h,d=2.2,$fn = 12);
		}
	}
	
	color("grey") translate([0,0,h/2]) cube([12.8,19,4.2],true); // inner block
	color("grey") translate([0,0,h/2]) cube([19,12.8,4.2],true); // inner block
	color("grey") translate([8.0,0,(2.7/2)+h]) cube([6,7.8,2.9],true); // USB
    //color("lightgrey") translate([0,8,(2.7/2)+h]) cube([8.5,6,4.0],true); // ESC conn
    
    if(clr)
    {
        color("red") translate([14.0,0,(2.7/2)+h]) cube([6,7.8,2.9],true); // USB connector
        color("red") translate([-9,0,0.75+h]) cube([3,13,2],true); // upper connector space 
        color("red") translate([0,-9,0.75+h]) cube([13,3,2],true); // connector space
       // color("red") translate([0,13,(2.7/2)+h]) cube([8.5,4,3.5],true); // ESC conn 
    
        for(i = [ [  l/2,   l/2,  0], [ l/2, -l/2, 0], [-l/2,  l/2, 0], [-l/2,  -l/2, 0] ])
        {   
			//color("red") translate (i) cylinder(h=1.6,d=4);
		}
    }
    
}


module copy_mirror(vec=[0,1,0])
{
    children();
    mirror(vec) children();
}


module ESC20x20(clr=false) 
{
	l = 20/2;
	lb= 31.0;
	wb= 27.5;
	h=1.0;
	r= 4;
	difference(){

		//PCB
        union()
        {
            color("green") hull()
            {
                w= (wb-r)/2;
                d = (wb-r)/2;
                for(i = [ 
                         [  w,   d,  0],
                         [ w, -d, 0],
                         [-w,  d, 0],
                         [-w,  -d, 0] ])
                {
                    translate (i) cylinder(h,d=r);
                }
            }
            
            color("green") translate([0,0,h/2]) cube([19.5,31,h],true);
        }
		
        for(i = [ 
		         [  l,   l,  -0.01],
		         [ l, -l, -0.01],
		         [-l,  l, -0.01],
		         [-l,  -l, -0.01] ])
		{   
			translate (i) cylinder(h+0.1,d=2.2,$fn=12);
		}
	}
	thick= clr?5:4.5;
    color("grey") translate([0,0,h/2]) cube([15,25.5,thick],true); // ok
	color("grey") translate([0,0,h/2]) cube([27,16.5,thick],true); // ok
    color("white") translate([14,0,2.5]) cube([7,9,3],true);
    
    // cables
    if(clr)
    {
    copy_mirror([0,1,0]) for(i = [-3.5*2.5:3.5:10] 
		        )
		{   
			color("red") translate ([ i, -10-3, +1.0+0.8]) rotate([90,0,0]) cylinder(h=10,d=2.5,$fn=12);
		}
    }
    
}



module OMNIBUS20x20(clr=false) 
{


	l= 20/2;
	h=1.0; // PCB thickness
	difference()
    {

		color("green") hull()
        {
			for(i = [ 
			         [  l,   l,  0],
			         [ l, -l, 0],
			         [-l,  l, 0],
			         [-l,  -l, 0] ])
			{
				translate (i) cylinder(h,d=(27-20));
			}
		}

		for(i = [ 
		         [  l,   l,  0],
		         [ l, -l, 0],
		         [-l,  l, 0],
		         [-l,  -l, 0] ])
		{   
			translate (i) cylinder(h,d=2.2);
		}
	}
	thick= clr?5.6:1.8+h+1.8;
	color("grey") translate([0,0,h/2]) cube([16.5,27,thick],true); // inner block
	color("grey") translate([0,0,h/2]) cube([27,16.5,thick],true); // inner block
	color("grey") translate([11.5,0,(2.7/2)+h]) cube([6,7.8,2.8],true); // USB
    
    if(clr)
    {
        color("red") translate([11.5+5,0,(2.7/2)+h]) cube([6+5,7.8,2.8],true); // USB
    }
    
}


module CAMERA(clr=false) 
{
	h_lens=6.7;
	color("grey") cylinder(d=10,h=h_lens); // lens
	color("grey") translate([0,0,-3/2]) cube([11.7,11.7,3],true); // upper block

	color("grey") translate([0,0,-1.3/2-3]) cube([12.5,12.5,1.3],true); // PCB


	color("grey") hull()
    {
		translate([0,0,-4]) cube([11.7,11.7,3],true);
		translate([0,0,-4]) cube([8,8,6],true);
	}
	color("grey") translate([-4.5,2.0,-7.5])  rotate([-60,0,0]) cylinder(d=4,h=2.5); // mic

	color("red") if(clr)
    {
        translate([0,0,h_lens]) cylinder(d1=8,d2=35,h=10); // view angle
        //hull() {
        color("grey") cylinder(d=10,h=h_lens); // lens
        //translate([0,-10,0]) color("grey") cylinder(d=10,h=h_lens); // lens ext}
		translate([0,0,-7]) cube([12.5,12.5,6],true); // conn block
		//translate([0,-10,-7]) cube([12.5,12.5,6],true); // conn block ext
        //translate([0,-10,-1.3/2-3]) cube([12.5,12.5,1.3],true); // PCB ext
        //translate([0,-10,-3/2]) cube([11.7,11.7,3],true); // upper block ext
        
	}

}

module RX_XMPLUS(clr=false)
{
	
    color("grey") cube([12,21.9,3.5],true);
	color("red") if(clr)
    {
		hull()
        {
			translate([1.5,-10,-1]) rotate([90,0,0]) cylinder(h=15,d=1.5);
			translate([5,-10,-1]) rotate([90,0,0]) cylinder(h=15,d=1.5);
		}
	}
}

module RX_XM(clr=false)
{
	
    color("grey") cube([10.3,16.9,3.5],true);
    color("grey") translate([0,-5,-1]) rotate([90,0,0]) cylinder(h=15,d=1.5);
	color("red") if(clr)
    {
			
	}
}

module TX_MM213TL(clr=false)
{
	color("grey") cube([19.5,22.5,3.5],true);

	color("grey") translate([5,-10.5,0.5]) rotate ([0,90,0])  cylinder(d=4,h=27);
	color("red") if(clr)
        {
		translate([0,10,0.5]) cube([13,4,4],true);
	}
}

module BEEPER(clr=false)
{
	color("grey") hull()
    {
        cylinder(d=9.2,h=6);
        translate([0,0,-1]) cylinder(d=6,h=1);
    }
	color("red") if(clr)
    {
        translate([0,0,-2]) cylinder(d=6,h=2);
        translate([0,0,6]) cylinder(d=9.5,h=10);
	}
	else
	{
		
	 
	}
}

module RUNCAM_SWIFT(ext=false) 
{
    difference()
    {
        union()
        {
            color("grey") cylinder(d=12,h=10); // lens
            color("orange") rotate ([0,90,0]) cylinder(d=6,h=19,center=true); // fixing block
            color("orange") hull()
            {
                translate([7.5,-7.5,-5]) cylinder(d=4,h=7);
                translate([-7.5,7.5,-5]) cylinder(d=4,h=7);
            }
            //translate([0,0,-4.5-Conn_Len/2]) cube([19,19,9+Conn_Len],true);
            color("orange") translate([0,0,-1.5]) cube([14,13.3,7],true);
            color("darkblue") translate([0,0,-1.9-5]) cube([19,19,3.8],true); // PCA
            color("lightgrey") translate([4.4,7.9,-2-5-3.5]) cube([10.2,3.2,3.5],true); // connector
            
            color("lightgrey") translate([0,0,-2-5-3.75]) cube([19,19,5],true); // TX (partly !!!)
            
        }
        rotate ([0,90,0]) cylinder(d=2,h=20,center=true); // drill M2
    }
    color("red")
    if(ext)
    {
        translate([0,0,10]) cylinder(d1=10,d2=35,h=10); // view cone  
        rotate ([0,90,0]) cylinder(d=2,h=30,center=true); // add M2+extension in case of substraction
        //translate([0,0,-1.5]) cube([16,16,9],true); // center block
        translate([0,0,-1.5]) cube([19,19,9],true); // center block
        
        
        //translate([0,0,-2-5-3.75]) cube([19,19,15],true); // TX extended for un/install
    }
    
    //
    //
}

module motor1103(ext=false)
{
     
    union(){
    color("grey",1.0) cylinder(d1=13,d2=14.4,h=1.5);
    color("grey",1.0) translate([0,0,1.5])cylinder(d=14.4,h=1);
    if(ext)
    {
        for(i=[0:90:360])
        {
            color("red") rotate([0,0,i-45]) translate([4.5,0,-10]) cylinder(d=2,h=10);
            color("red") rotate([0,0,i-45]) translate([4.5,0,-10]) cylinder(d=4,h=8);
        }
        color("red") translate([10,0,1]) cube([10,4.3,2],center=true); // cable
        color("blue") translate([9,0,4]) cube([5,4,5],center=true); // room for installation of cable
    }
    color("grey") translate([0,0,-1.5])cylinder(d=4,h=1.56); // free room for bearing 
  
    
    color("grey",1.0) translate([0,0,2.5]) cylinder(d=15.0,h=5); //bell
    }
    
    color("lime",0.3) translate([0,0,3+4.5]) cylinder(d=1.8*25.4+0.25,h=4.5); //prop
}

module motor1807(ext=false)
{
     
    union(){
    color("grey",1.0) cylinder(d1=16,d2=18.65,h=5);
    color("grey",1.0) translate([0,0,5])cylinder(d=18.65,h=18-5); // upper motor
    if(ext)
    {
        for(i=[0:90:360])
        {
            color("red") rotate([0,0,i-45]) translate([6,0,-10]) cylinder(d=2,h=10);
            color("red") rotate([0,0,i-45]) translate([6,0,-10]) cylinder(d=4,h=8);
        }
        color("red") translate([10,0,1.5]) cube([10,7,3],center=true); // cable
        color("blue") translate([9,0,4]) cube([5,5,5],center=true); // room for installation of cable
    }
    color("grey") translate([0,0,-1.5])cylinder(d=4,h=1.56); // free room for bearing 
  
    
    color("grey",1.0) translate([0,0,2.5]) cylinder(d=15.0,h=5); //bell
    }
    
    color("lime",0.3) translate([0,0,18]) cylinder(d=102,h=6.2); //prop
    color("black",0.3) translate([0,0,0]) cylinder(d=9,h=31,$fn=6); //prop
   
}

