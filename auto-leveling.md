# Hypercube Bed Leveling Process

This document was made using Marlin firmware RCBugFix branch at this [commit](https://github.com/MarlinFirmware/Marlin/tree/48925b7298bd1a1abb95b31246326af76d2f1aa8)

## Setup the bed

Usually done after moving the printer

- Give all the springs middle tension. My starting preference is 20mm between bed and lowest part of the spring. 

  I use a steel ruler to align each spring.

## Setup the probe

[LJ12A3-4-Z/BY PNP DC6-36V Inductive Proximity Sensor](http://www.banggood.com/LJ12A3-4-ZBY-PNP-DC6-36V-Inductive-Proximity-Sensor-Detection-Switch-p-982679.html?rmmds=myorder)

Some work at 5V but from my experience it's best to run them according to their spec levels. 
You can use a voltage divider to limit a higher voltage down to 5v if need be.

Attach Probe

- Put hotend nozzle flat to bed
- Use a 1mm object to slide under the probe and adjust the probe to be touching the top of the object (I use a steel ruler). Make sure that when you remove the object under the probe that the probe drop down to the bed when you pull away
- Tighten probe nuts with spanners or pliers if your using the original probe mount.
  I use this [part](http://www.thingiverse.com/thing:2179807) because I find easier to align the probe and allows me to hand tighten the nuts because it's clipped in already. 

- Calculate distance between probe tip and nozzle tip

  1. Heat the nozzle and bed for material temperature (Just be mindful of any filament getting in the way when leveling)
  2. `m851 z0` set the probe z offset to 0.
  3. `g28` home all axes. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
  4. Move the nozzle to the centre of the bed using a control or [G0 or G1](http://marlinfw.org/docs/gcode/G000-G001.html) 
  5. `g92 z5` give yourself some extra room so we can keep moving the nozzle down below what it thinks is zero.
  6. Slide paper under the nozzle.<br>Move the nozzle down until you get a tight grip.<br>The paper should be at the point where it just starts to folding in your hand.<br>Back off until it starts to slip under the nozzle. 
  7. Take note of the current z position. (It should be below 0)
  8. Run `m851 z%CALCULATED NUMBER GOES HERE%`. [M851](http://reprap.org/wiki/G-code#M851:_Set_Z-Probe_Offset)
  9. `g28` home all axes, this resets the g92 command we gave earlier and puts us back at the real zero level. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
  10. Move nozzle to z0 and double check with paper that it's the same
  11. If all ok run `m500` to save settings

Try printing a calibration cube! (I use a 40mm cube from here http://www.thingiverse.com/thing:56671 )

|Property|Value|Notes|
|--------|-----|-----|
|Line Width|0.4mm|For a 0.4mm nozzle|
|Initial Layer Height|0.1mm|This setting is usually set per print (typically 0.1-0.3mm)|
|Layer Height|0.2mm||
|Top\Bottom Layer Count|2|Layer height * Top\Bottom Layer Count = 0.4mm|
|Wall Line Count|1|Line Width * Wall Line Count = 0.4mm|
|Infill|0%||
|Supports|No||
|Print Speed|30mm/s||
|Skirt Line Count|1||
|Skirt Distance|8mm||

Examine the first layer and tweek bed springs if needed.

### Troubleshooting

##### Leveling the bed

  - Use the auto level data produced by the probe and adjust the springs to help level your bed if the report shows a large difference. 

    My bed is flat but I usually find a 2-3mm difference between the back and the front of the bed. I raise the back upwards (anti-clockwise turning) to close this gap. I then run the auto leveling procedure again. Repeat if I need to until I've got it around 0.5-0.8mm difference between the biggest corner gaps.

##### Check auto leveling is working

- At printer start-up you should see 
  ```
  Auto Bed Leveling:
  echo:  M420 S0
  ```
  If not then check you've enabled AUTO LEVELING in the configuration.
- `m420 v` will show that the bed leveling data is there from the previous run. [M420](http://reprap.org/wiki/G-code#M420:_Enable.2FDisable_Mesh_Leveling_.28Marlin.29)

##### Check the probe's repeatability.

- First you need to uncomment `#define Z_MIN_PROBE_REPEATABILITY_TEST` in your configuration.h
- `g28` home all axes. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
- `m48 p10 x100 y100 v2 e l2` [M48](http://reprap.org/wiki/G-code#M48:_Measure_Z-Probe_repeatability)
- Repeat 2 to 3 times to see how much difference in the "Standard Deviation" your probe is reporting.
- If it's always far away from each test check the tightness of the probe mount.
  - Make sure the cable has a bit of slack above the probe because the cable bundle would be able to pull the probe forcing it to wiggle slightly
  - Make sure associated printer parts are also tight and not loose.
  
Repeatability comparision

|Fixed z-endstop| | | | |
|-|-|-|-|-|
|Mean: -0.004750 |Min: -0.007 |Max: -0.003 |Range: 0.005|Standard Deviation: 0.001750|
|Mean: -0.009500| Min: -0.010 |Max: -0.007 |Range: 0.003|Standard Deviation: 0.001000|
|Mean: -0.010750 |Min: -0.012 |Max: -0.007 |Range: 0.005|Standard Deviation: 0.001601|

|Probe          | | | | |
|-|-|-|-|-|
|Mean: 0.521500 |Min: 0.515 |Max: 0.525 |Range: 0.010|Standard Deviation: 0.003000|
|Mean: 0.518250 |Min: 0.515 |Max: 0.520 |Range: 0.005|Standard Deviation: 0.001601|
|Mean: 0.512750 |Min: 0.507 |Max: 0.518 |Range: 0.010|Standard Deviation: 0.003052|
