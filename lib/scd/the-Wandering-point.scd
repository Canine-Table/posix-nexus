(
Routine({
    var z, c;
    c = Complex(0.3, 0.6);

    loop {
        var freq, amp;
        z = z ? Complex(0,0);
        z = z * z - c;

        freq = (z.real.abs + z.imag.abs).linexp(0, 4, 100, 2000);
        amp  = z.imag.linlin(-2, 2, 0.05, 0.3);

        {
            var sig;
            sig = SinOsc.ar(freq) * amp;
            sig ! 2
        }.play;

        0.2.wait;
    }
}).play;
)
