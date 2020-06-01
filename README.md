# DIY cosplay LED from Detroit: Become human
### Code name: becomehuman
![Img](/img/main.jpg)

This is my project that cosplays LED indicator from computer play Detroit: Become human. 
## Features
0. All effects copied from original video of gameplay. Timings and colors and sequence of effect exactly the same as in play
1. Android app that allows controll modes, pulse borders, and pick color. On ring side used HC-05 bluetooth uart.
2. Automatic heart rate monitoring with help piezo sensor. To use this feature you need to locate ring on blood vessel. To defend  arduino from voltage more than 5V from piezo used supressor diode 5.5V
3. Led ring use 9 sk6812, addresebale led that can control separtly and support ~16.7*10^9 colors
4. Touch button on the top of ring allows to control ring without connect it to bluetooth. Used ttp223 as touch button controller IC
5. All pcb one-layred so can be made by home tech.
## Known limitations
1. Pulse detection doesn't work if you move. Maybe optical pulse detection be better, but cheap chienese optical pulse detection module doesnt't work on head.
## More of usefull info you can find in README in subfolders.
## In folder video you can find video(russian language) about modes and work of the project and app
## In /android/becomehuman you can find APK for android installing
### effects:      
![Gif](/img/effects.gif)
