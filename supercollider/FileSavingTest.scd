Scale.names
Document.standardizePath("~/Google\ Drive/2016_Fall/Convolution/InterfaceCode/supercollider");

(
var f, g;
f = File("~/Google\ Drive/2016_Fall/Convolution/InterfaceCode/supercollider/test.txt".standardizePath,"w");
f.write("Does this work?\n is this thing on ?\n");
f.close;
)
(
var f, g;
f = File("~/Google\ Drive/2016_Fall/Convolution/InterfaceCode/supercollider/scales.txt".standardizePath,"w");
Scale.names.do{ |i|
	f.write(i);
	f.write(",");
	i.postln;
};
f.close;
)

Scale.at(Scale.names[0])
Scale.directory
Scale.major.degrees[0]
Scale.kurd.pitchesPerOctave;
Scale.kurd.degrees
Scale.kurd.size;
Scale.kurd.semitones
Scale.kurd.stepsPerOctave;

Scale.major.degreeToFreq(0, 57.midicps, 2); 