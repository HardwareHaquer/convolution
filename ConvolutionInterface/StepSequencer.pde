/*
@Author Ben Gonner
*/

/**
*Personalized class that combines a matrix, a radio button, a slider, and a series of buttons and toggles to be used for a Step Sequencer.
* Throughout the class, We refer to the cells in the matrix starting from the bottom and going up. The problem is that the library that we're
* using has the top cell defined as cell[0], but we want the bottom cell to be cell[-1] for the synthesizer.
* To adjust for this, we'll use something like (numberOfVericalCells - 2) - someIterationVariable.
* Subtract 2 so that the first element occurs at [-1] instead of [0]. Specifically use 2 instead of 1 because the first element is at index[0],
* but we refer to it as element 1.
* Then subtract the iterationVariable so that we index our cells from the bottom instead of the top.
* Under the predefined system, the top cell is cell[0], but we have 9 (vertical) cells, and want to make the bottom cell cell[-1].
* For example, if we want the third cell from the bottom, naturally, that would be cell[6] because there are 9 cells, the cells are [0] indexed,
* and it counts from the top. If we subtract 2 to get the [-1] index, and then subtract the index the cell would have if it were indexed from the bottom
* we get 9 (the total number of cells) - 2 (= 7) - 1 = 6 (the index that the library recognizes).
*/

class StepSequencer {

  /**
  *Defines the name of the Matrix that controls the Step Sequencer.
  */ 
 private String matrixName;  
 
 /**
 *Defines the number of buttons in one (horizontal) row of the Matrix.
 */
 private int xSteps;

 /**
 *Defines the number of buttons in one (vertical) column of the Matrix.
 */
 private int yNotes;
 
 /**
 *Remembers the last value of xSteps for use in stepCount function.
 */
 private int lastXSteps;
 
  /**
 *Remembers the current value of stepCount slider for use in stepCount function.
 */
 private int currStepCount;
 
  /**
 *Remembers the last value of stepcount Slider for use in stepCount function.
 */
 private int lastStepCount;
 
 private int lastCheck = 0;
 
/**
*Defines the interval for the Matrix object.
*/
 private int tempo;
 
 private float seqNoteDur;
 
 /**
 *Defines the X(horizontal) position of the Radio Button (used to change musical keys) on the screen.
 */
 private int posKeySelector_X;
 
 /**
 *Defines the Y(vertical) position of the Radio Button (used to change musical keys) on the screen.
 */
 private int posKeySelector_Y;
 
 /**
 *Defines the X(horizontal) position of the Matrix on the screen.
 */
 private int posMatrix_X;
 
 /**
 *Defines the Y(vertical) position of the Matrix on the Screen.
 */
 private int posMatrix_Y;
 
 /**
 *Defines of the size of the Matrix in the X(horizontal) direction.
 */
 private int sizeMatrix_X;
 
 /**
 *Defines the size of the Matrix in the Y(vertical) direction
 */
 private int sizeMatrix_Y;
 
 /**
 *Defines the X(horizontal) position of the Slider on the screen.
 */
 private int posStepSlider_X;
 
 /**
 *Defines the Y(vertical) position of the Slider on the screen.
 */
 private int posStepSlider_Y;
 
 /**
 *Defines the X(horizonal) position of the Random Button on the screen.
 */
 private int posButton_X;
 
 /**
 *Defines the Y(vertical) position of the Random Button on the screen.
 */
 private int posButton_Y;
 
 /**
 *A random number generator to randomize the beat on the sequencer.
 */
 private Random rand = new Random();
 
 /**
 *A random number generator to randomize the beat on the sequencer.
 */
 private Random rando = new Random();
 
 /**
 *A list to keep track of the active cells in the matrix; when filled, it holds one number for each (vertical) column; 
 *negative one (-1) represents the bottom cell in that column; each cell up increases the count by one, so that the top
 *cell is represented by seven (7).
 */
 private IntList activeCells = new IntList();
 
 /**
 *A list that follows the same conventions as activeCells, but keeps track of the most recent list of active cells, as
 *opposed to the current list.
 */
 private IntList lastActiveCells = new IntList();
 
 /**
 *An alternate variable for the number of horizontal cells of the matrix when the root_notes toggle is active.
 */
 private int xRootNotes;

/**
* Keeps track of the most recent xRootNotes.
*/
 private int lastXRootNotes;
 
 private float savedStepCount;
 private float savedRootCount;
 
 /**
 * A variable to keep track of the number of horizontal cells in the matrix at all times.
 */
 private int MDHIndex; //Stands for Mode Dependent Horizontal Index
 
 /**
 *Keeps track of which row the user is highlighting with keys.
 */
 private int highlightedRow;
 
 /**
 *Keeps track of which cells are active in the matrix while root notes mode is active.
 */
 private IntList selectedRootNotes = new IntList();
 
 /**
 *Keeps track of the most recent set of active cells in the matrix while root notes mode is active for 
 *comparison to the current set.
 */
 private IntList lastSelectedRootNotes = new IntList();
 
 String[] encModes = {"Column Select", "Synth Select", "BPM", "Random Probability", "BPM Steps", "Scale", "Root Note", "Tempo Multiplier"};
 
 /*Sets the order of the buttons as laid out on the interface function buttons.  If you add/take away buttons be sure to update this*/
private int[] buttonOrder =  { TOGGLE , TOGGLE ,TOGGLE , BUTTON, TOGGLE,  BUTTON, TOGGLE};
 
