
use <springs.scad>; // From: https://www.thingiverse.com/thing:3252637

module hexBase(height = 10, support=true) {
    difference() {
        translate([0,0,0]) linear_extrude(height = height, center = false, convexity = 10) 
            import (file = "hexout_q.dxf", $fn=128);
        
        translate([0,0,-1]) translate([0,0,0]) linear_extrude(height = 3, center = false, convexity = 10) 
            import (file = "gravitrax.dxf", layer="hexincut", $fn=32);
    }
    
    if (support) {
    translate([58,0,0]) difference() {
         translate([0,0,0]) linear_extrude(height = 4.2, center = false, convexity = 10) 
                import (file = "gravitrax.dxf", layer="hexInsert", $fn=32);
        translate([6,-6,2]) cube([12,12,12]);
        translate([6,-1.5,-1]) cube([12,3,12]);
    }
}
} 

module trackConnector(angle) {
    rotate([0,0,angle]) {
        translate([0,0,1]) linear_extrude(height = 16, center = false, convexity = 10) 
            import (file = "gravitrax.dxf", layer="track", $fn=64);
    
        translate([0,0,2.6]) linear_extrude(height = 16, center = false, convexity = 10) 
            import (file = "gravitrax.dxf", layer="trackup", $fn=64);
    }
}


module LiftInput(angle = 0) {
   
    rotate([0,0,angle]) {
    
    rotate([0,0,90+61]) {
translate([32,0,8+3.5]) scale([-1,1,1]) spring(r=7, R=16, windings=6/12, H=120/12, center = false, R1 = undef, start=false, end=false, ends=undef, w=undef, h=undef, $fn=64);
  }
  
  rotate([0,0,-30.5]) translate([-16,0,8+3.4]) {
                 sphere(r=14/2, $fn=64);
                // translate([0,0,0]) cylinder(r=7, h=height, $fn=64);
             }
  
  // Connectors
     translate([0,0,5])   trackConnector(0);
  }
}


module LiftOutput(angle = 0, height = 50) {
    
    rotate([0,0,angle]) {
        
        difference() {
            translate([0,0,10]) rotate([0,0,-60]) linear_extrude(height = height, center = false, convexity = 1) import (file = "gravitrax.dxf", layer="hexout1side", $fn=128);
            
             rotate([0,0,-30.5]) translate([-16,0,8+3.4]) {
                 sphere(r=14/2, $fn=64);
                 translate([0,0,0]) cylinder(r=7, h=height, $fn=64);
             }

             rotate([0,0,90+61]) {
                translate([32,0,height+5]) scale([1,-1,1]) spring(r=7, R=16, windings=6/12, H=120/12, center = false, R1 = undef, start=false, end=false, ends=undef, w=undef, h=undef, $fn=64);
  }
            
            // Connectors
            translate([0,0,height])   trackConnector(-60);
        }
        
        
    }
    
}

module LiftOutputNoOutput(angle = 0, height = 50) {
    
    rotate([0,0,angle]) {
        
        difference() {
            translate([0,0,10]) rotate([0,0,-60]) linear_extrude(height = height, center = false, convexity = 1) import (file = "hexout1_q.dxf", $fn=128);
            
             rotate([0,0,-30.5]) translate([-16,0,8+3.4]) {
                 sphere(r=14/2, $fn=64);
                 translate([0,0,0]) cylinder(r=7, h=height, $fn=64);
             }

             //rotate([0,0,90+61]) {
                //translate([32,0,height+5]) scale([1,-1,1]) spring(r=7, R=16, windings=6/12, H=120/12, center = false, R1 = undef, start=false, end=false, ends=undef, w=undef, h=undef, $fn=64);
  //}
            
            // Connectors
            //translate([0,0,height])   trackConnector(-60);
        }
        
        
    }
    
}

