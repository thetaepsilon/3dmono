$fn = 32;

width = 116.84;
height = 72.26;
thickness = 4;

// distance from the edge of the device's PCB to the centre of the mounting hole.
screw_inset = 2.79;
stem_radius = 2.79;
stem_depth = 4;
total_depth = stem_depth + thickness;
hole_radius = 1.6;



module stem() {
	cylinder(total_depth, stem_radius, stem_radius);
}



// the four locations of the stems inset from the edges.
x1 = screw_inset;
x2 = width - screw_inset;

y1 = screw_inset;
y2 = height - screw_inset;

c1 = [ x1, y1, 0 ];
c2 = [ x2, y1, 0 ];
c3 = [ x1, y2, 0 ];
c4 = [ x2, y2, 0 ];



module hole() {
	cylinder(total_depth, hole_radius, hole_radius);
}





// height zones listed in the schematic for surface mounted components.
// the Y (in this model) distances were measured on-device.
// the X and Z depths were taken from their schematic.

// zone widths layed out left-to-right, cumulative according to schematic.
zone_blank1	=  9.40;
zone_usb	= 12.94;
zone_dcjack	= 14.12;
zone_auxpower	= 11.29;
zone_backlight	=  9.95;
zone_blank2	= 15.30;
zone_bigcoil	= 13.91;
zone_blank3	=  4.18;
zone_hdmi	= 17.72;
zone_blank4	=  8.03;

// cumulative X as we go along the components left-to-right.
// XXX: how good is openscad's looping? might be easier to run through an array...
xz_usb	= zone_blank1;
xz_dcjack	=	xz_usb		+ zone_usb;
xz_auxpower	=	xz_dcjack	+ zone_dcjack;
xz_backlight	=	xz_auxpower	+ zone_auxpower;
xz_bigcoil	=	xz_backlight	+ zone_backlight	+ zone_blank2;
xz_hdmi	=	xz_bigcoil	+ zone_bigcoil		+ zone_blank3;

// assert the numbers line up with the edge of the board to check consistency with schematic.
xz_total	=	xz_hdmi	+ zone_hdmi	+ zone_blank4;
assert((xz_total == width), "cumulative height zone width mismatch");

module components() {
	// first put a base safety layer down for all other components.
	// the schematic states all other components are <2mm.
	// some of these components go right up to the edge of the board,
	// so with the exception of the mounting hole keep-out zones,
	// so must said safety layer without more precise measurements.
	cube([width, height, 2]);

	// reference everything "backwards" from the top edge...
	translate([0, height, 0]) {
		// XXX: assuming Y measurements based on device instead of schematic allowances...
		// naturally some safety margins are included.
		// GRRR why can't I use negative dimensions to work "backwards" here...
		translate([xz_usb,-12,0]) cube([zone_usb,12,4]);

		// this one's Y dim *was* given in the schematic.
		translate([xz_dcjack,-15.5,0]) cube([zone_dcjack,15.5,12]);

		translate([xz_auxpower,-14,0]) cube([zone_auxpower,14,6]);
		translate([xz_backlight,-13,0]) cube([zone_backlight,13,4]);
		translate([xz_bigcoil,-14,0]) cube([zone_bigcoil,14,6]);

		// again this one's Y was given in schematic
		translate([xz_hdmi,-10.69,0]) cube([zone_hdmi,10.69,8]);
	}
}



module base() {
	difference() {
		cube([width, height, thickness]);
		translate([0,height,total_depth]) rotate([180,0,0]) components();
	}
	translate(c1) stem();
	translate(c2) stem();
	translate(c3) stem();
	translate(c4) stem();
}




difference() {
	base();
	translate(c1) hole();
	translate(c2) hole();
	translate(c3) hole();
	translate(c4) hole();
}


//translate([0,height,50]) rotate([180,0,0]) components();

