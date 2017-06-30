s.latency

//sound recipe, required
SynthDef(\testbleep,{ Out.ar(0,Pan2.ar(Line.kr(1,0,0.1,doneAction:2)*SinOsc.ar(440)*0.1,0.0))}).add;
SynthDef(\testbleep2,{ Out.ar(0,Pan2.ar(Line.kr(1,0,0.1,doneAction:2)*SinOsc.ar(880)*0.1,0.0))}).add;

//no use of latency, immediate, timing slightly more ragged

(
{
	inf.do {|i|
		Synth(\testbleep);
		Synth(\testbleep2);

		[0.5,0.25,0.02].wrapAt(i).wait;
	}
}.fork;
)

s.latency = 0.2
s.latency = 0.05
s.latency;

(
{
	inf.do {|i|
		s.bind {  Synth(\testbleep); Synth(\testbleep2)};
		[0.5,0.25,0.02].wrapAt(i).wait;
	}
}.fork;
)


SynthDef(\testbleep3,{ OffsetOut.ar(0,Pan2.ar(Line.kr(1,0,0.1,doneAction:2)*SinOsc.ar(440)*0.1,0.0))}).add;

//with OffsetOut
(
{
	inf.do {|i|
		s.bind {  Synth(\testbleep3); };
		[0.5,0.25,0.001].wrapAt(i).wait;
		//note 0.001 milliseconds wait is under control period size, 64/44100 = 0.0014512471655329
	}
}.fork;
)

//without
(
{
	inf.do {|i|
		s.bind {  Synth(\testbleep); };
		[0.5,0.25,0.001].wrapAt(i).wait;
		//note 0.001 milliseconds wait is under control period size, 64/44100 = 0.0014512471655329
	}
}.fork;
)

//Demoes on the perception of rhythm


//s.bind and OffsetOut will be used in these demoes to get accurate timing of events; see the 'Precise Timing in SC' tutorial

SynthDef(\beep,{arg freq=440,amp=0.1, pan=0.0, dur=0.1; OffsetOut.ar(0,Pan2.ar(SinOsc.ar(freq,0,amp)*Line.kr(1,0,dur, doneAction:2),pan))}).add

//test
Synth(\beep,[\freq, 440, \amp,1])

//An event is sent at equal volume to both ears but arrives at the right ear 1 millisecond ahead of the left. You will hear it coming from the right
//(demo works best over headphones)
(
{

s.bind{Synth(\beep,[\freq, 440,\amp,0.1,\pan,-1])};

0.05.wait;

s.bind{Synth(\beep,[\freq, 440,\amp,0.1,\pan,1])};

}.fork
)

//which came first? 30 msec difference between two tones (try different values)
(
{

s.bind{Synth(\beep,[\freq,440,\amp,0.1,\pan,-1,\dur,0.1+0.03])};

0.03.wait;

s.bind{Synth(\beep,[\freq,560,\amp,0.1,\pan,1,\dur,0.1])};

}.fork
)

(
var n, delay;

n=rrand(3,9); //start increasing by 1

delay=0.4/n;

{

	n.do {
	s.bind{Synth(\beep,[\freq, 440,\amp,0.1,\pan,0])};

	delay.wait;
	}

}.fork
)

(
var categories, n;

n=7;

categories=[0.25,0.33,0.4,0.5,0.6,0.67,0.75,0.8,1,1.25,1.5,1.75];

n = min(n,categories.size);

{

	inf.do {

	s.bind{Synth(\beep,[\freq, 440,\amp,0.1,\pan,0])};

	(categories.wrapAt(n.rand))/10.wait;
	}

}.fork
)

