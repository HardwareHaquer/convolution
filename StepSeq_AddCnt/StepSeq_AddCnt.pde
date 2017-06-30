
import netP5.*;
import oscP5.*;

//Ben Gonner
//First attempt at controlP5
//Making Radio buttons to control the scale, and a matrix to match the number of notes in the scale

import controlP5.*;
import java.util.*;

ControlP5 cp5;

StepSequencer musicMaker;

OscP5 osc;
NetAddress address;

//IntList activeCells = new IntList();
//IntList lastActiveCells = new IntList();

// the OSC server to talk to
String HOST = "127.0.0.1";
int PORT = 57120;
float cnt = 0;

void setup() {
 size(800,480);
 address = new NetAddress(HOST, PORT); 
 osc = new OscP5(this, 12001);
 cp5 = new ControlP5(this);

 musicMaker = new StepSequencer("MatrixMusic");
  
}

void draw(){
background(color(32));
musicMaker.stepCount(cp5.get(Slider.class, "stepCount").getValue());
musicMaker.drawExtras();
}
 
void keySelector(int a) {
  println("a radio Button event: "+a);
  if (a == 8){
      musicMaker.sendMatrixOsc();
  }
}

void oscEvent(OscMessage msg)
{
  //print("<");
  //OscMessage outMsg = new OscMessage("/kStates");
  if(msg.addrPattern().equals("/tick")){
    cnt = (float)msg.arguments()[0];
    //outMsg.add(instNames[listIndex]);
    //outMsg.add(insts[listIndex].sliderValues);
    //printArray(outMsg.arguments());
  }
 // println(msg.arguments()[0]);
  if(cnt%16 == 15) musicMaker.sendMatrixOsc();
  println(cnt%16);
  
  
}