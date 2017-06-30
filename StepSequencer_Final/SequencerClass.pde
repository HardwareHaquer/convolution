/*
@Author Ben Gonner
*/

/**
*Personalized class that combines a matrix, a radio button, a slider, and a series of buttons and toggles to be used for a Step Sequencer.
*/

class StepSequencer {
  
  /*
  *A constant that defines the screen size in the X (horizontal) direction.
  */
// private static final int SCREEN_SIZE_X = 800;

  /*
  *A constant that defines the screen size in the Y (vertical) direction.
  */
 //private static final int SCREEN_SIZE_Y = 480;

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
*Defines the interval for the Matrix object.
*/
 private int tempo;
 
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
 
 private IntList selectedRootNotes = new IntList();
 
 private IntList lastSelectedRootNotes = new IntList();
 
 private Toggle root_notes;
 
 private Toggle mute;
 
 private Button random;
 
 private Toggle slide_mode;
 
 private Toggle loop;
 
 private RadioButton keyRadioButton;
 
 private Slider stepCount;
 
 private Matrix sequencerButtons;
 
 private Button Send;
 
 CallbackListener cb;
 

/**
*Constructs a new Step Sequencer with a Matrix with given Name, given rows, given columns, given x-position, given y-position, given x-size, and given y-size;
* a Radio Button with given x-position and given y-position; a Slider with given x-position and given y-position; and a set of Buttons at given x-position and given
* y-position; The given position of the set of buttons directly corresponds to the right-most button; All other buttons are in line (vertically) with that one.
*@param _matrixName
*@param _xSteps
*@param _yNotes
*@param _posMatrix_X
*@param _posMatrix_Y
*@param _sizeMatrix_X
*@param _sizeMatrix_Y
*@param _posKeySelector_X
*@param _posKeySelector_Y
*@param _posStepSlider_X
*@param _posStepSlider_Y
*@param _posButton_X
*@param _posButton_Y
*/
public StepSequencer(String _matrixName, int _xSteps, int _yNotes, int _posMatrix_X, int _posMatrix_Y,int _sizeMatrix_X, 
    int _sizeMatrix_Y, int _posKeySelector_X, int _posKeySelector_Y,int _posStepSlider_X, int _posStepSlider_Y, int _posButton_X, int _posButton_Y){
              
    matrixName = _matrixName;
    xSteps = _xSteps;
    yNotes = _yNotes;
    posMatrix_X = _posMatrix_X;
    posMatrix_Y = _posMatrix_Y;
    sizeMatrix_X = _sizeMatrix_X;
    sizeMatrix_Y = _sizeMatrix_Y;
    tempo = 200;
    
      
    posKeySelector_X = _posKeySelector_X;
    posKeySelector_Y = _posKeySelector_Y;
      
    posStepSlider_X = _posStepSlider_X;
    posStepSlider_Y = _posStepSlider_Y;
      
    posButton_X = _posButton_X;
    posButton_Y = _posButton_Y;
      
      
      //New Bug  FOUND ===============================================================================================================================
      //==============================================================================================================================================
      //For Some reason the error Zone (accounted for below) shows up on the 3 step setting. This could be because that is the only odd-numbered setting.
      //==============================================================================================================================================
      //==============================================================================================================================================
      
      
  //  I've added this as a safety net to avoid creating a matrix with an error zone on the side.
  if (sizeMatrix_X % xSteps != 0){
    if (sizeMatrix_X % xSteps >= (xSteps / 2)){
      sizeMatrix_X += xSteps - (sizeMatrix_X % xSteps);  
    }
    else {
      sizeMatrix_X -= (sizeMatrix_X % xSteps); 
    }
  }
  if(!(sizeMatrix_Y % yNotes == 0)){
    if (sizeMatrix_Y % yNotes >= (yNotes / 2)){
      sizeMatrix_Y += yNotes - (sizeMatrix_Y % yNotes); 
    }
    else {
      sizeMatrix_Y -= (sizeMatrix_Y % yNotes);
    }
  }
  //  End of Safety net. ========================================================================
      
    sequencerButtons = cp5.addMatrix(matrixName)
      .setPosition(posMatrix_X,posMatrix_Y)
      .setSize(sizeMatrix_X,sizeMatrix_Y)
      .setGrid(xSteps,yNotes)
      .setGap(6, 1)
      .setInterval(tempo)
      .setMode(ControlP5.SINGLE_COLUMN)
      .setColorBackground(color(120))
      .setBackground(color(40))
      .stop();
      ;
                
    keyRadioButton = cp5.addRadioButton("keySelector")
      .setPosition(posKeySelector_X, posKeySelector_Y)
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
      
    random = cp5.addButton("random")
      .setPosition(posButton_X,posButton_Y)
      ;
                  
    slide_mode = cp5.addToggle("slide_Mode")
      .setPosition(posButton_X - 100, posButton_Y)
      ;
    
    mute = cp5.addToggle("mute")
      .setPosition(posButton_X - 200, posButton_Y)
      ;
    
    loop = cp5.addToggle("loop")
      .setPosition(posButton_X - 520, posButton_Y)
      ;
    
    root_notes = cp5.addToggle("root_notes")
      .setPosition(posButton_X - 410, posButton_Y)
      ;
  }
  
  
/**
*Constructs a new StepSequencer with given Name and other default values.
*@param _matrixName
*/
public StepSequencer(String _matrixName){
  matrixName = _matrixName;
  xSteps = 16; 
  yNotes = 9;
  tempo = 200;
  posMatrix_X = 90;
  posMatrix_Y = 20;
  sizeMatrix_X = 608; //safe: 592, 608, 624 (add 16). Turns out, the size of the matrix needs to be evenly divisible by the number of cells in each direction.
  sizeMatrix_Y = 351; //safe Value: 342, 351, 360 (add 9)

  posKeySelector_X = 10;
  posKeySelector_Y = 20;

  posStepSlider_X = 730;
  posStepSlider_Y = 40;
    
  posButton_X = 600;
  posButton_Y = 385;
    
  xRootNotes = 4;
  
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
    
  random = cp5.addButton("random")
    .setPosition(posButton_X,posButton_Y)
    ;
   
  mute = cp5.addToggle("mute")
    .setPosition(posButton_X - 80, posButton_Y)
    ;
    
  slide_mode = cp5.addToggle("slide_Mode")
    .setPosition(posButton_X - 170, posButton_Y)
    ;
   
  loop = cp5.addToggle("loop")
    .setPosition(posButton_X - 520, posButton_Y)
    ;
    
  root_notes = cp5.addToggle("root_notes")
    .setPosition(posButton_X - 430, posButton_Y)
    ;
    
  Send = cp5.addButton("send")
    .setPosition(posButton_X + 80, posButton_Y)
    .setHeight(60);
    ;
    
  Send.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent tempEvent){
      if (tempEvent.getAction() == ControlP5.ACTION_PRESS){
      sendMatrixOsc();
      }
    }
  }
  );
    
  slide_mode.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent bEvent){
      int value;
      if (bEvent.getAction() == ControlP5.ACTION_PRESS){
      if (slide_mode.getBooleanValue()) value = 1;
      else value = 0;
      OscMessage slideMessage = new OscMessage("/Slide");
      slideMessage.add(value);
        
      osc.send(slideMessage, address);
      println("I sent a slide message " + value);
      }
    }
  }
  );
  
  mute.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent eEvent){
    OscMessage muteMessage = new OscMessage("/StepSeq");
    IntList zeros = new IntList();
    for (int i = 0; i < xSteps; i++){
     zeros.append(-1); 
    }
    int [] sendThis = zeros.array();
    muteMessage.add(sendThis);
        
    osc.send(muteMessage, address);
    }
  }
  );
  
  cb = new CallbackListener() {
    public void controlEvent(CallbackEvent vEvent) {
      //println("I found an event: KeySelect");
      if (vEvent.getAction() == ControlP5.ACTION_PRESS){
        if(vEvent.getController() == keyRadioButton.getItem(0))selectKeys(0);
        else if (vEvent.getController() == keyRadioButton.getItem(1)) selectKeys(1);
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

    
  random.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent anEvent){
      //if (anEvent.getAction() == ControlP5.ACTION_PRESS){
        randomize();
      //}
    }
  }
  );

  root_notes.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
        println(root_notes.getBooleanValue());
        saveRecentCells();
        if(root_notes.getBooleanValue()){
          stepCount.setValue(xRootNotes - 1);
          sequencerButtons.setGrid(xRootNotes,yNotes);
          for(int i = 0; i < Math.min(xRootNotes, selectedRootNotes.size()); i++){
            sequencerButtons.set(i, (yNotes - 2) - selectedRootNotes.get(i), true);
          }
        }
        else{
          switch(xSteps){
            case(2): cp5.get(Slider.class,("stepCount")).setValue(1); break;
            case(3): cp5.get(Slider.class,("stepCount")).setValue(2); break;
            case(4): cp5.get(Slider.class,("stepCount")).setValue(3); break;
            case(8): cp5.get(Slider.class,("stepCount")).setValue(4); break;
            case(16): cp5.get(Slider.class,("stepCount")).setValue(5); break;
          }
          sequencerButtons.setGrid(xSteps,yNotes);
          for(int i = 0; i < Math.min(xSteps, activeCells.size()); i++){
            sequencerButtons.set(i, (yNotes - 2) - activeCells.get(i), true);
          }
        }
      }
    }
  }
  );
}    
  /**
  *Changes the number of (horizontal) rows in the Matrix based on the setting of the slider.
  */
  
  