//limits of tempo
(
var tempo; var bpm;
bpm=120;
tempo=bpm/60; //bps 0.5 (2 second period), 4 (0.25 second period)

{
	inf.do {	arg i; var turth = true;
		/*(i).post;
		" : ".post;
		(i%2).post;*/

		// 0.5.wait;
		if((i%2.0)>0, {s.bind{Synth(\beep,[\freq, [110, 220, 330].wrapAt(i),\amp,[0.4,1].wrapAt(i),\pan,0])}; s.bind{Synth(\beep,[\freq, rrand(200,2000),\amp,0.2,\pan,0])}}, {s.bind{Synth(\beep,[\freq, 2000,\amp,0.2,\pan,0])}});
		//if((i%2) > 0, {"he".postln}, {"she".postln});
		0.5.wait;
		[0.6,1].wrapAt(i).postln;

	}
}.fork(TempoClock(tempo))
)

(
    {
        if( LFNoise1.kr(1.0,0.5,0.5) , SinOsc.ar, Saw.ar )
    }.play
)
(
if ( [false, true].choose,                // Boolean expression (chooses one at random)
    { "expression was true".postln },    // true function
    { "expression was false".postln }    // false function
)
)
(
{
	inf.do {	arg i; var turth;
		(i).post;
		" : ".post;
		turth = i%2;
		turth.post;


		//if((i%2.0)>0, s.bind{Synth(\beep,[\freq, 220,\amp,0.2,\pan,0])}, s.bind{Synth(\beep,[\freq, 2000,\amp,0.2,\pan,0])});
		if((i%2) == 0, {"he".postln;}, {"she".postln;});
		0.5.wait;

	}
}.fork
)

//tempo discrimination test

t = TempoClock(2);
t.tempo= 2*(1.1); //try different values like 1.01, 1.04, 1.1 for the multiplier in brackets
(
{
	inf.do {
		s.bind{Synth(\beep,[\freq, 440,\amp,0.1,\pan,0])};
		1.wait;
	}
}.fork(t)
)

t.tempo= 2*(1.01); //try different values like 1.01, 1.04, 1.1 for the multiplier in brackets

//swing

w = 0.1; //variable to hold amount of swing in seconds

(
{
	inf.do {|i|
		s.bind{Synth(\beep,[\freq, [440,1600]@@(i),\amp,0.1,\pan,0])};
		([1,-1]@@(i)*w + 0.25).wait; //@@ is wrapAt
	}
}.fork(TempoClock(2))
)

w = 0.07; //try 0.0, 0.2

(
var clock = TempoClock(1);

{


	6.do{|i|

		("iteration"+i).postln;

		{

			//pulse beats
			8.do{
				Synth(\beep,[\freq, 100, \amp,0.5]);

				1.0.wait;
			};

		}.fork(clock);


		{

			(4*6).do{
				Synth(\beep,[\freq, 200, \amp,0.5]);

				0.25.wait;
			};

			(5*2).do{
				Synth(\beep,[\freq, 300, \amp,0.5]);

				0.2.wait;
			};


		}.fork(clock);

		8.wait;

		clock.tempo = clock.tempo*(5/4);

	};

}.fork(clock);

)

(
var bpm = 60;
var clock = TempoClock(bpm/60);

{


	/*6.do{|i|

		("iteration"+i).postln; */

		{

			//pulse beats
			inf.do{
			   3.do {
				//0.5.wait;
				Synth(\beep,[\freq, 2000, \amp, 0.5]);

				1.0.wait;
			  };

			Synth(\beep,[\freq, 1000, \amp, 1.0]);

				1.0.wait;
			};

		}.fork(clock);


		inf.do{

			(2).do{
				Synth(\beep,[\freq, 200, \amp,0.5]);

				0.25.wait;
			};

			(1).do{
				Synth(\beep,[\freq, 300, \amp,0.5]);

				0.25.wait;
			};

		    (2).do{ arg x;
			Synth(\beep,[\freq, [400,600].wrapAt(x), \amp,0.5]);

				0.125.wait;
			};


		}.fork(clock);



		/*8.wait;

		clock.tempo = clock.tempo*(5/4);

	}; */

}.fork(clock);

)

s.latency