 /*string names of the toggles*/
 private String[] toggles = {"root_notes", "slide_Mode", "loop", "mute", "lock"};
 /*string name of the buttons*/
 private String[] buttons = {"random", "send"};
 /*All names together get ordered based on buttonOrder in constructor*/
 String [] buttonNames = concat(toggles, buttons);
 

 
 
 
 private int bWidth;
 /**
 *A Toggle button used to switch between the music sequencer mode and the root note mode.
 */
 private Toggle root_notes;
 
 /**
 *A Toggle button that immediately sends an osc message full of '-1' to signify rests, then prevents another 
 *osc message of notes from being sent.
 */
 private Toggle mute;
 
 /**
 *A Button that randomizes which cells are active on the matrix.
 */
 private Button random;
 
 /**
 *A Toggle button that sends an osc message to tell the synthesize whether to slide between notes, or jump to them.
 */
 private Toggle slide_mode;
 
 /**
 *A Toggle button that prevents a new osc message from being sent, allowing the user to make many changes to the
 *sequencer, then update the output all at the same time.
 */
 private Toggle loop;
 
 /**
 *A Radio Button that allows the user to pick which key the sequencer plays in.
 */
 private RadioButton keyRadioButton;
 
 /**
 *A Slider that changes the number of buttons in one (horizontal) row of the Matrix.
 */
 private Slider stepCount;
 
 /**
 *The body of the sequencer; used in both root notes mode and sequencer mode; each cell in the matrix 
 *corresponds to a specific beat and note; When activated, the coordinates of the cell are added to 
 *an osc message, which gets sent to a synthesizer to play the specified beats.
 */
 private Matrix sequencerButtons;
 
 /**
 *A Button that sends the osc message immediately, allowing for the output to change on-command.
 */
 private Button Send;
 
 /* toggle whether or not to update length of sequence */
 private Toggle lock;
 
 private boolean lockFlag = false;
 
 private Slider volume;
 
 private CallbackListener cb;  
 
 Timer[] funcDebounce;
  
/**
*Constructs a new StepSequencer with given Name and other default values.
*@param _matrixName
*/
public StepSequencer(String _matrixName){
  matrixName = _matrixName;
  xSteps = 16; 
  MDHIndex = xSteps;
  yNotes = 9;
  tempo = 200;
  seqNoteDur = 1;
  posMatrix_X = 90;
  posMatrix_Y = 20;
  sizeMatrix_X = 608; //safe: 592, 608, 624 (add 16). Turns out, the size of the matrix needs to be evenly divisible by the number of cells in each direction.
  sizeMatrix_Y = 351; //safe Value: 342, 351, 360 (add 9)

  posKeySelector_X = 10;
  posKeySelector_Y = 10;

  posStepSlider_X = 730;
  posStepSlider_Y = 40;
    
  posButton_X = 600;
  posButton_Y = 400;
    
  xRootNotes = 4;
  
  highlightedRow = 0;
  
  funcDebounce = new Timer[8];
     for( int i = 0; i < funcDebounce.length; i++){
       funcDebounce[i] = new Timer(500);
     }
    cp5.addTextlabel("seqEncMode")
      .setText("Input Mode: " + encModes[arduino.getMode(1)%2])
      .setPosition(50, 440)
      .setSize(100,5)
      .setColorValue(0xffff00ff)
      .setFont(createFont("AvenirNext-DemiBold",20))
      //.setMultiline(true)
      .setLineHeight(0)
      .setVisible(true)
      ;
  
  sequencerButtons = cp5.addMatrix(matrixName)
    .setPosition(posMatrix_X,posMatrix_Y)
    .setSize(sizeMatrix_X,sizeMatrix_Y)
    .setGrid(xSteps,yNotes)
    .setGap(sizeMatrix_X / (xSteps * 10), 1)
    .setInterval(tempo)
    .setMode(ControlP5.SINGLE_COLUMN)
    .setColorBackground(color(120))
    .setBackground(color(40))
    .stop();
    ;

  keyRadioButton = cp5.addRadioButton("keySelector")
    .setPosition(posKeySelector_X,posKeySelector_Y)
    .setSize(40,20)
    .setColorForeground(color(170))
    .setColorActive(color(255))
    .setColorLabel(color(225))
    .setItemsPerRow(1)
    .setSpacingColumn(50)
    .addItem("C",1)
    .addItem("D flat",2)
    .addItem("D",3)
    .addItem("E flat",4)
    .addItem("E",5)
    .addItem("F",6)
    .addItem("F sharp",7)
    .addItem("G",8)
    .addItem("A flat",9)
    .addItem("A",10)
    .addItem("B flat",11)
    .addItem("B",12)
    ;

  stepCount = cp5.addSlider("stepCount")
    .setPosition(posStepSlider_X,posStepSlider_Y)
    .setSize(35,200)
    .setRange(1,5)
    .setValueSelf(5.00)
    .setNumberOfTickMarks(5)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(0)
    ; 
    
  volume = cp5.addSlider("volume")
    .setPosition(posKeySelector_X, posKeySelector_Y + 260)
    .setSize(40, 180)
    .setRange(0, 1)
    .setValueSelf(1.00)
    .setNumberOfTickMarks(11)
    .setSliderMode(Slider.FIX)
    .setDecimalPrecision(2)
    .snapToTickMarks(false);
  ;
    int bGap = 10;
    bWidth = ((width-90)-bGap*(buttonNames.length+1))/buttonNames.length;
   // (width-buttonGap*(totalButtons+2))/totalButtons;
    
  root_notes = cp5.addToggle("root_notes")  
    .setPosition(((bWidth+bGap)*0)+90, posButton_Y)
    .setSize(bWidth,30)
    .setId(101)
    ;
    root_notes.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0); 
    
