float hash1(float x) {
	return fract(sin(x * 12.9898) * 43758.5453123);
}

vec2 randomOffset(float seed) {
	return vec2(
		hash1(seed + 1.0) * 0.05,
		hash1(seed + 2.0) * 0.05
	);
}


