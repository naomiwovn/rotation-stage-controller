// Naomi Yescas
// 08-30-21
// Rings go over switches to act as removable labels

ringID = 12.8;
ringOD = 16.5;

labelCubex = 9;
labelCubey = 7;

thickness = 1.5;

nubDepth = 0.79;
nubWidth = 1.5;

difference(){
    // combine outer cylinder with side cubes
    hull(){
        // OD cylinder
        cylinder(d = ringOD, h = thickness);
        //top cube
        translate([0,ringOD/2+labelCubey/2,thickness/2])
            cube([labelCubex,labelCubey,thickness], center=true);
        //bottom cube
        translate([0,-ringOD/2-labelCubey/2,thickness/2])
            cube([labelCubex,labelCubey,thickness], center=true);
    }
    // - Label
    translate([0,-ringOD/2-labelCubey/1.3,0])
        linear_extrude(3)
            scale([2,1,1])text(size=9,"-",halign="center");
    // + label
    translate([0,+ringOD/2-1.4,0])
        linear_extrude(3)
            scale([1,1,1])text(size=9,"+",halign="center");
    
    // inner cylinder
    translate([0,0,-2])
        cylinder(d = ringID, h = thickness+10);
} 

translate([0,-ringID/2+nubDepth/2-0.05,thickness/2])cube([nubWidth,nubDepth,thickness],center=true);