  slide_mode = cp5.addToggle("slide_Mode")
    .setPosition(((bWidth+bGap)*1)+90, posButton_Y)
    .setSize(bWidth,30)
    .setId(102)
    ;
    slide_mode.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0);
   
  loop = cp5.addToggle("loop")
    .setPosition(((bWidth+bGap)*2)+90, posButton_Y)
    .setSize(bWidth,30)
    .setId(103)
    ;
    loop.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0);
    
  random = cp5.addButton("random")
    .setPosition(((bWidth+bGap)*3)+90,posButton_Y)
    .setSize(bWidth,30)
    .setId(105)
    ;
    random.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0);
   
  mute = cp5.addToggle("mute")
    .setPosition(((bWidth+bGap)*4)+90, posButton_Y)
    .setSize(bWidth,30)
    .setId(104)
    ;
    mute.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0);
 
  Send = cp5.addButton("send")
    .setPosition(((bWidth+bGap)*5)+90, posButton_Y)
    .setSize(bWidth,30)
    //.setHeight(60)
    .setId(106)
    ;
    
    lock = cp5.addToggle("lock")
    .setPosition(((bWidth+bGap)*6)+90, posButton_Y)
    .setSize(bWidth,30)
    //.setHeight(60)
    .setId(107)
    ;
    lock.getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(0);
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
  Send.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent tempEvent){
      if (tempEvent.getAction() != ControlP5.ACTION_RELEASE){
      sendMatrixOsc();
      }
    }
  }
  );
    
          //When this button (the slide_mode button) is pushed, it sends a 1 or a 0 in an osc message to the synthesizer.
          // 1 corresponds to the button is on, and thus the mode of the synthesizer changes to sliding, rather than jumping.
          // 0 corresponds to the button is on, and thus the mode of the synthesizer changes to jumping, rather than sliding.
  slide_mode.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent bEvent){
      float value;
      if (bEvent.getAction() != ControlP5.ACTION_RELEASE){
        if (slide_mode.getBooleanValue()) value = 1;  //After the button is pressed, the boolean value immediately changes, so when checking the boolean 
        else value = 0.5;                               // after the button is switched from off to on, the boolean retruns true.
        OscMessage slideMessage = new OscMessage("/Slide");
        slideMessage.add(value);
        
        osc.send(slideMessage, address);
       // println("I sent a slide message " + value);
      }
    }
  }
  );
  
          //When this button is pressed, make a new IntList full of '-1' and put that into an osc message.
          // Then it immediately sends the message to the synthesizer. While the button remains active, it also prevents
          // the sequencer from sending any other osc messages, keeping the device silent.
  mute.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent eEvent){
    OscMessage muteMessage = new OscMessage("/StepSeq");
    IntList zeros = new IntList();      //Makes an IntList and appends -1 to it for every row of buttons in the matrix.
    for (int i = 0; i < xSteps; i++){
     zeros.append(-1); 
    }
    int [] sendThis = zeros.array();    //Changes the IntList into an array so it can be added to the message.
    muteMessage.add(sendThis);
        
    osc.send(muteMessage, address);
    }
  }
  );
  
     //This one is declared different from the others because it listens to a radio button.
     // If it were declared the same way as the others, it would require a different callbacklistener
     // for each individual button in the radio button set, which would be a pain.
  cb = new CallbackListener() {
    public void controlEvent(CallbackEvent vEvent) {
      if (vEvent.getAction() == ControlP5.ACTION_PRESS){
        if(vEvent.getController() == keyRadioButton.getItem(0))selectKeys(0);          //The if statement check which button in the radio set was pushed,
        else if (vEvent.getController() == keyRadioButton.getItem(1)) selectKeys(1);   // then calls the function with the corresponding parameter.
        else if (vEvent.getController() == keyRadioButton.getItem(2)) selectKeys(2);    
        else if (vEvent.getController() == keyRadioButton.getItem(3)) selectKeys(3);
        else if (vEvent.getController() == keyRadioButton.getItem(4)) selectKeys(4);
        else if (vEvent.getController() == keyRadioButton.getItem(5)) selectKeys(5);
        else if (vEvent.getController() == keyRadioButton.getItem(6)) selectKeys(6);
        else if (vEvent.getController() == keyRadioButton.getItem(7)) selectKeys(7);
        else if (vEvent.getController() == keyRadioButton.getItem(8)) selectKeys(8);
        else if (vEvent.getController() == keyRadioButton.getItem(9)) selectKeys(9);
        else if (vEvent.getController() == keyRadioButton.getItem(10)) selectKeys(10);
        else if (vEvent.getController() == keyRadioButton.getItem(11)) selectKeys(11);
      }
    }
   };
   cp5.addCallback(cb);

  //When this button (the random button) is pushed, the program calls the randomize function,
  // which uses a random number generator to randomly activate cells in the matrix.
  random.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent anEvent){
      if (anEvent.getAction() != ControlP5.ACTION_RELEASE){
        randomize();
      }
    }
  }
  );
  lock.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent anEvent){
      if (anEvent.getAction() == ControlP5.ACTION_BROADCAST){
      // println("lock is " + lock.getBooleanValue());
       if(!lock.getBooleanValue() && lockFlag){  //when lock is turned off and flag is set change stepcount slider postion back to same as when lock was set.
        // println("Step: " + savedStepCount + " Root: " + savedRootCount);
         if(root_notes.getBooleanValue()) cp5.get(Slider.class, "stepCount").setValue(savedRootCount);
         else cp5.get(Slider.class, "stepCount").setValue(savedStepCount);
         lockFlag = false;
       }
      }
    }
  }
  );  
  
