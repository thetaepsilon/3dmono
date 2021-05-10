// cube with six holes for internal tapping.
// to be used like a right angle bracket but omnidirectional.

module clamp_cube(s, d) {
	assert(s > d);
	half = s * 0.5;

	translate([half,half,half]) difference() {
		cube([s, s, s], true);
		cylinder(h = s, d = d, center = true);
		rotate([90,0,0]) cylinder(h = s, d = d, center = true);
		rotate([0,90,0]) cylinder(h = s, d = d, center = true);
	}
}

//$fn = 64;
// example instance which would be lego technic (8mm grid) compatible,
// if used with 0.5mm thickness washers on each face (M2.5 and M3 washers).
clamp_cube(7, 2.5);

