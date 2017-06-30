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
String HOST = "127.0.0.1";
 int PORT = 57120;
 float cnt = 0;
 
 Timer clockski;
 boolean clockD;
 
 
void setup() {
  size(800,480);
  address = new NetAddress(HOST, PORT); 
  osc = new OscP5(this, 12001);
  
 cp5 = new ControlP5(this);

 musicMaker = new StepSequencer("MatrixMusic");
 
 clockski = new Timer(500);
  
}

void draw(){
  background(color(32));
  musicMaker.stepCount(cp5.get(Slider.class, "stepCount").getValue());
  musicMaker.drawExtras();
  
  if (clockski.isFinished()) cnt ++;
  if(cnt%musicMaker.xSteps == musicMaker.xSteps - 1 && !clockD) {
    musicMaker.sendMatrixOsc();
    clockD = true;
    //println(cnt%musicMaker.xSteps);
  }
  if (cnt%musicMaker.xSteps == 0) clockD = false;
}
 
//void keySelector(int a) {
//  println("a radio Button event: "+a);
//  cnt = a;
//}
  
  void oscEvent(OscMessage msg)
 {
   if(msg.addrPattern().equals("/tick")){
     cnt = (float)msg.arguments()[0];
   }
   if(cnt%musicMaker.xSteps == musicMaker.xSteps - 1) musicMaker.sendMatrixOsc();
   println(cnt%16);
}