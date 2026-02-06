(
Routine({
    loop {
        var freq = rrand(200, 800);
        var amp  = 0.1;

        {
            var sig = Mix([
                SinOsc.ar(freq),
                Saw.ar(freq * 0.5),
                LFNoise1.ar(freq * 0.1)
            ]);
            sig * amp ! 2
        }.play;

        0.2.wait;
    }
}).play;
)
