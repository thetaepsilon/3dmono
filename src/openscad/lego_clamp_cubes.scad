use <right_angle_clamp_cube.scad>;

module cube() {
	translate([0.5, 0.5, 0]) clamp_cube(7, 2.5);
}

module array(nx, ny) {
	for (x = [0:1:nx-1]) {
	for (y = [0:1:ny-1]) {
		translate([x*8,y*8,0]) cube();
	}
	}
}

$fn = 8;
n = 10;
array(n, n);

