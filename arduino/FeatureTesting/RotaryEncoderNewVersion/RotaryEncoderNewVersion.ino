#define encoder0PinA 6
#define encoder0PinB 5
volatile unsigned int encoder0Pos = 0;
unsigned int tmp = 0;
unsigned int Aold = 0;
unsigned int Bnew = 0;
volatile int b = 0;
volatile int a = 0;
void setup() {
  pinMode(encoder0PinA, INPUT_PULLUP); 
  pinMode(encoder0PinB, INPUT_PULLUP);
// encoder pin on interrupt 0 (pin 2)
  attachInterrupt(6, doEncoderA, CHANGE);
// encoder pin on interrupt 1 (pin 3)
  attachInterrupt(5, doEncoderB, CHANGE);
// set up the Serial Connection 
  SerialUSB.begin (115200);
}
void loop(){
  //Check each changes in position
 if (tmp != encoder0Pos) {
    SerialUSB.println(encoder0Pos);
    tmp = encoder0Pos;
  }
  delay(1);
 // SerialUSB.print(a);
 // SerialUSB.print(b);
}
// Interrupt on A changing state
void doEncoderA(){
  Bnew^Aold ? encoder0Pos++:encoder0Pos--;
  Aold=digitalRead(encoder0PinA);
  //a+=10;
}
// Interrupt on B changing state
void doEncoderB(){
  Bnew=digitalRead(encoder0PinB);
  Bnew^Aold ? encoder0Pos++:encoder0Pos--;
 // b+=10;
}
