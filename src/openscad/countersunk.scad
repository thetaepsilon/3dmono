$fn = 36;

module countersink(radius = 5, ratio=10) {
	d = 2 * radius;
	hthick = radius / ratio;
	difference() {
		cube(size=[d,d,hthick*2],center=true);
		translate([0,0,-hthick]) {
			cylinder(h=hthick*4,r1=radius,r2=0);
		}
	};
}



module counterbore(r, h) {
	rotate([0,180,0]) cylinder(h=h,r1=r,r2=0);
}

counterbore(1, 0.5);


/*
difference() {
	sphere(60);
	countersink(radius=50);
}
*/
