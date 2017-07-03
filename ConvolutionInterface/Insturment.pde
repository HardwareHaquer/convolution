class Instrument{
 String theName;
 int id;
 float atk;
 float decay;
 float sustain;
 float release;
 float effect1, effect2;
 boolean visible = false;
 int[] steps;
 float[][] sliderRanges  = {{0.001, 1.0}, {0.01, 1.0},{0.01, 1.0},{0.05, 5.0}, {0.0, 1.0},{0.1, 10.0}}; //default ranges
 float[] sliderValues = {0.1,0.5,0.3,0.2,0.6,1.0};
 float[] envArray;
 FloatList envPoints;
 boolean lock = false;
 int coreNote = 57;
// Timer sliderRate;
// int root = 60;
 //EnvShaper env;
  /*Sets the order of the buttons as laid out on the interface function buttons.  If you add/take away buttons be sure to update this*/
private int[] buttonOrder =  { BUTTON, BUTTON, BUTTON, BUTTON, BUTTON, TOGGLE , TOGGLE};
 
 /*string names of the toggles*/
 private String[] toggles = {"Sustain", "Lock"};
 /*string name of the buttons*/
 private String[] buttons = {"Octave +", "Octave -", "Major Third", "Minor Thrid", "Fifth"};
 /*All names together get ordered based on buttonOrder in constructor*/
 String [] buttonNames = concat(toggles, buttons);
 private int bWidth;
 /**
 *A Toggle button used to switch between the music sequencer mode and the root note mode.
 */

 private Button[] buttArray;
 private Toggle[] togArray;
 
 /* toggle whether or not to update length of sequence */
 private Toggle lockTog;
 
 private boolean lockFlag = false;
 
 private int posButton_Y;
 
 Timer[] funcDebounce;
 
 Instrument(String _theName, int _id){
   atk = 0.1;
   decay = 0.5;
   sustain = 0.3;
   release =0.2;
   theName = _theName;
   id = _id;
   initEnvPoints();
   //sliderRate = new Timer(30);
   posButton_Y = 200;
   
   funcDebounce = new Timer[8];
     for( int i = 0; i < funcDebounce.length; i++){
       funcDebounce[i] = new Timer(500);
     }
   
     int bGap = 10;
    bWidth = (width-bGap*(buttonNames.length+1))/buttonNames.length;
   // (width-buttonGap*(totalButtons+2))/totalButtons;
    buttArray = new Button[buttons.length];
    for(int b = 0; b < buttons.length; b++){
       buttArray[b] =  cp5.addButton(buttons[b])
    .setPosition(((bWidth+bGap)*b),posButton_Y)
    .setSize(bWidth,30)
    //.setId(105)
    ;
    }
    togArray = new Toggle[toggles.length];
    for(int t = 0; t < toggles.length; t++){
       togArray[t] =  cp5.addToggle(toggles[t])
    .setPosition(((bWidth+bGap)*(t+buttons.length)),posButton_Y)
    .setSize(bWidth,30)
    //.setId(105)
    ;
    togArray[t].getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0); 
    
    }
   
 
    int cTogg = 0;
    int cButt = 0;
     for(int i =0; i < buttonOrder.length; i++){  //Use buttonOrder array to set buttonNames to the correct order for getting input from interface.  Allows for changing number of buttons and mixing toggles/buttons
       
       if(buttonOrder[i] == TOGGLE){
         buttonNames[i] = toggles[cTogg];
         cTogg++;
       }else{
         buttonNames[i] = buttons[cButt];
         cButt++;
       }
     }
     
            //When this button (the send button) is pressed, the program calls the sendMatrixOsc function,
        //vwhich sends an osc message of the currently selected cells to the synthesizer.
        for(int i = 0; i < buttArray.length; i++){
          final int temp = i;
          buttArray[i].addCallback(new CallbackListener() {
              public void controlEvent(CallbackEvent tempEvent){
              if (tempEvent.getAction() != ControlP5.ACTION_RELEASE){
                switch(temp){
                  case 0:
                  changeOctave(1);
                  break;
                  case 1:
                  changeOctave(-1);
                  break;
                  default:
                  break;
                }
              }
            }
          });
        }
       
 }
  void changeOctave(int mod){
   int test = lead.coreNote + 12*mod;
   if ( test >= 0 && test <= 120) lead.coreNote = test;
   
   sendCoreNote(lead.coreNote);
   cp5.get(Textlabel.class,"root").setText("Root Note: " + noteNames[lead.coreNote%12] + lead.coreNote/12);
  // println("Root Note: " + noteNames[lead.coreNote%12] + lead.coreNote/12);
   //println(lead.coreNote);
    
  }
 
  void record(){
  }
