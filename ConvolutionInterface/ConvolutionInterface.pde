/**
 * ControlP5 Matrix
 *
 * A matrix can be used for example as a sequencer, a drum machine.
 *
 * find a list of public methods available for the Matrix Controller
 * at the bottom of this sketch.
 *
 * by Andreas Schlegel, 2012
 * www.sojamo.de/libraries/controlp5
 *
 */
//----Serial and OSC routing-----------------------
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
float cnt = 0;
int DRUM_MACHINE = 2;
int LEAD = 1;
int SEQUENCER = 0;
int root = 0;

Serial port;
OscP5 osc;
NetAddress address;
HardwareInput arduino;

Matricks seq;
//---------------------------
//--------Interface---------------
import controlP5.*;
import java.util.*;

EnvShaper sup;
ControlP5 cp5;

StepSequencer musicMaker;

Instrument bass;
Instrument[] insts;
EffectsGroup efg;

 int BUTTON = 0;
 int TOGGLE = 1;


Timer[] debounce;
Timer instDsplyTime;
boolean instDisplay = true;
String[] noteNames = {"C", "C#", "D", "D#", "E","F","F#", "G" , "G#" , "A" , "A#" , "B"};
String[] instNames = {"bass",
                      "conga",
                      "hi-hat",
                      "kick",
                      "flute",
                      "snare",
                      "synth1",
                      "synth2"
                    };
String[] sliderNames = {"attack",
                        "decay",
                        "sustain",
                        "release",
                        "amp",
                        "rate"
                        };
String[] globalSliders = {"Global FX1",
                        "Global FX2",
                        "Global FX3",
                        "Global FX4",
                        "Global FX5",
                        "Global FX6"
                        };
                        
String[] funcs = {"setAtk",
                  "setDcy",
                  "setSus",
                  "setRel",
                  "setEffect1",
                  "setEffect2"
                  };
                  
int listIndex = 5;
int lastListIndex = 4;

//Input mode defaults and total for control via keyboard input.  
int theMode = 0;
int lastMode = 0;
int tModes = 3;  //total number of modes
boolean modeChgFlag = false;
int seqRowIndex;
PApplet appletRef;
//
int mode = 1;  //sequencer mode
int bpm = 30;
boolean mFlag = true;
boolean tFlag = true;
int nx = 32;
int ny = 8;
int gap = 2;
int mWidth = 800;
int padSize = (mWidth-gap*nx)/nx;
float test = float((mWidth-gap*nx)/nx);
int mHeight = ny*padSize + ny*gap;
//32*w + 32*gap
int gWidth = (800-64)/32;//32*20+32*2; //int(700/float(nx));
int gHeight = 8*23 + 8*2;

boolean Clear_Matrix;

String[] scales;
int scaleIndex = 0;
int lastScaleIndex = 0;
JSONObject json;
ButtonGroup bs;

int[] modeIndex1 =  new int[3];

