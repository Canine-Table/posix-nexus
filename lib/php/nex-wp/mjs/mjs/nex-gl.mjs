import { NxInclude } from './nex-include.mjs';

const VERTEX = {
	0: '.vert',
	1: '.frag',
	100: `
		attribute vec2 a_position;
		void main() {
			gl_Position = vec4(a_position, 0.0, 1.0);
		}`,
	300: `#version 300 es
		in vec2 a_position;
		void main() {
			gl_Position = vec4(a_position, 0.0, 1.0);
		}`
}

const FRAGMENT = {
	0: '.frag',
	1: '.vert',
	100: `
		precision mediump float;
		void main() {
			gl_FragColor = vec4(0.2, 0.8, 0.3, 1.0);
		}`,
	300: `#version 300 es
		precision mediump float;
		
		out vec4 outColor;
		void main() {
			outColor = vec4(0.2, 0.8, 0.3, 1.0);
		}`
}

export class NxGL
{
	#R = null;
	#U8 = null;
	#U16 = null;
	#U32 = null;
	#S32 = null;
	#F32 = null;
	#buffers = null;
	#pendingResize = false;

	#fromRGB(value) {
		this.#U32[0] = parseInt(String(value).replace('#', ''), 16);
		this.#U32[1] = 0x0000FF & this.#U32[0];
		this.#U32[2] = (0x00FF00 & this.#U32[0]) >> 8;
		this.#U32[3] = (0xFF0000 & this.#U32[0]) >> 16;
	}

	#loadColor(value) {
		if (value)
			this.#fromRGB(value);
		this.#U8[0] = 3;
		do {
			this.#F32[this.#U8[0]] = this.#U32[this.#U8[0]] / 255;
		} while (--this.#U8[0]);
	}

	constructor(
		node,
		{
			fragment,
			vertex,
			version,
			clearColor,
			x,
			y,
			alpha,
			buffers
		}
	) {

		// scratch registers and and a byte view
		this.#R = new ArrayBuffer(128);
		this.#U8 = new Uint8Array(this.#R);
		this.#U16 = new Uint16Array(this.#R);
		this.#U32 = new Uint32Array(this.#R);
		this.#S32 = new Int32Array(this.#R);
		this.#F32 = new Float32Array(this.#R);
		this.#buffers = new Map();

		// [0 - 9] scratchpads

		// seed for u_seed
		this.#U32[10] = Math.random() * 1000.0;

		// mouse x
		this.#F32[11] = 0;

		// viewport x start
		this.#F32[12] = x;

		// mouse y
		this.#F32[13] = 0;
		
		// viewport y start
		this.#F32[14] = y;

		// the color to use when no color is specified
		this.#loadColor(clearColor ?? '6495ED');

		// the Red channel of the above color
		this.#F32[15] = this.#F32[1];

		// the Blue channel of the above color
		this.#F32[16] = this.#F32[2];

		// the Green channel of the above color
		this.#F32[17] = this.#F32[3];

		// the alpha channel from 0-1 range for the above color
		this.#F32[18] = this.binaryWrap(alpha ?? 1);

		// the program counter
		this.#F32[19] = 0;

		// the version number
		this.#U8[20] = 0;

		this.initCanvas(node);
		this.mouseMove();
		this.nxinc = new NxInclude();
		if (!this.initGL(version ?? 2))
			// initGL already showed error
			return null;

		this.initShaders(fragment, vertex).then(() => {
			this.initBuf(buffers);
			this.initResizeDraw();
			this.render();
		});

		// initShaders already showed error
		if (!this.prog)
			return null;
	}

	binaryWrap(x) {
		if (x >= 0 && x <= 1)
			return this.#U32[0] = x;

		// write float into register 0
		this.#F32[0] = x;

		// scramble bits in-place using U32 view
		this.#U32[0] = (this.#U32[0] * 1664525 + 1013904223) >>> 0;

		// mask to mantissa only (safe)
		this.#U32[0] &= 0x007FFFFF;

		// now reinterpret as float32
		// but this float is in [0 .. 2^-126 .. 1)
		// so normalize to 0..1 using mantissa range
		return this.#U32[0] = this.#U32[0] * (1 / (1 << 23));
	}


	// ---------- core helpers ----------
	createShader(type, source) {
		const s = this.gl.createShader(type);
		this.gl.shaderSource(s, source);
		this.gl.compileShader(s);
		if (!this.gl.getShaderParameter(s, this.gl.COMPILE_STATUS)) {
			console.error(this.gl.getShaderInfoLog(s));
			this.gl.deleteShader(s);
			return null;
		}
		return s;
	}

	createProgram(vShader, fShader) {
		const p = this.gl.createProgram();
		this.gl.attachShader(p, vShader);
		this.gl.attachShader(p, fShader);
		this.gl.linkProgram(p);

		console.log(this.gl.getProgramInfoLog(p));

		if (!this.gl.getProgramParameter(p, this.gl.LINK_STATUS)) {
			console.error(this.gl.getProgramInfoLog(p));
			this.gl.deleteProgram(p);
			return null;
		}
		return p;
	}

	// ---------- canvas + GL ----------

	initCanvas(node) {
		this.node = node;
		this.cvs = document.createElement("canvas");
		this.ocvs = new OffscreenCanvas(0, 0);
		this.node.appendChild(this.cvs);
	}

	initGL(version = 2) {
		// #U8[2] used as a tiny counter / state
		this.#U8[2] = version;

		while (this.#U8[2] > 0) {
			let ctxName = (this.#U8[2] === 1) ? "webgl" : "webgl2";
			this.gl = this.cvs.getContext(ctxName);
			if (this.gl) {
				this.#U8[20] = this.#U8[2];
				return true;
			}
			this.#U8[2]--;
		}

		// no WebGL at all
		return this.showShaderError("WEBGL NOT SUPPORTED");
	}

	// ---------- shaders ----------

	async #fallbackShaders(type, source) {
		if (! type)
			return source[this.#U16[2]];

		// If type is a URL, load it
		if (typeof type === "string" && type.endsWith(source[0]))
			type = await this.nxinc.load(type);

		// Only inject #version for WebGL2 AND only if missing
		if (this.#U16[2] === 300 && ! /^\s*#version /.test(type))
			type = `#version 300 es\n${type}`;
		return type;
	}

	async initShaders(frag, vert) {
		this.#U16[2]  = this.ver === 1 ? 100 : 300;
		this.frag = await this.#fallbackShaders(frag, FRAGMENT);
		this.vert = await this.#fallbackShaders(vert, VERTEX);

		const v = this.createShader(this.gl.VERTEX_SHADER, this.vert);
		if (!v)
			return this.showShaderError("404 VERTEX SHADER NOT FOUND");

		const f = this.createShader(this.gl.FRAGMENT_SHADER, this.frag);
		if (!f)
			return this.showShaderError("404 FRAGMENT SHADER NOT FOUND");

		this.prog = this.createProgram(v, f);
		if (!this.prog)
			return this.showShaderError("SHADER LINK FAILED");

		this.gl.useProgram(this.prog);
	}
	// ---------- buffers ----------

	bindBuf(
		buffer,
		data,
		{
			size,
			type,
			normalize,
			stride,
			offset,
			shape,
			vao
		} = [
			2,
			'FLOAT',
			false,
			0,
			0,
			true,
			'TRIANGLES',
			null
		]
	) {
		// 1. Create buffer
		this.#U32[0] = data.length;
		this.#U32[3] = size ?? 2;
		while ((this.#U32[0] % this.#U32[3]) !== 0) {
			data.push(0);
			this.#U32[0]++
		}

		const glBuffer = this.gl.createBuffer();
		this.gl.bindBuffer(
			this.gl.ARRAY_BUFFER,
			glBuffer
		);
		this.gl.bufferData(
			this.gl.ARRAY_BUFFER,
			new Float32Array(data),
			this.gl.STATIC_DRAW
		);

		// determine VAO name
		vao ??= buffer;

		// create or reuse VAO
		let vaoInfo = this.#buffers.get(vao);
		if (!vaoInfo) {
			vaoInfo = {
				vao: this.gl.createVertexArray(),
				count: this.#U32[0] / this.#U32[3],
				shape: shape ?? 'TRIANGLES'
			};
			this.#buffers.set(vao, vaoInfo);
		}

		// 2. Create VAO
		vao = vaoInfo.vao;
		this.gl.bindVertexArray(vao);

		// 3. Bind attribute
		const loc = this.gl.getAttribLocation(this.prog, buffer);
		if (loc !== -1) {
			this.gl.enableVertexAttribArray(loc);
			this.#U32[1] = stride;
			this.#U32[2] = offset;

			// 4) Enable and describe the attribute
			this.gl.vertexAttribPointer(
				loc,			// attribute location
				this.#U32[3],		// components per vertex (x, y)
				this.gl[type ?? 'FLOAT'],	// type
				normalize === true,	// normalize
				this.#U32[1],		// stride (0 = tightly packed)
				this.#U32[2]		// offset
			);

		}

		this.gl.bindVertexArray(null);
	}

	initBuf(bufs) {
		Object.entries(bufs).forEach(([name, opt]) => {
			this.bindBuf(
				name,		// attribute name
				opt.vertex,	// vertex array
				{		// options object
					size: opt.size,
					type: opt.type,
					normalize: opt.normalize,
					stride: opt.stride,
					offset: opt.offset,
					shape: opt.shape,
					vao: opt.vao
				}
			);
		});
	}

	// ---------- resize + draw ----------
	initResizeDraw() {
		this.ro = new ResizeObserver(() => this.resize('draw'));
		this.ro.observe(this.node);
		this.resize('draw');
	}

	initResizeError() {
		this.ro = new ResizeObserver(e => this.resize('drawError'));
		this.ro.observe(this.node);
		this.resize('drawError');
	}

	resize(draw) {
		const rect = this.node.getBoundingClientRect();

		// if layout isn't ready yet, try again next frame
		if (!rect.width || !rect.height) {
			requestAnimationFrame(() => this.resize(draw));
			return;
		}

		this.#F32[21] = rect.width;
		this.#F32[22] = rect.height;
		this.#F32[23] = this.#F32[21] / this.#F32[22];
		if (!this.#pendingResize) {
			this.#pendingResize = true;
			requestAnimationFrame(() => {
				this.#pendingResize = false;
				this.cvs.width	= this.#F32[21];
				this.cvs.height = this.#F32[22];
				this[draw]();
			});
		}
	}

	draw() {
		this.gl.viewport(this.#F32[12], this.#F32[14], this.#F32[21], this.#F32[22]);
		this.gl.clearColor(this.#F32[15], this.#F32[16], this.#F32[17], this.#F32[18]);
		this.gl.clear(this.gl.COLOR_BUFFER_BIT);

		this.gl.useProgram(this.prog);
		this.updateUniforms();

		for (const { vao, count, shape } of this.#buffers.values()) {
			this.gl.bindVertexArray(vao);
			this.gl.drawArrays(this.gl[shape], 0, count);
		}

		this.gl.bindVertexArray(null);
	}

	spawnRandomTriangle() {
		const id = "tri_" + Math.random().toString(36).slice(2);

		const x = Math.random() * 2 - 1;
		const y = Math.random() * 2 - 1;
		const s = 0.1 + Math.random() * 0.2;

		const verts = [
			x, y,
			x + s, y,
			x, y + s
		];

		const cols = [
			Math.random(), Math.random(), Math.random(),
			Math.random(), Math.random(), Math.random(),
			Math.random(), Math.random(), Math.random()
		];

		this.bindBuf("a_position", verts, { vao: id, size: 2, shape: "TRIANGLES" });
		this.bindBuf("a_color", cols, { vao: id, size: 3 });
	}

	// ---------- error path (2D canvas) ----------
	showShaderError(msg) {
		// swap to 2D context for error rendering
		this.gl = this.cvs.getContext("2d");
		this.msg = msg;
		this.initResizeError();
		return false;
	}

	drawError() {
		if (!this.gl)
			return null; // prevent crash

		this.resize();
		this.gl.fillStyle = "black";
		this.gl.fillRect(0, 0, this.cvs.width, this.cvs.height);

		this.gl.fillStyle = "red";
		this.gl.font = "24px monospace";
		this.gl.textAlign = "center";
		this.gl.textBaseline = "middle";
		this.gl.fillText(this.msg, this.cvs.width / 2, this.cvs.height / 2);
	}

	mouseMove() {
		this.cvs.addEventListener("mousemove", e => {
			const rect = this.cvs.getBoundingClientRect();
			this.#F32[11] = e.clientX - rect.left;
			this.#F32[13] = rect.height - (e.clientY - rect.top); // flip Y
		});
	}

	render() {
		this.gl.useProgram(this.prog);
		this.updateUniforms();
		this.gl.bindVertexArray(this.vao);
		this.gl.drawArrays(this.gl.TRIANGLES, 0, 3);
		this.gl.bindVertexArray(null);
	}

	initUniforms() {
		// Time uniform
		this.u_time = this.gl.getUniformLocation(this.prog, "u_time");

		// Resolution uniform
		this.u_resolution = this.gl.getUniformLocation(this.prog, "u_resolution");

		// Mouse uniform
		this.u_mouse = this.gl.getUniformLocation(this.prog, "u_mouse");

		this.u_seed = this.gl.getUniformLocation(this.prog, "u_seed");
	}

	updateUniforms() {
		// Time
		this.gl.uniform1f(this.u_time, performance.now() * 0.001);

		// Resolution
		this.gl.uniform2f(this.u_resolution, this.cvs.width, this.cvs.height);

		// Mouse
		this.gl.uniform2f(this.u_mouse, this.#F32[11], this.#F32[13]);

		this.gl.uniform1f(this.u_seed, this.#S32[10]);
	}
}

