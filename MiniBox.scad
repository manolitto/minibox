/*
 * MiniBox v1.x
 */

/* [Box Configuration] */
// Overall type regarding side and front walls
Box_Type = "open_concave"; //["open_concave":Open box with concave cut side-walls, "open_solid":Open box with solid side-walls, "closable-box-and-door":Closable box with slide-in front wall, "closable-box":Closable box - for slide-in front wall, "3d-door":Slide-in front wall for closable box, "2d-door":2D projection of door only - for laser cuts]
// Cut out OpenLOCK connector bays?
Openlock_Support = "yes"; //["yes":Yes - cut out OpenLOCK connector bays, "no":No]

/* [Miniature Configuration] */
// How many minis shall be stored?
Number_of_Minis = 1; //[1:9]

// Diameter of mini's base
Mini_Base_Size = 25.25; //[16.37:small - 16.37 mm, 25.25:medium - 25.25 mm, 50.5:large - 50.5 mm, 75.75:huge - 75.75 mm, 101.0:gargantuan - 101 mm]

// Total width of mini (only when larger than base size)
Mini_Width = 0.01; //[::float]
// Total depth of mini (only when larger than base size)
Mini_Depth = 0.01;   //[::float]
// Total height of mini including base (in mm)
Mini_Height = 38.01;   //[::float]

// How is the left and right overhang of the mini distributed?
Left_Right_Overhang_Mode = "even"; //["even":Same overhang on both sides, "only_left":Overhang on left side only, "only_right":Overhang on right side only]
// Fixed left side overhang (in mm)
Left_Overhang_Override = 0.01; //[::float]
// Fixed right side overhang (in mm)
Right_Overhang_Override = 0.01; //[::float]

// How is the front and back overhang of the mini distributed?
Front_Back_Overhang_Mode = "even"; //["even":Same overhang on both sides, "only_front":Overhang on front side only, "only_back":Overhang on back side only]
// Fixed front side overhang (in mm)
Front_Overhang_Override = 0.01; //[::float]
// Fixed back side overhang (in mm)
Back_Overhang_Override = 0.01; //[::float]

/* [Box Size Override] */
// Minimal width of box (measured in grid fields)
Box_Width_Override = 2; //[2:18]
// Minimal depth of box (measured in grid fields)
Box_Depth_Override = 2; //[2:8]
// Minimal height of box (measured in grid fields)
Box_Height_Override = 3; //[2:12]

/* [Magnet Configuration] */
// Cut out cylinder magnet hole?
Magnet_Support = "yes"; //["yes":Yes - cut out hole for magnet, "no":No]
// 5.2 mm works fine for 5x1 mm cylinder magnets
Magnet_Diameter = 5.2;
// 1.4 mm works fine for 5x1 mm cylinder magnets
magnet_height = 1.4;

/* [Expert Settings] */
// Size of one square grid field (11.0 mm recommended)
Grid_Size = 11;
// Thickness of side walls (in mm)
Side_Wall_Thickness = 0.9;
// Thickness of back wall (in mm)
Back_Wall_Thickness = 1.6;
// Thickness of box ceiling (in mm)
Ceiling_Thickness = 0.9;
// Thickness of box floor (in mm)
Floor_Thickness = 7.2;
// Depth of mini base cut out (in mm)
Mini_Base_Cut_Out_Depth=1.0;
// Height of mini base (in mm)
Mini_Base_Height=2.5;

/* [Padding and Buffering] */
// Additional space on left side of miniature 
padding_x_left = 0.2;
// Additional space on right side of miniature 
padding_x_right = 0.2;
// Additional space in front of miniature 
padding_y_front = 0.2;
// Additional space behind miniature 
padding_y_back = 0.2;
// Additional space above miniature 
padding_z = 1.2;
// Additional space on very left side of box 
buffer_left = 0.1;
// Additional space on very right side of box 
buffer_right = 0.1;
// Addition to base cutout diameter  (in mm)
base_cutout_padding = 0.68;
// Shrinkage of slide-in wall 
front_wall_buffer = 0.5;

/* [Rail Settings] */
// Offset of the rail from the front edge
rail_offset = 1.01;
// Width of the rail inside (must be less than rail_width_outer)
rail_width_inner = 0.51;
// Width of the rail at the opening
rail_width_outer = 1.01;
// Depth of the rail
rail_depth = 1.01;

/* [Hidden] */

