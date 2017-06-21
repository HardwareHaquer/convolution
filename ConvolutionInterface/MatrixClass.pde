class Matricks {
 //add array for controls for each instrument rate and amp also lock state for each
  String matrixName;
  boolean instVals[][];
  boolean mute = false;
  boolean muteInst = false;
  int interval;
  int numInsts;
  int numSteps;
  int activeSet = 0;
  String[] instNames;
  Timer time;
  Timer[] funcDebounce;
  Timer[] padTimer;
  int mHeight;
  int mWidth;
  float randomProb = 0.31;
 // String[] buttons = {"Mute", "Adjust/Lock", "Clear Insturment", "Clear Matrix", "Save"};
 // ButtonGroup b;
  
   String[] encModes = {"Insturment Select", "BPM", "Random Probability", "BPM Steps"};
   String[] toggleNames = {"Adjust_Lock","Mute_All", "Mute_Instrument"};
   String[] buttonNames = {"Randomize", "Clear_Instrument", "Clear_Matrix"};
   
   
    Toggle[] toggles = new Toggle[toggleNames.length]; 
    Button[] buttons = new Button[buttonNames.length]; 
    
    int totalButtons = toggles.length + buttons.length;
    
    String [] allNames = concat(toggleNames, buttonNames);
    int buttonGap = 10;
    int buttonWidth = (width-buttonGap*(totalButtons+2))/totalButtons;
    int buttonHeight = 40;
  
 Matricks(String _matrixName, int _nx, int _ny, int _mWidth, int _mHeight, String[] _instNames, int _interval){
   //make numSteps variable from 16 -128 while only displaying 32 steps
   mHeight = _mHeight;
   numInsts = _ny;
   numSteps = _nx;
   interval = _interval;
   matrixName = _matrixName;
    cp5.addMatrix(_matrixName, _nx, _ny,0,height-_mHeight,_mWidth, _mHeight)//704,176)
     //.setPosition(100, height-200)
    // .setSize(750, 200)
     //.setGrid(nx, ny)
     .setGap(gap, gap)
     //.setInterval(interval)
     .setMode(ControlP5.MULTIPLES)
     .setColorBackground(color(120))
     .setBackground(color(40))
     //.setVisible(mFlag);
     .stop()
     ;
     
     for(int i = 0; i < toggleNames.length; i++){ 
     toggles[i] = cp5.addToggle( toggleNames[i])
       
       //.setValue( 0.1 )
       .setLabel(toggleNames[i])
       //.setPosition(430, 5+i*45)
       .setPosition(buttonGap+(buttonWidth+buttonGap)*i, 210)
       //.setSize(150, 30)
       .setSize(buttonWidth, buttonHeight)
       ;
       cp5.getController(toggleNames[i]).getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0); //getValueLabel().alignX(ControlP5.CENTER);
      // cp5.getController(toggles[i]).getValueLabel().alignY(ControlP5.CENTER);
  
      }
      for(int i = 0; i < buttonNames.length; i++){ 
       buttons[i] =  cp5.addButton( buttonNames[i])
       
       //.setValue( 0.1 )
       .setLabel(buttonNames[i])
       .setPosition(buttonGap+(buttonWidth+buttonGap)*(i+toggles.length), 210)
       .setSize(buttonWidth, buttonHeight)
       
       ;
       cp5.getController(buttonNames[i]).getValueLabel().alignX(ControlP5.CENTER);
  
      }
      
     cp5.addTextlabel("EncoderMode")
      .setText("Encoder Mode: " + encModes[arduino.getMode(1)%2])
      .setPosition(width-360, 40)
      .setSize(100,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",20))
      //.setMultiline(true)
      .setLineHeight(0)
      .setVisible(true)
      ;
      
      cp5.addTextlabel("RandomProb")
      .setText("Randomizer Probability: " + randomProb)
      .setPosition(width-360, 80)
      .setSize(100,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",20))
      //.setMultiline(true)
      .setLineHeight(0)
      
      ;
     
     instVals = new boolean[numInsts][numSteps];
     for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < numSteps; j++){
        instVals[i][j] = false;
      }
     }
     instNames = _instNames;
     
     time = new Timer(interval*(numSteps+1)-1);
     funcDebounce = new Timer[8];
     for( int i = 0; i < funcDebounce.length; i++){
       funcDebounce[i] = new Timer(500);
     }
     padTimer = new Timer[arduino.pads.length];
   for (int i = 0; i < padTimer.length; i++) padTimer[i] = new Timer(100);
     
     //String _gName, String[] _names, float _gX, float _gY, int _w, int _h
  //   b = new ButtonGroup("Controls", buttons, 5, 5, width/2,10);
 }
 
 void setVisibility(boolean vis){
   if(vis==true){
   for (int i = 0; i < toggles.length; i++) toggles[i].show();
   for (int i = 0; i < buttons.length; i++) buttons[i].show();
   cp5.get(Textlabel.class, "bpm").show();
  cp5.get(Textlabel.class, "current").show();
  cp5.get(Group.class, "Effects Controls").show();
  cp5.get(Textlabel.class, "EncoderMode").show();
  
   }else{
     for (int i = 0; i < toggles.length; i++) toggles[i].hide();
   for (int i = 0; i < buttons.length; i++) buttons[i].hide();
   cp5.get(Textlabel.class, "bpm").hide();
  cp5.get(Textlabel.class, "current").hide();
  cp5.get(Group.class, "Effects Controls").hide();
  cp5.get(Textlabel.class, "EncoderMode").hide();
    cp5.get(Textlabel.class, "RandomProb").hide();

   }
 }
 
 void clearMatrix(){
   cp5.get(Matrix.class, matrixName).clear();
 }
 
 void clearInst(int cur){
   for(int i =0; i < numSteps; i++){
     cp5.get(Matrix.class, matrixName).set(i, cur, false);
   }
 }
 
 void randomize(float prob){
   for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < numSteps; j++){
        float rand = random(0,1);
        boolean state;
        if(rand < prob) state = true;
        else state = false;
        
       cp5.get(Matrix.class, matrixName).set(j, i, state);
      }
   }
 }
 
