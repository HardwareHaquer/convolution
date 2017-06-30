

static int pinA = 5; // Our first hardware interrupt pin is digital pin 2
static int pinB = 6; // Our second hardware interrupt pin is digital pin 3

volatile int encoderPos = 0; //this variable stores our current value of encoder position. Change to int or uin16_t instead of byte if you want to record a larger range than 0-255
volatile int oldEncPos = 0; //stores the last encoder position value so we can compare to the current reading and see if it has changed (so we know when to print to the serial monitor)
volatile byte reading = 0; //somewhere to store the direct values we read from our interrupt pins before checking to see if we have moved a whole detent
volatile bool curA = LOW;
volatile bool curB = LOW;
volatile bool lastA = LOW;
volatile bool lastB = LOW;
volatile int  rawEnc = 0;

const int irqpin = 2;  // Digital 2
int octave = 3;
boolean touchStates[12]; //to keep track of the previous touch states
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
long curInterruptTime = 0;
long lastInterruptTime = 0;
