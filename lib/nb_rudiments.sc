Nb_rudiments {
	classvar <voxs;
	*initClass {
		voxs = 4.collect {nil};

		StartUp.add {
			"teaching rudiments".postln;
		  	SynthDef(\nb_rudiments,{

                | rudiments_shape = 0,
                rudiments_freq = 220,
                rudiments_decay = 0.2,
                rudiments_sweep = 1000,
                rudiments_lfoFreq = 60,
                rudiments_lfoShape = 0,
                rudiments_lfoSweep = 100,
                rudiments_gain = 1|

                // ENV
                var env = EnvGen.kr(Env.perc(0, rudiments_decay), doneAction: 2);
                
                // LFO
                var lfoSquare = Pulse.ar(rudiments_lfoFreq);
                var lfoTriangle = LFTri.ar(rudiments_lfoFreq);
                var lfo = SelectX.ar(rudiments_lfoShape, [lfoTriangle, lfoSquare]);
                
                // OSC
                var triangle = LFTri.ar(rudiments_freq + (env * rudiments_sweep) + (lfo * rudiments_lfoSweep));
                var square = Pulse.ar(rudiments_freq + (env * rudiments_sweep) + (lfo * rudiments_lfoSweep));
                var oscil = SelectX.ar(rudiments_shape, [triangle, square]);
                
                // AMP
                var final = (oscil * env) / 8;
                
                // OUTPUT
                final = (final * rudiments_gain).tanh;
                Out.ar(0, final.dup);
			}).add;

			OSCFunc.new({ |msg, time, addr, recvPort|
				var args = [[ \rudiments_shape,
                \rudiments_freq,
                \rudiments_decay,
                \rudiments_sweep,
                \rudiments_lfoFreq,
                \rudiments_lfoShape,
                \rudiments_lfoSweep,
                \rudiments_gain],
				msg[1..]].lace;
                Synth.new(\nb_rudiments, args);
			}, "/nb_rudiments/perc");
		};
	}
}
