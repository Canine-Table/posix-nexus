(
Routine({
    var z = Complex(0, 0);     // state
    var c = Complex(0.3, 0.6); // constant
    var freq, amp, magnitude;

    loop {
        // 1. Apply fractal rule
        z = z * z - c;

        // 2. Measure geometry
		magnitude = z.abs;

        // 3. Map to sound
        freq = magnitude.linexp(0, 4, 100, 2000);
        amp  = magnitude.linlin(0, 4, 0.05, 0.2);

        // 4. Play sound
        {
            var sig = SinOsc.ar(freq) * amp;
            sig ! 2
        }.play;

        // 5. Timing
        0.1.wait;
    }
}).play;
)
