// --- Hash function (random 0..1) ---
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

// --- Black/white noise ---
float noiseBW(vec2 uv) {
	float r = hash(uv * 100.0);
	return r > 0.5 ? 1.0 : 0.0;
}

// --- Grayscale noise ---
float noiseGray(vec2 uv) {
	return hash(uv * 100.0);
}

// --- Mixed BW + grayscale ---
float noiseMixed(vec2 uv, float mixAmount) {
	float r = hash(uv * 100.0);
	float bw = r > 0.5 ? 1.0 : 0.0;
	return mix(bw, r, mixAmount);
}

float applyContrast(float v, float c) {
	// c = 1.0 -> no change
	// c > 1.0 -> more contrast
	// c < 1.0 -> less contrast
	return 0.5 + (v - 0.5) * c;
}

float applyBrightness(float v, float b) {
	// b = 0.0 -> no change
	// b > 0.0 -> brighter
	// b < 0.0 -> darker
	return v + b;
}

float noiseGrayControlled(vec2 uv, float contrast, float brightness) {
	float r = hash(uv * 100.0);
	r = applyContrast(r, contrast);
	r = applyBrightness(r, brightness);
	return clamp(r, 0.0, 1.0);
}

// Signed distance to a circle
float sdfCircle(vec2 uv, vec2 center, float radius) {
	return length(uv - center) - radius;
}

vec2 randomPoint(vec2 uv) {
	return vec2(
		hash(uv + 1.0),
		hash(uv + 2.0)
	);
}

float randomRadius(vec2 uv) {
	return 0.05 + hash(uv + 3.0) * 0.2;
}

float randomCircle(vec2 uv) {
	vec2 center = randomPoint(vec2(0.123, 0.456)); // seed
	float radius = randomRadius(vec2(0.789, 0.321));

	float d = sdfCircle(uv, center, radius);
	return d < 0.0 ? 1.0 : 0.0; // inside = white, outside = black
}

float hashSeeded(vec2 p, float seed) {
	return fract(sin(dot(p + seed, vec2(12.9898, 78.233))) * 43758.5453123);
}

float mandelbrot(vec2 c) {
	vec2 z = vec2(0.0);
	float iter = 0.0;

	for (int i = 0; i < 100; i++) {
		if (dot(z, z) > 4.0) break;

		z = vec2(
			z.x*z.x - z.y*z.y + c.x,
			2.0*z.x*z.y + c.y
		);

		iter++;
	}

	return iter / 100.0;
}

