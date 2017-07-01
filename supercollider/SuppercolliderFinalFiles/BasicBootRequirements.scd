
/*To Start Convolution audio server: 1) move cursor into code block below and hit cmd+enter in osx ctrl + enter in windows
*/
(
s.startAliveThread;
ServerBoot.add { s.initTree };
s.boot;
)


/* Setp 2: execute this block of code.  This loads the three required .scd files */
(
//note currently need to load testsAndStops.scd by hand first
var files = #["SynthDefs_test.scd", "DrumMachine.scd", "OSCdefsTempoBuffer_test.scd", "LeadSynthFinal.scd"];
Server.default.waitForBoot {
        var dir = thisProcess.nowExecutingPath.dirname;
	files.do { |f| (dir +/+ f).load; s.sync; };
}
)

/*Step 3: Run the ConvolutionInterface.pde file in processing to open the interace*/


//EXTRAS: PlotTree shows how many instances of each synth are playing.  Good for debugging
//meter shows levels for inputs and outputs
s.plotTree;
s.meter(2,8);

//If things go haywire either reboot or quit server.  You also may need to reboot the Interpreter via Language-> Reboot Interpreter
s.reboot;
s.quit;

//test play a sound if drum machine does not start
x = {SinOsc.ar(440)}.play
x=Synth(\help_sinegrain, [\amp, 1.0]);
x.free;
thisProcess.nowExecutingPath.dirname;