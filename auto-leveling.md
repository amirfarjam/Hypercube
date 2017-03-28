# Hypercube Bed Leveling Process

At the time of last updating this document, Marlin firmware RCBugFix branch used was [commit](https://github.com/MarlinFirmware/Marlin/tree/8c07ac7f7c6da6d0a7e60581019c0b1e62732bf3)

## Setup the bed

Usually done after moving the printer

- Give all the springs middle tension. My starting preference is 20mm between bed and lowest part of the spring.<br>
  I use a steel ruler to align each spring.

## Setup the probe

[LJ12A3-4-Z/BY PNP DC6-36V Inductive Proximity Sensor](http://www.banggood.com/LJ12A3-4-ZBY-PNP-DC6-36V-Inductive-Proximity-Sensor-Detection-Switch-p-982679.html?rmmds=myorder)

Some work at 5V but from my experience it's best to run them according to their spec levels. 
You can use a voltage divider to limit a higher voltage down to 5v if need be.

##### Attach Probe

- Put hotend nozzle flat to bed
- Use a 1mm object to slide under the probe and adjust the probe to be touching the top of the object (I use a steel ruler). Make sure that when you remove the object under the probe that the probe drop down to the bed when you pull away
- Tighten probe nuts with spanners or pliers if your using the original probe mount.<br>
  I use this [part](http://www.thingiverse.com/thing:2179807) because I find easier to align the probe and allows me to hand tighten the nuts because it's clipped in already. 

##### Calculate distance between probe tip and nozzle tip

1. Heat the nozzle and bed for material temperature (Just be mindful of any filament getting in the way when leveling)
2. `M851 Z0` set the probe z offset to 0.
3. `G28` home all axes. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
4. Move the nozzle to the centre of the bed using a control or [G0 or G1](http://marlinfw.org/docs/gcode/G000-G001.html) 
5. `G92 Z5` give yourself some extra room so we can keep moving the nozzle down below what it thinks is zero.
6. Slide paper under the nozzle.<br>Move the nozzle down until you get a tight grip.<br>The paper should be at the point where it just starts to folding in your hand.<br>Back off until it starts to slip under the nozzle. 
7. `M114` and take note of the current z position, it should be below 0 (Read the first "Z:##" outputted in the logged result).
8. `M851 z%YOUR CALCULATED Z OFFSET%`. [M851](http://reprap.org/wiki/G-code#M851:_Set_Z-Probe_Offset)
9. `G92 Z0` resets the printer to be at Z:0. **This is critical because executing `G28` could cause a crash on screws extruding from the bed.**
9. `G28` home all axes. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
10. Move nozzle to Z0 and double check with paper that it's the same.
11. If all ok run `M500` to save settings

## Auto level the bed (using AUTO_BED_LEVELING_BILINEAR, 5x5 grid)

**Heat the hotend and bed before doing this**

  - `G28` home all axes. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
  - `G29` run auto bed level. [G29](http://reprap.org/wiki/G-code#G29:_Detailed_Z-Probe)
  - Don't move the print head and slide paper under the nozzle and again check the paper grip at Z0
  - `M500` to save these settings if you have EEPROM enabled in your configuration.h.<br>
    If you dont use EEPROM then you will need to auto level each time you restart your printer [M500](http://reprap.org/wiki/G-code#M500:_Store_parameters_in_EEPROM)
  - `M420 S1` to ensure auto leveling is enabled just before your print starts. [See discussion here for more info](https://github.com/MarlinFirmware/Marlin/issues/5996#issuecomment-287380079)

Try printing a calibration cube! (I use a 40mm cube from here http://www.thingiverse.com/thing:56671 )

|Property|Value|Notes|
|--------|-----|-----|
|Line Width|0.4mm|For a 0.4mm nozzle|
|Initial Layer Height|0.12mm| Check out the [Prusa calculator](http://www.prusaprinters.org/calculator#layerheight) for your layer height settings|
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
  If not then check you've enabled AUTO_BED_LEVELING_*** in your configuration.h [Example](https://github.com/pflannery/Hypercube/blob/master/configuration.h#L812)
  
- Check your leveling data has persisted using `M420 V`. This will show that the bed leveling data [M420](http://reprap.org/wiki/G-code#M420:_Enable.2FDisable_Mesh_Leveling_.28Marlin.29)

- Ensure you have `M420 S1` in your start.gcode just before your printer starts to print so to ensure that auto leveling is enabled. [Example](https://github.com/pflannery/Hypercube/blob/master/start.gcode#L18)
  
##### Check the probe's repeatability.

- First you need to uncomment `#define Z_MIN_PROBE_REPEATABILITY_TEST` in your configuration.h
- `G28` home all axes. [G28](http://reprap.org/wiki/G-code#G28:_Move_to_Origin_.28Home.29)
- `M48 P10 X100 Y100 V2 E l2` [M48](http://reprap.org/wiki/G-code#M48:_Measure_Z-Probe_repeatability)
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
|Mean: 1.019500 |Min: 1.017 |Max: 1.022 |Range: 0.005|Standard Deviation: 0.002179|
|Mean: 1.020750 |Min: 1.017 |Max: 1.022 |Range: 0.005|Standard Deviation: 0.001601|
|Mean: 1.011750 |Min: 1.005 |Max: 1.017 |Range: 0.012|Standard Deviation: 0.003544|

Example output from marlin log

```
M48 Z-Probe Repeatability Test
1 of 10: z: 1.020
2 of 10: z: 1.017
3 of 10: z: 1.020
4 of 10: z: 1.022
5 of 10: z: 1.022
6 of 10: z: 1.022
7 of 10: z: 1.020
8 of 10: z: 1.020
9 of 10: z: 1.022
10 of 10: z: 1.020
Finished!
Mean: 1.020750 Min: 1.017 Max: 1.022 Range: 0.005
Standard Deviation: 0.001601
```
