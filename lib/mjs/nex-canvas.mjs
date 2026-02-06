
class NxCanvasEngine
{
	static #wm = new WeakMap();
	constructor(par) {
		const el = document.createElement('canvas');
		if (par instanceof Element)
			par.appendChild(el);
		else
			document.body.appendChild(el);

		const wm = new WeakMap();
		const layerSym = Symbol('layers');
		const ctxSym = Symbol('ctx');
		const entSym = Symbol('ent');
		const curlSym = Symbol('currentLayer');

		const obj = {
			[layerSym]: [],
			[ctxSym]: el.getContext('2d')
		};

		wm.set(el,[ layerSym, ctxSym, curSym ]);
		NxCanvasEngine.#wm.set(this, [el, wm, obj]);
	}
	
	get engine() {
		return NxCanvasEngine.#wm.get(this);
	}

	get canvas() {
		return this.engine[0];
	}

	get #symbols() {
		return this.engine[1].get(this.canvas);
	}

	get #obj() {
		return this.engine[2];
	}

	get layers() {
		return this.#obj[this.#symbols[0]];
	}

	addLayer(layer) {
		this.#obj[this.#symbols[0]].push(layer);
	}

	get context() {
		return this.#obj[this.#symbols[1]];
	}

	get width() {
		return this.canvas.width;
	}

	get height() {
		return this.canvas.height;
	}

	getRandomNumber(min, max) {
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}

	resetX(start = 0) {
		return this.getRandomNumber(start, this.width);
	}

	resetY(start = 0) {
		return this.getRandomNumber(start, this.height);
	}

	#moveFrame(obj) {
		obj.x += obj.xDirection;
		obj.y += obj.yDirection;
		if (obj.x <= 0 || obj.x + obj.width >= this.width)
			obj.xDirection *= -1;
		if (obj.y <= 0 || obj.y + obj.height >= this.height)
			obj.yDirection *= -1;
	}
}

class NxCanvasLayers {
	constructor(engine, name = "layer") {
		this.engine = engine;
		this.name = name;
		this.items = [];
		engine.addLayer(this);

	}

	add(drawable) {
		this.items.push(drawable);
		this.engine.registerEntity(drawable);
	}

	registerEntity(entity) {
		this.#obj[this.#symbols[2]].add(entity);
	}

	get entities() {
		return this.#obj[this.#symbols[2]];
	}

	draw(ctx) {
		for (const item of this.items) {
			item.draw?.(ctx);
		}
	}
}

class NxCanvasRectangles {
	constructor(engine, x, y, w, h, color = "red") {
		this.engine = engine;
		this.coords = new Float64Array(4);
		this.coords[0] = x;
		this.coords[1] = y;
		this.coords[2] = w;
		this.coords[3] = h;
		this.color = color;
		engine.registerEntity(this);
	}

	draw() {
		const ctx = this.engine.context;
		ctx.fillStyle = this.color;
		ctx.fillRect(this.coords[0], this.coords[1], this.coords[2], this.coords[3]);
	}
}

