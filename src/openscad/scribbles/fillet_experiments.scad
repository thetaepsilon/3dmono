
signs = [-1, 1];
nudge = -0.3;

module filleted_cuboid_centered(dims, r, $fn) {
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



module filleted_cylinder_centered(radius, height, edge_radius, fn_radial, fn_edge) {
	radial_remainder = radius - edge_radius;
	assert(radial_remainder >= 0);

	hoffset = height*0.5 - edge_radius;
	assert(hoffset >= 0);

	rotate_extrude($fn = fn_radial) {
		union() {
			intersection() {
				// rotate_extrude can't handle anything 2D that hits negative X coordinates.
				// hence the intersection to bound it in case the circle reaches there.
				// the precise size isn't important and just needs to be >= the circle
				// (in the +X quadrants only).
				translate([0,-height]) square([radius,2*height]);

				// note for() is an implied union of each iteration here.
				// otherwise an explicit union would have been used inside the intersection.
				for (y = [-hoffset, hoffset]) {
					translate([radial_remainder,y]) {
						circle(r = edge_radius, $fn = fn_edge * 4);
					}
				}
			}

			translate([0,-0.5*height]) {
				square([radial_remainder, height]);
			}
			translate([0,-hoffset]) {
				square([radius, 2*hoffset]);
			}
		}
	}
}



fn = 4;
//filleted_cuboid_centered([24, 16, 4], 1, $fn = fn);
filleted_cylinder_centered(4, 4, 0.5, 32, fn);





