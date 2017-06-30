

/*Copyright (c) 2010 bildr community
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

/*
 MIDI note player

 This sketch shows how to use the serial transmit pin (pin 1) to send MIDI note data.
 If this circuit is connected to a MIDI synth, it will play
 the notes F#-0 (0x1E) to F#-5 (0x5A) in sequence.


 The circuit:
 * digital in 1 connected to MIDI jack pin 5
 * MIDI jack pin 2 connected to ground
 * MIDI jack pin 4 connected to +5V through 220-ohm resistor
 Attach a MIDI cable to the jack, then to a MIDI synth, and play music.

 created 13 Jun 2006
 modified 13 Aug 2012
 by Tom Igoe

 This example code is in the public domain.

 http://www.arduino.cc/en/Tutorial/Midi

 */

#include "interface.h"
#include "mpr121.h"
#include "SerialSetup.h"
#include <Wire.h>
#include "EnCode.h"


EnCode enc(8,9,10);

void setup(){

  
  pinMode(irqpin, INPUT_PULLUP);
 

  pinMode(pinA, INPUT_PULLUP); // set pinA as an input, pulled HIGH to the logic voltage (5V or 3.3V for most cases)
  pinMode(pinB, INPUT_PULLUP); // set pinB as an input, pulled HIGH to the logic voltage (5V or 3.3V for most cases)

  pinMode(rotButt, INPUT_PULLUP);
  
  pinMode(13, OUTPUT);
  
 Serial.begin(1843200);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  
  //Serial.begin(9600);
  Wire.begin();

 // mpr121_setup();

    establishContact();  // send a byte to establish contact until receiver responds
   analogReadResolution(12);
}



void loop(){
 // curInterruptTime = millis();
  //if ((curInterruptTime - lastInterruptTime) >= 10) {
    encoderPos = enc.readPins();//readPins(pinA, pinB, encoderPos);
  //  lastInterruptTime = curInterruptTime;
  //}
  
  if(encoderPos%2 == 0) digitalWrite(13, HIGH);
  else digitalWrite(13,LOW);
  if(mode == oMode){
    octave = enc.checkOctave(); //octCheck = checkOctave(octCheck, numOctaves, encoderPos, oldEncPos);
  }else volume = checkVolume(volume, encoderPos, oldEncPos);
  //if(octCheck != octave) octave = octCheck;
  //readTouchInputs();
  readRotButt();
  readKnobs(knobs, sizeof(knobs)/sizeof(int));
  
  //serialComm();
 // if (mode == oMode) digitalWrite(13, HIGH);
 // else digitalWrite(13, LOW);
  
}

//need to add multiple presses to set mode
void readRotButt(){
  int reading = digitalRead(rotButt);
  if(reading != lastRotButtState){
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if(reading != rotButtState){
      rotButtState = reading;
    
    if(rotButtState == LOW){
      ledState = !ledState;
      //digitalWrite(13, HIGH);
      if(mode == oMode) mode = vMode;
      else mode = oMode;
    }//else digitalWrite(13, LOW);
  }
  }
  //digitalWrite(13, ledState);
  lastRotButtState = reading;
}

void readTouchInputs(){
  if(!checkInterrupt()){
    
    //read the touch state from the MPR121
    Wire.requestFrom(0x5A,2); 
    
    byte LSB = Wire.read();
    byte MSB = Wire.read();
    
    uint16_t touched = ((MSB << 8) | LSB); //16bits that make up the touch states

    
    for (int i=0; i < 12; i++){  // Check what electrodes were pressed
      if(touched & (1<<i)){
      
        if(touchStates[i] == 0){
          //pin i was just touched
          int note = i+octave*12;
          if(note <= 0x7F){
            noteOn(0x90, note, volume);  //herer
            
          }
//          Serial.print("pin ");
//          Serial.print(i);
//          Serial.print(": note: ");
//          Serial.println(i+octave*12);
        
        }else if(touchStates[i] == 1){
          //pin i is still being touched
        }  
      
        touchStates[i] = 1;      
      }else{
        if(touchStates[i] == 1){
          int note = i+octave*12;
          if(note <= 0x7F){
          noteOff(0x80, i+octave*12, 0x00);
          }
//          Serial.print("pin ");
//          Serial.print(i);
//          Serial.print(": note: ");
//          Serial.println(i+octave*12);
          
          //pin i is no longer being touched
       }
        
        touchStates[i] = 0;
      }
      
    
    }
    
  }
}

//  plays a MIDI note.  Doesn't check to see that
//  cmd is greater than 127, or that data values are  less than 127:
//void noteOn(int cmd, int pitch, int velocity) {
//  Serial.write(cmd);
//  Serial.write(pitch);
//  Serial.write(velocity);
//}
//


