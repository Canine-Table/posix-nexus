precision mediump float;

in vec3 v_color;
out vec4 outColor;

void main() {
    outColor = vec4(v_color, 1.0);
}

//#nx_include common.glsl


//in vec2 v_uv;
//out vec4 outColor;

//void main() {
	// Pick ONE of these:
	//float val = noiseBW(v_uv);
	//float val = noiseGray(v_uv);
	//float val = noiseMixed(v_uv, 0.5);
	//float val = noiseGrayControlled(v_uv, 2.0, -0.1);
	//float val = randomCircle(v_uv);

	// Normalized pixel coordinates (0..1)
//	vec2 uv = gl_FragCoord.xy / u_resolution;

	// Center and scale the fractal
//	vec2 p = (uv - 0.5) * 3.0;

	// animate zoom
	//p *= 1.0 + 0.3 * sin(u_time * 0.2);

	// mouse zoom
	//p *= zoom;

	// mouse pan
	//p += vec2(
	//	(u_mouse.x / u_resolution.x - 0.5) * 2.0,
	//	 (u_mouse.y / u_resolution.y - 0.5) * 2.0
	//);

//	float m = mandelbrot(p);

	// Simple grayscale
	//outColor = vec4(vec3(m), 1.0);

//	outColor = vec4(vec3(m * 0.5 + 0.5, m * 0.3, m), 1.0);

//}

//uniform float u_time;
//uniform vec2 u_resolution;
//uniform vec2 u_mouse;
//uniform float u_seed;
//in vec2 v_uv;
//in float v_seed;
//out vec4 outColor;



//void main() {
//	vec2 uv = (v_uv - 0.5) * 3.0;

//	float t = u_time * 0.5;
	// wiggle based on seed
//	uv += 0.01 * sin(u_time * 2.0 + v_seed + uv * 10.0);

	//float zoom = 1.0 + (u_mouse.x / u_resolution.x) * 4.0;

	// color shift based on seed

//	float r = sin(uv.x + t) * 0.5 + 0.5;
//	float g = sin(uv.y + t * 1.3) * 0.5 + 0.5;
//	float b = sin(uv.x + uv.y + t * 0.7) * 0.5 + 0.5;

//	outColor = vec4(r, g, b, 1.0);
	//outColor = vec4(vec3(m * 0.5 + 0.5, m * 0.3, m), 1.0);
//}


