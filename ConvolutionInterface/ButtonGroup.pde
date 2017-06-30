class ButtonGroup{
  String[] names;
  String groupName;
  float gX, gY, xoff, yoff;
  int w, h;
  int numButtons;
  float buttonXSpace;
  float buttonWidth;
  float gapWidth;
  
  
  ButtonGroup(String _gName, String[] _names, float _gX, float _gY, int _w, int _h){
    names = _names;
    groupName = _gName;
    gX = _gX;
    gY = _gY;
    w = _w;
    h = _h;
    xoff = 10;
    yoff = 10;
    gapWidth = 2;
    numButtons = names.length;
    buttonXSpace = w -xoff*2;
    buttonWidth = (buttonXSpace - (numButtons-1)*gapWidth)/numButtons;
    println("Created");
  }
  
  void setupButtons(){

                 
  Group g6 = cp5.addGroup(groupName)
                 .setPosition(gX,gY)
                 .setBarHeight(40)
                 .setBackgroundHeight(200)
                 .setSize(w,h)
                 .setBackgroundColor(0xffff11ff)
                 ;
                 
  
  for(int i = 0; i < names.length; i++){ 
   cp5.addButton( names[i] + i )
       
       //.setValue( 0.1 )
       .setLabel(names[i])
       .setPosition(xoff+(buttonWidth+gapWidth)*i, yoff)
       .setSize((int)buttonWidth, (int)buttonWidth)
       .setGroup(g6)
       ;
       cp5.getController(names[i]+i).getValueLabel().alignX(ControlP5.CENTER);
  }
 /*      
     cp5.addSlider( "decay" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setDcy" )
       .setValue( 0.5 )
       .setLabel("Decay")
       .setPosition(70,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "sustain" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setSus" )
       .setValue( 0.3 )
       .setLabel("Sustain")
       .setPosition(130,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
 cp5.addSlider( "release" )
       .setRange( 0.01, 5.0 )
       //.plugTo( this, "setRel" )
       .setValue( 1 )
       .setLabel("Release")
       .setPosition(190,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "effect1" )
       .setRange( 0.0, 100.0 )
       //.plugTo( this, "setEffect1" )
       .setValue( 50 )
       .setLabel("Effect1")
       .setPosition(250,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
       
  cp5.addSlider( "effect2" )
       .setRange( 0.0, 100.0 )
       //.plugTo( this, "setEffect2" )
       .setValue( 50 )
       .setLabel("Effect2")
       .setPosition(310,10)
       .setSize(50, 180)
       .setGroup(g1)
       ;
      */
  cp5.addTextlabel("FX Group: " + groupName)
       .setText("Instrument: " + instNames[listIndex])
       .setPosition(50,210)
       .setSize(50, 300)
       .setColorValue(0xffffff00)
       .setFont(createFont("AvenirNext-DemiBold",24))
       //.setMultiline(true)
       .setLineHeight(30)
       .setGroup(g6)
       ;
  //cp5.getController("attack").getValueLabel().alignX(ControlP5.CENTER);
  //cp5.getController("decay").getValueLabel().alignX(ControlP5.CENTER);
  //cp5.getController("sustain").getValueLabel().alignX(ControlP5.CENTER);
  //cp5.getController("release").getValueLabel().alignX(ControlP5.CENTER);
  //cp5.getController("effect1").getValueLabel().alignX(ControlP5.CENTER);
  //cp5.getController("effect2").getValueLabel().alignX(ControlP5.CENTER);
       
       //End g1 === ========
       
 
 // plugSliders(listIndex, 0);
}

}