//================================================
//========Setup=================================
void setup() {
  size(800, 480, P2D);
  frameRate(30);
  println(System.getProperty("os.name"));
  for(int i = 0; i < modeIndex1.length; i++) modeIndex1[i] = 0;
  appletRef = this;
  
  String[] scalesFile = loadStrings("scales.txt");
  scales = split(scalesFile[0], ",");
  
  //smooth(2);
    debounce = new Timer[8];
  for(int i = 0; i < debounce.length; i++) debounce[i] = new Timer(500);
  //==========Serial/OSC setup==============
  arduino = new HardwareInput(6,128,2,0);
  printArray(Serial.list());
  osc = new OscP5(this, 12001);
  address = new NetAddress(HOST, PORT);
 // port = new Serial(this, Serial.list()[SERIAL_PORT], BAUD);
 if(System.getProperty("os.name").equals("Mac OS X")){
   //change value to length-2 to use with mac without serial device attached
  port = new Serial(this, Serial.list()[Serial.list().length -1], BAUD);
 }else{
   port = new Serial(this, Serial.list()[Serial.list().length -2], BAUD);
 }
  port.bufferUntil('\n');
  //==============================================
  
  sup = new EnvShaper(5,425,15,350,233, 20);
   
  String instText = join(instNames, "\n");
  String dynText = "Insturment: " + instNames[0];
  cp5 = new ControlP5(this);
  
  
    // use setMode to change the cell-activation which by 
  // default is ControlP5.SINGLE_ROW, 1 active cell per row, 
  // but can be changed to ControlP5.SINGLE_COLUMN or 
  // ControlP5.MULTIPLES
  //check about changing matrix buttons from toggles
  // Matricks(String _matrixName, int _nx, int _ny, int _mWidth, int _mHeight, String[] _instNames){
    seq = new Matricks("seq", nx, ny, mWidth, mHeight, instNames, 125);
   musicMaker = new StepSequencer("MatrixMusic"); 
    int tWidth = 100; 
    cp5.addTextlabel("label")
      .setText(instText)
      .setPosition(width/2-tWidth/2,height-mHeight-1)
      .setSize(tWidth,mHeight+1)
      .setColorValue(0xffffff00)
      .setFont(createFont("AvenirNext-DemiBold",20))
      .setMultiline(true)
      .setLineHeight(25)
      
      ;
     cp5.addTextlabel("current")
      .setText("---------------------------------------------------")
      .setPosition(0,height-mHeight-25)
      .setSize(tWidth,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",50))
      //.setMultiline(true)
      .setLineHeight(0)
      ;
      
     cp5.addTextlabel("root")
      .setText("Scale Root: " + noteNames[root%12] + (int)arduino.encoders[0])
      .setPosition(width-150, 255)
      .setSize(tWidth,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",20))
      //.setMultiline(true)
      .setLineHeight(0)
      ;
      
    cp5.addTextlabel("bpm")
      .setText("BPM: " + bpm)
      .setPosition(width-300, 255)
      .setSize(tWidth,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",20))
      //.setMultiline(true)
      .setLineHeight(0)
      .setVisible(false)
      ;
      
   cp5.addTextlabel("inputMode")
      .setText("InputMode: " + arduino.getMode(1))
      .setPosition(width-300, 155)
      .setSize(tWidth,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",20))
      //.setMultiline(true)
      .setLineHeight(0)
      .setVisible(true)
      ;
      
   cp5.addTextlabel("scale")
      .setText("scale: " + scales[scaleIndex])
      .setPosition(width-500, 255)
      .setSize(tWidth,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",20))
      //.setMultiline(true)
      .setLineHeight(0)
      .setVisible(true)
      ;
    //String[] toggleNames = {"Adjust_Lock","Mute_All", "Mute_Instrument"};
    //String[] buttonNames = {"Randomize", "Clear_Instrument", "Clear_Matrix"};
    //  for(int i = 0; i < toggleNames.length; i++){ 
    //  cp5.addToggle( toggleNames[i])
       
    //   //.setValue( 0.1 )
    //   .setLabel(toggleNames[i])
    //   .setPosition(0, 5+i*45)
    //   .setSize(150, 30)
       
    //   ;
      // cp5.getController(toggleNames[i]).getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0); //getValueLabel().alignX(ControlP5.CENTER);
      // cp5.getController(toggles[i]).getValueLabel().alignY(ControlP5.CENTER);
  
      //}
      //for(int i = 0; i < buttonNames.length; i++){ 
      //cp5.addButton( buttonNames[i])
       
      // //.setValue( 0.1 )
      // .setLabel(buttonNames[i])
      // .setPosition(0, (toggleNames.length)*45 + i*45)
      // .setSize(150, 30)
       
      // ;
      // cp5.getController(buttonNames[i]).getValueLabel().alignX(ControlP5.CENTER);
  
      //}
      
     //cp5.addKnob("bpm")
     //  .setSize(50, 50)
     //  .setPosition(width-75, 10)
     //  .setRange(30,240)
     //  .plugTo(this,"setBPM")
     //  ;
        

//  cp5.getController("myMatrix").getCaptionLabel().alignX(CENTER);
  


  noStroke();
  smooth();
  instDsplyTime = new Timer(2000);

  bass = new Instrument("bass", 0);
  insts = new Instrument[instNames.length];
  for(int i=0; i < instNames.length; i++){
    insts[i] = new Instrument(instNames[i], i);
   
  }
  
  setupInstSliders();
 // efg = new EffectsGroup("test", sliderNames, 100,100,500, 300);
 // efg.setupSliders();
// String[] buttons = {"Mute", "Adjust/Lock", "Clear Insturment", "Clear Matrix", "Save"};
// bs = new ButtonGroup("Controls", buttonNames, 430, 5, 300,300);
}


void draw() {
  //updateInputMode();
  lastMode = theMode;
  theMode = arduino.enc1Mode;
  if(lastMode != theMode) modeChgFlag = true;
  //println(modeChgFlag);
  
  if(theMode == SEQUENCER){// || theMode == SEQUENCER){
    
    dmMode();
    
  }
  else if(theMode == LEAD){ // || theMode == LEAD){
    leadMode();
     
  }
  else if(theMode == DRUM_MACHINE){ // || theMode == DRUM_MACHINE){
    seqMode();
    
  
  }else{
    //herein lay the problem
    cp5.getController(musicMaker.matrixName).hide();
    cp5.getController("seq").setVisible(false);
    cp5.get(Group.class, "Effects Controls").setVisible(false);
    cp5.get(Group.class, "Global Controls").setVisible(false);
    cp5.get(Textlabel.class, "bpm").setVisible(false);
    background(0);
    fill(255,0,255);
  }
  //updateInsturment();
  sendSlide();
}

void Clear_Matrix(){
  seq.clearMatrix();
}

void Clear_Instrument(){
  seq.clearInst(listIndex);
  
}
void Adjust_Lock(boolean state){
  insts[listIndex].lock = state;
}
void Randomize(){
  seq.randomize(seq.randomProb);

}
void Mute_All(boolean state){
  seq.mute = state;
}
void updateRootText(){
   cp5.get(Textlabel.class,"root").setText("Scale Root: " + noteNames[root%12] + (int)arduino.encoders[0]);
   
}
void updateInputMode(){
  if(arduino.enc2ModeFlg == true){
   cp5.get(Textlabel.class,"inputMode").setText("InputMode: " + arduino.getMode(1));
   arduino.enc2ModeFlg = false;
  }
   switch(arduino.getMode(1)){
     case 0:
     updateInsturment();
     break;
     
     case 1:
     updateScale();
     break;
     
     default:
     break;
   }
}

void updateScale(){
  if(arduino.encChangeFlag == true){
    lastScaleIndex = scaleIndex;
    arduino.encChangeFlag = false;
    if( arduino.rawEnc2[0] > arduino.rawEnc2[1]){
       scaleIndex = (scaleIndex+1) % scales.length;
     }else if(arduino.rawEnc2[0] < arduino.rawEnc2[1]){
       
       scaleIndex -= 1;
       if(scaleIndex < 0) scaleIndex = scales.length-1;
     }
     sendScale(scaleIndex);
    cp5.get(Textlabel.class,"scale").setText("Scale: " + scales[scaleIndex]);
  }
}

void sendScale(int scaleNum){
  OscMessage scaleName = new OscMessage( "/scale" );
  scaleName.add(scaleNum);
  osc.send(scaleName, address);
}

void sendSeqMult(float mult){
  OscMessage multName = new OscMessage( "/seqMult" );
  multName.add(mult);
  osc.send(multName, address);
}
void sendRoot(){
  OscMessage scaleRoot = new OscMessage( "/root" );
  scaleRoot.add(12*(int)arduino.encoders[0]+root);
  osc.send(scaleRoot, address);
}
  
void shiftRoot(){
  //OscMessage scaleRoot = new OscMessage( "/root" );
  //change scale root note
  //currently holding down produces many ticks add timer
  if(arduino.quadPad[2] == true && debounce[2].isFinished()){
   // arduino.quadPad[2] = false;
   root = (root+1)%noteNames.length;
   
    sendRoot();
    updateRootText();
  }else if(arduino.funcPads[0] == true && debounce[0].isFinished() ){
    //arduino.quadPad[0] = false;
    root--;
    if(root < 0) root = noteNames.length-1;
    sendRoot();
   // println(root);
    updateRootText();
  }
    
  
  
}
void setBPM(){
  OscMessage bpmMsg = new OscMessage( "/bpm" );
  //change BPM
  if(arduino.quadPad[1] == true && debounce[1].isFinished()){
       bpm++;
   
       bpmMsg.add(bpm);
       osc.send(bpmMsg, address);
       cp5.get(Textlabel.class,"bpm").setText("BPM: " + bpm);
    
       
  }else if(arduino.quadPad[3] == true && debounce[3].isFinished() ){
    
    bpm--;
    if(root < 0) bpm = 0;
    bpmMsg.add(bpm);
    osc.send(bpmMsg, address);
    cp5.get(Textlabel.class,"bpm").setText("BPM: " + bpm);
    
    
  }
}

void updateBPM(){
  OscMessage bpmMsg = new OscMessage( "/bpm" );
  //change BPM
  if(arduino.encChangeFlag == true){
    if(arduino.rawEnc2[0] > arduino.rawEnc2[1]) bpm++;
    else bpm--;
    arduino.encChangeFlag = false;
  }
    if( bpm < 0 ) bpm = 0;
    bpmMsg.add(bpm);
     osc.send(bpmMsg, address);
    cp5.get(Textlabel.class,"bpm").setText("BPM: " + bpm);
} 
       
void updateBPMSteps(){
  OscMessage bpmMsg = new OscMessage( "/bpm" );
  //change BPM
  if (bpm < 30) bpm = 30;
  else if (bpm > 30 && bpm < 60) bpm = 60;
  else if (bpm > 60 && bpm < 90) bpm = 90;
  else if (bpm > 90 && bpm < 120) bpm = 120;
  else if (bpm > 120 && bpm < 150) bpm = 150;
  else if (bpm > 150) bpm = 180;
  if(arduino.encChangeFlag == true){
    if(arduino.rawEnc2[0] > arduino.rawEnc2[1]) bpm+=30;
    else bpm-=30;
    arduino.encChangeFlag = false;
  }
    if( bpm < 30 ) bpm = 30;
    bpmMsg.add(bpm);
     osc.send(bpmMsg, address);
    cp5.get(Textlabel.class,"bpm").setText("BPM: " + bpm);
} 

void updateInsturment(){
  if(arduino.encChangeFlag == true){
    lastListIndex = listIndex;
    arduino.encChangeFlag = false;
    if( arduino.rawEnc2[0] > arduino.rawEnc2[1]){
       listIndex = (listIndex+1) % instNames.length;
       seqRowIndex = (seqRowIndex+1)%(musicMaker.MDHIndex - 1);
     }else if(arduino.rawEnc2[0] < arduino.rawEnc2[1]){
       listIndex -= 1;
       seqRowIndex -= 1;
       if(listIndex < 0)listIndex = instNames.length-1;
       if (seqRowIndex < 0) seqRowIndex = musicMaker.MDHIndex - 2;
     }
     cp5.get(Textlabel.class, "instName").setText("Instrument: " + instNames[listIndex]);  //change inst name display
     cp5.get(Textlabel.class, "instName2").setText("Instrument: " + instNames[listIndex]);  //change inst name display
     sup.copyEnvPointsTo(insts[lastListIndex]);  //copy the existing envelop from the shaper to the last insturment
  
     sup.copyEnvPointsFrom(insts[listIndex]);  //copy the envelop from current instrument to shaper
     sup.updateVertices();  //update vertices on envelop display
     insts[lastListIndex].lock = true;
     cp5.get(Toggle.class, "Adjust_Lock").setState(insts[lastListIndex].lock);
     unPlugSliders(lastListIndex);  //unplug the effects sliders from the previos instrument
     plugSliders(listIndex, lastListIndex);  //plug the sliders to the current instrument
     //println(listIndex + " | " + lastListIndex);
  }
}



void plugSliders(int active, int last){
 unPlugSliders(last);
  cp5.get(Toggle.class, "Adjust_Lock").setState(insts[active].lock);
  for(int i=0; i < sliderNames.length; i++){
  cp5.getController(sliderNames[i]).setValue(insts[active].sliderValues[i]); //.setSliderValue(insts[active], funcs[i]);
  cp5.getController(sliderNames[i]).plugTo(insts[active], funcs[i]);
  }
}

void unPlugSliders(int last){
  for(int i=0; i < sliderNames.length; i++){
  cp5.getController(sliderNames[i]).unplugFrom(insts[last]);
  }
}

void setupInstSliders(){
  float[][] sliderRanges  = {{0.001, 5.0}, {0.01, 5.0},{0.01, 5.0},{0.01, 5.0}, {0.0, 1.0},{0.1, 10.0}};              
  int slideWidth = 60;
  int slideHeight = 160;
  int slideGap = 10;
  int gWidth = slideGap + sliderNames.length*(slideWidth+slideGap);
  Group g2 = cp5.addGroup("Global Controls")
                 .setPosition(10,0)
                 .setBarHeight(20)
                 .setBackgroundHeight(180)
                 .setSize(400,210)
                 .setBackgroundColor(#585858)
                 //.close()
                 ;
                 
  Group g1 = cp5.addGroup("Effects Controls")
                 .setPosition(0,0)
                 .setBarHeight(10)
                 .setBackgroundHeight(200)
                 .setSize(gWidth,slideHeight+30)
                 .setBackgroundColor(#585858)
                 ;
 
   for( int i =0; i < sliderNames.length; i++){
     cp5.addSlider( sliderNames[i] )
       .setRange( sliderRanges[i][0], sliderRanges[i][1] )
       //.plugTo( this, "setAtk" )
       .setValue( 0.1 )
       .setLabel(sliderNames[i])
       .setPosition(slideGap+(i*(slideWidth+slideGap)),10)
       .setSize(slideWidth, slideHeight)
       .setGroup(g1)
       ;
   }
/*   cp5.addSlider( "attack" )
       .setRange( 0.0, 5.0 )
       //.plugTo( this, "setAtk" )
       .setValue( 0.1 )
       .setLabel("attack")
       .setPosition(10,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
     cp5.addSlider( "decay" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setDcy" )
       .setValue( 0.5 )
       .setLabel("Decay")
       .setPosition(70,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "sustain" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setSus" )
       .setValue( 0.3 )
       .setLabel("Sustain")
       .setPosition(130,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
 cp5.addSlider( "release" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setRel" )
       .setValue( 1 )
       .setLabel("Release")
       .setPosition(190,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "effect1" )
       .setRange( 0.0, 1.0 )
       //.plugTo( this, "setEffect1" )
       .setValue( 0.6 )
       .setLabel("Amp")
       .setPosition(250,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "effect2" )
       .setRange( 0.0, 10.0 )
       //.plugTo( this, "setEffect2" )
       .setValue( 1.0 )
       .setLabel("Rate")
       .setPosition(310,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
*/
cp5.addTextlabel("instName")
       .setText("Instrument: " + instNames[listIndex])
       .setPosition(10,250)
       .setSize(50, 300)
       .setColorValue(0xffffff00)
       .setFont(createFont("AvenirNext-DemiBold",24))
       //.setMultiline(true)
       .setLineHeight(30)
       .setGroup(g1)
       ;
       
      
  cp5.getController("attack").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("decay").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("sustain").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("release").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("amp").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("rate").getValueLabel().alignX(ControlP5.CENTER);
       
       //End g1 === ========
       
  cp5.addSlider( "Global FX1" )
       .setRange( 0.0, 5.0 )
       //.plugTo( this, "setAtk" )
       .setValue( 0.1 )
       .setLabel("FX1")
       .setPosition(10,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
     cp5.addSlider( "Global FX2" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setDcy" )
       .setValue( 0.5 )
       .setLabel("FX2")
       .setPosition(70,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
  cp5.addSlider( "Global FX3" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setSus" )
       .setValue( 0.3 )
       .setLabel("FX3")
       .setPosition(130,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
 cp5.addSlider( "Global FX4" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setRel" )
       .setValue( 1 )
       .setLabel("FX4")
       .setPosition(190,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
  cp5.addSlider( "Global FX5" )
       .setRange( 0.0, 100.0 )
       //.plugTo( this, "setEffect1" )
       .setValue( 50 )
       .setLabel("FX5")
       .setPosition(250,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;
       
  cp5.addSlider( "Global FX6" )
       .setRange( 0.0, 100.0 )
       //.plugTo( this, "setEffect2" )
       .setValue( 50 )
       .setLabel("FX6")
       .setPosition(310,10)
       .setSize(50, 180)
       .setGroup(g2)
       ;   
       
  cp5.addTextlabel("instName2")
       .setText("Instrument: " + instNames[listIndex])
       .setPosition(10,210)
       .setSize(50, 300)
       .setColorValue(0xffffff00)
       .setFont(createFont("AvenirNext-DemiBold",24))
       //.setMultiline(true)
       .setLineHeight(30)
       .setGroup(g2)
       ;
 cp5.getController("Global FX1").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX2").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX3").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX4").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX5").getValueLabel().alignX(ControlP5.CENTER);
  cp5.getController("Global FX6").getValueLabel().alignX(ControlP5.CENTER); 
  
  plugSliders(listIndex, 0);
}

void setGlobalEffects(float[] input, String[] sliders ){ //add flag for lock
if(!insts[listIndex].lock){
  for(int i = 0; i < input.length; i++){
    float min = cp5.getController(sliders[i]).getMin();
    float max = cp5.getController(sliders[i]).getMax();
    float temp = map(input[i], 0, 4096, min, max);
    cp5.getController(sliders[i]).setValue(temp);
  }
}
  }
  

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  listIndex += e;
  if(listIndex < 0) listIndex = instNames.length-1;
  listIndex = (listIndex+1) % instNames.length;
  cp5.get(Textlabel.class, "instName").setText("Instrument: " + instNames[listIndex]);
  cp5.get(Textlabel.class, "instName2").setText("Instrument: " + instNames[listIndex]);
   unPlugSliders(lastListIndex);
   plugSliders(listIndex, lastListIndex);
  println(e + " " +listIndex);
}


void sendSlide(){
  OscMessage outMsg = new OscMessage("/kStates");
  outMsg.add(listIndex);
    outMsg.add(insts[listIndex].sliderValues);
    osc.send(outMsg, address);
}
//void oscEvent(OscMessage msg)
//{
//  print("<");
//  print(msg.addrPattern());
//  for (int i = 0; i < msg.arguments().length; i++) {
//    print("\t" + msg.arguments()[i].toString());
//    port.write(msg.arguments()[i].toString());
//    if (i < msg.arguments().length - 1) port.write("\t");
//  }
//  println();
//  port.write("\n");
//}

/**
*Sends a message between 1 and 0 to change the volume of the step sequencer with respect to the other parts.
*/
void volume(float count){
  OscMessage vMessage = new OscMessage("/volume");
  vMessage.add(count);
 
  osc.send(vMessage, address);
}