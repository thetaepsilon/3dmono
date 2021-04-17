// mini-ITX (and ATX?) spec assumes that for the purposes of component Z-height measurement,
// the motherboard PCB thickness is this (in mm).
s_pcb_thickness = 1.57;

// board X/Y dimensions where the I/O area is at the top.
// used for relative positioning from the top edge below among other things.
s_board_width = 170;
s_board_height = 170;



/*
component height zone layout diagram follows.
information extracted from intel's "Mini-ITX Addendum Version 1.1" document.
this crude diagram is neither to scale (see figures that follow)
nor reproduces any creative aspect of the original technical drawing,
and is in the spirit of interoperability, therefore is believed to be fair use.
*/
/*

// diagram NOT to scale but does represent entire board area.

+--------+------------+
|        |   area D   |
|        +------------+
| area B |   area A
|        +------------+
|        |   area C   |
+--------+------------+

area A takes up everything that B, C and D do not.

*/

// heights of each zone.
s_height_zone_a = 57;
s_height_zone_b = 16;
s_height_zone_c = 38;
s_height_zone_d = 39;


module height_zone_volumes_parametric(
		board_width,
		board_height,
		b_width,
		c_height,
		d_height
	)
{
	// NB: these are just the volumes from the top of the board.
	// it's expected this is pre-elevated to PCB surface via a transform() block.

	cube([b_width, board_height, s_height_zone_b]);

	// all the other zones go from B's right edge to the board's right edge,
	// so they all have a common width.
	b_rhs_width = board_width - b_width;

	// y u no negative distances to go backwards from origin...
	translate( [b_width, board_height - d_height, 0] ) {
		cube([b_rhs_width, d_height, s_height_zone_d]);
	}

	// zone A is between C and D anchored at either edge,
	// so it's Y height is whatever they don't take.
	a_height = board_height - (c_height + d_height);
	assert(a_height > 0);

	translate( [b_width, c_height, 0] ) {
		cube([b_rhs_width, a_height, s_height_zone_a]);
	}

	translate( [b_width, 0, 0] ) {
		cube([b_rhs_width, c_height, s_height_zone_c]);
	}
}

module height_zone_volumes() {
	height_zone_volumes_parametric(
		board_width = s_board_width,
		board_height = s_board_height,
		b_width = 15,
		c_height = 30,
		d_height = 27
	);
}






module mitx_base_volumes() {
	cube([s_board_width, s_board_height, s_pcb_thickness]);

	// component heights based off top of PCB.
	translate([0, 0, s_pcb_thickness]) {
		height_zone_volumes();
	}
}

module mitx_base() {
	difference() {
		mitx_base_volumes();
		// mitx_base_cutouts();
	}
}

mitx_base();

