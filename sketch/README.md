# This is firmware for arduino nano.
### Features
* Pulse detect by piezo
* Super simple protocol that works over bluetjoth uart protocol. 
* Work with buttons - 1click next effect, 2clicks previous effect
* Work with 9 addresable led and realistic effect exactly the same as in play.
### Known limitations
* Pulse detect don't work so good if you in moving.

### Efects
1. Low stress(slowly blue fade and round effect)
2. Medium stress (slowly yellow fade and round effect)
3. High stress(slowly red fade and round effect )
4. Very high stress(fast blinking red)
When effects goes to previous used round effect(watch gif on readme in root directory, /img/effect.gif), when go forward this effect doesn't enabled

## Bluetooth protocol
### Recieve
```
1st symbol:
e
    +   #next effect
    -   #previous effect

c
    rgb #r - red byte, g - green byte, b - blue byte
    #system goes in color mode automatically

s
    1st char - '0'/'1' fade in medium effect on/off
    2nd char - '0'/'1' spaces in medium effect on/off

g
    0   #disable send data from piezo to phone by bluetooth
    1   #enable send data from piezo to phone by bluetooth
    # need to display graph in app for locate ring on head in right way

p
    1st char - number of border: 0/1/2
    2,3,4 char - value of pulse border. 
    If next value lower than previous logic won't work
```
### Send
System must work without smartphone, so all effect change logic on arduino side. Because of it, firmware must send nubmer of effect to app. It's need to correct animate the effect in app.
```
1st symbol
e
    x   #x - number of effect
```
If graph activated by smartphone app we send
```
g
    v #v - filtered value from piezo
```

### Externetal libraries
To work with buttons used library gyverbutton, to easy controll timers library gyvertimer,  thanks alexgyver for this libraries. You can easy find his channel on youtube and website by typing in search "alexgyver"