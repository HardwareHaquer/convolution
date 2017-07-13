class EnCode {
  private:

  int pinA;
  int pinB;
  int buttPin;
  int id;
  volatile bool currA;
  volatile bool currB;
  volatile bool lastA;
  volatile bool lastB;

  volatile int pos;
  volatile int mode;
  volatile int rawButt;

  volatile int buttPinState;
  volatile bool lastButtPinState;
  volatile bool sendFlag;
  int dBounceTime;
  int dBounce;
  

  public:

  EnCode(int a, int b, int but, int _id);
  int readPins();
  int getPos();
  bool getSendFlag();
  void setSendFlag(bool v);
  int getMode();
  int getRawButt();
  int getID();
  int getButtonState(int nModes);
};

EnCode::EnCode(int a, int b, int but, int _id){
  this->pinA = a;
  this->pinB = b;
  this->buttPin = but;
  this->id = _id;
  this->currA = LOW;
  this->currB = LOW;
  this->lastA = LOW;
  this->lastB = LOW;
  this->dBounceTime = 0;
  this->dBounce = 50;
  this->lastButtPinState = LOW;
  this->mode = 0;
  this->rawButt = 0;
  this->sendFlag = true;
  
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

int EnCode::getPos(){
  return this->pos;
}

bool EnCode::getSendFlag(){
  return this->sendFlag;
}

void EnCode::setSendFlag(bool v){
  this->sendFlag = v;
}

int EnCode::getMode(){
  return this->mode;
}

int EnCode::getRawButt(){
  return this->rawButt;
}

int EnCode::getID(){
  return this->id;
}

int EnCode::getButtonState(int nModes){
  int reading = digitalRead(buttPin);
  if(reading != lastButtPinState){
    dBounceTime = millis();
  }
  if ((millis() - dBounceTime) > dBounce) {
    if(reading != buttPinState){
      buttPinState = reading;
    //if the change is a button press rather than release
    //set flag for osc send
    if(buttPinState == LOW){
      sendFlag = true;
      
     // if(mode == oMode) mode = vMode;
     // else mode = oMode;
      rawButt++;
      if(mode < nModes) mode++;
      else mode = 0;
    }
  }
  }
  
  lastButtPinState = reading;
  return mode;
}

