# DIY cosplay LED from Detroit: Become human
### Code name: becomehuman
 This is hardware part of my project. All project cosist of two board:
 ## First big board
 1. The first big board with arduino and hc-05 bluetooth module and suprressor
 It connects by grey six-wired cable to upper board-ring, by mini-usb to power source(powerbank, can be used something like 1x18650cell connected directly), hc-05 allows to connect to smartpohne by bluetooth, but it's not requiered. This board are "head" for all system. It uses arduino nano to controll all peripehal. Firmware for arduino can be found in folder sketch.
 ### Pcb components falues can be found in schematic
 ![Img](/img/big_board.png)
 Photo
 ![Img](/img/big_board_photo.jpg)
 Shematic can be found in subfolder schematic     
 Board for home fabricate - Arduino_pcb.jpg
## Second small led ring board
 2. Second board it's small round board that consist of 9 sk6812 addresable led, ttp223 touch button controller, and piezo sensor on bottom side. It's covered by transparen plastic that covered by transparent plastic, on bottom side it has small glued round piece of copper foil, that connects to ttp223 input. Led sk6812 used in 4020 bottom sided package, that solders in wrong way - side to up. Unfourtanetly, i can't found a common led's with package smaller than 3535, so you may have problem if you want to solder board with hot air. 
 Schematic so simple, that not needed, board image for home fabricate - Round pcb.jpg   
 ### Pcb components values
* C1 - capacitor for touch button - 22pF
* U3 - ttp223
* U23-u31 - sk6812    
      
![Img](/img/ring_board.png)    
          
 Photo      
 ![Img](/img/photo_of_ring.jpg)     