/*
class NxCanvasLayers
{

}

class NxCanvasAnimations
{

}

class NxCanvasRectangles
{

}

class NxCanvasGradients
{

}

class NxCanvasEvents
{

}

class NxCanvasPolygons
{

}

class NxCanvasCircles
{

}

class NxCanvasImages
{

}
*/


	/*
	
	class NxCanvas {

	static #wm = new WeakMap();

	constructor() {
		const el = document.createElement('canvas');
		document.body.appendChild(el);
		el.classList.add('nex-canvas');
		this.canvas = Symbol('canvas');
		this.ctx = Symbol('ctx');
		this[this.canvas] = el;
		this[this.ctx] = el.getContext('2d');

		this.img = "data:image/svg+xml;base64," + btoa(` <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64"> <rect width="64" height="64" fill="blue"/> </svg> `);

		NxCanvas.#wm.set(this, new WeakMap());
	}

	getWidth(offset = 0) {
		return this[this.canvas].width - offset;
	}

	getHeight(offset = 0) {
		return this[this.canvas].height - offset;
	}

	getRandomNumber(min, max) {
		return Math.floor(Math.random() * (max - min + 1)) + min;
	}

	resetX(start = 0) {
		return this.getRandomNumber(start, this.getWidth());
	}

	resetY(start = 0) {
		return this.getRandomNumber(start, this.getHeight());
	}


addFrame() {
	const prop = {
	x: this.resetX(),
	y: this.resetY(),
	width: 64,
	height: 64,
	xDirection: Math.random() < 0.5 ? -1 : 1,
	yDirection: Math.random() < 0.5 ? -1 : 1,
	ready: false,
	img: null
	};

	// Load initial image ONCE
	this.replaceImage(prop, `
	<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64">
		<rect width="64" height="64" fill="blue"/>
	</svg>
	`);

	NxCanvas.#wm.get(this).set(prop, prop);
	this.#startAnimation(prop);

	// ⭐ THIS IS WHERE YOU CALL replaceImage() ⭐
	// Example: replace after 2 seconds
	let i = 1
	setTimeout(() => {
		i += 1000;
	this.replaceImage(prop, `
		<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64">
		<circle cx="32" cy="32" r="30" fill="#${i}"/>
		</svg>
	`);
	}, 200);

	return this;
}

	#startAnimation(obj) {
		const animate = () => {
		this.#moveFrame(obj);
		this.#drawFrame(obj);
		requestAnimationFrame(animate);
		};
		requestAnimationFrame(animate);
	}



replaceImage(obj, svgString) {
	const img = new Image();
	img.src = "data:image/svg+xml;base64," + btoa(svgString);

	img.onload = () => {
	obj.img = img;	 // atomic replacement
	obj.ready = true;
	};

	obj.ready = false; // pause drawing until loaded
}



#drawFrame(obj) {
	const ctx = this[this.ctx];

	// If no image yet, load it once
	if (!obj.img) {
	const img = new Image();
	img.src = this.img;

	img.onload = () => {
		obj.img = img;
		obj.ready = true;
	};

	obj.ready = false;
	return;
	}
	// Only draw when ready
	if (obj.ready) {
	ctx.drawImage(obj.img, obj.x, obj.y, obj.width, obj.height);
	}
}

	 }



	class NxDivCanvas {

		static #wm = new WeakMap();
		constructor(){
			const el = document.createElement('div');
			document.body.appendChild(el);
			el.classList.add('nex-canvas');
			this.canvas = Symbol('canvas');
			this[this.canvas] = el
			NxDivCanvas.#wm.set(this[this.canvas], {[this.canvas]: new WeakMap()});
		}

		getRandomNumber(min, max) {
			return Math.floor(Math.random() * (max - min + 1) ) + min;
		}

		getHeight(offset = 25) {
			return this[this.canvas].clientHeight - offset;
		}

		getWidth(offset = 25){
			return this[this.canvas].clientWidth - offset;
		}

		resetX(start = 48) {
			return this.getRandomNumber(start, this.getWidth());
		}

		resetY(start = 48) {
			return this.getRandomNumber(start, this.getHeight());
		}

		startFrame(frm, obj, interval = 20) {
			setInterval(() => {this.#moveFrame(frm, obj)}, interval);
		}

		addFrame() {
			const el = document.createElement("div");
			const prop = {};
			el.classList.add('nex-canvas-item');

			prop.x = this.resetX();
			prop.y = this.resetY();
			prop.xDirection = (prop.x & 1) == 0 ? -1 : 1;
			prop.yDirection = (prop.y & 1) == 0 ? -1 : 1;
			el.style.top = `${prop.x}px`;
			el.style.left = `${prop.y}px`;
			el.style.height = '64px';
			el.style.width = '64px';
			this[this.canvas].appendChild(el);
			NxDivCanvas.#wm.get(this[this.canvas])[this.canvas].set(el, prop);
			this.startFrame(el, prop);
			return this;
		}

		get getY() {
			return this.resetY();
		}

		get getX() {
			return this.resetX();
		}

		#moveFrame(frm, obj) {
			obj.x = obj.x + obj.xDirection;
			obj.y = obj.y + obj.yDirection;

			if (obj.x >= this.getWidth())
				obj.xDirection = -1;

			if (obj.x <= 0) {
				obj.xDirection = 1;
				obj.x = 1;
			}

			if (obj.x < 0 || obj.x > this.getWidth())
				obj.x = this.getX;

			if (obj.y >= this.getHeight())
				obj.yDirection = -1;

			if (obj.y <= 0)
				obj.yDirection = 1;

			if (obj.y < 0 || obj.y > this.getHeight())
				obj.y = this.getY;

			frm.style.left = obj.x + 'px';
			frm.style.top = obj.y + 'px';
		}
	}

	const frm = new NxDivCanvas();
	frm.addFrame();
	*/