draw_box = (Box_Type == "open_concave") || (Box_Type == "open_solid") || (Box_Type == "closable-box-and-door") || (Box_Type == "closable-box");
draw_3d_door = (Box_Type == "closable-box-and-door") || (Box_Type == "3d-door");
draw_2d_door = (Box_Type == "2d-door");
is_closable_box = (Box_Type == "closable-box-and-door") || (Box_Type == "closable-box");
is_concave_sides = (Box_Type == "open_concave");
is_openlock = (Openlock_Support == "yes");
is_magnet = (Magnet_Support == "yes");

// because of the upper rail we have to increase the z padding for the mini to pass through the opening:
padding_z_effective = padding_z + (is_closable_box ? rail_depth : 0);
ceiling_edge_thickness = Ceiling_Thickness + (is_closable_box ? rail_depth : 0);

front_wall_thickness = is_closable_box
                        ? rail_offset + max(rail_width_inner, rail_width_outer)
                        : 0;

mini_x = max(Mini_Width, Left_Overhang_Override + Mini_Base_Size + Right_Overhang_Override);
mini_y = max(Mini_Depth, Front_Overhang_Override + Mini_Base_Size + Back_Overhang_Override);
mini_z = Mini_Height;

total_width_overhang = mini_x - Mini_Base_Size;
distr_width_overhang = total_width_overhang - Left_Overhang_Override - Right_Overhang_Override;
overhang_left  = Left_Right_Overhang_Mode == "only_left"  ? Left_Overhang_Override + distr_width_overhang :
                 Left_Right_Overhang_Mode == "only_right" ? Left_Overhang_Override :
                                                            Left_Overhang_Override + distr_width_overhang / 2;
overhang_right = Left_Right_Overhang_Mode == "only_left"  ? Right_Overhang_Override :
                 Left_Right_Overhang_Mode == "only_right" ? Right_Overhang_Override + distr_width_overhang :
                                                            Right_Overhang_Override + distr_width_overhang / 2;
total_depth_overhang = mini_y - Mini_Base_Size;
distr_depth_overhang = total_depth_overhang - Front_Overhang_Override - Back_Overhang_Override;
overhang_front = Front_Back_Overhang_Mode == "only_front" ? Front_Overhang_Override + distr_depth_overhang :
                 Front_Back_Overhang_Mode == "only_back"  ? Front_Overhang_Override :
                                                            Front_Overhang_Override + distr_depth_overhang / 2;
overhang_back  = Front_Back_Overhang_Mode == "only_front" ? Back_Overhang_Override :
                 Front_Back_Overhang_Mode == "only_back"  ? Back_Overhang_Override + distr_depth_overhang :
                                                            Back_Overhang_Override + distr_depth_overhang / 2;
echo(
    str("Actual Overhangs: ",
        "Left=", overhang_left,
        ", Right=", overhang_right,
        ", Front=", overhang_front,
        ", Back=", overhang_back
));
                    
padded_mini_x = padding_x_left + mini_x + padding_x_right;
padded_mini_y = padding_y_front + mini_y + padding_y_back;
padded_mini_z = mini_z + padding_z_effective;

minimal_openlock_buffer_left = 11.1 - Side_Wall_Thickness - padding_x_left - overhang_left - ((Mini_Base_Size + base_cutout_padding) / 2 - Magnet_Diameter / 2);
minimal_openlock_buffer_right = 11.1 - Side_Wall_Thickness - padding_x_right - overhang_right - ((Mini_Base_Size + base_cutout_padding) / 2 - Magnet_Diameter / 2);
eff_buffer_left = max(buffer_left, is_openlock && is_magnet ? minimal_openlock_buffer_left : 0);
eff_buffer_right = max(buffer_right, is_openlock && is_magnet ? minimal_openlock_buffer_right : 0);
echo(
    str("Effective side buffers: ",
        "Left=", eff_buffer_left,
        ", Right=", eff_buffer_right
));

x = max(ceil((Side_Wall_Thickness + eff_buffer_left + padded_mini_x * Number_of_Minis + eff_buffer_right + Side_Wall_Thickness) / Grid_Size), Box_Width_Override);
y = max(ceil((front_wall_thickness + padded_mini_y + Back_Wall_Thickness) / Grid_Size), Box_Depth_Override);
z = max(ceil((Floor_Thickness + padded_mini_z + Ceiling_Thickness) / Grid_Size), Box_Height_Override);

x_space_per_mini = (Grid_Size*x - 2 * Side_Wall_Thickness- eff_buffer_left - eff_buffer_right) / Number_of_Minis;
y_space_per_mini = Grid_Size*y - front_wall_thickness - Back_Wall_Thickness;
z_space_per_mini = Grid_Size*z - Floor_Thickness - ceiling_edge_thickness;

