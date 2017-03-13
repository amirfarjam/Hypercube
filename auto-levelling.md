#Hypercube Bed Levelling Process

##Setup the bed. 

- First give all the springs middle tension. (My preference is 15mm between bed and lowest part of the spring. I use a caliper to check each spring)
- Now remove any sag between the front and back of the bed. (This will make it much easier)
  - Place spirit level on left side so the spirit bubble it's facing between back and front. Now raise the front to be level with back by turning the left front screw clockwise.
  - Place spirit level on right side so the spirit bubble it's facing between back and front. Now raise the front to be level with back and turning the right front screw clockwise.

##Setup the probe

[LJ12A3-4-Z/BY PNP DC6-36V Inductive Proximity Sensor](http://www.banggood.com/LJ12A3-4-ZBY-PNP-DC6-36V-Inductive-Proximity-Sensor-Detection-Switch-p-982679.html?rmmds=myorder)

Some work at 5V but from my experience it's best to run them according to their spec levels. 
You can use a voltage divider to limit a higher voltage down to 5v if need be.

- Put hotend nozzle flat to bed
- Use a 1mm object to slide under the probe and adjust the probe to be touching the top of the object. Make sure that when you remove the object the probe isn't resting on it and drops down when you pull away
- Tighten probe nuts with spanners or pliers etc.

##Auto level the bed (using AUTO_BED_LEVELING_BILINEAR, 3x3 grid)

**Heat the hotend and bed before doing this**

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
