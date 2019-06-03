vst = 45; // vertical support thickness
hst = 45; // horizontal support thickness
bh = 1300; // base height
bhl = 1300; // base height Laura
rh = 1800; // rail height
ew = 400; // entrance width
mid = 90; // mattress insert depth
th = bh+500; // top height

module room_floor() {
    translate([0, 0, -10])
    cube([2400, 2500, 10]);
}

module room_back_wall() {
    cube([0.1, 2500, 2500]);
}

module room_right_wall() {
    cube([2400, 0.1, 2500]);
}

module room_door() {
    translate([1700, 2500, 0]) {
        intersection() {
            cylinder(h = 2000, r1 = 800, r2 = 800);
            rotate([0, 0, 180])
            cube([800, 800, 2000]);
        }
    }
}

module room_window_threshold() {
    translate([2200, 600, 800]) {
        cube([200, 1400, 28]);
    }
}

module vertical_support() {
    cube([vst, vst, th]);
}

module horizontal_support(l) {
    translate([0, 0, mid])
    mirror([0,0,1])
    cube([l, hst, 195]);
}

module rail(l) {
    translate([0, 0, 60])
    mirror([0,0,1])
    cube([l, hst, 70]);
}

module mattress_sara() {
    cube([2000, 800, 120]);
}

module mattress_laura() {
    translate([0,-(350+150),0])
    cube([800, 1300+350+150, 120]);
}


module bed() {
    translate([50, 50, 0]) {
        color("black")
        translate([0, 800, bhl])
        cube([800, 5, mid+50]);

        color("white") {
            translate([0, 0, bh]) {
                mattress_sara();
            }

            translate([0, 800, bhl]) {
                mattress_laura();
            }
        }

        color("brown") { 
            translate([0, 0, 0])
            rotate([0,0,180])
            vertical_support();
            
            translate([2000, 0, 0])
            rotate([0,0,-90])
            vertical_support();
            
            translate([0, 800, 0])
            rotate([0,0,90])
            vertical_support();
            
            translate([2000, 800, 0])
            rotate([0,0,0])
            vertical_support();
            
            translate([800, 800, 0])
            rotate([0,0,0])
            vertical_support();

            translate([800, 800+1300, 0])
            rotate([0,0,0])
            vertical_support();

            translate([0, 800+1300, 0])
            rotate([0,0,90])
            vertical_support();
        }
        
        color("RosyBrown") {
            mirror([0,1,0])
            translate([0, 0, bh])
            horizontal_support(2000);
            
            translate([0, 800, bh])
            horizontal_support(800);

            translate([800+vst, 800, bh])
            horizontal_support(2000-800-vst);

            translate([800, 800+vst, bhl])
            mirror([1,0,0])
            rotate([0,0,90])
            horizontal_support(1300-vst);
            
            translate([0, 800+vst, bhl])
            mirror([0,0,0])
            rotate([0,0,90])
            horizontal_support(1300-vst);
            
            translate([0, 0, bh])
            mirror([0,0,0])
            rotate([0,0,90])
            horizontal_support(800);
            
            translate([2000, 0, bh])
            mirror([1,0,0])
            rotate([0,0,90])
            horizontal_support(800);

            translate([0, 800+1300, bhl])
            mirror([0,0,0])
            rotate([0,0,00])
            horizontal_support(800);
        }

        // extra vertical support at entrance
        translate([800+ew+vst, 800, bh+mid])
        cube([vst, vst, th-bh-mid]);
        
        for (h = [bh+200, bh+400])
        color("Wheat") {
            mirror([0,1,0])
            translate([0, 0, h])
            rail(2000);
            
            *translate([0, 800, h])
            rail(800);
           
            translate([1200+2*vst, 800, h])
            rail(2000-800-vst-ew-vst);

            translate([800, 800+vst, h-(bh-bhl)])
            mirror([1,0,0])
            rotate([0,0,90])
            rail(1300-vst);
            
            translate([0, 800+vst, h-(bh-bhl)])
            mirror([0,0,0])
            rotate([0,0,90])
            rail(1300-vst);
            
            translate([0, 0, h])
            mirror([0,0,0])
            rotate([0,0,90])
            rail(800);
            
            translate([2000, 0, h])
            mirror([1,0,0])
            rotate([0,0,90])
            rail(800);

            translate([0, 800+1300, h-(bh-bhl)])
            mirror([0,0,0])
            rotate([0,0,00])
            rail(800);
        }        

        color("Wheat") {
            render()
            translate([800, 800+vst, 0])
            difference() {
                stairs(
                    top=bh+mid,
                    num_steps=5,
                    step_width=ew,
                    shift_depth=100,
                    step_depth=120,
                    rail_width=140);
                
                translate([0, 0, bh+mid-195])
                cube([vst, bh+mid, 195]);
            }
        }
    }
}

module stairs(
    top,
    num_steps,
    step_width,
    step_depth,
    step_thickness=28,
    shift_width=50 ,
    rail_width=140,
) {
    translate([0, 0, top-step_thickness])
    for (i = [0:num_steps-1]) {
        shift_y = i*shift_width;
        shift_z = i*(top/num_steps);
        
        translate([vst, shift_y, -shift_z])
        cube([step_width, step_depth, step_thickness]);
    }

    angle = atan(shift_width*num_steps/top);
    rl = top/cos(angle) + rail_width*sin(angle);

    render()
    intersection() {
        translate([0, -25, top])
        rotate([angle, 0, 0])
        translate([0, 0, -rl]) {
            translate([0, 0, 0])
            cube([vst, rail_width, rl]);
    
            translate([vst+step_width, 0, 0])
            cube([vst, rail_width, rl]);
        };
        
        cube([1000, 1000, top]);
    }
}

color("blue") {
    *room_right_wall();
    *room_back_wall();
    room_floor();
    *room_window_threshold();
}

color("blue", 1) {
    *room_door();
}

bed();
        
