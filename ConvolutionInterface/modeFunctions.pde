void seqMode(){
  background(0);
  fill(255,0,255);
  cp5.getController("label").setVisible(false);
  musicMaker.setVisibility(true);
   musicMaker.setEncMode();
  //musicMaker.updateSeqRowIndex();
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
    updateScale();
    
    if(arduino.encoders[0] != arduino.lastEncode[0]){
      updateRootText();
      sendRoot();
      
    }
    cp5.getController("label").setVisible(false);
    musicMaker.setVisibility(false);
    seq.setVisibility(false);
    cp5.getController("seq").hide();
    cp5.get(Textlabel.class, "bpm").hide();
    cp5.get(Textlabel.class, "current").hide();
    plugLeadSliders(listIndex);
    lead.lock=false;
    cp5.get(Group.class, "Effects Controls").show();
    cp5.get(Group.class, "Global Controls").hide();
    cp5.get(Textlabel.class, "root").show();
     sup.updateEnvPoints();
     sup.disp();
    if(arduino.knobFlag){
      setGlobalEffects(arduino.smoothKnobs(), sliderNames, lead);
      arduino.knobFlag  = false;
     }
     if(arduino.enc1ChangeFlag){
       arduino.enc1ChangeFlag = false;
       if ( arduino.rawEnc1[0] < arduino.rawEnc1[1]) lead.coreNote++;
       else if ( arduino.rawEnc1[0] > arduino.rawEnc1[1]) lead.coreNote--;
       if (lead.coreNote > 100) lead.coreNote = 100;
       else if (lead.coreNote < 1) lead.coreNote =1;
       lead.sendCoreNote();
       //println(lead.coreNote);
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
    setGlobalEffects(arduino.smoothKnobs(), sliderNames, insts[listIndex]);
    
    arduino.knobFlag  = false;
  }
// double total = (double)((Runtime.getRuntime().totalMemory()/1024)/1024);
//double used  = (double)((Runtime.getRuntime().totalMemory()/1024 - Runtime.getRuntime().freeMemory()/1024)/1024);
//println("total: " + total + " Used: " + used); 
  seq.drawExtras();
  //setBPM();
  
}