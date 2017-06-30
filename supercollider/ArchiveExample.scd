// make a storage place for various objects:
q = (); // Event

q[\a_long_array] = Array.rand(128, 0.0, 1.0);
q[\pi_squared] = pi * pi;
q[\favourite_sound] = { { SinOsc.ar([300, 330]).sum * LFPulse.kr(2 + [0, 0.01]) * 0.1 }.play };
q[\same_long_array] = q[\a_long_array]; // same objects may appear several times

Archive.global.put(\myData, q);


Archive.global.at(\myData).postcs;

a=Archive.global.at(\myData);

a[\favourite_sound].postcs;

// after a recompile:
s.boot;

q = Archive.global.at(\myData);
q.postcs;
x = Array2D.new(16,32);
x = q[\saved_timeline];

x.rowsDo(_.postln);

Archive.write;
