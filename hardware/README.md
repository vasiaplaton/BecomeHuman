# DIY cosplay LED from Detroit: Become human
### Code name: becomehuman
 This is hardware part of my project. All project cosist of two board:
 1. The first big board with arduino and hc-05 bluetooth module and suprressor
 It connects by grey six-wired cable to upper board-ring, by mini-usb to power source(powerbank, can be used something like 1x18650cell connected directly), hc-05 allows to connect to smartpohne by bluetooth, but it's not requiered. This board are "head" for all system. It uses arduino nano to controll all peripehal. Firmware for arduino can be found in folder sketch.
 Photo
 ![Img](/img/big_board.png)
 Shematic can be found in subfolder schematic     
 Board for home fabricate - Arduino_pcb.jpg

 2. Second board it's small round board that consist of 9 sk6812 addresable led, ttp223 touch button controller, and piezo sensor on bottom side. It's covered by transparen plastic that covered by transparent plastic, on bottom side it has small glued round piece of copper foil, that connects to ttp223 input. 
 Schematic so simple, that not needed, board image for home fabricate - Round pcb.jpg