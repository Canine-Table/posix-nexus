
vec2 rotate2D(vec2 p, float a) {
	float s = sin(a);
	float c = cos(a);
	return vec2(
		p.x * c - p.y * s,
		p.x * s + p.y * c
	);
}

vec2 translate2D(vec2 p, vec2 t) {
	return p + t;
}

