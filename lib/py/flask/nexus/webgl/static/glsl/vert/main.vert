


/*precision mediump float;

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
uniform float u_seed;

void main() {
	vec2 p = a_position;

	// Try any of these:
	//p = rotate2D(p, u_time);
	// p = scale2D(p, 1.0 + 0.2 * sin(u_time));
	// p = translate2D(p, vec2(0.1, 0.0));
	p = wobble(p, u_time);
	p = p + randomOffset(float(gl_VertexID));

	v_uv = a_uv;
	gl_Position = vec4(p, 0.0, 1.0);
}

*/


in vec2 a_position;
in vec3 a_color;

out vec3 v_color;

void main() {
    v_color = a_color;
    gl_Position = vec4(a_position, 0.0, 1.0);
}