module Lift(h1=60, h2=60, h3=60) {

difference() {
    
    union() {
    
        hexBase(12, false);
         
        //LiftOutput(0,h1);
        LiftOutputNoOutput(0, 60);
        translate([0, 0, 5+60]) {
            LiftOutputNoOutput(0, 60);
            translate([0, 0, 5+60]) {
                LiftOutputNoOutput(0, 50);
                translate([0, 0, 5+50]) LiftOutput(0, 10);
            }
        }
        LiftOutput(120,h2);
        LiftOutput(-120,h3);
        
        translate([0,0,0]) cylinder(r=17, h=2.5, $fn=64);
    }
    
    LiftInput(0);
    LiftInput(-120);
    LiftInput(120);
    
    translate([0,0,2.5]) cylinder(r=17, h=max(h1, h2, h3) + 100, $fn=64);

  translate([0,0,-1]) rotate([0,0,-60]) linear_extrude(height = 22, center = false, convexity = 1) 
            import (file = "gravitrax.dxf", layer="motorIn", $fn=128);
 
 translate([0,-1.5,-1]) cube([40,3,3]);
  
}

difference() {
translate([0,0,2]) cylinder(r=15/2, h=23, $fn=64);
 translate([0,0,-1]) rotate([0,0,-60]) linear_extrude(height = 27, center = false, convexity = 1) 
            import (file = "gravitrax.dxf", layer="motor", $fn=128);
}
//translate([0,0,8]) spring(r=7, R=16, windings=6/12, H=120/12, center = false, R1 = undef, start=false, end=false, ends=undef, w=undef, h=undef, $fn=64);

}

module Hub() {
    difference() {
        translate([0,0,0]) cylinder(r=15.6/2, h=12, $fn=64);
        translate([0,0,-1]) linear_extrude(height = 22, center = false, convexity = 1) 
            import (file = "gravitrax.dxf", layer="motoraxle", $fn=128);
    }
}




module BaseCoil(turns = 4, bottom = false, top=false) {
    
    height = turns * 20;
    coilstart = (bottom)?8:-12;
    coilturns = (bottom)?turns:turns+1;
   
   translate([0,0,(bottom)?0:8]) {
    
       difference() {
                cylinder(r=16, h=height, $fn=64);
                if (top) translate([0,0,height]) spring(R=16, w = 14,  h=14, windings=1/2, H=10, $fn=64);
                translate([0,0,coilstart]) 
                    spring(r=7, R=16, windings=coilturns, H=coilturns*20, center = false, R1 = undef, start=false, end=false, ends=undef, w=undef, h=undef, $fn=64);
                
                if (bottom) translate([0,0,-1]) cylinder(r=16/2, h=height-5, $fn=64);
                if (!top) translate([0,0,height-20]) cylinder(r=16/2, h=25, $fn=64);
                if (bottom && top) translate([0,0,height-20]) cylinder(r=3, h=25, $fn=64);
                
        }
         if (!top)  translate([6,-1,height-10]) cube([2.5,2,10]);
             
         if (!bottom) {
             difference() {
                translate([0,0,-8]) cylinder(r=15.6/2, h=10, $fn=64);
                translate([5.75,-2.5/2,-9]) cube([2.5,2.5,10]);
             }
         }
    }
}


// Mirror all the parts with this for rotating in the opposite direction
//scale([1,-1,1])

// the body of the lift with configurable height for the 3 output towers
Lift(180,0,0);

// The hub for the motor (friction fit inside the spiral bottom)
//translate([40,30,0]) Hub();

// Bottom part of the spiral
//translate([0,0,12]) BaseCoil(turns = 3, bottom = true, top=false);

// Middle part of the spiral
//translate([0,0,75])  BaseCoil(turns = 2, bottom = false, top=false);

// Top part of the spiral
//translate([0,0,125]) BaseCoil(turns = 2, bottom = false, top=true);

// To make the spiral in one single part
//BaseCoil(turns = 6, bottom = true, top=true);
