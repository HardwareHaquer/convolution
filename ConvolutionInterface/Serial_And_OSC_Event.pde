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
  if(cnt%seq.numSteps == 0) seq.sendMatrixOsc();
   if(cnt%musicMaker.xSteps == musicMaker.xSteps - 1) musicMaker.sendMatrixOsc();
  //println(cnt);
}

//version that forwards info directly from serial to osc
void serialEvent(Serial port)
{
  try{
  String line = port.readStringUntil('\n');
  if (line == null) return;
  String[] vals = splitTokens(line);
  OscMessage msg = new OscMessage(trim(vals[0]));
  //println(vals.length);
  for (int i = 1; i < vals.length; i++) {
    float val = float(trim(vals[i]));
  //  print("\t" + val);
    msg.add(val);
  }
  //if(vals[0].equals("/keyOn") ) println(vals[0] + " : " + vals[1]);
  //println();
  if(arduino.enc1Mode == SEQUENCER && (vals[0].equals("/noteOff") || vals[0].equals("/noteOn"))){
   // println(" no send");
  }else{
    osc.send(msg, address);
  }
  arduino.recordValues(vals);
  }
  catch(RuntimeException e){
    e.printStackTrace();
  }
}