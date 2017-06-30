SynthDef(\help_sawgrain,
    { arg out=0, freq=440, ssustain=0.1;
        var env;
        env = EnvGen.kr(Env.perc(0.001, ssustain, 0.05), doneAction:2);
		Out.ar(out, SawDPW.ar(freq, 0, env))
    }).add;