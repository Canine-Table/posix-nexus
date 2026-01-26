(
{
    // Fundamental frequency — the "anchor" of Zero
    var base = 110; // low, steady, unassuming

    // Harmonic forks — entropy pushing outward
    var forks = Mix.fill(6, { |i|
        var ratio = (i + 1) * (1 + LFNoise1.kr(0.1).range(-0.02, 0.02));
        SinOsc.ar(base * ratio, 0, 0.15 / (i + 1))
    });

    // Slow rise and collapse — the pulse of Zero
    var env = EnvGen.kr(
        Env(
            levels: [0, 1, 0.3, 0],      // rise → bloom → collapse → silence
            times:  [4, 8, 6],          // slow, inevitable, gravitational
            curve:  'sine'
        ),
        doneAction: 2
    );

    // Subtle modulation — the shimmer of divergence
    var mod = SinOsc.kr(0.05).range(0.9, 1.1);

    // Output
    (forks * env * mod).tanh ! 2
}.play;
)