private void selectKeys(int button){
  OscMessage keyMessage = new OscMessage("/keySel");
  keyMessage.add(button - 1);
  osc.send(keyMessage, address);
  println("I sent a message " + (button));
}

/**
*Changes the number of horizontal rows available in the matrix. Uses the slider to decide the value.
*/
void stepCount(float count){
  if(!root_notes.getBooleanValue()){
    lastXSteps = xSteps;
    switch(str(int(count))){
      case("1"):xSteps = 2; break;
      case("2"):xSteps = 3; break;
      case("3"):xSteps = 4; break;
      case("4"):xSteps = 8; break;
      case("5"):xSteps = 16; break;
    }
    if (lastXSteps != xSteps){
      println("Number of Steps: "+ xSteps + " : " + stepCount.getValue());
      if(xSteps == 3) sequencerButtons.setSize(612,sizeMatrix_Y);
      else sequencerButtons.setSize(sizeMatrix_X, sizeMatrix_Y);
      sequencerButtons.setGrid(xSteps,yNotes);
    }
  }
  else{
    lastXRootNotes = xRootNotes;
    switch(str(int(count))){
      case("1"):xRootNotes = 2; break;
      case("2"):xRootNotes = 3; break;
      case("3"):xRootNotes = 4; break;
      case("4"):xRootNotes = 5; break;
      case("5"):xRootNotes = 6; break;
    }
    if(lastXRootNotes != xRootNotes){
      if(xRootNotes == 3 || xRootNotes == 6) sequencerButtons.setSize(612, sizeMatrix_Y);
      else if(xRootNotes == 5) sequencerButtons.setSize(610,sizeMatrix_Y);
      else sequencerButtons.setSize(sizeMatrix_X, sizeMatrix_Y);
      sequencerButtons.setGrid(xRootNotes,yNotes);
    }
  }
}
  
  /**
  *Randomizes which buttons on the matrix are selected.
  */