// update slider values (currently atk decay etc, but should be mapped to other features as envelope is better for these)  
  void setAtk(float v){
   //atk = v;
   if(lock != true)sliderValues[0] = v;
  // println(theName + ": attack: " + sliderValues[0]);
  }
  
  void setDcy(float v){
   decay = log(v)*10;
   if(lock != true) sliderValues[1] = v; //log(v)*10;
  // println(theName + ": decay: " + sliderValues[1]);
  }
  
  void setSus(float v){
    sustain = v;
    if(lock != true) sliderValues[2] = v;
   // println(theName + ": sustain: " + sliderValues[2]);  
  }
  
   void setRel(float v){
    release = v;
    if(lock != true) sliderValues[3] = v;
   // println(theName + ": release: " + sliderValues[3]);  
  }
  
  void setEffect1(float v){
    effect1 = v;
    if(lock != true) sliderValues[4] = v;
  //  println(theName + ": effect1: " + sliderValues[4]);  
  }
  
  void setEffect2(float v){
    effect2 = v;
    if(lock != true) sliderValues[5] = v;
   // println(theName + ": effect2: " + sliderValues[5]);  
  }
//initialize default envelop settings 
  void initEnvPoints(){
     envPoints = new FloatList();
     envPoints.append(0.0); //start length
     envPoints.append(0.0); //start amp
     
     envPoints.append(1.0);//Attack
     envPoints.append(1.0);
     envPoints.append(2.0);//decay
     envPoints.append(0.5);
     envPoints.append(3.0);//sustain
     envPoints.append(0.3);
     envPoints.append(4.0); //release
     envPoints.append(0.0);
     //envPoints.set(i, map(vertices[i/2].x, x, w+x, 0, tSecs));
     //envPoints.set(i+1, map(vertices[i/2].y, h+y, y, 0,1));
    
    //save_State(envPoints);
    }
   void sendCoreNote(int core){
       
      OscMessage mMessage = new OscMessage("/core" );
      mMessage.add(core);
    osc.send(mMessage, address);
   
    
   }
   void sendSliders(){
    // if(sliderRate.isFinished()){
      OscMessage outMsg = new OscMessage("/leadKnobs");
      outMsg.add(id);
      outMsg.add(sliderValues);
      osc.send(outMsg, address);
    // }
   }
   
   void setSliderRanges(float[][] slides){
     sliderRanges = slides;
     for( int i =0; i < sliderNames.length; i++){
     ((Slider)cp5.getController(sliderNames[i])).setRange( sliderRanges[i][0], sliderRanges[i][1] );
     cp5.getController(sliderNames[i]).getValueLabel().alignX(ControlP5.CENTER);
   }
     
   }
   
   void setSliderLabels(String[] labels){
     
     for( int i =0; i < sliderNames.length; i++){
     ((Slider)cp5.getController(sliderNames[i])).setLabel(labels[i]);
     }
   }
   
    void setButtonStates(HardwareInput a){  //check for input from interface and set button/toggle values accordingly.

    for(int i=0; i < buttonOrder.length; i++){
      
      if(a.funcPads[i] == true && funcDebounce[i].isFinished()){
        boolean state;
     if(buttonOrder[i] == TOGGLE){
       state =  cp5.get(Toggle.class, buttonNames[i]).getState();
       state = !state;
       cp5.get(Toggle.class, buttonNames[i]).setState(state);
       
     }else{
       //button code here fuck
       cp5.get(Button.class, buttonNames[i]).setValue(1);

     }
     a.funcPads[0] = false;
    
    }
   // if((i >= toggleNames.length) && cp5.get(Button.class, allNames[i]).isOn() && funcDebounce[i].isFinished()) cp5.get(Button.class, allNames[i]).setOff();
    }
  }
void setVisibility(boolean vis){
  if(vis == true){
    for(int i=0; i < buttonOrder.length; i++){
     if(buttonOrder[i] == TOGGLE){
       cp5.get(Toggle.class, buttonNames[i]).show();
         
     }else{
       //button code here fuck
       cp5.get(Button.class, buttonNames[i]).show();

     }
    
    }
  }else{
    
    for(int i=0; i < buttonOrder.length; i++){
     if(buttonOrder[i] == TOGGLE){
       cp5.get(Toggle.class, buttonNames[i]).hide();
         
     }else{
       //button code here fuck
       cp5.get(Button.class, buttonNames[i]).hide();

     }
    
    }
   }
  }
}