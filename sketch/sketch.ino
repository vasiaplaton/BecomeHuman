//includes
#include "GyverTimer.h"
#include "GyverFilters.h"
#include <FastLED.h>
#include "GyverButton.h"
//defines(settings)
#define BRIGHTNESS 70 // max brightness
#define MIN_BRIGHTNESS 5 // min brightness
#define OFF_BRIGHTNESS 2 // off led brightness
#define TIME_FADE 700 / (BRIGHTNESS-MIN_BRIGHTNESS) // calculate the fade time
#define DATA_PIN 13 // pin where's sk6812 connected
#define NUM_LEDS 9 // how many leds in your circle
#define BTN_PIN 3
#define EFFECTS_AMOUNT 7
#define SENSOR_PIN A0

//start effect timer with 1 ms period
GTimer_ms effectTimer(10);
// Define the array of leds
CRGB leds[NUM_LEDS];
//Work with buttons
GButton touch(BTN_PIN, LOW_PULL, NORM_OPEN);
//Filter
GFilterRA filter;

/// global variables
uint8_t brightness = 35; // global brightness ( for fade)
uint8_t effect = 6; // number effect
boolean dir = true; // direction (global boolean variable);
unsigned long counter = 0; // first ( big) counter. Used to set period of calling effects
int counter2 = 0; // second counter
int counter3 = 0;
boolean in_peak = true; // direction (global boolean variable);
unsigned long counter_p = 0; // first ( big) counter. Used to set period of calling effects
uint8_t prev_val = 0; // second counter
uint8_t peak_amount = 0;
uint8_t pulse_effect = 0;
boolean need_setup = true; // is effect need to setup(SET TO TRUE IF YOU CHANGED EFFECT)
boolean fade = true;
boolean off_leds = true;
boolean bluetooth_changes = true; // if effect changed need to set it
boolean graph = false;
uint8_t pulse_borders[3] = {60, 90, 120};
CRGB SerialColor = CRGB(0, 0, 0); // global color variable(now used for serial color storage)
///

///effect timer tick(call in loop) period of calling 1ms
void effectTick(int effect_num) {
  if (effectTimer.isReady()) {
    switch (effect_num) {
      case 0:
        medium(false , false, true);
        break;
      case 1:
        round_effect(true , true, false, false , false, true);
        break;
      case 2:
        medium(true , true, false);
        break;
      case 3:
        round_effect(true , false, false, true , true, false);
        break;
      case 4:
        medium(true , false, false);
        break;
      case 5:
        fast(true , false, false);
        break;
      case 7:
        color(SerialColor);
        break;
    }
  }
}
// call in loop to work with serial
void serialTick() {
  if (Serial.available() > 0) {
    String serial = Serial.readString();
    if (serial[0] == 'e') {
      if(effect >= 6 ) {
        effect = 0;
        bluetooth_changes = true;
      }
      if ( serial[1] == '+' && effect < 5) next_effect();
      if ( serial[1] == '-' ) previous_effect();
      need_setup = true;
    }
    if (serial[0] == 'c') {
      effect = 7;
      int red = serial[1];
      int green = serial[2];
      int blue = serial[3];
      SerialColor = CRGB(red, green, blue);
      /// Serial.println(effect);
      need_setup = true;
    }
    if (serial[0] == 's') {
      if (serial[1] - '0' == 0) fade = false;
      if (serial[1] - '0' == 1) fade = true;
      if (serial[2] - '0' == 0) off_leds = false;
      if (serial[2] - '0' == 1) off_leds = true;
    }
    if (serial[0] == 'g') {
      if ( serial[1] == '1' ) graph = true;
      if ( serial[1] == '0' ) graph = false;
    }
    if (serial[0] == 'p') {
      if ((serial[1] - '0') < 3) {
        int number_getted = (serial[2] - '0') * 100 + (serial[3] - '0') * 10 + (serial[4] - '0');
        int border_num = serial[1] - '0';
        pulse_borders[border_num] = number_getted;
        Serial.println(pulse_borders[border_num]);
        effect = 6;
        need_setup = true;
      }
    }
  }
  if (bluetooth_changes) {
    bluetooth_changes = false;
    char effect_char = effect + '0';
    Serial.print("e");
    Serial.println(effect_char);
  }

}
void next_effect() {
  if (effect + 1 < EFFECTS_AMOUNT) effect++; // last effect is serial color
  if ( effect == 1 || effect == 3 ) { // skip round effects
    effect++;
  }
  need_setup = true;
  bluetooth_changes = true;
}
void previous_effect() {
  if (effect > 0) effect--;
  need_setup = true;
  bluetooth_changes = true;
}
void buttonTick() {
  touch.tick();

  if (touch.hasClicks()) {
    byte clicks = touch.getClicks();
    switch (clicks) {
      case 1:
        next_effect();
        break;
      case 2:
        previous_effect();
        break;
      case 3:
        break;
    }
  }
}
void setup() {
  FastLED.addLeds<NEOPIXEL, DATA_PIN>(leds, NUM_LEDS);
  FastLED.show();
  Serial.begin(9600);
  Serial.setTimeout(40);
  //button settings
  touch.setTimeout(300);
  touch.setStepTimeout(10);
  analogReference(INTERNAL);
  // filters
  filter.setCoef(0.3);
  filter.setStep(1);
}
void loop() {
  if (effect == 6) {
    piezo();
    effectTick(pulse_effect);
  }
  else effectTick(effect);
  buttonTick();
  serialTick();
}
