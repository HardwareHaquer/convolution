// This program proxies data between open-source control (OSC)
// messages and a serial port. Serial port data is formatted as
// tab-separated ASCII-formatted floating point numbers, with
// each (newline-terminated) line of serial data corresponding
// to one OSC message, e.g.:
// 100.0  2.3  47.5
// Requires: oscP5 library

// David A. Mellis Thank god for damellis
// April 22, 2016

import processing.serial.*;

import netP5.*;
import oscP5.*;

// which serial device to use. this is an index into the list
// of serial devices printed when this program runs. 
int SERIAL_PORT = 5;
int BAUD = 1843200; // baud rate of the serial device

// the OSC server to talk to
String HOST = "127.0.0.1";
int PORT = 57120;


Serial port;
OscP5 osc;
NetAddress address;
HardwareInput arduino;



void setup()
{
  arduino = new HardwareInput(6,128,2,0);
  printArray(Serial.list());
  osc = new OscP5(this, 12000);
  address = new NetAddress(HOST, PORT);
  port = new Serial(this, Serial.list()[SERIAL_PORT], BAUD);
  port.bufferUntil('\n');
}

void draw()
{
  background(0);
}

void serialEvent(Serial port)
{
  String line = port.readStringUntil('\n');
  if (line == null) return;
  String[] vals = splitTokens(line);
  OscMessage msg = new OscMessage(trim(vals[0]));
  
  for (int i = 1; i < vals.length; i++) {
    float val = float(trim(vals[i]));
  //  print("\t" + val);
    msg.add(val);
  }
  //println();
  osc.send(msg, address);
  arduino.recordValues(vals);
  
}

void oscEvent(OscMessage msg)
{
  print("<");
  for (int i = 0; i < msg.arguments().length; i++) {
    print("\t" + msg.arguments()[i].toString());
    port.write(msg.arguments()[i].toString());
    if (i < msg.arguments().length - 1) port.write("\t");
  }
  println();
  port.write("\n");
}

//added two encoder inputs, updates, and getters not tested

class HardwareInput{
  float[] knobs;
  int[] notes;
  float[] encoders;
  float mode;
  int enc1Mode = 0;
  int enc2Mode = 0;
  float[] lastEncode;
  float[] rawEncode = {0,0};
  
 HardwareInput(int numKnobs, int numNotes, int numEncoders, float initMode){
   
   knobs = new float[numKnobs];
   for(int i=0; i < numKnobs; i++) knobs[i] = 0;
   
   notes = new int[numNotes];
   for(int i=0; i < numNotes; i++) notes[i] = 0;
   
   encoders = new float[numEncoders];
   lastEncode = new float[numEncoders];
   for(int i=0; i < numEncoders; i++){
     encoders[i] = 0;
     lastEncode[i] = 0;
   }
   mode = initMode;
 }
 
 void updateKnobs(float[] k){
   knobs = k;
 }
 
 void updateNotes(int[] n){
   notes = n;
 }
 
 void updateEncoders(float[] e){
   encoders = e;
 }
 
 void updateMode(int encNum, int m){
   if(encNum==0)enc1Mode = m;
   else if(encNum==1)enc2Mode = m;
   else println("No encoder of that number!!");
   println("1: " + enc1Mode + "  2: " + enc2Mode);
 }
 
 int getMode(int encNum){
   if(encNum==0) return enc1Mode;
   else if(encNum==1)return enc2Mode;
   else return -1;
 }
 void recordValues(String[] v){
  
  if(v[0].equals("/encoder")){
    //encoder has 12 positions (0-11) based on Midi notes there should only be 11 octaves  may need to fix better in future
    //code to turn off notes if held down while octave changes
    for (int i = 1; i < v.length; i++){
      lastEncode[i-1] = encoders[i-1];
      encoders[i-1] = float(trim(v[i]));
    //  lastEncode[1] = encoders[1];
     // encoders[1] = float(trim(v[2]));
  }
   if(lastEncode[0] < encoders[0]){
     int subLength;
   //  println("positive encoder change! turn off keys:" + (12*lastEncode[0]) + " to " + (12*lastEncode[0]+11) );
     if(encoders[0] < 11) subLength = int(12*encoders[0]);
     else subLength = 128;
     for(int i = int(12*lastEncode[0]); i < subLength; i++){
       //if(notes[i] == 1){
       //  OscMessage offOn = new OscMessage("/noteOff");
       //  offOn.add(0x80);
       //  offOn.add(i);
       //  offOn.add(0x00);
       //  osc.send(offOn, address);
       //  print(" sent:");
       //  offOn.print();
       //  offOn.clearArguments();
       //  offOn.setAddrPattern("/noteOn");
       //  offOn.add(0x90);
       //  offOn.add(i+12);
       //  offOn.add(127);
       //  osc.send(offOn, address);
       //  offOn.print();
       //}
       notes[i] = 0;
     }
   }else if(lastEncode[0] > encoders[0]){
     int subLength;
     if(lastEncode[0] >= 10) subLength = 128;
     else subLength = int(12*lastEncode[0]+12);
   //  println("negative encoder change! turn off keys:" +int(12*lastEncode[0]) + " to " + int(12*lastEncode[0]+12)  );
     for(int i = int(12*lastEncode[0]); i < subLength; i++){
       notes[i] = 0;
     }
   }
  }else if(v[0].equals("/knobs")){
    for (int i = 1; i < v.length; i++) knobs[i-1] = float(trim(v[i]));
    
  }else if(v[0].equals("/mode")){
   if(int(trim(v[1])) == 0) enc1Mode = int(trim(v[2])); 
   if(int(trim(v[1])) == 1) enc2Mode = int(trim(v[2]));
   //println(v[0] + v[1] + v[2]);
   
  }else if(v[0].equals("/noteOn")){
    notes[int(trim(v[2]))] = 1;
          //for(int i=0; i < notes.length; i++){
          //  print(notes[i] + " ");
          //  if(i%12 == 0 ) println();
          //}
          //println();
  //set note to off
  }else if(v[0].equals("/noteOff")){
    notes[int(trim(v[2]))] = 0;
          //for(int i=0; i < notes.length; i++){
          //  print(notes[i] + " ");
          //  if(i%12 == 0 ) println();
          //}
          //println();
  }else if(v[0].equals("/rawEnc")){
    rawEncode[1] = rawEncode[0];
    rawEncode[0] = float(trim(v[1]));
        //println(v[0] + ": " + int(trim(v[1])));
  }
  
}
  
}

void mousePressed(){
  for(int i = 0; i < arduino.notes.length; i++){
  OscMessage offOn = new OscMessage("/noteOff");
         offOn.add(0x80);
         offOn.add(i);
         offOn.add(0x00);
         osc.send(offOn, address);
         print(" sent:");
         offOn.print();
  }
}