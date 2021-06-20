/*
 * miniStorage v1.0
 */

/* [Number of minis] */
// How many minis shall be stored?
number_of_minis = 1; //[1:8]

/* [Mini Base Size] */
// Diameter of mini's base
mini_base_size = 25.25; //[16.37:small - 16.37 mm, 25.25:medium - 25.25 mm, 50.5:large - 50.5 mm, 75.75:huge - 75.75 mm, 101.0:gargantuan - 101 mm]

/* [Mini Size] */
// Width of mini, measured in mm
mini_x = 16.37; //[::float]
// Depth of mini, measured in mm
mini_y = 16.37;   //[::float]
// Height of mini, measured in mm
mini_z = 12.71;   //[::float]

/* [Minimum Size of the Box] */
// With of the box, measured in grid fields
box_w = 3; //[2:18]
// Depth of the box, measured in grid fields
box_d = 2; //[2:8]
// Height of the box, measured in grid fields
box_h = 3; //[2:12]

/* [Grid Size] */
// What is the size in mm of one square grid field? (11.0 mm recommended)
grid_size = 11;

/* [Magnet cut out] */
// 5.2 mm works fine for 5x1 cylindrical magnets
magnet_diameter = 5.2;
// 1.4 mm works fine for 5x1 cylindrical magnets
magnet_height = 1.4;

/* [Wall Dimensions] */
wall_side = 0.9;
wall_back = 1.6;
wall_top = 0.9;

/* [Padding] */
padding_x = 1;
padding_y = 1;
padding_z = 1;

x = max(ceil((max(mini_x,mini_base_size) * number_of_minis + 2*wall_side + padding_x) / grid_size), box_w);
y = max(ceil((max(mini_y,mini_base_size) + wall_back + padding_y) / grid_size), box_d);
z = max(ceil((mini_z + wall_top + 7.2 + padding_z) / grid_size), box_h);


/*
 * Openlock connection bay
 */
module openlock() {
    height = 4;
    zPos = 1.6;
    buffer=1;
    translate([-buffer,-7,zPos]) cube([2+buffer,7*2,height]);
    hull() {
        translate([0,-6,zPos]) cube([2,6*2,height]);
        translate([3+0.01,-5,zPos]) cube([2,5*2,height]);
    }
    hull() {
        translate([5,-5,zPos]) cube([1,5*2,height]);
        translate([6,-5,zPos]) cube([1,5*2,height]);
    }
    translate([6,-6.4,zPos]) cube([4.7,6.4*2,height]);
}


module bottom_square() {
    hull() {
        translate([0.1,0.1,1.2]) cube([grid_size-0.2,grid_size-0.2,0.01]);
        translate([1.1,1.1,0]) cube([grid_size-2.2,grid_size-2.2,0.01]);
    }
}

module bottom_squares() {
    for ( i = [0 : x-1] ) {
        for ( j = [0 : y-1] ) {
            translate([i*grid_size, j*grid_size, 0])
            bottom_square();
        }
    }
}

module top_square() {
    difference() {
        cube([grid_size, grid_size, 1]);
        hull() {
            translate([0.9,0.9,-0.01])
             cube([grid_size-1.8, grid_size-1.8, 0.01]);
            translate([0.1,0.1,1.01])
             cube([grid_size-0.2, grid_size-0.2, 0.01]);
        }
    }
}

module top_squares() {
    for ( i = [0 : x-1] ) {
        for ( j = [0 : y-1] ) {
            translate([i*grid_size, j*grid_size, z*grid_size])
            top_square();
        }
    }
}

module main_cube() {
    render_buffer = 0.06;
    difference() {
        translate([0,0,1.2-render_buffer])
         cube([x*grid_size,y*grid_size,z*grid_size-1.2+render_buffer]);
        translate([wall_side, -0.01, 7.2])
         cube([x*grid_size-2*wall_side, y*grid_size-wall_back+0.01,
               z*grid_size-7.2-wall_top]);
    }
}

module front_bar() {
    zPos = grid_size/2;
    translate([0,0,zPos])
    rotate([0,90,0])
    linear_extrude(height = x*grid_size)
    polygon(points=[[-1,0],[1,0],[0,-1]]);
}

module main_positive() {
    union() {
        bottom_squares();
        main_cube();
        front_bar();
        top_squares();
    }
}

module back_grooves() {
    for ( i = [0 : z-1] ) {
        translate([-0.01, y*grid_size, grid_size/2 + i*grid_size])
        rotate([0,90,0])
        linear_extrude(height = x*grid_size + 0.02)
        polygon(points=[[-1.01,0.01],[1.01,0.01],[0,-1.2]]);
    }
}

module round_sidewall_cuts() {
    zPos = (grid_size/2+1);
    h = z*grid_size - zPos - wall_top;
    translate([-0.01, 0, h/2 + zPos])
    rotate([0,90,0])
    linear_extrude(height = x*grid_size + 0.02)
    resize([h, y*grid_size]) circle(d=1,$fn=100);
}

module openlock_negatives() {
    
    for( i= [y-1 : -2 : 1]) {
        translate([0, i*grid_size, 0]) rotate([0,0,0]) openlock();
        translate([x*grid_size, i*grid_size, 0]) rotate([0,0,180]) openlock();
    }
    
}

module figure_base_cutout() {
    translate([0,0,6.2])
    linear_extrude(4)
     circle(d=mini_base_size + 0.75, $fn=100);
    translate([0,0,6.2 - magnet_height])
     linear_extrude(magnet_height + 0.01)
     circle(d=magnet_diameter, $fn=100);
}

module figure_base_cutouts() {
    buf = (grid_size*x - 2*wall_side - mini_base_size*number_of_minis) / (2*number_of_minis + 2);
    x0 = x*grid_size - 2*wall_side - 2*buf;
    y0 = y*grid_size;
    x1 = (x0/number_of_minis);
    for ( i = [0 : number_of_minis-1] ) {
        translate([wall_side + buf + x1/2 + i*x1, y0/2, 0])
        figure_base_cutout();
    }
}

module all() {
    difference() {
        main_positive();
        
        back_grooves();
        
        openlock_negatives();
        
        figure_base_cutouts();
        
        round_sidewall_cuts();
    }
    
    
}



//color("green")
rotate([-90,0,0])
all();

echo(
    str("Box size: ",
        x, " x ",
        y, " x ",
        z
));

echo(
    str("Box outside dimension: ",
        grid_size*x, " x ",
        grid_size*y, " x ",
        grid_size*z
));

echo(
    str("Max Miniature dimension: ",
        (grid_size*x - 2*wall_side) / number_of_minis, " x ",
        grid_size*y - wall_back, " x ",
        grid_size*z - wall_top - 7.2
));
//figure_base_cutout();
