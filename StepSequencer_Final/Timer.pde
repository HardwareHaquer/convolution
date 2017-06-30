class Timer{
  
  int current;
  int delayTime;
  
  
  Timer(int _delayTime){
    delayTime = _delayTime;
    reset();
    
  }
  
  boolean isFinished(){
    if(millis() - current >= delayTime){
      reset();
      return true;
    }else{
      return false;
    }
  }
  
  void reset(){
    current = millis();
  }
  void finish(){
    current = delayTime;
  }
}