import { NxGL } from "./mjs/nex-gl.mjs"

document.addEventListener('DOMContentLoaded', () => {
	const cvs = new NxGL(document.body, {
		fragment: "static/glsl/frag/main.frag",
		vertex: "static/glsl/vert/main.vert",
		buffers: {
			a_position: {
				vao: "tri1",
				size: 2,
				vertex: [
					-0.5, -0.5,
					 0.5, -0.5,
					 0.0,  0.5
				]
			},

			a_color: {
				vao: "tri1",
				size: 3,
				vertex: [
					1, 0, 0,   // red
					0, 1, 0,   // green
					0, 0, 1	// blue
				]
			}
		}
	});
});