//This button (the root_notes button) allows the user to switch between sequencer mode and root notes mode.
  root_notes.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
     
       if(theEvent.getAction() == ControlP5.ACTION_BROADCAST){
       // println(ControlP5.ACTION_ENTER + " : " + theEvent.getAction());
       lock.setValue(true);
       lockFlag = true;
        saveRecentCells();      //When the button is pressed, save a list of the cells that were active for future reference when the user returns.
        
        if(root_notes.getBooleanValue()){    //Split here because the values are different for entering root notes mode and entering sequencer mode.
          stepCount.setValue(xRootNotes - 1);          //Change the size of the matrix to show the root note, 
          sequencerButtons.setGrid(xRootNotes,yNotes); // And change the value of the step count slider to reflect that change.
          MDHIndex = xRootNotes;
          seqRowIndex = 0;
          for(int i = 0; i < Math.min(xRootNotes, selectedRootNotes.size()); i++){     //Sets the appropriate cells on the matrix to true.
            sequencerButtons.set(i, (yNotes - 2) - selectedRootNotes.get(i), true);    // This means that if the user has set cells in this
          }                                                         // mode before, it will set the most recent active cells to the matrix. 
        }                                                           // If the user has not set any cells in this mode yet, or the matrix 
        else{                                                       // was blank when the user switched the mode last,the bottom row of cells is set.
        MDHIndex = xSteps;
        seqRowIndex = 0;
          switch(xSteps){                                                    
            case(2): cp5.get(Slider.class,("stepCount")).setValue(1); break;  //Changes the size of the matrix to show the sequencer mode,
            case(3): cp5.get(Slider.class,("stepCount")).setValue(2); break;  // and changes the value of the step count slider to reflect that change
            case(4): cp5.get(Slider.class,("stepCount")).setValue(3); break;
            case(8): cp5.get(Slider.class,("stepCount")).setValue(4); break;
            case(16): cp5.get(Slider.class,("stepCount")).setValue(5); break;
          }
          
          sequencerButtons.setGrid(xSteps,yNotes);
          for(int i = 0; i < Math.min(xSteps, activeCells.size()); i++){      //Sets the appropriate cells on the matrix to true.
            sequencerButtons.set(i, (yNotes - 2) - activeCells.get(i), true); // This means that if the user has set cells in 
          }                                                                   // this mode before, it will set the most recent active cells to the matrix.
        }                                                                    // If the user has not set any cells in this mode yet, or the matrix was blank 
      }                                                                      // when the user switched the mode last, the bottom row of cells is set.
    }
  }
  );
}


  /**
  *Sends a message to the synthesizer to change the key the beats are played in.
  *The value of button is taken from which button in the radio set is pressed.
  */
private void selectKeys(int button){
  OscMessage keyMessage = new OscMessage("/keySel");
  keyMessage.add(button);
  osc.send(keyMessage, address);
  println("I sent a message " + (button));
}

/**
*Changes the number of buttons in a (horizontal) row available in the matrix. Uses the slider to decide the value.
*/
void stepCount(float countSeq){
  //if (modeChgFlag == true)
  if(!lock.getBooleanValue()){
   
  if(!root_notes.getBooleanValue()){  //Checks to see if the matrix is in root note mode or sequencer mode.
   savedStepCount = countSeq;
    lastXSteps = xSteps;//In this case, the matrix is in sequencer mode.
    switch(str(int(countSeq))){
      case("1"):xSteps = 2; break;  //Uses pre-determined values for the number of buttons. 
      case("2"):xSteps = 3; break;  // These numbers are based on common time signitures.
      case("3"):xSteps = 4; break;
      case("4"):xSteps = 8; break;
      case("5"):xSteps = 16; break;
    }
    MDHIndex = xSteps;
    if (lastXSteps != xSteps){
      
      if(xSteps == 3) sequencerButtons.setSize(612,sizeMatrix_Y);  //Fixes an error in the matrix caused by 
      else sequencerButtons.setSize(sizeMatrix_X, sizeMatrix_Y);   // the size of the matrix not being divisible by the number of buttons in it.
      sequencerButtons.setGrid(xSteps,yNotes);
    }
  }
  else{
     savedRootCount = countSeq;
    lastXRootNotes = xRootNotes;  //In this case, the matrix is in root note mode.
    switch(str(int(countSeq))){
      case("1"):xRootNotes = 2; break;
      case("2"):xRootNotes = 3; break;
      case("3"):xRootNotes = 4; break;
      case("4"):xRootNotes = 5; break;
      case("5"):xRootNotes = 6; break;
    }
    if(lastXRootNotes != xRootNotes){
      MDHIndex = xRootNotes;
      if(xRootNotes == 3 || xRootNotes == 6) sequencerButtons.setSize(612, sizeMatrix_Y);
      else if(xRootNotes == 5) sequencerButtons.setSize(610,sizeMatrix_Y);//This, again, fixes an error in the 
      else sequencerButtons.setSize(sizeMatrix_X, sizeMatrix_Y);          // matrix caused by the size of the matrix not 
      sequencerButtons.setGrid(xRootNotes,yNotes);                        // being divisible by the number of buttons in it.
    }
  }
  }
}

/**
*Sends a message between 1 and 0 to change the volume of the step sequencer with respect to the other parts.
*/
void volume(float count){
  OscMessage vMessage = new OscMessage("/volume");
  vMessage.add(count);
  println("sending message");
  osc.send(vMessage, address);
}
  
  /**
  *Randomizes which buttons on the matrix are selected.
  */