eff_mini_x = x_space_per_mini - padding_x_left - padding_x_right;
eff_mini_y = y_space_per_mini - padding_y_front - padding_y_back;
eff_mini_z = z_space_per_mini - padding_z_effective;

eff_overhang_left = overhang_left + (eff_mini_x - mini_x) / 2;
eff_overhang_right = overhang_right + (eff_mini_x - mini_x) / 2;

eff_overhang_front = overhang_front + (eff_mini_y - mini_y) / 2;
eff_overhang_back = overhang_back + (eff_mini_y - mini_y) / 2;

echo(
    str("Input miniature dimensions: ",
        mini_x, " x ",
        mini_y, " x ",
        mini_z, " mm"
));

echo(
    str("Effective overhangs: ",
        "Left=", eff_overhang_left,
        ", Right=", eff_overhang_right,
        ", Front=", eff_overhang_front,
        ", Back=", eff_overhang_back
));

/*
 * Openlock connection bay
 */
module openlock_negative() {
  height = 4;
  zPos = 1.6;
  buffer=1;
  union() {  
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
}

module openlock_negatives() {
    for( i= [y-1 : -2 : 1]) {
        translate([0, i*Grid_Size, 0]) rotate([0,0,0]) openlock_negative();
        translate([x*Grid_Size, i*Grid_Size, 0]) rotate([0,0,180]) openlock_negative();
    }
}


module bottom_square() {
  hull() {
    translate([0.1,0.1,1.2]) cube([Grid_Size-0.2,Grid_Size-0.2,0.01]);
    translate([1.1,1.1,0]) cube([Grid_Size-2.2,Grid_Size-2.2,0.01]);
  }
}

module bottom_squares() {
    for ( i = [0 : x-1] ) {
        for ( j = [0 : y-1] ) {
            translate([i*Grid_Size, j*Grid_Size, 0])
            bottom_square();
        }
    }
}

module top_square() {
    difference() {
        cube([Grid_Size, Grid_Size, 1]);
        hull() {
            translate([0.9,0.9,-0.01])
             cube([Grid_Size-1.8, Grid_Size-1.8, 0.01]);
            translate([0.1,0.1,1.01])
             cube([Grid_Size-0.2, Grid_Size-0.2, 0.01]);
        }
    }
}

module top_squares() {
    for ( i = [0 : x-1] ) {
        for ( j = [0 : y-1] ) {
            translate([i*Grid_Size, j*Grid_Size, z*Grid_Size])
            top_square();
        }
    }
}

module main_cube() {
    render_buffer = 0.06;
    difference() {
      translate([0,0,1.2-render_buffer])
        cube([x*Grid_Size,y*Grid_Size,z*Grid_Size-1.2+render_buffer]);
      translate([Side_Wall_Thickness, -0.01, Floor_Thickness])
        cube([x*Grid_Size-2*Side_Wall_Thickness, y*Grid_Size-Back_Wall_Thickness+0.01,
              z*Grid_Size-Floor_Thickness-Ceiling_Thickness]);
    }
}

module front_bar() {
    zPos = Grid_Size/2;
    translate([0,0,zPos])
    rotate([0,90,0])
    linear_extrude(height = x*Grid_Size)
    polygon(points=[[-1,0],[1,0],[0,-1]]);
}

module rails_bottom_rail_negative() {
    
    translate([-0.1, rail_offset, Floor_Thickness - rail_depth])
    hull() {
        translate([0, rail_width_outer - rail_width_inner, 0])
          cube([x*Grid_Size +0.2, rail_width_inner, 0.01]);
        
        translate([0, 0, rail_depth])
          cube([x*Grid_Size +0.2, rail_width_outer, 0.01]);
    }

}

module rails_sidewall_cuts() {
    // side wall cut
    h = z*Grid_Size - Floor_Thickness - Ceiling_Thickness;
    translate([0 -0.1, -0.1, Floor_Thickness])
      cube([x*Grid_Size +0.2, rail_offset + rail_width_outer + 0.1, h]);
}

module frontCeiling_Thickness_rails() {
    // back 
    translate([0, rail_offset + rail_width_outer, z*Grid_Size - Ceiling_Thickness - rail_depth])
    hull() {
      cube([x*Grid_Size, 0.1, 0.1]);
      translate([0,0,rail_depth])
        cube([x*Grid_Size, 2*rail_offset, 0.1]);
    }
    // front 
    translate([0, 0, z*Grid_Size - Ceiling_Thickness - rail_depth])
    hull() {
      translate([0, 0, 0])
        cube([x*Grid_Size, rail_offset, 0.1]);
      translate([0, 0, rail_depth])
        cube([x*Grid_Size, rail_offset + (rail_width_outer - rail_width_inner), 0.1]);
    }
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
        translate([-0.01, y*Grid_Size, Grid_Size/2 + i*Grid_Size])
        rotate([0,90,0])
        linear_extrude(height = x*Grid_Size + 0.02)
        polygon(points=[[-1.01,0.01],[1.01,0.01],[0,-1.2]]);
    }
}

