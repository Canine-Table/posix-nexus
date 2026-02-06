(
Routine({
    loop {
        var freq = 440;
        var amp = 0.1;
        var wait = 0.1 + 0.4.rand;   // chaotic timing

        { SinOsc.ar(freq) * amp ! 2 }.play;
        wait.wait;
    }
}).play;
)