void randomize(){
  sequencerButtons.clear();    //Clear the matrix because using .set() doesn't obey the singles rule (allowing only cell per column to be active).
  if (root_notes.getBooleanValue()){    //Checks to see if the matrix is in root note mode or sequencer mode.
    for (int i = 0; i < xRootNotes; i++){    //In this case, the matrix is in root note mode.

      if (rand.nextInt(3) > 0){      //Each collumn has a (2/3) chance to have a cell activated. 
                                     // If one isn't chosen, the bottom cell (the rest cell) is activated.
        sequencerButtons.set(i, rando.nextInt(yNotes), true);
      }                                                //Each cell in the collumn has an equal chance to activate.
      else sequencerButtons.set(i, yNotes - 1, true);
    }
  }
  else{
    for (int i = 0; i < xSteps; i++){  //In this case, the matrix is in sequencer mode.

      if (rand.nextInt(3) > 0){   //Each collumn has a (2/3) chance to have a cell activated.
                                  // If one isn't chosen, the bottom cell (the rest cell) is activated.
        sequencerButtons.set(i, rando.nextInt(yNotes), true);
      }                                                //Each cell in the collumn ahs an equal chance to activate.
      else sequencerButtons.set(i, yNotes - 1, true);
    }
  }
}


  void setSeqSteps(HardwareInput a, int column){
    boolean pushedButton = false;          //Keeps track of whether the cell in question was active when the corresponding button was pushed.
   
  
    if( a.enc1ChangeFlag && modeChgFlag == false){// && (millis()-lastCheck > 100)){
      a.enc1ChangeFlag = false;
     
      if( (int)a.rawEnc1[0] > (int)a.rawEnc1[1] ){
        currStepCount++;
        if (currStepCount > 5) currStepCount = 1;
      }else if ((int)a.rawEnc1[0] < (int)a.rawEnc1[1]){
        currStepCount--;
        if(currStepCount < 1) currStepCount = 5;
      }
     
      lastCheck = millis();
     
        stepCount.setValue(currStepCount); //Checks to see if the matrix is in root note mode or sequencer mode.
     
     // println(currStepCount + " :currStep " + (int)a.rawEnc1[0] + " :[0]" +  (int)a.rawEnc1[1] + " :[1]");
    }
    else {
      modeChgFlag = false;
      a.rawEnc1[1] = a.rawEnc1[0];
    }
   
    
    //int encPos = ((int)a.encoders[0] % 5) + 1;
               //Alows the tall rotary encoder to change the value of the stepCount Slider.
   
    float[] knobsList = a.getKnobs();
    float volumeKnob = knobsList[0] / 4096; //Allows the smooth knob to changed the value of the volume slider.
    volume.setValue(volumeKnob);            // Used 4000 because that seems to be the max value of the knob.
    
    for(int i = 0; i < a.pads.length; i++){//Checks each pad to see if one was pushed.
      if(a.pads[i] == true){
        if(i % 2 == 0){                    //Splits the buttons into two sets of 8, rather than one set of 16
          if(sequencerButtons.get(column, (yNotes - 2) - (i / 2)))
            pushedButton = true;           //If the cell that matches the button that was pushed was active, set PushedButton to true.
          clearRow(column);                //Clear the row of the cell that was pushed to ensure only one cell gets activated at a time.
          if(!pushedButton)                //If the cell that matches the button that was pushed wasn't active, we'll set the cell to active.
            sequencerButtons.set(column, (yNotes - 2) - (i / 2), !sequencerButtons.get(column, (yNotes - 2) - (i / 2)));
          a.pads[i] = false;               // Otherwise, we'll leave it off from when we cleared the entire row.
        }
        else {                              //Split the buttons into two sets. This set activates the next row forward.
          if(sequencerButtons.get(column + 1, (yNotes - 2) - (i / 2)))
            pushedButton = true;          //If the cell that matches the button that was pushed was active, set PushedButton to true.
          clearRow(column + 1);           //Clear the row of the cell that was pushed to ensure only one cell gets activated at a time.
          if(!pushedButton)               //If the cell that matches the button that was pushed wasn't active, we'll set the cell to active.
            sequencerButtons.set(column + 1,(yNotes - 2) -  (i / 2), !sequencerButtons.get(column + 1, (yNotes - 2) - (i / 2)));
          a.pads[i] = false;              // Otherwise, we'll leave it off from when we cleared the entire row.
        }
      } 
    }
  }


