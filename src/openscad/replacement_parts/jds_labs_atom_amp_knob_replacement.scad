shaft_diameter = 6;
shaft_radius = shaft_diameter * 0.5;
shaft_flat_diameter = 4.5;
shaft_flat_radius = shaft_flat_diameter - shaft_radius;
shaft_cut_depth = 5;

knob_diameter = 22;
knob_radius = knob_diameter * 0.5;
knob_height = 8;

knob_dial_cut_width = 2;
knob_dial_cut_depth = 0.6;

$fn = 128;



module shaft_volume() {
	difference() {
		cylinder(h = shaft_cut_depth, d = shaft_diameter);
		translate([shaft_flat_radius, -shaft_radius, 0]) {
			cube([shaft_diameter, shaft_diameter, shaft_cut_depth]);
		}
	}
}



module knob() {
	difference() {
		cylinder(h = knob_height, d = knob_diameter);
		shaft_volume();
		translate([-knob_radius, -knob_dial_cut_width*0.5, knob_height - knob_dial_cut_depth]) {
			cube([knob_radius, knob_dial_cut_width, 100]);
		}
	}
}



knob();

