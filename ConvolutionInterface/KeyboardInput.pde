void keyPressed() {
  //musicMaker.keysPressed();
  //cannot use left/right without error!
  if(key == CODED){
    lastMode = theMode;
    lastListIndex = listIndex;
    if(keyCode == LEFT){
      theMode -= 1;
      if(theMode < 0) theMode = tModes-1;
      println(theMode);
    }else if(keyCode == RIGHT){
      theMode = (theMode + 1) % tModes;
       println(theMode);
    }
    else if (keyCode == UP) {
      listIndex -= 1;
      if(listIndex < 0) listIndex = instNames.length-1;
    } else if (keyCode == DOWN) {
     listIndex = (listIndex+1) % instNames.length;
    }
//-----------Code to be moved into function called on keyup/down and rotary encoder change
   cp5.get(Textlabel.class, "instName").setText("Instrument: " + instNames[listIndex]);  //change inst name display
   cp5.get(Textlabel.class, "instName2").setText("Instrument: " + instNames[listIndex]);  //change inst name display
   sup.copyEnvPointsTo(insts[lastListIndex]);  //copy the existing envelop from the shaper to the last insturment

   sup.copyEnvPointsFrom(insts[listIndex]);  //copy the envelop from current instrument to shaper
   sup.updateVertices();  //update vertices on envelop display
  
   unPlugSliders(lastListIndex);  //unplug the effects sliders from the previos instrument
   plugSliders(listIndex, lastListIndex);  //plug the sliders to the current instrument
//-------------------------------------------------
  arduino.enc1Mode = theMode;
  }
}