void seqMode(){
  background(0);
  fill(255,0,255);
  cp5.getController("label").setVisible(false);
  musicMaker.setVisibility(true);
  musicMaker.updateSeqRowIndex();
  musicMaker.setButtonStates(arduino);
  musicMaker.stepCount(cp5.get(Slider.class, "stepCount").getValue());
  
  musicMaker.setSeqSteps(arduino, seqRowIndex);
  musicMaker.drawExtras();
  musicMaker.sequencerButtons.update();
  seq.setVisibility(false);
  cp5.getController("seq").hide();
 cp5.get(Textlabel.class, "bpm").hide();
    cp5.get(Textlabel.class, "current").hide();
    cp5.get(Group.class, "Effects Controls").hide();
    cp5.get(Group.class, "Global Controls").hide();
    cp5.get(Textlabel.class, "root").hide();
    
}

void leadMode(){
 background(0);
    fill(255,0,255);
    shiftRoot();
    if(arduino.encoders[0] != arduino.lastEncode[0]){
      updateRootText();
      sendRoot();
      cp5.get(Textlabel.class, "root").show();
    }
    cp5.getController("label").setVisible(false);
    musicMaker.setVisibility(false);
    seq.setVisibility(false);
    cp5.getController("seq").hide();
    cp5.get(Textlabel.class, "bpm").hide();
    cp5.get(Textlabel.class, "current").hide();
    cp5.get(Group.class, "Effects Controls").hide();
    cp5.get(Group.class, "Global Controls").show();
     sup.updateEnvPoints();
     sup.disp();
    if(arduino.knobFlag){
      setGlobalEffects(arduino.smoothKnobs(), globalSliders);
      arduino.knobFlag  = false;
     }
  
}

void dmMode(){
 // println("pad: " + arduino.quadPad[1] + " timeout: " + debounce[1].isFinished());
  musicMaker.setVisibility(false);
  
  seq.setVisibility(true);
   cp5.getController("seq").show();
  //cp5.getController("seq").bringToFront();
 // cp5.getController("seq").updateInternalEvents(this);
  // cp5.getController(musicMaker.matrixName).bringToFront();
  
    cp5.get(Group.class, "Global Controls").hide();
    cp5.get(Textlabel.class, "root").hide();

  if(instDisplay){
    if(instDsplyTime.isFinished()){
      instDisplay = false;
      cp5.getController("label").setVisible(instDisplay);
     }
   }
  // if(Clear_Matrix) seq.clearMatrix();
  background(0);

  fill(255, 100);
  seq.setInstStepsO(arduino, listIndex);
  seq.setButtonStates(arduino);
  seq.setEncMode();
   seq.update();
   //seq.sendMatrixOsc();
   sup.updateEnvPoints();
 // sup.disp();
  if(arduino.knobFlag){
    setGlobalEffects(arduino.smoothKnobs(), sliderNames);
    
    arduino.knobFlag  = false;
  }
// double total = (double)((Runtime.getRuntime().totalMemory()/1024)/1024);
//double used  = (double)((Runtime.getRuntime().totalMemory()/1024 - Runtime.getRuntime().freeMemory()/1024)/1024);
//println("total: " + total + " Used: " + used); 
  seq.drawExtras();
  setBPM();
  
}