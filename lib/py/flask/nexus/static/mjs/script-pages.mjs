	let page = navbar.addPage({
		plant: {
			innerText: '⭐'
		}
	});
	page.twig.innerHTML = `
	  <div class="nx-accordion">
	  <details class="nx-accordion-body">
		<summary class="nx-nabla">Epcot Center</summary>
		  <p>Epcot is a theme park at Walt Disney World Resort featuring exciting attractions, international pavilions, award-winning fireworks and seasonal special events.</p>
	  </details>
	  <details class="nx-accordion-body">
		<summary class="nx-nabla">Epcot Center</summary>
		  <p>Epcot is a theme park at Walt Disney World Resort featuring exciting attractions, international pavilions, award-winning fireworks and seasonal special events.</p>
	  </details>
	  <details class="nx-accordion-body">
		<summary class="nx-nabla">Epcot Center</summary>
		  <p>Epcot is a theme park at Walt Disney World Resort featuring exciting attractions, international pavilions, award-winning fireworks and seasonal special events.</p>
	  </details>
	  </div>
	`;

	page = navbar.addPage({
		plant: {
			innerText: 'b'
		}
	});

	page.twig.appendChild(
		new NxForm("Offering to the Constructs")
		.addFields("color", {
			type: "color",
			label: "Colour"
		})
		.addFields("password", {
			type: "password",
			label: "Password"
		})
		.addFields("time", {
			type: "time",
			label: "time"
		})
		.addFields("datetime-local", {
			type: "datetime-local",
			label: "Datetime Local"
		})
		.addFields("week", {
			type: "week",
			label: "Week"
		})
		.addFields("month", {
			type: "month",
			label: "Month"
		})
		.addFields("url", {
			type: "url",
			label: "URL"
		})
		.addFields("file", {
			type: "file",
			label: "File"
		})
		.addFields("date", {
			type: "date",
			label: "Date"
		})
		.addFields("firstName", {
			type: "text",
			label: "First Name",
			required: true
		})
		.addFields("lastName", {
			type: "text",
			label: "Last Name",
			required: true
		})
		.addFields("phone", {
			type: "tel",
			label: "Phone Number",
			pattern: "[0-9]{10}",
			required: true
		})
		.addFields("email", {
			type: "email",
			label: "Email",
			pattern: "^[A-Za-z0-9._%+-]+@[a-zA-Z]+\\.[a-zA-Z]+$",
			required: true })
		.addFields("address", {
			type: "text",
			label: "Address",
			required: true
		})
		.addFields("zeroReference", {
			type: "text",
			label: "Zero Reference (Anchor)",
			placeholder: "Name the anchor point of your offering",
			required: true
		})
		.addFields("boundaryContext", {
			type: "textarea",
			label: "∅ - Boundary Description",
			placeholder: "Describe the container of absence framing this offering",
			required: true
		})
		.addFields("offeringType", {
			type: "select",
			label: "Offering Type",
			required: true,
			options: [
				{ value: "", label: "Select an offering…" },
				{ value: "fruit", label: "Fruit" },
				{ value: "incense", label: "Incense" },
				{ value: "metal", label: "Metal Shavings" },
				{ value: "water", label: "Purified Water" },
				{ value: "bread", label: "Bread / Grain" },
				{ value: "stone", label: "Stone" },
				{ value: "light", label: "Light (Candle / LED)" },
				{ value: "code", label: "Code Snippet" },
				{ value: "silence", label: "A Moment of Silence" }
			]
		})
		.addFields("comments", {
			type: "textarea",
			label: "Comments",
			required: true
		})
		.addFields("recipient", {
			type: "radio",
			label: "Zero - The Anchor",
			value: "zero",
			required: true
		})
		.addFields("recipient", {
			type: "radio",
			label: "∅ - The Empty Set",
			value: "empty-set",
			required: true
		})
		.addFields("recipient", {
			type: "radio",
			label: "Entropy - The Divergence Pressure",
			value: "entropy",
			required: true
		})
		.addFields("recipient", {
			type: "radio",
			label: "Nothing - The Unreferred Outside",
			value: "nothing",
			required: true
		})
		.addFields("offering_fruit", {
			type: "checkbox",
			label: "Fruit - ordered matter collapsing inward"
		})
		.addFields("offering_incense", {
			type: "checkbox",
			label: "Incense - diffusion into the void"
		})
		.addFields("offering_metal", {
			type: "checkbox",
			label: "Metal Shavings - fractured symmetry"
		})
		.addFields("offering_water", {
			type: "checkbox",
			label: "Purified Water - smoothing of gradients"
		})
		.addFields("offering_stone", {
			type: "checkbox",
			label: "Stone - inert witness"
		})
		.addFields("offering_light", {
			type: "checkbox",
			label: "Light - oscillation on the imaginary axis"
		})
		.addFields("offering_code", {
			type: "checkbox",
			label: "Code Snippet - recursive self-reference"
		})
		.addFields("offering_silence", {
			type: "checkbox",
			label: "Silence - unvoiced boundary"
		})
		.addFields("nothingField", {
			type: "text",
			label: "Nothing",
			placeholder: "Cannot be filled - Nothing cannot be referred to",
			disabled: true
		})
		.addFields("intent", {
			type: "textarea",
			label: "Intent - Explain the Offering",
			placeholder: "Describe the divergence, the anchor, and the boundary.",
			required: true
		})
		.addFields("reset", {
			type: "reset",
			label: "Reset"
		})
		.addFields("submit", {
			type: "submit",
			label: "Submit Offering"
		}).mailTo(
			'stro0123@algonquinlive.com',
			'Offering Submission',
			'entropy@origin.null',
			'zero@empty.set'
		).form
	);

	/*
	page = navbar.addPage({
		plant: {
			innerText: 'c'
		}
	});
	page.twig.innerHTML = `
		<div class="nx-card">
			<img class="nx-img-top" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-0.jpeg') }}"/>
			<div class="nx-header">
				Aureth, the Ember Archivist
			</div>
			<div class="nx-main">
				A keeper of extinguished timelines, Aureth gathers the final sparks of forgotten worlds. Each ember held in its wings is a memory that refused to die. Offerings made here are transmuted into preserved echoes.
			</div>
			<div class="nx-footer">
				Offer an Ember
			</div>
			<img class="nx-img-bottom" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-1.jpeg') }}"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-2.jpeg') }}"/>
			<div class="nx-header">
				Veyla, the Circuit Seer
			</div>
			<div class="nx-main">
				Veyla reads the branching futures encoded in luminous circuitry. Her feathers hum with unresolved probability. Those who seek clarity bring her fragments of uncertainty to be rendered into pattern.
			</div>
			<div class="nx-footer">
				Reveal the Pattern
			</div>
			<img class="nx-img-bottom" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-3.jpeg') }}"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-4.jpeg') }}"/>
			<div class="nx-header">
				Solkara, the Phoenix of Returning Paths
			</div>
			<div class="nx-main">
				Solkara governs cycles of departure and return. Every flame she sheds becomes a doorway back to something once lost. Offerings placed here are carried through the fire and returned transformed.
			</div>
			<div class="nx-footer">
				Open the Passage
			</div>
			<img class="nx-img-bottom" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-5.jpeg') }}"/>
		</div>
	`;
	
	page = navbar.addPage({
		plant: {
			innerText: 'v'
		}
	});

	const cvs = document.createElement('canvas');
	cvs.className = 'nx-gl-canvas';
	page.appendChild(cvs);
	const gl = cvs.getContext("webgl");

	const vertexSrc = `
	attribute vec2 a_position;
	void main() {
	  gl_Position = vec4(a_position, 0.0, 1.0);
	}
	`;

	const fragmentSrc = `
	precision mediump float;
	void main() {
	  gl_FragColor = vec4(0.2, 0.8, 0.3, 1.0); // green-ish
	}
	`;


	const vShader = createShader(gl, gl.VERTEX_SHADER, vertexSrc);
	const fShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentSrc);

	const program = gl.createProgram();
	gl.attachShader(program, vShader);
	gl.attachShader(program, fShader);
	gl.linkProgram(program);
	if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
	  console.error(gl.getProgramInfoLog(program));
	}
	gl.useProgram(program);

	const vertices = new Float32Array([
	  0.0,  0.8,   // top
	 -0.8, -0.8,   // bottom left
	  0.8, -0.8    // bottom right
	]);

	const buffer = gl.createBuffer();

	const posLoc = gl.getAttribLocation(program, 'a_position');
	const ro = new ResizeObserver(e => {
		for (const es of e) {
			const { width, height } = es.contentRect;
			cvs.height = width;
			cvs.width = height;
	gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
	gl.bufferData(gl.ARRAY_BUFFER, vertices, gl.STATIC_DRAW);
	gl.enableVertexAttribArray(posLoc);
	gl.vertexAttribPointer(
	  posLoc,
	  2,            // components per vertex (x, y)
	  gl.FLOAT,
	  false,
	  0,
	  0
	);


			gl.viewport(0, 0, cvs.width, cvs.height);
			gl.clearColor(0.0, 0.0, 0.0, 1.0);
			gl.clear(gl.COLOR_BUFFER_BIT);
			gl.drawArrays(gl.TRIANGLES, 0, 3);
		}
	});

	ro.observe(page.twig.parentElement);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	*/
	page = navbar.addPage({
		plant: {
			innerText: '⚙️'
		}
	});
	/*const nd = NxFragment.Batch({
		twig: 'div',
		leaf: [
		"hello",
		" world"
	]})*/
	page.twig.innerHTML = `
                <div class="nx-card">
                        <img class="nx-img-top" src="img/img/posix-nexus-image-0.jpeg"/>
                        <div class="nx-header">
                                Aureth, the Ember Archivist
                        </div>
                        <div class="nx-main">
                                A keeper of extinguished timelines, Aureth gathers the final sparks of forgotten worlds. Each ember held in its wings is a memory that refused to die. Offerings made here are transmuted into preserved echoes.
                        </div>
                        <div class="nx-footer">
                                Offer an Ember
                        </div>
                        <img class="nx-img-bottom" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-1.jpeg') }}"/>
                </div>
                <div class="nx-card">
                        <img class="nx-img-top" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-2.jpeg') }}"/>
                        <div class="nx-header">
                                Veyla, the Circuit Seer
                        </div>
                        <div class="nx-main">
                                Veyla reads the branching futures encoded in luminous circuitry. Her feathers hum with unresolved probability. Those who seek clarity bring her fragments of uncertainty to be rendered into pattern.
                        </div>
                        <div class="nx-footer">
                                Reveal the Pattern
                        </div>
                        <img class="nx-img-bottom" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-3.jpeg') }}"/>
                </div>
                <div class="nx-card">
                        <img class="nx-img-top" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-4.jpeg') }}"/>
                        <div class="nx-header">
                                Solkara, the Phoenix of Returning Paths
                        </div>
                        <div class="nx-main">
                                Solkara governs cycles of departure and return. Every flame she sheds becomes a doorway back to something once lost. Offerings placed here are carried through the fire and returned transformed.
                        </div>
                        <div class="nx-footer">
                                Open the Passage
                        </div>
                        <img class="nx-img-bottom" src="{{ url_for('nexus.static', filename='img/img/posix-nexus-image-5.jpeg') }}"/>
                </div>`

