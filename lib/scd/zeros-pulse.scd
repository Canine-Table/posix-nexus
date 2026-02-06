
(
SynthDef(\zeroPulse, { |base = 110|
    var forks, env, mod;

    forks = Mix.fill(6, { |i|
        var ratio = (i + 1) * (1 + LFNoise1.kr(0.1).range(-0.02, 0.02));
        SinOsc.ar(base * ratio, 0, 0.15 / (i + 1))
    });

    env = EnvGen.kr(
        Env(
            levels: [0, 1, 0.3, 0],
            times:  [4, 8, 6],
            curve:  'sine'
        ),
        doneAction: 2
    );

    mod = SinOsc.kr(0.05).range(0.9, 1.1);

    Out.ar(0, (forks * env * mod).tanh ! 2);
}).add;

Synth(\zeroPulse, [\base, 55]);
)
