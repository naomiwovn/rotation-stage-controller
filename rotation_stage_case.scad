// Noami Yescas
// 08-17-2021
// Box or holder for arduino, relay and rotation stage switches

$fn= 70;


//Arduino dimensions
arduinox = 68.6;
arduinoy = 53.3;
arduinoz = 3;

// Box dimensions
boxThickness = 2;
boxx = arduinox + boxThickness*2 +20;
boxy = arduinoy + boxThickness*2 +20;
boxz = 15;

// Hole positions
holediam = 3.2;
h1x = 14;
h1y = 2.5;
h2x = h1x + 1.3;
h3x = h2x + 50.8;
h4y = h1y + 5.1;
h4x = h3x;
h3y = h4y + 27.9;
h2y = h3y + 15.2;

module Hole(holediam){
    cylinder(d = holediam,h=arduinoz+.1);
}

module PlaceHole(holenum){
    // Populates hole coordinates of desired hole number
    //  *2   .3
    // *1    *4
    if (holenum <= 4 && holenum >= 1){
        positions = [[h1x,h1y],[h2x,h2y],[h3x,h3y],[h4x,h4y]];
        hx = positions[holenum-1][0];
        hy = positions[holenum-1][1];
        translate([hx,hy,-0.05]) 
            Hole();
    }
}

module FourHoles(){
        // Bottom Left hole
        PlaceHole(1);
        // Top Left hole
        PlaceHole(2);
        // Top Right hole
        PlaceHole(3);
        // Bottom Right Hole
        PlaceHole(4);
}

module Arduino(){
    difference(){
        cube([arduinox, arduinoy, arduinoz]);
        FourHoles();
    }
}

module OutsideBox(){
    cube([boxx,boxy,boxz]);    
}

module InsideBox(){
    translate([boxThickness,boxThickness,boxThickness])
        cube([boxx-boxThickness*2, boxy-boxThickness*2, boxz]);
}


difference(){    
    OutsideBox();        
    InsideBox();
}
translate([boxx/2-arduinox/2,boxy/2-arduinoy/2,boxThickness]) Arduino();
