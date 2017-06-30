s.meter;

x ={SinOsc.ar([300, 500])}.play;
x ={[SinOsc.ar(300), SinOsc.ar(500)]}.play;
x.free;

(
SynthDef.new(\multi,  {
	var sig, amp, env;
	env =  EnvGen.kr(  //triangle envelope to shape volume of synth
		Env.new([0,1,0], [0.1,10], [1, -1]),
		doneAction: 2
	);
	amp = SinOsc.kr({ExpRand(0.2,12)}!8).range(0,0.8);  //Create an array of 8 unique amplitude oscillators
	sig = SinOsc.ar({ExpRand(50, 1200)}!8);                    //create an array of 8 unique frequency oscillators
	sig = sig * amp * env;                                               //combine the signal, amplitude, and envelop for each
	sig = Splay.ar(sig)!2*0.25;                                        //Splay the 8 signals between two audio channels(stereo sound)
	Out.ar(0,sig);                                                            //Send signal to speakers
}).add;
)

(
x = Synth.new(\multi);                                             //play two copies of the synth

y = Synth.new(\multi);
)
(
x.free;
y.free;
)

s.boot
s.reboot