/* interrupt routine for Rotary Encoders
   tested with Noble RE0124PVB 17.7FINB-24 http://www.nobleusa.com/pdf/xre.pdf - available at pollin.de
   and a few others, seems pretty universal

   The average rotary encoder has three pins, seen from front: A C B
   Clockwise rotation A(on)->B(on)->A(off)->B(off)
   CounterCW rotation B(on)->A(on)->B(off)->A(off)

   and may be a push switch with another two pins, pulled low at pin 8 in this case
   raf@synapps.de 20120107

*/


// usually the rotary encoders three pins have the ground pin in the middle
enum PinAssignments {
  encoderPinA = 5,   // right
  encoderPinB = 6,   // left
  clearButton = 7    // another two pins
};

volatile unsigned int encoderPos = 0;  // a counter for the dial
unsigned int lastReportedPos = 1;   // change management
static boolean rotating=false;      // debounce management

// interrupt service routine vars
boolean A_set = false;              
boolean B_set = false;


void setup() {

  pinMode(encoderPinA, INPUT_PULLUP); 
  pinMode(encoderPinB, INPUT_PULLUP); 
  pinMode(clearButton, INPUT_PULLUP);


// encoder pin on interrupt 0 (pin 2)
  attachInterrupt(encoderPinA, doEncoderA, FALLING);
// encoder pin on interrupt 1 (pin 3)
  attachInterrupt(encoderPinB, doEncoderB, FALLING);

  SerialUSB.begin(9600);  // output
  SerialUSB.println("starting...");
}

// main loop, work is done by interrupt service routines, this one only prints stuff
void loop() { 
  rotating = true;  // reset the debouncer

  if (lastReportedPos != encoderPos) {
    SerialUSB.print("Index:");
    SerialUSB.println(encoderPos, DEC);
    lastReportedPos = encoderPos;
  }
  if (digitalRead(clearButton) == LOW )  {
    encoderPos = 0;
  }
}

// Interrupt on A changing state
void doEncoderA(){
  
  // Test transition, did things really change? 
  if( digitalRead(encoderPinB) == HIGH ) {  
    
      encoderPos += 1;

    
  }
}

// Interrupt on B changing state, same as A above
void doEncoderB(){
 
  if( digitalRead(encoderPinA) == HIGH ) {

      encoderPos -= 1;
  }
}


