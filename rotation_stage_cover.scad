use <MCAD/boxes.scad>
use <rotation_stage_case.scad>


$fa=1;
$fs=0.4;

//Arduino dimensions
arduinox = 68.6;
arduinoy = 53.3;
arduinoz = 3;

rboxx = arduinox + 60;
rboxy = arduinoy + 80;
rboxz = 3;
rboxrad = 1.5; 

// Switch Hole Size and Spacing
switchHoleDiam = 12;
switchSpacing = 30;

// Lid inner rim 
rimz = 2;
rimDist = 6;
rimThickness = 9;
rimx = rboxx-rimDist;
rimy = rboxx-rimDist;
innerRimx = rimx-rimThickness;
innerRimy = rimy-rimThickness;

// Rounded Lid part
module HalfRoundBox(){
    translate([rboxx/2,rboxy/2,0]){
        difference(){
            roundedBox(size=[rboxx,rboxy,rboxz],
            radius=rboxrad,
            sidesonly=false);
            translate([0,0,-rboxz/2])
                cube([rboxx+2,rboxy+2,rboxz],center=true);
        }
    }
}

// Holes
module Holes(){
        translate([rboxx/2.5,rboxy/3+switchSpacing/2,-0.1])
            cylinder(d=switchHoleDiam,h=rboxz+0.1);
        translate([rboxx/2.5,rboxy/3-switchSpacing/2,-0.1])
            cylinder(d=switchHoleDiam,h=rboxz+0.1);
        translate([rboxx/2.5,rboxy/2 + switchSpacing*1.2,-0.1])
            cylinder(d=switchHoleDiam,h=rboxz+0.1);
}


// top part
module Lid(){
    difference(){
        HalfRoundBox();
        Holes();
    }
}

// Rim for the lid to stay put on box
module Rim(){
    difference(){
        translate([rboxx/2-rimx/2,rboxy/2-rimy/2,0])
            cube([rimx,rimy,rimz]);
        translate([rboxx/2-innerRimx/2,rboxy/2-innerRimy/2,-rimz-0.1])
            cube([rimx-rimThickness,rimy-rimThickness,2*rimz]);
        Holes();
    }
}


module Words(){
    // Text Jog
    translate([rboxx/2+switchHoleDiam,rboxy/3+switchSpacing/2+1,rboxz+0.1])
        rotate([0,0,90])
            text(size=10,"Jog",halign="center");
    // Text +
    translate([rboxx/3.4,rboxy/3-switchSpacing/2-0.5,rboxz+0.1])
        rotate([0,0,90])
            text(size=20,"+",halign="center");
    // Text -
    translate([rboxx/2+1.6*switchHoleDiam,rboxy/3-switchSpacing/2-0.5,rboxz+0.1])
        rotate([0,0,90])
            text(size=25,"-",halign="center");
    // Jog dir
    translate([rboxx/2.4,rboxy/3-switchSpacing/1.1,rboxz+0.1])
        rotate([0,0,180])
        text(size=7,"Jog Dir",halign="center");
        
    // Text +90
    translate([rboxx/3.4,rboxy/2 + switchSpacing*1.2,rboxz+0.1])
        rotate([0,0,90])
            text(size=10,"+90",halign="center");
    // Text -90
    translate([rboxx/2+switchHoleDiam,rboxy/2 + switchSpacing*1.2,rboxz+0.1])
        rotate([0,0,90])
            text(size=10,"-90",halign="center");
}



difference(){
    translate([0,0,rimz]) Lid();
    Words();
}
Rim();



