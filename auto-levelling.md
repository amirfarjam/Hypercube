# Hypercube Bed Levelling Process

This document was made using Marlin RCBugFix branch at this [commit](https://github.com/MarlinFirmware/Marlin/tree/48925b7298bd1a1abb95b31246326af76d2f1aa8)

## Setup the bed

Usually done after moving the printer

- First give all the springs middle tension. (My preference is 15mm between bed and lowest part of the spring. I use a caliper to check each spring)
- Now remove any sag between the front and back of the bed. (This will make it much easier)
  - Place spirit level on left side so the spirit bubble it's facing between back and front. Now raise the front to be level with back by turning the left front screw clockwise.
  - Place spirit level on right side so the spirit bubble it's facing between back and front. Now raise the front to be level with back and turning the right front screw clockwise.

## Setup the probe

[LJ12A3-4-Z/BY PNP DC6-36V Inductive Proximity Sensor](http://www.banggood.com/LJ12A3-4-ZBY-PNP-DC6-36V-Inductive-Proximity-Sensor-Detection-Switch-p-982679.html?rmmds=myorder)

Some work at 5V but from my experience it's best to run them according to their spec levels. 
You can use a voltage divider to limit a higher voltage down to 5v if need be.

- Put hotend nozzle flat to bed
- Use a 1mm object to slide under the probe and adjust the probe to be touching the top of the object. Make sure that when you remove the object the probe isn't resting on it and drops down when you pull away
- Tighten probe nuts with spanners or pliers etc.

## Test Z Probe Repeatability

- First you need to uncomment `#define Z_MIN_PROBE_REPEATABILITY_TEST` in your configuration.h
- `g28` home all axes. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
- `m48 p10 x100 y100 v2 e l2` [M48](http://reprap.org/wiki/G-code#M48:_Measure_Z-Probe_repeatability)
- Repeat 3 to 5 times to see how much difference in the "Standard Deviation" your probe is reporting.
  - If it's always far away from each test check the tightness of the probe mount etc.. Make sure things aren't loose.

## Auto level the bed (using AUTO_BED_LEVELING_BILINEAR, 3x3 grid)

**Heat the hotend and bed before doing this**

- `m851 z0` (Sets the z offset to 0)
- `g28` home all axes. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
- `g29` run auto bed level. [G29](http://reprap.org/wiki/G-code#G29:_Detailed_Z-Probe)
- `g92 z5` give yourself some extra room so we can keep moving the nozzle down below what it thinks is zero. [G92](http://reprap.org/wiki/G-code#G92:_Set_Position)
- Now slide paper under the nozzle. We need to get the paper tight but still being able to slide it smoothly under the nozzle
- Move the nozzle down until you get a tight grip. The paper should be folding in your hand when trying to push it under the nozzle.
- Now start moving the nozzle-down\bed up by 0.1mm increments until the paper stays flat when pushing it under the nozzle. That should be near the sweet spot.
- Take note of your current Z position and run `m851 z%CALCULATED NUMBER GOES HERE%`. [M851](http://reprap.org/wiki/G-code#M851:_Set_Z-Probe_Offset)
- `g28` home all axes, this resets the g92 command we gave earlier and puts us back at the real zero level. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
- `m420 v` to check that the bed leveling data is there. [M420](http://reprap.org/wiki/G-code#M420:_Enable.2FDisable_Mesh_Leveling_.28Marlin.29)
- `m500` to save these settings if you have EEPROM enabled in your configuration.h. If you dont use EEPROM then you will need to auto level each time you restart your printer [M500](http://reprap.org/wiki/G-code#M500:_Store_parameters_in_EEPROM)

Troubleshooting:

- At start up you should see 
  ```
  Auto Bed Leveling:
  echo:  M420 S0
  ```
  If not then check you've enabled AUTO LEVELING in the configuration.


Try printing a calibration cube! (I use a 40mm cube from here http://www.thingiverse.com/thing:56671 )

|Property|Value|Notes|
|--------|-----|-----|
|Line Width|0.4mm|For a 0.4mm nozzle|
|Initial Layer Height|0.1mm|This setting is usually set per print (typically 0.1-0.3mm).<br> Changes the bed adhesion for the part that is being printed print.<br> I like this set to 0.1 when levelling the bed so I can adjust for different prints later|
|Layer Height|0.2mm||
|Top\Bottom Layer Count|2|Layer height * Top\Bottom Layer Count = 0.4mm|
|Wall Line Count|1|Line Width * Wall Line Count = 0.4mm|
|Infill|0%||
|Supports|No||
|Print Speed|30mm/s||
|Skirt Line Count|1||
|Skirt Distance|8mm||

Examine the first layer and tweek z layer offset (`m851 z*****`) and\or the bed springs if needed