void randomize(){
  sequencerButtons.clear();
  if (root_notes.getBooleanValue()){
    for (int i = 0; i < xRootNotes; i++){
      if (rand.nextInt(3) > 0){
        sequencerButtons.set(i, rando.nextInt(yNotes), true);
      }
      else sequencerButtons.set(i, yNotes - 1, true);
    }
  }
  else{
    for (int i = 0; i < xSteps; i++){
      if (rand.nextInt(3) > 0){
        sequencerButtons.set(i, rando.nextInt(yNotes), true);
      }
      else sequencerButtons.set(i, yNotes - 1, true);
    }
  }
}

private void saveActiveCells(){
  int k;
  if(!root_notes.getBooleanValue()){
    activeCells.clear();
    for(int i = 0; i < xSteps; i ++){
      k = 0;
      for (int j = 0; j < yNotes; j++){
        if (sequencerButtons.get(i,j)){
          k++;
          activeCells.append((yNotes - 2) - j);
        }
      }
      if (k == 0) activeCells.append(-1);
    }
  }
  else{
    selectedRootNotes.clear();
    println("xRootNotes: " + xRootNotes);
    for(int i = 0; i < xRootNotes; i ++){
      k = 0;
      for (int j = 0; j < yNotes; j++){
        println("i,j: " + i,j);
        if (sequencerButtons.get(i,j)){
          k++;
          selectedRootNotes.append((yNotes - 1) - j);
        }
      }
      if (k == 0) selectedRootNotes.append(-1);
    }
  }
}

