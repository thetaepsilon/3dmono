
signs = [-1, 1];
nudge = -0.3;

module filleted_cuboid_centered(dims, r, $fn = 2) {
	dia = r * 2.0;

	fn = $fn * 4.0;

	sub = [dims.x - dia, dims.y - dia, dims.z - dia];
	assert(sub.x >= 0);
	assert(sub.y >= 0);
	assert(sub.z >= 0);

	union() {
		// internal cuboids to produce flat faces.
		cube([dims.x, sub.y, sub.z], true);
		cube([sub.x, dims.y, sub.z], true);
		cube([sub.x, sub.y, dims.z], true);

		// cylinders for the edges.
		for (x = signs) {
		for (y = signs) {
			translate([x * sub.x * 0.5, y * sub.y * 0.5, 0]) {
				cylinder(h = sub.z, r = r, center = true, $fn = fn);
			};
		};
		};

		for (y = signs) {
		for (z = signs) {
			translate([0, y * sub.y * 0.5, z * sub.z * 0.5]) {
				rotate([0,90,0]) {
					cylinder(h = sub.x, r = r, center = true, $fn = fn);
					
				}
			};
		};
		};

		
		for (x = signs) {
		for (z = signs) {
			translate([x * sub.x * 0.5, 0, z * sub.z * 0.5]) {
				rotate([90,0,0]) {
					cylinder(h = sub.y, r = r, center = true, $fn = fn);
					
				}
			};
		};
		};

		// sphere-like shapes for the corners.
		// one cannot actually use spheres directly as one winds up with discontinuous geometry.
		// below a shape guaranteed to line up with cylinder representation is used;
		// sphere() doesn't actually work exactly like the below in practice.
		for (x = signs) {
		for (y = signs) {
		for (z = signs) {
			tr = [x * sub.x * 0.5, y * sub.y * 0.5, z * sub.z * 0.5];
			translate(tr) {
				rotate_extrude($fn = fn) intersection() {
					circle(r = r, $fn = fn);
					translate([0,-r]) square(size=[r, 2. * r]);
				}
			}
		}
		}
		}
	};
}

fn = 8;
filleted_cuboid_centered([24, 16, 4], 1, $fn = fn);





