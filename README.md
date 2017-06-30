
<h1>Convolution</h1>
<h3>Repository for Supercollider powered Raspberry Pi programmable portable synthesizer.</h3>

<p>Currently very messy and in active development.  Eventually the code base will stablize.  The goal is to create a programmable synth that removes many of the annoyances of getting supercollider set up on a raspberyy pi and the challenges for beginning programmers to write a hardware and software interface for supercollider.  Effectively sandboxing the process of coding synths, samplers, and filters in supercollider. Beginning programmers will be able to quickly create and perform custom insturments while being introduced to the power and flexibility of supercollider.  Advanced programmers will be to use this as a starting point for further development.</p>

<p>Currently the software will run on osx, I believe it will run on windows and linux.  It also runs on the Raspberry Pi, but requires a some dependencies, and removing Sonic Pi to get supercollider working.  If you look at the Working Notes document in the repo I have links to steps needed to get it running.</p>

<p>The plan is to create an Image of the modified Raspbian OS and make that available for download so all of the headache of installing supercollider, setting up audio routing, turning off unneeded processes, etc. is done and people can copy the image to an SD card and start playing.</p> 

# Setup for OSX and Windows:
<ol>
<li> Clone or download this repo and unzip.</li>
<li> Download processing: <a href="www.processing.org">www.processing.org</a></li>
<li> Open Processing and open the ConvolutionInterface.pde file.</li>
<li> Currently if no usb serial device (arduino) is attached the interface will fail to open when run.  This can easily be solved by attaching an arduino to the usb port, or on OSX you can change one line of code to make it listen to the /dev/cu.Incoming-Bluetooth-Port as a dummy port.  Bluetooth must be turned on for this to work.  Have not tested in Windows. In the setup() function in the processing sketch change: 
<pre>if(System.getProperty("os.name").equals("Mac OS X")){
   //change value to length-2 to use with mac without serial device attached
  port = new Serial(this, Serial.list()[Serial.list().length -1], BAUD);
 }else{
   port = new Serial(this, Serial.list()[Serial.list().length -2], BAUD);
   }</pre>
   to:
   
  <pre>if(System.getProperty("os.name").equals("Mac OS X")){
   //change value to length-2 to use with mac without serial device attached
   port = new Serial(this, Serial.list()[Serial.list().length -<span style="bgcolor:red;">2</span>], BAUD);
 }else{
   port = new Serial(this, Serial.list()[Serial.list().length -2], BAUD);
   }</pre>
   and save the changes.
<li> Download SuperCollider: <a href="http://supercollider.github.io/">http://supercollider.github.io/</a></li>
<li> Open SuperCollider and then open convolution/supercollider/SuppercolliderFinalFiles/BasicBootRequirements.scd. (yes Suppercollider and not supercollider)</li>
<li> Follow the instructions in the comments to boot the server and load the required files.  The drum machine should begin playing an obnoxoius repetitive beat if it is working.</li>
<li> Open Processing and open the ConvolutionInterface.pde file and run it.  </li>
</ol>
<p>Once the matrix has played through once the drum machine should go silent.  Now you can turn on and off different instruments.  The up and down arrow allow you to switch instruments and then use the last two sliders to control amplitude and playback rate.  The others are not connected to controls on the synth server yet.  The left and right arrows allow you to change from drum machine to step sequencer to lead synth, though lead synth needs the physical interface to work.  Also, occasionally you cannot click on any buttons until you cycle through the modes at least once more.  </p>

This will get the software working.  The SynthDefs.scd file and the DrumMachine.scd file in the convolution/supercollider/SuppercolliderFinalFiles/ folder have example synth definitions and the code that looks for samples in .wav format.  Currently the samples used are a subset of TR-808 samples, but as long as you record them in .wav format at 48k you could add any samples you want to the folders and access them through the interface.

A lot of work needs to be done.  This is pre-alpha, but somewhat functional especially with the interface.


