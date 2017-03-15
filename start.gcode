;prepare positions
G21 ;metric values
G90 ;absolute positioning
M82 ;set extruder to absolute mode
M107 ;start with the fan off
G28 X0 Y0 ;move X/Y to min endstops

M104 S{material_print_temperature}; heat hotend (no wait)
M190 S{material_bed_temperature}; heat bed (wait)
M109 S{material_print_temperature}; heat hotend (wait)

G92 E0 ;zero the extruded length
G1 F200 E8 ;extrude 8mm of feed stock
G92 E0 ;zero the extruded length again
G1 F9000

G28 Z0 ;move Z to min endstops

M117 Printing...
