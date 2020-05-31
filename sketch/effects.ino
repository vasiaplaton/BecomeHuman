void fillAll(boolean Red, boolean Green, boolean Blue, int bright) {
  for (int j = 0; j < NUM_LEDS; j++) {
    leds[j] = CRGB(Red ? bright : 0, Green ? bright : 0, Blue ? bright : 0);
  }
}
void medium(boolean Red, boolean Green, boolean Blue) {
  if (need_setup) {
    need_setup = false;
    FastLED.clear();
    counter = 0;
    counter2 = 0;
  }
  if (dir) {
    if (fade) fillAll(Red, Green, Blue, brightness);
    brightness++;
    if (brightness >= BRIGHTNESS) {
      dir = false;
    }
  }
  else {
    if (fade) fillAll(Red, Green, Blue, brightness);
    brightness--;
    if (brightness <= MIN_BRIGHTNESS) {
      dir = true;
    }
  }
  if (!fade) fillAll(Red, Green, Blue, BRIGHTNESS);
  if (off_leds) leds[counter2] = CRGB(Red ? OFF_BRIGHTNESS : 0, Green ? OFF_BRIGHTNESS : 0, Blue ? OFF_BRIGHTNESS : 0);
  int counter21 = counter2 + 4;
  if (counter21 > NUM_LEDS - 1) counter21 -= NUM_LEDS;
  if (off_leds) leds[counter21] = CRGB(Red ? OFF_BRIGHTNESS : 0, Green ? OFF_BRIGHTNESS : 0, Blue ? OFF_BRIGHTNESS : 0);
  FastLED.show();
  if ((counter % 6) == 0) {
    // if (!(random(5) == 0)) counter2++;
    counter2++;
    if (counter2 > NUM_LEDS - 1) counter2 = 0;

  }
  counter++;
}
void round_effect(boolean Red, boolean Green, boolean Blue, boolean Red1, boolean Green1, boolean Blue1) {
  if (need_setup) {
    counter = 0;
    need_setup = false;
    fillAll(Red, Green, Blue, BRIGHTNESS);
    counter2 = 3;
    FastLED.show();
  }
  if ((counter % 6) == 0 ) {
    leds[counter2] = CRGB(Red1 ? BRIGHTNESS : 0, Green1 ? BRIGHTNESS : 0, Blue1 ? BRIGHTNESS : 0);
    counter2--;
    if (counter2 < 0) counter2 = NUM_LEDS - 1;
    if (counter2 == 3) {
      effect -= 1;
      bluetooth_changes = true;
      //need_setup = true;
    }
    FastLED.show();
  }
  counter++;
}
void fast(boolean Red, boolean Green, boolean Blue) {
  if (need_setup) {
    counter = 0;
    need_setup = false;
    dir = true;
    fillAll(Red, Green, Blue, BRIGHTNESS);
    counter2 = 6;
    FastLED.show();
  }
  if ((counter % counter2) == 0 ) {
    if (dir) {
      fillAll(Red, Green, Blue, BRIGHTNESS);
      dir = false;
      if (counter2 == 6) counter2 = 16;
      else if (counter2 == 16) counter2 = 6;
    }
    else {
      fillAll(true, true, true, 0);
      dir = true;
    }
    FastLED.show();
  }
  counter++;
}
void color(CRGB Color) {
  for (int j = 0; j < NUM_LEDS; j++) {
    leds[j] = Color;
  }
  FastLED.show();

}
void piezo() {
  if (need_setup) {
    counter_p = millis(); // time now
    need_setup = false; // setup no't needed any more
    in_peak = false; // in peak
    prev_val = 0; //  previous value
    peak_amount = 6; // number of peaks in time interval
    pulse_effect = 0;
  }
  int pulse = 60;
  int16_t val = 0; //readed  from annalog value

  // analog and filter staff
  for (int i = 0; i < 33; i++) {
    val += analogRead(SENSOR_PIN);
  }
  val = val / 32; // medium from 64 readings
  val = filter.filteredTime(val); // filter values
  if (val < 30) val = 0; // if value > TRESHOLD value = 0

  if (val > prev_val) { // if value > prev value
    in_peak = true; // we in peak
  }
  if ((val < prev_val) && in_peak) { // if in peak and we going down then peak ended(amplitude = counter)
    if (prev_val > 15) { // if amplitude > TRESHOLD
      peak_amount++; // increment counter of peaks
    }
    in_peak = false; // not in peak
  }
  prev_val = val; // ended peak and analog staff previous value = value
  //Serial staff
  // pulse (recalculate pulse every 6 sec)
  if ((millis() - counter_p) > 6000) {
    // calculate and timer staff
    counter_p = millis();
    Serial.print("p");
    pulse = peak_amount * 10; // calculate pulse
    Serial.println(pulse);
    // mood staff
    if (pulse <= pulse_borders[0]) {
      pulse_effect = 0;
    }
    if (pulse > pulse_borders[0] && pulse <= pulse_borders[1]) {
      pulse_effect = 2;
    }
    if (pulse > pulse_borders[1] && pulse <= pulse_borders[2]) {
      pulse_effect = 4;
    }
    if (pulse > pulse_borders[2]) {
      pulse_effect = 5;
    }
    need_setup = true;
    peak_amount = 0;
  }
  // graph(send if needed(graph = true)
  if (graph) {
    //Serial.print("v");
    Serial.println(val);
  }
 

}
