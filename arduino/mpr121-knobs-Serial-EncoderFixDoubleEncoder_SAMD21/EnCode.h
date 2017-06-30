class EnCode {
  private:

  int pinA; //encoder pin a
  int pinB;  //encoder pin b
  int buttPin;  //button pin
  
  
  volatile bool currA;
  volatile bool currB;
  volatile bool lastA;
  volatile bool lastB;

  volatile int pos;  //current raw encoder position
  volatile int oldPos; //last raw encoder position

  int octave;  //current octave
  int lastOct;  //previous otacve
  int nOct;  //maximum number of octaves

  public:

  EnCode(int a, int b, int but);
  int readPins();
  int checkOctave();
  void resetOctave();
  
};

EnCode::EnCode(int a, int b, int but){
  this->pinA = a;
  this->pinB = b;
  this->buttPin = but;
  this->currA = LOW;
  this->currB = LOW;
  this->lastA = LOW;
  this->lastB = LOW;
  this->nOct = 11;  //standard midi range
  this->octave = 4;  //set in middle to start
  this->lastOct = 0;
  this->oldPos = -999; //make sure is different from pos;
  
  pinMode(this->pinA, INPUT_PULLUP); // set pinA as an input, pulled HIGH to the logic voltage (5V or 3.3V for most cases)
  pinMode(this->pinB, INPUT_PULLUP); // set pinB as an input, pulled HIGH to the logic voltage (5V or 3.3V for most cases)

  pinMode(this->buttPin, INPUT_PULLUP);
}

int EnCode::readPins(){
   this->currA = digitalRead(this->pinA);
  this->currB = digitalRead(this->pinB);

  if(!this->currA && this->lastA){
    if(this->currB == LOW){
    this->pos++;
    
    }else{
      this->pos--;
      
    }
    
  }
  
  this->lastA = this->currA;
  return this->pos;
}

int EnCode::checkOctave(){
   if (pos != oldPos) {
    if(pos < oldPos) {
      octave--;
     // rawEnc--;
    }
    if(pos > oldPos){
      octave++;
      //rawEnc++;
    }
    if(octave < 0) octave = 0;
    if(octave > nOct) octave = nOct;
    
    oldPos = pos;
  //  resetNotes();
    //Serial.println(current);
   }
   
   return octave;
}
void EnCode::resetOctave(){
  this->octave = 4;
  this->lastOct = 0;
}

