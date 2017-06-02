class HardwareInput{
  float[] knobs;
  boolean knobFlag;
  int[] notes;
  boolean[] pads;
  boolean[] lastPads;
  boolean[] padChange;
  float[] encoders;
  float mode;
  int enc1Mode = 0;
  int enc2Mode = 0;
  boolean enc1ModeFlg = false;
  boolean enc2ModeFlg = false;
  float[] lastEncode;
  int[] rawEnc1 = {0,0};
  int[] rawEnc2 = {0,0};
  float[][] smoothing;
  float[] smoothKnobs;
  boolean[] quadPad;
  boolean[] funcPads;
  boolean[] lastFuncPads;
  boolean[] funcStates;
  int smoothSteps;
  boolean encChangeFlag =false;
  boolean enc1ChangeFlag = false;
  
  
  
 HardwareInput(int numKnobs, int numNotes, int numEncoders, float initMode){
   smoothSteps = 10;
   quadPad = new boolean[4];
   funcPads = new boolean[8];
   lastFuncPads = new boolean[funcPads.length];
   funcStates = new boolean[8];
   pads = new boolean[16];
   lastPads = new boolean[16];
   knobs = new float[numKnobs];
   smoothKnobs = new float[numKnobs];
   smoothing = new float[smoothSteps][numKnobs];
   for(int i=0; i < pads.length; i++){
      pads[i] = false;
      lastPads[i] = false;
    }
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
 
 float[] getKnobs(){
   return knobs;
 }
 
 float[] smoothKnobs(){
   
   for (int i =0; i < smoothSteps-1; i++){
     smoothing[i] = smoothing[i+1];
   }
   smoothing[smoothSteps-1] = knobs;
   float[] sum = new float[knobs.length];
   for (int j = 0; j < sum.length; j++){
     for(int i = 0; i < smoothSteps; i++){
       sum[j] += smoothing[i][j];
     }
   sum[j] = sum[j]/smoothSteps;
   }
     return sum;
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
    knobFlag = true;
  }else if(v[0].equals("/mode")){
    int lastEnc1 = enc1Mode;
    int lastEnc2 = enc2Mode;
   if(int(trim(v[1])) == 0){
     enc1Mode = int(trim(v[2])) % tModes; 
     
     if(lastEnc1 != enc1Mode) enc1ModeFlg = true;
   }
   if(int(trim(v[1])) == 1){
     enc2Mode = int(trim(v[2]));
     if(lastEnc2 != enc2Mode) enc2ModeFlg = true;
   }
   //println(v[0] + v[1] + v[2]);
   }else if(v[0].equals("/keyOn")){
    int note = int(trim(v[1]));
    if (enc1Mode == SEQUENCER || enc1Mode == DRUM_MACHINE){
     // println("note on: " + note + " | oct: " + encPos + " | note%enc: " + ((note-encPos*12)+(16*(encPos%2))));
      
      lastPads[note] = pads[note];
      pads[note] = true;
    }
     }else if(v[0].equals("/keyOff")){
    int note = int(trim(v[1]));
    if (enc1Mode == SEQUENCER || enc1Mode == DRUM_MACHINE){
     // println("note on: " + note + " | oct: " + encPos + " | note%enc: " + ((note-encPos*12)+(16*(encPos%2))));
      
      lastPads[note] = pads[note];
      pads[note] = false;
    }
    
  }else if(v[0].equals("/noteOn")){
    int note = int(trim(v[2]));
    int encPos = (int)encoders[0];
    notes[note] = 1;
    //if (enc1Mode == SEQUENCER || enc1Mode == DRUM_MACHINE){
    // // println("note on: " + note + " | oct: " + encPos + " | note%enc: " + ((note-encPos*12)+(16*(encPos%2))));
    //  note -= encPos*12;
    //  lastPads[note] = pads[note];
    //  pads[note] = true;
    //}
          //for(int i=0; i < notes.length; i++){
          //  print(notes[i] + " ");
          //  if(i%12 == 0 ) println();
          //}
          //println();
  //set note to off
  }else if(v[0].equals("/noteOff")){
    int note = int(trim(v[2]));
    int encPos = (int)encoders[0];
    notes[note] = 0;
     if (enc1Mode == SEQUENCER || enc1Mode == DRUM_MACHINE){
     // println("note off: " + note + " | oct: " + encPos + " | note%enc: " + ((note-encPos*12)+(16*(encPos%2))));
      note -= encPos*12;
      lastPads[note] = pads[note];
      pads[note] = false;
    }
          //for(int i=0; i < notes.length; i++){
          //  print(notes[i] + " ");
          //  if(i%12 == 0 ) println();
          //}
          //println();
  }else if(v[0].equals("/rawEnc")){
    rawEnc1[1] = rawEnc1[0];
    rawEnc1[0] = int(trim(v[1]));
    
    if (rawEnc1[0] != rawEnc1[1]) enc1ChangeFlag = true;
    
    rawEnc2[1] = rawEnc2[0];
    rawEnc2[0] = int(trim(v[2]));
    //updateCurrInst();
    if(rawEnc2[0] != rawEnc2[1]) encChangeFlag = true;
       // println(v[0] + ": " + rawEnc1[0] + " | " + rawEnc1[1]);
  }else if(v[0].equals("/buttons")){
   // print(v[0] + " : ");
    for(int z = 1; z < v.length; z++){
      int padVal = int(trim(v[z]));
      if(padVal ==1) quadPad[z-1] = true;
      else{ 
        quadPad[z-1] = false;
       debounce[z-1].finish();
      }
     // print(quadPad[z-1] + " | " );
    }
    lastFuncPads = funcPads;
    for(int z = 1; z < v.length; z++){
      lastFuncPads[z-1] = funcPads[z-1];
      int padVal = int(trim(v[z]));
      
      if(padVal ==1) funcPads[z-1] = true;
      else{ 
        funcPads[z-1] = false;
        debounce[z-1].finish();
      }
     // println("funcPads: " + funcPads[z-1] + " lastFuncPads: " + lastFuncPads[z-1]);
     if(funcPads[z-1] == true && lastFuncPads[z-1] == false){
       funcStates[z-1] = true;
       println("hloy fucking shit man shit be workin!!!!!!!!");
     }else {
       funcStates[z-1] = false;
     }
     // print(funcStates[z-1] + " | " );
    }
   // println();
  }
}

void updateCurrInst(){
  //lastListIndex = listIndex;
  if(rawEnc1[0] != rawEnc1[1]){
     if( rawEnc1[0] > rawEnc1[1]){
       listIndex = (listIndex+1) % instNames.length;
     }else if(rawEnc1[0] < rawEnc1[1]){
       
       listIndex -= 1;
       //if(listIndex < 0) listIndex = instNames.length-1;
     }
     println(listIndex);
     
    // cp5.get(Textlabel.class, "instName").setText("Instrument: " + instNames[listIndex]);  //change inst name display
    // cp5.get(Textlabel.class, "instName2").setText("Instrument: " + instNames[listIndex]);  //change inst name display
    // sup.copyEnvPointsTo(insts[lastListIndex]);  //copy the existing envelop from the shaper to the last insturment

    // sup.copyEnvPointsFrom(insts[listIndex]);  //copy the envelop from current instrument to shaper
   // sup.updateVertices();  //update vertices on envelop display
  
  //   unPlugSliders(lastListIndex);  //unplug the effects sliders from the previos instrument
  //   plugSliders(listIndex, lastListIndex);  //plug the sliders to the current instrument
  }
}

  
}