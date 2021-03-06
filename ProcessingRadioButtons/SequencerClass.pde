/*
@Author Ben Gonner
*/

/**
*Personalized class that combines a matrix, a radio button, a slider, and a series of buttons and toggles to be used for a Step Sequencer.
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
 
 private Slider volume;
 
 private CallbackListener cb;  
  
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
  posButton_Y = 395;
    
  xRootNotes = 4;
  
  highlightedRow = 0;
  
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
    .setPosition(posButton_X - 500, posButton_Y + 40)
    .setSize(200, 20)
    .setRange(0, 1)
    .setValueSelf(1.00)
    .setNumberOfTickMarks(4)
    .setSliderMode(Slider.FLEXIBLE)
    .setDecimalPrecision(2)
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
    
    //When this button (the send button) is pressed, the program calls the sendMatrixOsc function.
    //Which sends an osc message of the currently selected cells to the synthesizer.
  Send.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent tempEvent){
      if (tempEvent.getAction() == ControlP5.ACTION_PRESS){
      sendMatrixOsc();
      }
    }
  }
  );
    
    //When this button (the slide_mode button) is pushed, it sends a 1 or a 0 in an osc message to the synthesizer.
    // 1 corresponds to the button is on, and thus the mode of the synthesizer changes to sliding, rather than jumping.
    //0 corresponds to the button is on, and thus the mode of the synthesizer changes to jumping, rather than sliding.
  slide_mode.addCallback(new CallbackListener(){
    public void controlEvent(CallbackEvent bEvent){
      int value;
      if (bEvent.getAction() == ControlP5.ACTION_PRESS){
   //After the button is pressed, the boolean value immediately changes, so when checking the boolean after the
   //button is switched from off to on, the boolean retruns true.
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
  
  //When this button is pressed, the program makes a new IntList full of '-1' and puts that into an osc message.
  //Then it immediately sends the message to the synthesizer. While the button remains active, it also prevents
  //the program from sending any other osc messages, keeping the device silent.
  mute.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent eEvent){
    OscMessage muteMessage = new OscMessage("/StepSeq");
//makes an IntList and appends -1 to it for every row of buttons in the matrix.
    IntList zeros = new IntList();
    for (int i = 0; i < xSteps; i++){
     zeros.append(-1); 
    }
//changes the IntList into an array so it can be added to the message.
    int [] sendThis = zeros.array();
    muteMessage.add(sendThis);
        
    osc.send(muteMessage, address);
    }
  }
  );
  
  //This one is declared different from the others because it listens to a radio button.
  //If it were declared the same way as the others, it would require a different callbacklistener
  //for each individual button in the radio button set, which would be a pain.
  cb = new CallbackListener() {
    public void controlEvent(CallbackEvent vEvent) {
      if (vEvent.getAction() == ControlP5.ACTION_PRESS){
   //The if statement check which button in the radio set was pushed, then calls the function
   //with the corresponding parameter.
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

    //When this button (the random button) is pushed, the program calls the randomize function.
    //Which uses a random number generator to randomly activate cells in the matrix.
  random.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent anEvent){
      if (anEvent.getAction() == ControlP5.ACTION_PRESS){
        randomize();
      }
    }
  }
  );

//This button (the root_notes button) allows the user to switch between sequencer mode and root notes mode.
  root_notes.addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      if (theEvent.getAction()==ControlP5.ACTION_PRESS) {
    //When the button is pressed, the program saves a list of the cells that were active for future reference when the user returns.
        saveRecentCells();
    //the function splits here because the values are different for entering root notes mode and entering sequencer mode.
        if(root_notes.getBooleanValue()){
    //changes the size of the matrix to show the root note, 
    // and changes the value of the step count slider to reflect that change
          stepCount.setValue(xRootNotes - 1);
          sequencerButtons.setGrid(xRootNotes,yNotes);
    //sets the appropriate cells on the matrix to true.
    //This means that if the user has set cells in this mode before, it will set the most recent active cells to the matrix.
    //If the user has not set any cells in this mode yet, or the matrix was blank when the user switched the mode last,
    // the bottom row of cells is set.
          for(int i = 0; i < Math.min(xRootNotes, selectedRootNotes.size()); i++){
            sequencerButtons.set(i, (yNotes - 2) - selectedRootNotes.get(i), true);
          }
        }
        else{
    //changes the size of the matrix to show the sequencer mode, 
    // and changes the value of the step count slider to reflect that change
          switch(xSteps){
            case(2): cp5.get(Slider.class,("stepCount")).setValue(1); break;
            case(3): cp5.get(Slider.class,("stepCount")).setValue(2); break;
            case(4): cp5.get(Slider.class,("stepCount")).setValue(3); break;
            case(8): cp5.get(Slider.class,("stepCount")).setValue(4); break;
            case(16): cp5.get(Slider.class,("stepCount")).setValue(5); break;
          }
          sequencerButtons.setGrid(xSteps,yNotes);
    //sets the appropriate cells on the matrix to true.
    //This means that if the user has set cells in this mode before, it will set the most recent active cells to the matrix.
    //If the user has not set any cells in this mode yet, or the matrix was blank when the user switched the mode last,
    // the bottom row of cells is set.
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
void stepCount(float count){
//Checks to see if the matrix is in root note mode or sequencer mode.
  if(!root_notes.getBooleanValue()){
//In this case, the matrix is in sequencer mode.
    lastXSteps = xSteps;
//uses pre-determined values for the number of buttons. Numbers based on common time signitures.
    switch(str(int(count))){
      case("1"):xSteps = 2; break;
      case("2"):xSteps = 3; break;
      case("3"):xSteps = 4; break;
      case("4"):xSteps = 8; break;
      case("5"):xSteps = 16; break;
    }
    if (lastXSteps != xSteps){
//This fixes an error in the matrix caused by the size of the matrix not being divisible by the number of buttons in it.
      if(xSteps == 3) sequencerButtons.setSize(612,sizeMatrix_Y);
      else sequencerButtons.setSize(sizeMatrix_X, sizeMatrix_Y);
      sequencerButtons.setGrid(xSteps,yNotes);
    }
  }
  else{
//In this case, the matrix is in root note mode.
    lastXRootNotes = xRootNotes;
    switch(str(int(count))){
      case("1"):xRootNotes = 2; break;
      case("2"):xRootNotes = 3; break;
      case("3"):xRootNotes = 4; break;
      case("4"):xRootNotes = 5; break;
      case("5"):xRootNotes = 6; break;
    }
    if(lastXRootNotes != xRootNotes){
//This, again, fixes an error in the matrix caused by the size of the matrix not being devisible by the number of buttons in it.
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
//Checks to see if the matrix is in root note mode or sequencer mode.
  if (root_notes.getBooleanValue()){
//In this case, the matrix is in root note mode.
    for (int i = 0; i < xRootNotes; i++){
//Each collumn has a (2/3) chance to have a cell activated. If one isn't chosen, the bottom cell (the rest cell) is activated.
      if (rand.nextInt(3) > 0){
//Each cell in the collumn has an equal chance to activate.
        sequencerButtons.set(i, rando.nextInt(yNotes), true);
      }
      else sequencerButtons.set(i, yNotes - 1, true);
    }
  }
  else{
//In this case, the matrix is in sequencer mode.
    for (int i = 0; i < xSteps; i++){
//Each collumn has a (2/3) chance to have a cell activated. If one isn't chosen, the bottom cell (the rest cell) is activated.
      if (rand.nextInt(3) > 0){
//Each cell in the collumn ahs an equal chance to activate.
        sequencerButtons.set(i, rando.nextInt(yNotes), true);
      }
      else sequencerButtons.set(i, yNotes - 1, true);
    }
  }
}

/**
*Allows keyPresses to activate cells in the matrix.
*/
void keysPressed(){
//the '=' button and '-' button move left and right across the matrix.
  if(key == '=' || key == '+')highlightedRow ++;
  if(!root_notes.getBooleanValue())highlightedRow = highlightedRow % xSteps;
  else highlightedRow = highlightedRow % xRootNotes;
  if (key == '-' || key == '_')highlightedRow --;
//wraps the highlighter around from 0 to the end of the matrix.
  if(!root_notes.getBooleanValue() && highlightedRow < 0) highlightedRow = xSteps - 1;
  else if (root_notes.getBooleanValue() && highlightedRow < 0) highlightedRow = xRootNotes - 1;

//The number buttons set the cells in the highlighted collumn. 
  if (key == '1'){
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

private void saveActiveCells(){
//k keeps track of the differences between the recent set of active cells and the current cells.
  int k;
//Checks if the matrix is in root notes mode or sequencer mode.
  if(!root_notes.getBooleanValue()){
//In this case, the matrix is in sequencer mode.
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
//In this case, the matrix is in root notes mode.
    selectedRootNotes.clear();
    for(int i = 0; i < xRootNotes; i ++){
      k = 0;
      for (int j = 0; j < yNotes; j++){
        if (sequencerButtons.get(i,j)){
          k++;
          selectedRootNotes.append((yNotes - 1) - j);
        }
      }
      if (k == 0) selectedRootNotes.append(-1);
    }
  }
}

private void clearRow(int row){
  for (int i = 0; i < yNotes; i ++){
    sequencerButtons.set(row,i,false);
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
   
    if (activeCells.size() != lastActiveCells.size()){
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
    if (!(k == 0) && !(loop.getBooleanValue())){
      lastActiveCells.clear();
      lastActiveCells = activeCells.copy();
      println(activeCells);

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
  
  /**
  *Draws a rectangle at the top of the matrix to keep track of which row is being played by the synthesizer.
  */
   void drawExtras(){
     float counts;
     int number = (int)cnt;
     if(!root_notes.getBooleanValue()) counts = cnt % xSteps;
     else counts = (number / xSteps) % (xRootNotes);
     //println("cnt " + cnt + "xSteps " + xSteps + " rootNotes" + xRootNotes + " counts: " + counts);
     int stepper;
     if(!root_notes.getBooleanValue()) stepper = xSteps;
     else stepper = xRootNotes;
     
     float matrixWidth = sequencerButtons.getWidth();
     rectMode(CORNER);
     fill(255,255,0);
     float spacing  = ((matrixWidth/stepper)*(counts)) - 1;
     rect(posMatrix_X + spacing, posMatrix_Y - 20, matrixWidth/(stepper), 20); 
 
     float buttonSpacing = ((matrixWidth/stepper)*(highlightedRow)) - 1;
     rectMode(CORNER);
     fill(100, 215, 40);
     rect(posMatrix_X + buttonSpacing, posMatrix_Y + sizeMatrix_Y, matrixWidth/(stepper), 20);
   }

}