void setRandomProb(HardwareInput a){
    if(arduino.encChangeFlag == true){
      if(arduino.rawEnc2[0] > arduino.rawEnc2[1]) randomProb += 0.1;
      else randomProb -= 0.1;
      arduino.encChangeFlag = false;
    }
    if( randomProb < 0.1 ) randomProb = 0.1;
    if( randomProb > 0.9) randomProb = 0.9;
    cp5.get(Textlabel.class, "RandomProb")
      .setText("Randomizer Probability: " + randomProb);
   
 }
  void update(){
    
    for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < numSteps; j++){
       instVals[i][j] =  cp5.get(Matrix.class, matrixName).get(j, i);
      }
    }
    //println("current: " + time.current + "   " + (millis()-time.current) + "   delay: " + time.delayTime);
    if(time.isFinished()){
     // println("truth");
     // sendMatrixOsc();
    }
    
  }
 void drawExtras(){
    rectMode(CENTER);
    fill(0,200,150);
    if(activeSet == 0){
      rect(width/4,height-mHeight-(gap), width/2, 50);
    }else{
      rect(3*width/4,height-mHeight-(gap), width/2, 50);
    }
    fill(255,0,255);
    float spacing  = width/numSteps*(cnt%numSteps+1);
    rect(spacing-(width/numSteps)/2,height-mHeight-(2*gap), width/numSteps-gap*2, 20); 
    rectMode(CORNER); 
    
    cp5.getController("current").setPosition(0,(height-mHeight-25)+(25*listIndex)+10);
   
   
 }
 void sendMatrixOsc(){
   if(mute != true){
   OscBundle mBundle = new OscBundle();
   for(int i = 0; i < numInsts;  i++){
      OscMessage mMessage = new OscMessage("/" + instNames[i]);
      int[] instSteps = new int[numSteps];
      for( int j = 0; j < numSteps; j++){
       instSteps[j] = int(instVals[i][j]); // =  cp5.get(Matrix.class, matrixName).get(j, i);
      }
      //println(instNames[i] + " : " + instSteps[0]);
      mMessage.add(instSteps);
      mBundle.add(mMessage);
      
    }
    mBundle.setTimetag(mBundle.now() + 10000);
    osc.send(mBundle, address);
   }
    //println(mBundle);
    
 
  }

  //void setInstSteps(HardwareInput a, int index){
  //  int encPos = (int)a.encoders[0];
  //  int start  = encPos*12;
  //  int end;
  //  if (encPos > 9) end = 128;
  //  else end = start + 16;
  // // println("start: " + start + " | End: " + end + " | " + a.encoders[0]);
  //  for(int i = start; i <end; i++){
  //    int dex; 
  //    if (start == 0) dex = 0;
  //    else dex = i%start +16*(encPos%2) ;
  //    cp5.get(Matrix.class, matrixName).set(dex, index, boolean(a.notes[i]));
  //  //  print(dex + " : " + boolean(a.notes[i]) +" | ");
  //  }
  // // println();
  //} 
  void setButtonStates(HardwareInput a){
    for(int i=0; i < allNames.length; i++){
      if(a.funcPads[i] == true && funcDebounce[i].isFinished()){
        boolean state;
     if(i < toggleNames.length){
       state =  cp5.get(Toggle.class, allNames[i]).getState();
       state = !state;
       cp5.get(Toggle.class, allNames[i]).setState(state);
     }else{
       //button code here fuck
       cp5.get(Button.class, allNames[i]).setValue(1);
       println("we tried");
     }
     a.funcPads[0] = false;
    
    }
   // if((i >= toggleNames.length) && cp5.get(Button.class, allNames[i]).isOn() && funcDebounce[i].isFinished()) cp5.get(Button.class, allNames[i]).setOff();
    }
  }
  void setInstSteps(HardwareInput a, int index){
    int encPos = (int)a.encoders[0];
    int start  = encPos*12;
    int end;
    if (encPos > 9) end = 128;
    else end = start + 16;
   // println("start: " + start + " | End: " + end + " | " + a.encoders[0]);
    for(int i = 0; i < a.pads.length; i++){
      int dex = i + 16*(encPos%2);
      
      if(a.pads[i] == true){
        boolean state  = cp5.get(Matrix.class, matrixName).get(dex, index);
        state = !state;
        cp5.get(Matrix.class, matrixName).set(dex, index, state);
        a.pads[i] = false;
      }
      //print(dex + " : " + boolean(a.notes[i]) +" | ");
    }
    //println();
  } 
  
  void setInstStepsO(HardwareInput a, int index){
    
    int encPos = (int)a.encoders[0];
    int start  = encPos*12;
    activeSet = encPos%2;
    int end;
    if (encPos > 9) end = 128;
    else end = start + 16;
   // println("start: " + start + " | End: " + end + " | " + a.encoders[0]);
    for(int i = 0; i < a.padsOrder.length; i++){
      int dex = i + 16*(activeSet);
      
      if(a.padsOrder[i] == true){
        boolean state  = cp5.get(Matrix.class, matrixName).get(dex, index);
        state = !state;
        cp5.get(Matrix.class, matrixName).set(dex, index, state);
        a.padsOrder[i] = false;
      }
      //print(dex + " : " + boolean(a.notes[i]) +" | ");
    }
    //println();
  } 
  
  void setEncMode(){
    int currMode = arduino.rawEnc2Mode % encModes.length;
  if(arduino.enc2ModeFlg == true){
   cp5.get(Textlabel.class,"EncoderMode").setText("Encoder Mode: " + encModes[currMode]);
   arduino.enc2ModeFlg = false;
  }
   switch(currMode){
     case 0:
     cp5.get(Textlabel.class, "RandomProb").hide();
     updateInsturment();
     break;
     
     case 1:
     cp5.get(Textlabel.class, "RandomProb").hide();
     updateBPM();
     break;
     
     case 2:
     cp5.get(Textlabel.class, "RandomProb").show();
     setRandomProb(arduino);
     break;
     
     case 3:
     cp5.get(Textlabel.class, "RandomProb").hide();
     updateBPMSteps();
     break;
     
     default:
     break;
   }
}


}