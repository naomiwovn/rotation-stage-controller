/* Run the SHIELDS rotation stage
*/
#define ENCODER_OPTIMIZE_INTERRUPTS
#include <Encoder.h>


// Teensy 2.0 has the LED on pin 11
// Teensy++ 2.0 has the LED on pin 6
// Teensy 3.x / Teensy LC have the LED on pin 13
const int ledPin = 13;    // pin 29 on the B3 LO controller and the V1.5 B1B2 controller
const int relayA = 25;    // relay on + side of motor
const int relayB = 26;    // relay on - side of motor
const int encA = 2;       // encoder A input
const int encB = 3;       // encoder B input
const int manFwd = 4;     // pull low to manually movwe forward
const int manBack = 5 ;   // pull low to manually move backwards
const int goFwd = 6 ;     // go 90 degrees forward
const int goBack = 7 ;    // go 90 degrees back
long encPos = 0 ;
long desired = 0 ;
long degree90 = 250000 ;    // number of steps in 90 degrees of rotation
byte mode = 0 ;               // 0 = stopped and we don't know where
                          // 1 = moving forward 90 degrees
                          // 2 = stopped at 90 degrees fwd
                          // 3 = moving backward 90 degrees
                          // 4 = stopped at 90 degrees back
                          // 5 = moving forward manually
                          // 6 = moving backward manually

Encoder preSelect(encA, encB) ;

// the setup() method runs once, when the sketch starts

void setup() {
  // initialize the digital pin as an output.
  pinMode(ledPin, OUTPUT);
  pinMode(relayA, OUTPUT) ;
  digitalWrite(relayA, HIGH) ;
  pinMode(relayB, OUTPUT) ;
  digitalWrite(relayB, HIGH) ;
  pinMode(encA, INPUT) ;
  pinMode(encB, INPUT) ;
  pinMode(manFwd, INPUT_PULLUP) ;
  pinMode(manBack, INPUT_PULLUP) ;
  pinMode(goFwd, INPUT_PULLUP) ;
  pinMode(goBack, INPUT_PULLUP) ;
  preSelect.write(0);
  Serial.begin(9600);
}

// the loop() methor runs over and over again,
// as long as the board has power

void loop() {
  long curPos ;
  static int counter ;
// read the encoder
  curPos = preSelect.read() ;
#ifdef DEBUG
  if (curPos != encPos) {
    if (++counter % 1000 == 0) {
      Serial.println(curPos) ;
      counter = 0 ;
    }
    encPos = curPos ;
  }
#else
  encPos = curPos ;
#endif

  // check if we need to manually go forward or backward
  if (!digitalRead(manFwd)) {
    mode = 5 ;
    desired = encPos + 1 ;
  }
  else if (!digitalRead(manBack)) {
    mode = 6 ;
    desired = encPos - 1 ;
  }
  else
  // see if we are being comanded to go 90 degrees forward
  //  only valid if we are 90 degrees back or mode 0
  if ((!digitalRead(goFwd)) && ((mode == 0) || (mode == 4))) {
    mode = 1 ;
    desired = encPos + degree90 ;
  }
  else
  // see if we are being comanded to go 90 degrees backward
  //  only valid if we are 90 degrees forward or mode 0
  if ((!digitalRead(goBack)) && ((mode == 0) || (mode == 2))) {
    mode = 3 ;
    desired = encPos - degree90 ;
  }
  
  if ((mode == 1) || (mode == 5)) {   // are we moving forward?
    if (encPos < desired) {           // have we gone far enough?
      digitalWrite(relayA, LOW) ;     // no, keep going
    }
    else {
      digitalWrite(relayA, HIGH) ;    // yes - stop
      switch(mode) {
        case 1:
          mode = 2 ;    // done going 90 forward
          break ;
        case 5:
          mode = 0 ;    // done moving manually forwqard
          break ;
      }
    }
  }
  else if ((mode == 3) || (mode == 6)) {  // are we moving backward?
    if (encPos > desired) {               // have we gone far enough?
      digitalWrite(relayB, LOW) ;         // no - keep going
    }
    else {
      digitalWrite(relayB, HIGH) ;        // yes - stop
      switch(mode) {
        case 3:
          mode = 4 ;                      // done going 90 back
          break ;
        case 6:
          mode = 0 ;                      // done with manual back
          break ;
      }
    }
  }
  // else do nothing - BAD PROGRAMMING ALERT: probably a LOT of unhandled cases here
}
