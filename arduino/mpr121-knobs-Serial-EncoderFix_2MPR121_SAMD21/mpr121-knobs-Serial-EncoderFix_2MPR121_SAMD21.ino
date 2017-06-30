//Test buttonstate code
//for Sparkfun board defs: SAMD21 1.2.2 Arduino: 1.6.5
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

#include <Wire.h>
#include "mpr121.h"


#include "EnCode.h"
#include "interface.h"
#include "SerialSetup.h"





void setup(){
  pinMode(irqpin, INPUT_PULLUP);
  pinMode(irqpin2, INPUT_PULLUP);

  
  pinMode(13, OUTPUT);
  
 Serial.begin(1843200);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }
  
  //Serial.begin(9600);
  Wire.begin();

  mpr121_setup(mpr121_A);
  mpr121_setup(mpr121_B);

   // establishContact();  // send a byte to establish contact until receiver responds
   analogReadResolution(12);
}



void loop(){
  encoderPos = enc1.readPins();
  enc2.readPins();
  if(encoderPos%2 == 0) digitalWrite(13, HIGH);
  else digitalWrite(13,LOW);
  //if(mode == oMode){
    octCheck = checkOctave(octCheck, numOctaves, encoderPos, oldEncPos);
  //}else volume = checkVolume(volume, encoderPos, oldEncPos);
  if(octCheck != octave) octave = octCheck;
  readTouchInputs(irqpin, mpr121_A);
  readTouchInputs(irqpin2, mpr121_B);
  readRotButt();
  enc1.getButtonState(3);
  enc2.getButtonState(10);
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

void readTouchInputs(int irq, byte addr){
  if(!checkInterrupt(irq)){
    
    //read the touch state from the MPR121
    Wire.requestFrom(addr,2); 
    
    byte LSB = Wire.read();
    byte MSB = Wire.read();
    
    uint16_t touched = ((MSB << 8) | LSB); //16bits that make up the touch states

    if(addr == 0x5B){
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
    }else{
      //remaining big buttons
      for (int i=0; i < 4; i++){  // Check what electrodes were pressed
        if(touched & (1<<i)){
        
          if(touch2States[i] == 0){
            //pin i was just touched
            int note = i+(octave+1)*12;
            if(note <= 0x7F){
              noteOn(0x90, note, volume);  //herer
              
            }
  //          Serial.print("pin ");
  //          Serial.print(i);
  //          Serial.print(": note: ");
  //          Serial.println(i+octave*12);
          
          }else if(touch2States[i] == 1){
            //pin i is still being touched
          }  
        
          touch2States[i] = 1;      
        }else{
          if(touch2States[i] == 1){
            int note = i+(octave+1)*12;
            if(note <= 0x7F){
            noteOff(0x80, i+(octave+1)*12, 0x00);
            }
  //          Serial.print("pin ");
  //          Serial.print(i);
  //          Serial.print(": note: ");
  //          Serial.println(i+octave*12);
            
            //pin i is no longer being touched
         }
          
          touch2States[i] = 0;
        }
        
      
      }
      // quad small buttons
      for(int i = 4; i < 8; i++){
        if(touched & (1<<i)){
          if(quadStates[i-4] == 0){
            //pin i just touched
          }else if(quadStates[i-4] == 1){
            //pin i still being touched
          }
          quadStates[i-4] = 1;
          
        }else{
          if(quadStates[i-4] == 1){
            //if pin i was just released
          }
          quadStates[i-4] = 0;
          
        }
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
//change to be able to add multiple sensors
void mpr121_setup(byte addr){

  set_register(addr, ELE_CFG, 0x00); 
  
  // Section A - Controls filtering when data is > baseline.
  set_register(addr, MHD_R, 0x01);
  set_register(addr, NHD_R, 0x01);
  set_register(addr, NCL_R, 0x00);
  set_register(addr, FDL_R, 0x00);

  // Section B - Controls filtering when data is < baseline.
  set_register(addr, MHD_F, 0x01);
  set_register(addr, NHD_F, 0x01);
  set_register(addr, NCL_F, 0xFF);
  set_register(addr, FDL_F, 0x02);
  
  // Section C - Sets touch and release thresholds for each electrode
  set_register(addr, ELE0_T, TOU_THRESH);
  set_register(addr, ELE0_R, REL_THRESH);
 
  set_register(addr, ELE1_T, TOU_THRESH);
  set_register(addr, ELE1_R, REL_THRESH);
  
  set_register(addr, ELE2_T, TOU_THRESH);
  set_register(addr, ELE2_R, REL_THRESH);
  
  set_register(addr, ELE3_T, TOU_THRESH);
  set_register(addr, ELE3_R, REL_THRESH);
  
  set_register(addr, ELE4_T, TOU_THRESH);
  set_register(addr, ELE4_R, REL_THRESH);
  
  set_register(addr, ELE5_T, TOU_THRESH);
  set_register(addr, ELE5_R, REL_THRESH);
  
  set_register(addr, ELE6_T, TOU_THRESH);
  set_register(addr, ELE6_R, REL_THRESH);
  
  set_register(addr, ELE7_T, TOU_THRESH);
  set_register(addr, ELE7_R, REL_THRESH);
  
  set_register(addr, ELE8_T, TOU_THRESH);
  set_register(addr, ELE8_R, REL_THRESH);
  
  set_register(addr, ELE9_T, TOU_THRESH);
  set_register(addr, ELE9_R, REL_THRESH);
  
  set_register(addr, ELE10_T, TOU_THRESH);
  set_register(addr, ELE10_R, REL_THRESH);
  
  set_register(addr, ELE11_T, TOU_THRESH);
  set_register(addr, ELE11_R, REL_THRESH);
  
  // Section D
  // Set the Filter Configuration
  // Set ESI2
  set_register(addr, FIL_CFG, 0x04);
  
  // Section E
  // Electrode Configuration
  // Set ELE_CFG to 0x00 to return to standby mode
  set_register(addr, ELE_CFG, 0x0C);  // Enables all 12 Electrodes
  
  
  // Section F
  // Enable Auto Config and auto Reconfig
  /*set_register(addr, ATO_CFG0, 0x0B);
  set_register(addr, ATO_CFGU, 0xC9);  // USL = (Vdd-0.7)/vdd*256 = 0xC9 @3.3V   set_register(addr, ATO_CFGL, 0x82);  // LSL = 0.65*USL = 0x82 @3.3V
  set_register(addr, ATO_CFGT, 0xB5);*/  // Target = 0.9*USL = 0xB5 @3.3V
  
  set_register(addr, ELE_CFG, 0x0C);
  
}


boolean checkInterrupt(int irq){
  return digitalRead(irq);
}


void set_register(int address, unsigned char r, unsigned char v){
    Wire.beginTransmission(address);
    Wire.write(r);
    Wire.write(v);
    Wire.endTransmission();
}
