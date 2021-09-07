/* Run the SHIELDS rotation stage with Arduino EVERY
*/
#define ENCODER_DO_NOT_USE_INTERRUPTS
#include <Encoder.h>

const int ledPin = 13;    // pin 29 on the B3 LO controller and the V1.5 B1B2 controller
const int relayA = 12;    // relay on + side of motor
const int relayB = 11;    // relay on - side of motor

const int encA = 2;       // encoder A input
const int encB = 3;       // encoder B input

const int dirPin = 7;       // direction pin
const int jogGoPin = 4;     // pull low to manually move forward
const int go90Pin = 6 ;     // go 90 degrees forward

long encPos = 0 ;
long desired = 0 ;
//long degree90 = 250000 ;    // number of steps in 90 degrees of rotation
long degree90 = 9000;
byte mode = 0 ;               

// Mode 
// 0 = stopped and we don't know where
// 1 = moving forward 90 degrees
// 2 = stopped at 90 degrees fwd
// 3 = moving backward 90 degrees
// 4 = stopped at 90 degrees back
// 5 = moving forward manually
// 6 = moving backward manually

Encoder preSelect(encA, encB) ;

// Runs Once at Start
void setup() {
  // initialize the digital pin as an output.
  pinMode(ledPin, OUTPUT);
  pinMode(relayA, OUTPUT) ;
  digitalWrite(relayA, HIGH) ;
  pinMode(relayB, OUTPUT) ;
  digitalWrite(relayB, HIGH) ;
  
  pinMode(encA, INPUT) ;
  pinMode(encB, INPUT) ;
  
  pinMode(dirPin, INPUT_PULLUP);
  pinMode(jogGoPin, INPUT_PULLUP) ;
  pinMode(go90Pin, INPUT_PULLUP) ;
  
  preSelect.write(0);
  Serial.begin(9600);
}


// Runs Continuously
void loop() {
  // Encoder
  long curPos ;
  static int counter;
  curPos = preSelect.read() ;
  // read the encoder
  #ifdef DEBUG
  if (curPos != encPos) {
    if (++counter % 100 == 0) {
      Serial.println(curPos) ;
      counter = 0 ;
    }
    encPos = curPos ;
  }
  #else
  encPos = curPos ;
  #endif
  
  // Check Jog Forwards (+) // 
  if (!digitalRead(jogGoPin) && digitalRead(dirPin)) {
    mode = 5 ;
    desired = encPos + 1 ;
//    Serial.println("+++JOG+++");
//    Serial.print("Desired: ");
//    Serial.println(desired);
//    Serial.print("encPos: ");
//    Serial.println(encPos);
  }
  // Check Jog Backwards (-) //
  else if (!digitalRead(jogGoPin) && !digitalRead(dirPin)) {
    mode = 6 ;
    desired = encPos - 1 ;
//    Serial.println("---JOG---");
//    Serial.print("Desired: ");
//    Serial.println(desired);
//    Serial.print("encPos: ");
//    Serial.println(encPos);
  }
  // Check go 90 Forwards (+) //
  // only valid if we are 90 degrees back or mode 0
  else if ((!digitalRead(go90Pin) && digitalRead(dirPin)) && ((mode == 0) || (mode == 4))) {
    mode = 1 ;
    desired = encPos + degree90 ;
    Serial.println("+++90+++");
    delay(10);
  }
  // Check go 90 Backwards (-) //
  //  only valid if we are 90 degrees forward or mode 0
  else if ((!digitalRead(go90Pin) && !digitalRead(dirPin)) && ((mode == 0) || (mode == 2))) {
    mode = 3 ;
    desired = encPos - degree90 ;
    Serial.println("---90---");
    delay(10);
  }

  
  // Execute Movement //
  if ((mode == 1) || (mode == 5)) {   // are we moving forward?
    if (encPos < desired) {           // have we gone far enough?
      digitalWrite(relayA, LOW) ;     // no, keep going
//      Serial.println(encPos);
      Serial.println(curPos);
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
//      Serial.println(encPos);
      Serial.println(curPos);
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
  delay(10);
  // else do nothing - BAD PROGRAMMING ALERT: probably a LOT of unhandled cases here
}