/**
*Allows keyPresses to activate cells in the matrix.
*/
void keysPressed(){
  if(key == '=' || key == '+')highlightedRow ++;      //The '=' button moves a cursor right across the matrix.
  if(!root_notes.getBooleanValue())highlightedRow = highlightedRow % xSteps;  //Wraps the cursor around from the end of the matrix to 0. in sequencer mode
   else highlightedRow = highlightedRow % xRootNotes;                         //Wraps the cursor around from the end of the matrix to 0. in root notes mode
   
  if (key == '-' || key == '_')highlightedRow --;    //The '-' button moves the cursor left across the matrix
  if(!root_notes.getBooleanValue() && highlightedRow < 0) highlightedRow = xSteps - 1; //Wraps the cursor around from 0 to the end of the matrix. in sequencer mode
  else if (root_notes.getBooleanValue() && highlightedRow < 0) highlightedRow = xRootNotes - 1; 
                                                                            //Wraps the cursor around from 0 to the end of the matrix. in root notes mode 
  if (key == '1'){  //The number buttons set the cells in the highlighted collumn.
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 1, !sequencerButtons.get(highlightedRow, yNotes - 1));
  }
  else if (key == '2'){
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 2, !sequencerButtons.get(highlightedRow, yNotes - 2));
  }
  else if (key == '3'){
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 3, !sequencerButtons.get(highlightedRow, yNotes - 3));
  }
  else if (key == '4'){
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 4, !sequencerButtons.get(highlightedRow, yNotes - 4));
  }
  else if (key == '5'){
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 5, !sequencerButtons.get(highlightedRow, yNotes - 5));
  }
  else if (key == '6'){
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 6, !sequencerButtons.get(highlightedRow, yNotes - 6));
  }
  else if (key == '7'){
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 7, !sequencerButtons.get(highlightedRow, yNotes - 7));
  }
  else if (key == '8'){
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 8, !sequencerButtons.get(highlightedRow, yNotes - 8));
  }
  else if (key == '9'){
    clearRow(highlightedRow);
    sequencerButtons.set(highlightedRow, yNotes - 9, !sequencerButtons.get(highlightedRow, yNotes - 9));
  }
}

                                //This function saves the active cells in the current mode to an array.
private void saveActiveCells(){
  int k;      //k keeps track of the number of cells active in each column. This will typically be 1 or 0, because of the singles setting on the matrix.
  if(!root_notes.getBooleanValue()){    //Checks if the matrix is in root notes mode or sequencer mode.
  
    activeCells.clear();    //In this case, the matrix is in sequencer mode.
    for(int i = 0; i < xSteps; i ++){    //Iterates across the matrix, column by column.
      k = 0;
      for (int j = 0; j < yNotes; j++){  //Iterates down the matrix, row, by row.
        if (sequencerButtons.get(i,j)){    
          k++;                                   //If it finds an active cell, it increases k to count it
          activeCells.append((yNotes - 2) - j);  // and adds the corresponding number to the list.
        }
      }
      if (k == 0) activeCells.append(-1); //If k = 0, that means no cells are active in this column,
    }                                     // so, we'll save the number corresponding to the bottom cell to signify a rest.
  }
  else{    //In this case, the matrix is in root notes mode.
    selectedRootNotes.clear();  
    
    for(int i = 0; i < xRootNotes; i ++){//Iterates across the matrix column by column
      k = 0;
      for (int j = 0; j < yNotes; j++){ //iterates down the matrix row by row
        if (sequencerButtons.get(i,j)){
          k++;                                        //If it finds an active cell, it increases k to count it 
          selectedRootNotes.append((yNotes - 1) - j); // and adds the corresponding number to the list.
        }
      }
      if (k == 0) selectedRootNotes.append(-1); //If k = 0, that means no cells are active in this column,
    }                                           // so, we'll save the number corresponding to the bottom cell. as a place holder.
  }
}

private void clearRow(int row){  //Handy function for quickly clearing just one (vertical) column of the matrix.
  for (int i = 0; i < yNotes; i ++){
    sequencerButtons.set(row,i,false);
  }
}
                                 //This function saves the active cells of the mode that the user just switched from.
private void saveRecentCells(){  // it will practically only be called when the root_notes button is pressed to switch modes.
  int k;            //K counts the number of active cells in each (vertical) column.
  if(root_notes.getBooleanValue()){
    activeCells.clear();             //Because of the timing that this function gets used, when the root_notes boolean is true, and the matrix
    for(int i = 0; i < xSteps; i ++){// is in root_notes mode, this function wants to save the cells that were just active in the sequencer mode.
      k = 0;
      for (int j = 0; j < yNotes; j++){
        if (sequencerButtons.get(i,j)){
          k++;                                  //If it finds an active cell, it increases k to count it
          activeCells.append((yNotes - 2) - j); // and adds the corresponding number to the list.
        }
      }
      if (k == 0) activeCells.append(-1);    //If k = 0, that means there were no active cells in this column,
    }                                        // so, we'll save the number corresponding to the bottom cell to signify a rest.
  }
  else{
    selectedRootNotes.clear(); 
    //Problem here when using screen interface when the button is hit with cursor it crashes so currently disabled all input except broadcast
  //  int[][] temp = sequencerButtons.getCells();
    //println("matrix x: " + temp.length + " matrix y: " + temp[1].length);
  //  if(temp.length != xRootNotes) sequencerButtons.setGrid(xRootNotes,yNotes); 
   //In this case, we're back in sequencer mode, so the function wants to save the cells
    for(int i = 0; i < xRootNotes; i++){ // that were just active in the root_notes mode.
      k = 0;          //K counts the number of active cells in each (vertical) column.
      for (int j = 0; j < yNotes; j++){
      //  println("i: " + i + " j: "+ j + " yNotes: " + yNotes + " xRootNotes: " + xRootNotes);
        if (sequencerButtons.get(i,j)){
          k++;                                       //If it finds an active cell, it increases K to count it
          selectedRootNotes.append((yNotes - 2) - j);// and adds the corresponding number to the list.
        }
      }
      if (k == 0) selectedRootNotes.append(-1); //If k = 0, then no cells in the column were active,
    }                                           // so we'll save the number corresponding to the bottom cell. as a place holder.
  
  }
}



 /** Sts the visibility of all ControlP5 elements in the instance */
