

static int pinA = 5; // Our first hardware interrupt pin is digital pin 2
static int pinB = 6; // Our second hardware interrupt pin is digital pin 3

const int enc1PinA = 5; // Our first hardware interrupt pin is digital pin 2
const int enc1PinB = 6; // Our second hardware interrupt pin is digital pin 3
const int enc1ButtPin = 7; // Our first hardware interrupt pin is digital pin 2
const int enc1_ID = 0;

static int enc2PinA = 8; // Our first hardware interrupt pin is digital pin 2
static int enc2PinB = 9; // Our second hardware interrupt pin is digital pin 3
static int enc2ButtPin = 10; // Our first hardware interrupt pin is digital pin 2
static int enc2_ID = 1;

volatile long encoderPos = 0; //this variable stores our current value of encoder position. Change to int or uin16_t instead of byte if you want to record a larger range than 0-255
volatile long oldEncPos = 0; //stores the last encoder position value so we can compare to the current reading and see if it has changed (so we know when to print to the serial monitor)
volatile byte reading = 0; //somewhere to store the direct values we read from our interrupt pins before checking to see if we have moved a whole detent
volatile bool curA = LOW;
volatile bool curB = LOW;
volatile bool lastA = LOW;
volatile bool lastB = LOW;
volatile int  rawEnc = 0;

const int irqpin = 2;  // Digital 2
const int irqpin2 = 3; 
int octave = 3;
boolean touchStates[12]; //to keep track of the previous touch states
boolean touch2States[4];
boolean quadStates[4];
const int vMode = 1;
const int oMode = 0;
int mode = 0;

long oldPosition  = -999;
int octCheck = 3;
int numOctaves = 11;
int volume = 127;

//Rotary Button Variables
int ledState = HIGH;
const int rotButt = 7;
int rotButtState;
int lastRotButtState = LOW;
long lastDebounceTime = 0;  // the last time the output pin was toggled
long debounceDelay = 50;    // the debounce time; increase if the output flickers

EnCode enc1(enc1PinA,enc1PinB,enc1ButtPin, enc1_ID);
EnCode enc2(enc2PinA,enc2PinB,enc2ButtPin, enc2_ID);


const byte mpr121_A = 0x5A;
const byte mpr121_B = 0x5B;