int checkOctave(int current, int nOct, long newPos, long oldPos){
   if (newPos != oldPos) {
    if(newPos < oldPos) {
      current--;
      rawEnc--;
    }
    if(newPos > oldPos){
      current++;
      rawEnc++;
    }
    if(current < 0) current = 0;
    if(current > nOct) current = nOct;
    
    oldEncPos = newPos;
  //  resetNotes();
    //Serial.println(current);
   }
   
   return current;
}

int checkVolume(int current, long newPos, long oldPos){
   if (newPos != oldPos) {
    if(newPos < oldPos) current-=10;
    if(newPos > oldPos) current+=10;
    if(current < 0) current = 0;
    if(current > 127) current = 127;
    
    oldEncPos = newPos;
//    resetNotes();
    //Serial.println(current);
   }
   return current;
}
//maybe add timer for debounce
long readPins(int a, int b, long pos){
  curA = digitalRead(a);
  curB = digitalRead(b);

  if(!curA && lastA){
    if(curB == LOW){
    pos++;
    
    }else{
      pos--;
      
    }
    
  }
  
  lastA = curA;
  return pos;
}

void mpr121_setup(void){

  set_register(0x5A, ELE_CFG, 0x00); 
  
  // Section A - Controls filtering when data is > baseline.
  set_register(0x5A, MHD_R, 0x01);
  set_register(0x5A, NHD_R, 0x01);
  set_register(0x5A, NCL_R, 0x00);
  set_register(0x5A, FDL_R, 0x00);

  // Section B - Controls filtering when data is < baseline.
  set_register(0x5A, MHD_F, 0x01);
  set_register(0x5A, NHD_F, 0x01);
  set_register(0x5A, NCL_F, 0xFF);
  set_register(0x5A, FDL_F, 0x02);
  
  // Section C - Sets touch and release thresholds for each electrode
  set_register(0x5A, ELE0_T, TOU_THRESH);
  set_register(0x5A, ELE0_R, REL_THRESH);
 
  set_register(0x5A, ELE1_T, TOU_THRESH);
  set_register(0x5A, ELE1_R, REL_THRESH);
  
  set_register(0x5A, ELE2_T, TOU_THRESH);
  set_register(0x5A, ELE2_R, REL_THRESH);
  
  set_register(0x5A, ELE3_T, TOU_THRESH);
  set_register(0x5A, ELE3_R, REL_THRESH);
  
  set_register(0x5A, ELE4_T, TOU_THRESH);
  set_register(0x5A, ELE4_R, REL_THRESH);
  
  set_register(0x5A, ELE5_T, TOU_THRESH);
  set_register(0x5A, ELE5_R, REL_THRESH);
  
  set_register(0x5A, ELE6_T, TOU_THRESH);
  set_register(0x5A, ELE6_R, REL_THRESH);
  
  set_register(0x5A, ELE7_T, TOU_THRESH);
  set_register(0x5A, ELE7_R, REL_THRESH);
  
  set_register(0x5A, ELE8_T, TOU_THRESH);
  set_register(0x5A, ELE8_R, REL_THRESH);
  
  set_register(0x5A, ELE9_T, TOU_THRESH);
  set_register(0x5A, ELE9_R, REL_THRESH);
  
  set_register(0x5A, ELE10_T, TOU_THRESH);
  set_register(0x5A, ELE10_R, REL_THRESH);
  
  set_register(0x5A, ELE11_T, TOU_THRESH);
  set_register(0x5A, ELE11_R, REL_THRESH);
  
  // Section D
  // Set the Filter Configuration
  // Set ESI2
  set_register(0x5A, FIL_CFG, 0x04);
  
  // Section E
  // Electrode Configuration
  // Set ELE_CFG to 0x00 to return to standby mode
  set_register(0x5A, ELE_CFG, 0x0C);  // Enables all 12 Electrodes
  
  
  // Section F
  // Enable Auto Config and auto Reconfig
  /*set_register(0x5A, ATO_CFG0, 0x0B);
  set_register(0x5A, ATO_CFGU, 0xC9);  // USL = (Vdd-0.7)/vdd*256 = 0xC9 @3.3V   set_register(0x5A, ATO_CFGL, 0x82);  // LSL = 0.65*USL = 0x82 @3.3V
  set_register(0x5A, ATO_CFGT, 0xB5);*/  // Target = 0.9*USL = 0xB5 @3.3V
  
  set_register(0x5A, ELE_CFG, 0x0C);
  
}


boolean checkInterrupt(void){
  return digitalRead(irqpin);
}


void set_register(int address, unsigned char r, unsigned char v){
    Wire.beginTransmission(address);
    Wire.write(r);
    Wire.write(v);
    Wire.endTransmission();
}