void setVisibility(boolean vis){
  if(vis == true){
    sequencerButtons.show();
   volume.show();
   keyRadioButton.show();
   stepCount.show();
   random.show();
   mute.show();
   loop.show();
   slide_mode.show();
   root_notes.show();
   lock.show();
   Send.show();
   cp5.get(Textlabel.class,"seqEncMode").show();
  }else{
    
    
    sequencerButtons.hide();
   volume.hide();
   keyRadioButton.hide();
   stepCount.hide();
   random.hide();
   mute.hide();
   loop.hide();
   slide_mode.hide();
   root_notes.hide();
   Send.hide();
   lock.hide();
   cp5.get(Textlabel.class,"seqEncMode").hide();
    
    
  }

   if(vis == true){
     cp5.getController(matrixName).bringToFront();
      cp5.getController(matrixName).updateInternalEvents(appletRef);
       loop.updateInternalEvents(appletRef);
       loop.bringToFront();
   }

}
  
  /**
  *Iterates through the matrix to make a list of which cell is active in each (vertical) column; Then compares the current active cells list to
  * to the most recent list of active cells. If the lists are different, it makes a new OSC message and sends it.
  */
void sendMatrixOsc(){
  int k;       //K = the differences between the current list of active cells and the previous list of active cells.
  saveActiveCells();  //save the active cells
  if(!root_notes.getBooleanValue() && !mute.getBooleanValue()){ //If the mute button is active, we don't want to send a message in sequencer mode.
                                                                // Split the code here as well because of differing variables for root note and sequencer mode.
    if (activeCells.size() != lastActiveCells.size()){ //We only want to send a message if the current list of active cells differs from the previous one.
      k = 1;                                           // if the size of the lists are different, then obviously the lists are different, so we can check that
    }                                                  // first to be efficient. Make k > 0 to signify that the lists are different.
    else {
      k = activeCells.size();                          //If the lists have the same size, we have to check each element to see if they match.
      for (int i = 0; i < activeCells.size(); i ++){   //Start by setting k = (the size of the list) so that we can decrement it each time the elements match.
        if(activeCells.get(i) == lastActiveCells.get(i)){
          k--;                                         //For each element, if the current list and the previous list are the same, decrement k
        }
      }
    }                                              //Now k = (the number of elements where the current list and the previous list aren't equal).
    if (!(k == 0) && !(loop.getBooleanValue())){    //If there are differences, we'll send the message, but 
      lastActiveCells.clear();                      // we don't want to send a message if the loop button is active
      lastActiveCells = activeCells.copy();       //Make sure to copy the current array to the previous array variable so we can compare against it next time.

    OscMessage mMessage = new OscMessage("/StepSeq");
    int[] activeCellsOut = activeCells.array();      //Make a message object and send it.
    mMessage.add(activeCellsOut);
        
    osc.send(mMessage, address);
    }
  }
  else if (root_notes.getBooleanValue() && !mute.getBooleanValue()){  //This handles the case that we're in rootNotes mode, rather than sequencer mode.
   
    if (!(selectedRootNotes.size() == lastSelectedRootNotes.size())){  //Just like in sequencer mode, we only send a message if it's different.
      k = 1;                                                         //K will still count the differences and we'll still check the size first.
    }
    else {
      k = selectedRootNotes.size();                                //If the lists are the same size, we can use the same loop from before to check each element.
      for (int i = 0; i < selectedRootNotes.size(); i ++){            //Set k = (the size of the list) so we can decrement it for every similarity.
        if(selectedRootNotes.get(i) == lastSelectedRootNotes.get(i)){
          k--;                                                        //Decrement K
        }
      }
    }
    if (!(k == 0) && !loop.getBooleanValue()){                 //If there are differences (k > 0), then we'll send the message, but
      lastSelectedRootNotes.clear();                           // we don't want to send one if the loop button is active.
      lastSelectedRootNotes = selectedRootNotes.copy();   //Make sure to copy the current list to the previous list variable so we can compare against it next time.
  
    OscMessage rootMessage = new OscMessage("/RootNotes");
    int[] rootNotesOut = selectedRootNotes.array();         //Make a message object and send it
    rootMessage.add(rootNotesOut);
        
    osc.send(rootMessage, address);
    }
  }
}
  
  /**
  *Draws a rectangle at the top of the matrix to keep track of which row is being played by the synthesizer.
  *Also draws a rectangle at the bottom as a cursor for which row is highlighed by the buttons.
  */
void drawExtras(){
  float counts;     //Counts stands for the timer count (modulus)-ed by the current number of horizontal cells.
 
  if(!root_notes.getBooleanValue()) counts = cnt % xSteps; // it really just makes it so the if statment doesn't have to cover the entire function while
  else counts = (cnt / xSteps) % (xRootNotes - 1);         // accounting for the differences between rootNote mode and sequencer mode.
  
  int stepper;                                          //Stepper is another intermediary variable, just like counts.
  if(!root_notes.getBooleanValue()){
    stepper = xSteps;   // It doesn't really serve a purpose other than avoiding writing an entire function inside an if statement.
    if (seqRowIndex > xSteps) seqRowIndex = 0;
  }
  else{ stepper = xRootNotes;
  if (seqRowIndex > xRootNotes-2) seqRowIndex = 0;
  }
  //updateSeqRowIndex();
  
  
  float matrixWidth = sequencerButtons.getWidth();
  rectMode(CORNER);
  fill(255,255,0);
  float spacing  = ((matrixWidth/stepper)*(counts)) - 1;  //Spacing gives: (the size of each cell) * (the current timer count). Subtract 1 becuase 
  rect(posMatrix_X + spacing, posMatrix_Y - 20, matrixWidth/(stepper), 20); // it somehow looks better when it's back one pixel.
                                                                         //Draw a rectangle above the matrix.
  //float buttonSpacing = ((matrixWidth/stepper)*(highlightedRow)) - 1;
  float buttonSpacing = ((matrixWidth/stepper)*(seqRowIndex)) - 1;
  rectMode(CORNER);                                                     //This is the same as the above rectangle, just at the bottom, instead of the top.
  fill(100, 215, 40);
  rect(posMatrix_X + buttonSpacing, posMatrix_Y + sizeMatrix_Y, matrixWidth/(stepper), 20);
  //println("seqRowIndex: " + seqRowIndex + "matrix width: " + matrixWidth + " stepper: " + stepper);
}
void setSeqNoteDuration(){
  if(arduino.encChangeFlag == true){
    arduino.encChangeFlag = false;
  if( arduino.rawEnc2[0] > arduino.rawEnc2[1]){
       
       seqNoteDur *=2;
       if(seqNoteDur > 8) seqNoteDur = 8;
     }else if(arduino.rawEnc2[0] < arduino.rawEnc2[1]){
       
       seqNoteDur /= 2;
       
       if (seqNoteDur < 0.125/2) seqNoteDur = 0.125/2;
       
     }
     sendSeqMult(seqNoteDur);
  }
}
  
