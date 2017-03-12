#Hypercube Bed Levelling Process

##Setup the bed. 

  - First give all the springs middle tension. (My preference is 15mm between bed and lowest part of the spring. I use a caliper to check each spring)
  - Now remove any sag between the front and back of the bed. (This will make it much easier)
    - Place spirit level on left side so the spirit bubble it's facing between back and front. Now raise the front to be level with back by turning the left front screw clockwise.
    - Place spirit level on right side so the spirit bubble it's facing between back and front. Now raise the front to be level with back and turning the right front screw clockwise.

##Setup the probe

[LJ12A3-4-Z/BY PNP DC6-36V Inductive Proximity Sensor](http://www.banggood.com/LJ12A3-4-ZBY-PNP-DC6-36V-Inductive-Proximity-Sensor-Detection-Switch-p-982679.html?rmmds=myorder)

  - Put hotend nozzle flat to bed
  - Use a 1mm object to slide under the probe and now place probe just above the 1mm object. Making sure that when I remove the object the probe doesnt drop down.
  - Tighten probe nuts with two spanners or two pliers.

##Auto level the bed (using AUTO_BED_LEVELING_BILINEAR, 3x3 grid)
    - `m851 z0` (Sets the z offset to 0)
    - `g28` (home all axes)
    - `g29` (runs auto bed level)
    - `g92 z5` (give yourself some extra room so we can keep moving the nozzle down below what it thinks is zero)
    - Now slide paper under the nozzle. We need to get the paper tight but still being able to slide it smoothly under the nozzle
    - Move the nozzle down until you get a tight grip. The paper should be folding in your hand when trying to push it under the nozzle.
    - Now start moving the nozzle up by 0.1mm increments until the paper stays flat when pushing it under the nozzle. That should be the sweet spot.
    - Take note of your current Z position and run `m851 z%CALCULATED NUMBER GOES HERE%`.
    - `m28` (home all axes, this resets the g92 command we gave earlier and puts us back at the real zero level)
    - `m500` to save the settings if you have EEPROM enabled in your configuration.h. (If you dont use EEPROM then you will need to auto level each time you restart your printer)
    
Try printing a calibration cube! (I use this http://www.thingiverse.com/thing:24238)

Examine the first layer. 

You may need to tweek the bed springs.
