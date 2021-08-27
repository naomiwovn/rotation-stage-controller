use <MCAD/boxes.scad>
use <rotation_stage_case.scad>
$fn=40;


//Arduino dimensions
arduinox = 68.6;
arduinoy = 53.3;
arduinoz = 3;

rboxx = arduinox + 30;
rboxy = arduinoy + 40;
rboxz = 3;
rboxrad = 1.5; 

// Switch Hole Size and Spacing
switchHoleDiam = 12;
switchSpacing = 28;
holeMoatLen = 4;

// Lid inner rim 
rimz = 2;
rimDist = 3;
rimThickness = 4;
rimx = rboxx-rimDist;
rimy = rboxy-rimDist;
innerRimx = rimx-rimThickness;
innerRimy = rimy-rimThickness;


// Word Settings
wordDepth = rboxz/2;
scaleVal = 1;


// Honeycomb 
r = 6.5; // radius/thickness
n = 6; // number holes
combDiam = 6;
combHeight = 5;

// Change the scale of the web of combs 
combxScale = 1.05;
combyScale = 0.95;


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

// Not Round Box
module RegularBox(){
        difference(){
            cube([rboxx,rboxy,rboxz]);
            translate([0,0,-rboxz/2])
                cube([rboxx+2,rboxy+2,rboxz],center=true);
        }
   
}

// Holes
module Holes(){
        translate([rboxx/2.5,rboxy/3+switchSpacing/2,-3])
            cylinder(d=switchHoleDiam,h=rboxz+10);
        translate([rboxx/2.5,rboxy/3-switchSpacing/2,-3])
            cylinder(d=switchHoleDiam,h=rboxz+10);
        translate([rboxx/2.5,rboxy/2 + switchSpacing*1.2,-3])
            cylinder(d=switchHoleDiam,h=rboxz+10);
}

module NonHoles(){
        translate([rboxx/2.5,rboxy/3+switchSpacing/2,-0.1])
            cylinder(d=switchHoleDiam+holeMoatLen,h=rboxz+0.6);
        translate([rboxx/2.5,rboxy/3-switchSpacing/2,-0.1])
            cylinder(d=switchHoleDiam+holeMoatLen,h=rboxz+0.6);
        translate([rboxx/2.5,rboxy/2 + switchSpacing*1.2,-0.1])
            cylinder(d=switchHoleDiam+holeMoatLen,h=rboxz+0.6);
}

// top part
module Lid(){
    difference(){
        HalfRoundBox();
        //RegularBox();
    }
}

// Rim for the lid to stay put on box
module Rim(){
    difference(){
        translate([rboxx/2-rimx/2,rboxy/2-rimy/2,0])
            cube([rimx,rimy,rimz]);
        translate([rboxx/2-innerRimx/2,rboxy/2-innerRimy/2,-rimz+0.1])
            cube([rimx-rimThickness,rimy-rimThickness,2*rimz]);
        Holes();
        //translate([rboxx/1.27,rboxy/2,rboxz-combHeight/2])rotate([0,0,90-22])ManyCombs();
    }
}


module Words(){
    translate([0,0,0]){
        // Text Jog
        translate([rboxx/5+switchHoleDiam,rboxy/3+switchSpacing/2,rboxz])
            rotate([0,0,90])
                linear_extrude(wordDepth)
                    scale([scaleVal,scaleVal,scaleVal])
                        text(size=8,"Jog",halign="center");
        
        // Text +
        translate([rboxx/3.4,rboxy/3-switchSpacing/2-0.5,rboxz])
            rotate([0,0,90])
                linear_extrude(wordDepth)
                    scale([scaleVal,scaleVal,scaleVal])
                        text(size=20,"+",halign="center");
        
        // Text -
        translate([rboxx/2+1.6*switchHoleDiam,rboxy/3-switchSpacing/2-0.5,rboxz])
            rotate([0,0,90])
                linear_extrude(wordDepth)
                    scale([scaleVal,scaleVal,scaleVal])
                        text(size=25,"-",halign="center");
        
        // Jog dir
        translate([rboxx/2.4,rboxy/3-switchSpacing/1.1,rboxz])
            rotate([0,0,180])
                linear_extrude(wordDepth)
                    scale([scaleVal,scaleVal,scaleVal])
                        text(size=7,"Jog Dir",halign="center");
            
        // Text +90
        translate([rboxx/3.4,rboxy/2 + switchSpacing*1.2,rboxz])
            rotate([0,0,90])
                linear_extrude(wordDepth)
                    scale([scaleVal,scaleVal,scaleVal])
                        text(size=10,"+90",halign="center");
        // Text -90
        translate([rboxx/2+switchHoleDiam,rboxy/2 + switchSpacing*1.2,rboxz])
            rotate([0,0,90])
                linear_extrude(wordDepth)
                    scale([scaleVal,scaleVal,scaleVal])
                        text(size=10,"-90",halign="center");
        }
}



module Cyl(){
    cylinder(d=combDiam,h=combHeight,$fn = 6);
}



// Single Honeycomb
module HoneyComb(comb=false){
    rotate([0,0,90]) 
        cylinder(d=combDiam,h=5,$fn = 6);

    step = 360/n;
    for (i=[0:step:359]) {
        angle = i;
        dx = r*cos(angle);
        dy = r*sin(angle);
        translate([dx,dy,0])
            rotate([0,0,90]) Cyl();
    }
    
    r2 = r + combDiam;
    for (i=[0:step:359]) {
        angle = i+30;
        dx = r2*cos(angle);
        dy = r2*sin(angle);
        translate([dx,dy,0])
            rotate([0,0,90])Cyl();
    }
    
    r3 = r2+combDiam/6;
    for (i=[0:step:359]) {
        angle = i;
        dx = r3*cos(angle);
        dy = r3*sin(angle);
        translate([dx,dy,0])
            rotate([0,0,90])Cyl();
    }
}


module CombOfCombs(){
    rotate([0,0,90]) 
    cylinder(d=combDiam,h=5,$fn = 6);
    
    step = 360/n;
    rotate([0,0,0])HoneyComb();
    
    r4 = 35-r/2;
    for (i=[0:step:359]) {
        angle = i+30;
        dx = r4*cos(angle);
        dy = r4*sin(angle);
        translate([dx,dy,0])
            HoneyComb();
    }
    
    r5 = 59-r/2;
    for (i=[0:step:359]) {
        angle = i;
        dx = r5*cos(angle);
        dy = r5*sin(angle);
        translate([dx,dy,0])
            HoneyComb();
    }
}


module CombSquare(){
    difference(){
        //HoneyComb();
        CombOfCombs();
        cubesize = 200;
        
        translate([cubesize/2+43,0,0])cube(cubesize,center=true);
        mirror([1,0,0])translate([cubesize/2+43,0,0])cube(cubesize,center=true);
        
        translate([0,cubesize/2+45,0])cube(cubesize,center=true);
        mirror([0,1,0])translate([0,cubesize/2+45,0])cube(cubesize,center=true);
    }
}


difference(){
    // Lid Base
    translate([0,0,rimz])
        Lid();
        Holes();
    // Words
//    translate([0,0,-wordDepth/2])
//        Words();
    // Honeycomb Pattern
    translate([rboxx/2,rboxy/2,rboxz-rboxz])
        scale([combxScale,combyScale,1])CombSquare();

}
difference(){
    Rim();

}

difference(){
    NonHoles();
    Holes();
}
