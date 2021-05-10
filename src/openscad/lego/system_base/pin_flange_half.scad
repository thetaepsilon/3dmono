include <technic_base_metric.scad>;
include <pin_dimensions_metric.scad>;

module lego_pin_flanged_base(units) {
	height = units * lego_technic_unit_length;
	flange_height = lego_pin_flange_half_length;

	assert(height >= flange_height, "pin not possible: shorter than flange length!")

	cylinder(h = flange_height, d = lego_pin_flange_diameter);
	cylinder(h = height, d = lego_pin_main_diameter);
}

//$fn = 256;
lego_pin_flanged_base(1.0);