void updateSeqRowIndex(){
  if(arduino.encChangeFlag == true){
    arduino.encChangeFlag = false;
  if( arduino.rawEnc2[0] > arduino.rawEnc2[1]){
       
       seqRowIndex = (seqRowIndex+1)%(musicMaker.MDHIndex - 1);
     }else if(arduino.rawEnc2[0] < arduino.rawEnc2[1]){
       
       seqRowIndex -= 1;
       
       if (seqRowIndex < 0) seqRowIndex = musicMaker.MDHIndex - 2;
     }
  }
}

  void setButtonStatesOld(HardwareInput a){
    for(int i=0; i < buttonOrder.length; i++){
      if(a.funcPads[i] == true && funcDebounce[i].isFinished()){
        boolean state;
     if(i < toggles.length){
       state =  cp5.get(Toggle.class, toggles[i]).getState();
       state = !state;
       cp5.get(Toggle.class, toggles[i]).setState(state);
     }else{
       //button code here fuck
       cp5.get(Button.class, buttons[i-toggles.length]).setValue(1);
      
     }
     a.funcPads[0] = false;
    
    }
   // if((i >= toggleNames.length) && cp5.get(Button.class, allNames[i]).isOn() && funcDebounce[i].isFinished()) cp5.get(Button.class, allNames[i]).setOff();
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
  
  void setEncMode(){
    int currMode = arduino.rawEnc2Mode % encModes.length;
    
  if(arduino.enc2ModeFlg == true){
   cp5.get(Textlabel.class,"seqEncMode").setText("Input Mode: " + encModes[currMode]);
   arduino.enc2ModeFlg = false;
  }
   switch(currMode){
     case 0:  //Column Select
     
     updateSeqRowIndex();
     break;
     
     case 1:  //Synth Select
     
     
     break;
     
     case 2:  //BPM
     
     updateBPM();
     
     cp5.get(Textlabel.class,"seqEncMode").setText("Input Mode: " + encModes[currMode] + ": " + bpm);
     break;
     
     case 3:  //Random Prob
     
     //cp5.get(Textlabel.class, "RandomProb").show();
     //setRandomProb(arduino);
     break;
     
     case 4:  //BPM steps
     //cp5.get(Textlabel.class, "RandomProb").hide();
     updateBPMSteps();
     cp5.get(Textlabel.class,"seqEncMode").setText("Input Mode: " + encModes[currMode] + ": " + bpm);
     break;
     
     case 5:  //scale
     //cp5.get(Textlabel.class, "RandomProb").show();
     updateScale();
     //sendOSCmsg();
     cp5.get(Textlabel.class,"seqEncMode").setText("Input Mode: " + encModes[currMode] + ": " + scales[scaleIndex]);
     break;
     case 6:  //Root Note 
     if(arduino.encChangeFlag){
       arduino.encChangeFlag = false;
      if (arduino.rawEnc2[0] < arduino.rawEnc2[1]) lead.coreNote++;
         else if ( arduino.rawEnc2[0] > arduino.rawEnc2[1]) lead.coreNote--;
         if (lead.coreNote > 104) lead.coreNote = 104;
         else if (lead.coreNote < 12) lead.coreNote =12;
         lead.sendCoreNote(lead.coreNote);
          OscMessage mMessage = new OscMessage("/StepSeq");
          int[] activeCellsOut = activeCells.array();      //Make a message object and send it.
          mMessage.add(activeCellsOut);
        
          osc.send(mMessage, address);
        // musicMaker.sendMatrixOsc();
     cp5.get(Textlabel.class,"seqEncMode").setText("Input Mode: " + encModes[currMode] + ": " + noteNames[lead.coreNote%12] + lead.coreNote/12);
     }
     break;
     case 7:  //Tempo multiplier
     //cp5.get(Textlabel.class, "RandomProb").show();
     setSeqNoteDuration();
     cp5.get(Textlabel.class,"seqEncMode").setText("Input Mode: " + encModes[currMode] + ": " + seqNoteDur);
     break;
     
     default:
     break;
   }
}

void sendOSCmsg(){
  OscMessage mMessage = new OscMessage("/StepSeq");
          int[] activeCellsOut = activeCells.array();      //Make a message object and send it.
          mMessage.add(activeCellsOut);
        
          osc.send(mMessage, address);
}
}