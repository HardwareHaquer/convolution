
String knobData;
String noteOnData;
String noteOffData;
String encoderData;
String encButtData;
String rawEncData;
String quadData;

int timerLength = 100;
int knobTimer=0;
int inByte = 0;         // incoming serial byte
int knobs[6];
//#if defined(ARDUINO_SAMD_ZERO) && defined(SERIAL_PORT_USBVIRTUAL)
//  // Required for Serial on Zero based boards
//  #define Serial SERIAL_PORT_USBVIRTUAL
//#endif

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');   // send a capital A
    delay(300);
  }
}
void sendRawEnc(int e1, int e2){
  rawEncData = "/rawEnc ";
  rawEncData += String(e1) + " ";
  rawEncData += String(e2) + "\n";
  Serial.print(rawEncData);
}

void sendEncoder(int e){
  encoderData = "/encoder ";
  encoderData += String(e) + "\n";
  Serial.print(encoderData);
}
void sendModeState(EnCode e){
  if(e.getSendFlag()){
    e.setSendFlag(false);
    encButtData = "/mode ";
    encButtData += String(e.getID()) + " " + String(e.getMode()) + "\n"; 
    Serial.print(encButtData);
  }
}
void sendQuadStates(boolean q[], int theSize){
  quadData = "/buttons ";
  int dataBit;
  for(int i=0; i <theSize; i++){
    if(q[i]) dataBit =1;
    else dataBit = 0;
    quadData += String(dataBit) + " ";
  }
  quadData += "\n";
  Serial.print(quadData);
}
void readKnobs(int k[], int theSize){
  knobData = "/knobs ";
  for(int i = 0; i < theSize; i++){
      analogRead(i);
      k[i] = analogRead(i);
      knobData += String(k[i]) + " ";
    }
    knobData += "\n";
   if (millis() - knobTimer >= timerLength) {
    Serial.print(knobData);
    sendEncoder(octave);
    sendRawEnc(enc1.getPos(), enc2.getPos());
    sendModeState(enc1);
    sendModeState(enc2);
    sendQuadStates(quadStates, 4);
    knobTimer = millis();
  }
    
}
void keyNumOn(int k){
  String keyOnData = "/keyOn ";
  keyOnData += String(k) + "\n";
  Serial.print(keyOnData);
}

void keyNumOff(int k){
  String keyOffData = "/keyOn ";
  keyOffData += String(k) + "\n";
  Serial.print(keyOffData);
}
void noteOn( byte c, byte n, int v){
  noteOnData = "/noteOn ";
  noteOnData += String(c)+" "+ String(n)+ " " +String(v) + "\n";
  Serial.print(noteOnData);
//  Serial.write(c);
//  Serial.write(n);
//  Serial.write(v);
}

void noteOff( byte c, byte n, int v){
  noteOffData = "/noteOff ";
  noteOffData += String(c)+" "+ String(n)+ " " +String(v) + "\n";
  Serial.print(noteOffData);
//  Serial.write(c);
//  Serial.write(n);
//  Serial.write(v);
}


void serialComm(){
   // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
    // get incoming byte:
    inByte = Serial.read();
    if(inByte == 'A'){
      //convert analog input to byte array
      //and send out
      byte bytes[sizeof(knobs)/2];
      for(int i = 0; i < sizeof(bytes); i+=2){
        bytes[i] = highByte(knobs[i/2]);
        bytes[i+1] = lowByte(knobs[i/2]);
      }
      // send sensor values:
      Serial.write(0x85);
      Serial.write(bytes, sizeof(bytes));
    }
  }
}

