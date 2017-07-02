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
 float[][] sliderRanges  = {{0.001, 1.0}, {0.01, 1.0},{0.01, 1.0},{0.05, 5.0}, {0.0, 1.0},{0.1, 10.0}}; //default
 float[] sliderValues = {0.1,0.5,0.3,0.2,0.6,1.0};
 float[] envArray;
 FloatList envPoints;
 boolean lock = false;
 int coreNote = 57;
// Timer sliderRate;
// int root = 60;
 //EnvShaper env;
 
 
 Instrument(String _theName, int _id){
   atk = 0.1;
   decay = 0.5;
   sustain = 0.3;
   release =0.2;
   theName = _theName;
   id = _id;
   initEnvPoints();
   //sliderRate = new Timer(30);
   
   
       
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
   void sendCoreNote(){
       
      OscMessage mMessage = new OscMessage("/core" );
      mMessage.add(coreNote);
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

}