module round_sidewall_cuts() {
    zPos = (Grid_Size/2+1);
    h = z*Grid_Size - zPos - Ceiling_Thickness;
    translate([-0.01, 0, h/2 + zPos])
    rotate([0,90,0])
    linear_extrude(height = x*Grid_Size + 0.02)
    resize([h, y*Grid_Size]) circle(d=1,$fn=100);
}

module figure_base_cutout() {
  translate([0,0,Floor_Thickness - Mini_Base_Cut_Out_Depth])
    linear_extrude(Mini_Base_Height + Mini_Base_Cut_Out_Depth)
    circle(d=Mini_Base_Size + base_cutout_padding, $fn=100);
  
  if (is_magnet) {
    translate([0,0,Floor_Thickness - Mini_Base_Cut_Out_Depth - magnet_height])
      linear_extrude(magnet_height + 0.01)
      circle(d=Magnet_Diameter, $fn=100);
  }
}

module figure_base_cutouts() {
    for ( i = [0 : Number_of_Minis-1] ) {
        translate([Side_Wall_Thickness + eff_buffer_left + padding_x_left + eff_overhang_left + Mini_Base_Size / 2 + x_space_per_mini * i,
      front_wall_thickness + padding_y_front + eff_overhang_front + Mini_Base_Size / 2, 0])
        figure_base_cutout();
    }
}

module box() {
    union() {
        difference() {
            main_positive();
            
            back_grooves();
            
            if (is_openlock) {
              openlock_negatives();
            }
            
            figure_base_cutouts();
            
            if (is_concave_sides) {
                round_sidewall_cuts();
            } else if (is_closable_box) {
                rails_sidewall_cuts();
                rails_bottom_rail_negative();
            }
        }
        
        if (is_closable_box) {
            frontCeiling_Thickness_rails();
        }
    }
}

module slide_in_front_wall() {
    h = z*Grid_Size - Ceiling_Thickness - Floor_Thickness + rail_depth - front_wall_buffer;
    
    translate([0, -(rail_width_outer - rail_width_inner),0])
    union() {
        hull() {
            translate([0, 0, rail_depth])
              cube([x*Grid_Size, rail_width_inner, h - 2*rail_depth]);

            translate([0, rail_width_outer - rail_width_inner, 0])
              cube([x*Grid_Size, rail_width_inner, h]);
        }
        
        //handles
        translate([0, -(rail_offset - front_wall_buffer/2), rail_depth])
          cube([Side_Wall_Thickness, rail_offset, h - 2*rail_depth]);
        translate([x*Grid_Size-Side_Wall_Thickness, -(rail_offset - front_wall_buffer/2), rail_depth])
          cube([Side_Wall_Thickness, rail_offset, h - 2*rail_depth]);
    }
}

module slide_in_front_wall_2d() {
    h = z*Grid_Size - Ceiling_Thickness - Floor_Thickness + rail_depth - front_wall_buffer;
    cube([x*Grid_Size, 1, h]);
}

if (draw_box) {
  translate([z*Grid_Size, 0, y*Grid_Size])
  rotate([-90,0,90])
    box();
}

if (draw_3d_door) {
  translate([z*Grid_Size - Floor_Thickness, -x*Grid_Size-10, rail_width_inner])
  rotate([-90,0,90])
    slide_in_front_wall();
}

if (draw_2d_door) {
  projection()
    rotate([-90,0,90])
    slide_in_front_wall_2d();
}

echo(
    str("Box grid size: ",
        x, " x ",
        y, " x ",
        z
));

echo(
    str("Box outside dimension: ",
        Grid_Size*x, " x ",
        Grid_Size*y, " x ",
        Grid_Size*z, " mm"
));

echo(
    str("Maximum single miniature dimension: ",
        x_space_per_mini, " x ",
        y_space_per_mini, " x ",
        z_space_per_mini, " mm"
));