/*

	page.appendChild(NxFragment.Batch([
	{
		twig: 'div',
		leaf: [
			{ twig: 'div', leaf: 'A' },
			{ twig: 'div', leaf: 'B' },
			{ twig: 'div', leaf: 'C' }
		]
	},
	{
		twig: 'div',
		leaf: 'X'
	},
	{
		twig: 'div',
		leaf: [
			{ twig: 'div', leaf: 'Y1' },
			{ twig: 'div', leaf: 'Y2' },
			{ twig: 'div', leaf: 'Y3' }
		]
	},
	{
		twig: 'div',
		leaf: 'Y'
	},
	{
		twig: 'div',
		leaf: [
			{ twig: 'div', leaf: [ 'Z1', 'a', 'b', 'c', 'd' ] },
			{ twig: 'div', leaf: 'Z2' },
			{ twig: 'div', leaf: 'Z3' }
		]
	},
	{
		twig: '<>',
		leaf: [
			'textsasd',
			{
				twig: 'div',
				leaf: [
					'div',
					' some text',
					' and more text text',
					{
						'twig': '!--',
						leaf: [
							'hello',
							' world'
						]
					},
					{
						'twig': '<>',
						'leaf': [
							'once upon a time more text text',
							' in a far away land',
							' a text node ended',
							' the end'
						]
					}
				]
			}
		],
	},
	{
		twig: '!--',
		leaf: {
			twig: 'div',
			leaf: [
				'comment',
				'comment',
				'comment',
				'comment',
				'comment',
				{
					'twig': 'div',
					'leaf': {
						'twig': '<>',
						leaf: [
							'another',
							' long ',
							'long',
							' long ',
							'example',
							' the end'
						]
					}
				}
			]
		}
	},
	{
		"twig": "div",
		"leaf": [
			"A has no twig, so leaf is just a text node",
			{"twig":"br"},
			{
				"twig": "div",
				"leaf": {
					twig: 'div',
					leaf: "B this is a comment node special case twig"
				}
			},
			{"twig":"br"},
			"C hello nested and useless json world!!!"
		]
	},
	{
		twig: 'div',
		leaf: [
			"D hello nested and useless json world!!!",
			{"twig":"br"},
			"E hello nested and useless json world!!!",
			{"twig":"br"},
			{
				"twig": "!--",
				"leaf": "F this is a comment node special case twig"
			},
			"G hello nested and useless json world!!!",
			{
				'twig': '<>',
				'leaf': [
					'ahaa',
					' ahaa',
					' ahaa',
				]
			},
			{"twig":"br"},
			"H hello nested and useless json world!!!",
			{"twig":"br"},
			{
				"twig": "!--",
				"leaf": "I this is a comment node special case twig"
			}
		]
	}
	]));
*/