private void saveRecentCells(){
  int k;
  if(root_notes.getBooleanValue()){
    activeCells.clear();
    for(int i = 0; i < xSteps; i ++){
      k = 0;
      for (int j = 0; j < yNotes; j++){
        if (sequencerButtons.get(i,j)){
          k++;
          activeCells.append((yNotes - 2) - j);
        }
      }
      if (k == 0) activeCells.append(-1);
    }
  }
  else{
    selectedRootNotes.clear();
    for(int i = 0; i < xRootNotes; i ++){
      k = 0;
      for (int j = 0; j < yNotes; j++){
        if (sequencerButtons.get(i,j)){
          k++;
          selectedRootNotes.append((yNotes - 2) - j);
        }
      }
      if (k == 0) selectedRootNotes.append(-1);
    }
  }
}


  
  /**
  *Iterates through the matrix to make a list of which cell is active in each (vertical) column; Then compares the current active cells list to
  * to the most recent list of active cells. If the lists are different, it makes a new OSC message and sends it.
  */
void sendMatrixOsc(){
  int k; //k counts the number of active cells in a row.
  saveActiveCells();
  if(!root_notes.getBooleanValue() && !mute.getBooleanValue()){
   
    if (!(activeCells.size() == lastActiveCells.size())){
      k = 1;
    }
    else {
      k = activeCells.size();
      for (int i = 0; i < activeCells.size(); i ++){
        if(activeCells.get(i) == lastActiveCells.get(i)){
          k--;
        }
      }
    }
    println("k :" +k);
    if (!(k == 0) && !(loop.getBooleanValue())){
      lastActiveCells.clear();
      lastActiveCells = activeCells.copy();
      println(activeCells); // FIXME!!! change this line from print to send the message * * * * * * * *

    OscMessage mMessage = new OscMessage("/StepSeq");
    int[] activeCellsOut = activeCells.array();
    mMessage.add(activeCellsOut);
        
    osc.send(mMessage, address);
    }
  }
  else if (root_notes.getBooleanValue() && !mute.getBooleanValue()){
   
    if (!(selectedRootNotes.size() == lastSelectedRootNotes.size())){
      k = 1;
    }
    else {
      k = selectedRootNotes.size();
      for (int i = 0; i < selectedRootNotes.size(); i ++){
        if(selectedRootNotes.get(i) == lastSelectedRootNotes.get(i)){
          k--;
        }
      }
    }
    println("k :" +k);
    if (!(k == 0) && !loop.getBooleanValue()){
      lastSelectedRootNotes.clear();
      lastSelectedRootNotes = selectedRootNotes.copy();
      println(selectedRootNotes); // FIXME!!! change this line from print to send the message * * * * * * * *
  
    OscMessage rootMessage = new OscMessage("/RootNotes"); //FIXME: I changed the name of the message in this end of the if statements.
    int[] rootNotesOut = selectedRootNotes.array();        //FIXME:  if we need it to be the same in both cases, don't forget to fix that.
    rootMessage.add(rootNotesOut);
    println("length of message: " + rootNotesOut.length);
        
    osc.send(rootMessage, address);
    }
  }
}
  
    //I don't know what the rest of this does.=============================
    
    
  /*
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
    //  print(dex + " : " + boolean(a.notes[i]) +" | ");
    }
   // println();
  } */
  
  /**
  *Draws a rectangle at the top of the matrix to keep track of which row is being played by the synthesizer.
  */
   void drawExtras(){
     float counts;
     if(!root_notes.getBooleanValue()) counts = cnt % xSteps;
     else counts = (cnt / xSteps) % (xRootNotes - 1);

     
     
     int stepper;
     if(!root_notes.getBooleanValue()) stepper = xSteps;
     else stepper = xRootNotes;
     
     float matrixWidth = sequencerButtons.getWidth();
     rectMode(CORNER);
     fill(255,255,0);
     float spacing  = ((matrixWidth/stepper)*(counts)) - 1;
     rect(posMatrix_X + spacing, posMatrix_Y - 20, matrixWidth/(stepper), 20); 
    
 //   cp5.getController("current").setPosition(0,(height-mHeight-25)+(25*listIndex)+10);
   }
   
   
  /*
    void update(){
    
    for(int i = 0; i < numInsts;  i++){
      for( int j = 0; j < xSteps; j++){
       instVals[i][j] =  cp5.get(Matrix.class, matrixName).get(j, i);
      }
    }
    //println("current: " + time.current + "   " + (millis()-time.current) + "   delay: " + time.delayTime);
    if(time.isFinished()){
     // println("truth");
     // sendMatrixOsc();
    }
    
  }
  
  */
  

}