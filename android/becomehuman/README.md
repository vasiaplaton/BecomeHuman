# Android app for become human

A my Flutter application to work with led ring
## Features
* Pulse borders change, view graph from piezo
* Effect animation and change in mood mode
* Static color with pallete picker and brightness color
* Easy connect to device by list
* Fade and dir disable in mood mode
## Known limitations
* No drawing animations of effect in pulse mode
## Modes
### * Pulse   
This mode let you to set pulse border and view graph. Graph need to make sure that led ring locate on the head in the right way.
#### Screenshots:
![Screen1](/img/pulse.jpg)
### * Mood
This mode let you to manually set the mode and settings for mode.
You can disable fade and space(round effect) in settings
Watch the video(/video/main.mp4) to watch effects
Efects
1. Low stress(slowly blue fade and round effect)
2. Medium stress (slowly yellow fade and round effect)
3. High stress(slowly red fade and round effect )
4. Very high stress(fast blinking red)
When effects goes to previous used round effect(watch gif on readme in root directory, /img/effect.gif), when go forward this effect doesn't enabled
#### Screenshot
![Screen](/img/mood.jpg)
### * Color
This mode let you to pick constant color from pallete picker and set brightness
#### Screenshot
![Screen](/img/color.jpg)

## Bluetooth protocol
### Send
```
1st symbol:
e
    +   #next effect
    -   #previous effect
    # used in mood mode

c
    rgb #r - red byte, g - green byte, b - blue byte
    #system goes in color mode automatically
    #used in color mode

s
    1st char #'0'/'1' fade in medium effect on/off
    2nd char #'0'/'1' spaces in medium effect on/off
    # used in mood mode

g
    0   #disable send data from piezo to phone by bluetooth
    1   #enable send data from piezo to phone by bluetooth
    # need to display graph in app for locate ring on head in right way
    # when you tap on graph sended g1, when you close graph sended g0

p
    1st char #number of border: 0/1/2
    2,3,4 char #value of pulse border. 
    #If next value lower than previous logic won't work
    #used in pulse mode

```
### Recieve
System must work without smartphone, so all effect change logic on arduino side. Because of it, firmware must send nubmer of effect to app. It's need to correct animate the effect in app.
```
1st symbol
e
    x   #x - number of effect
    #used in mood mode
```
If graph activated by smartphone app we send
```
g
    v #v - filtered value from piezo
    #used in graph


