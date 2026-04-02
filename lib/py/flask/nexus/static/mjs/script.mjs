/*import { NxNav } from "./mjs/nex-nav.mjs"
import { nxObj } from "./mjs/nex-obj.mjs"
import { NxCSSOM } from "./mjs/nex-css.mjs"
import { NxForm } from "./mjs/nex-form.mjs"
*/

//import { NxElement } from "./mjs/nex-element.mjs"
import { NxFragment } from "./mjs/nex-fragment.mjs"
import { NxSlab } from "./mjs/nex-vm.mjs"
import { nxBit32 } from "./mjs/nex-bit32.mjs"

import { NxForm } from "./mjs/nex-form.mjs"
import { NxNav } from "./mjs/nex-nav.mjs"
import { NxDom } from "./mjs/nex-dom.mjs"



document.addEventListener('DOMContentLoaded', () => {

	const navbar = new NxNav(
		document.querySelector('body > div.nx-page > nav.nx-nav'),
		document.querySelector('body > div.nx-page > main.nx-main'),
		document.querySelector('body > div.nx-page > header.nx-header')
	);

	/*
	const slab = new NxSlab();

	const a = slab.alloc;
	const b = slab.alloc;
	const c = slab.alloc;
	const d = slab.alloc;
	const e = slab.alloc;
	slab.i32[b] = -a;
	slab.i32[b + 1] = c;
	slab.i32[a + 1] = -b;
	slab.i32[c] = b;

	//slab.modifier(0,0,0,0,0)
	//slab.i32[c + 1] = d;
	//slab.i32[a] = d;
	//slab.reclaim(b);

	slab.enforce(b);
//	console.log(slab.i32);
*/


	const dom = NxDom.Batch([
		'a', 'b', [
			'c', 'd', 'e', [
				'hello', 'world'
			], 'g', 'h', 'i', 'j'
		], 'k', 'l', 'm'
	]);

	/*

	console.log(navbar)
	let page = navbar.addpage({
		plant: {
			innertext: '⚙️'
		}
	});

	const nd = NxFragment.Batch([{
		twig: 'div',
		leaf: [
			"hello",
			{
				twig: 'div',
				leaf: 'hi'
			},
			" world",
			{
				twig: 'div',
				leaf: 'hi'
			}
		]
	}])
	page.twig.appendChild(nd);

	
	page.twig.innerHTML = `
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-0.jpeg"/>
			<div class="nx-header">
				Aureth, the Ember Archivist
			</div>
			<div class="nx-main">
				A keeper of extinguished timelines, Aureth gathers the final sparks of forgotten worlds. Each ember held in its wings is a memory that refused to die. Offerings made here are transmuted into preserved echoes.
			</div>
			<div class="nx-footer">
				Offer an Ember
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-1.jpeg"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-2.jpeg"/>
			<div class="nx-header">
				Veyla, the Circuit Seer
			</div>
			<div class="nx-main">
				Veyla reads the branching futures encoded in luminous circuitry. Her feathers hum with unresolved probability. Those who seek clarity bring her fragments of uncertainty to be rendered into pattern.
			</div>
			<div class="nx-footer">
				Reveal the Pattern
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-3.jpeg"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-4.jpeg"/>
			<div class="nx-header">
				Solkara, the Phoenix of Returning Paths
			</div>
			<div class="nx-main">
				Solkara governs cycles of departure and return. Every flame she sheds becomes a doorway back to something once lost. Offerings placed here are carried through the fire and returned transformed.
			</div>
			<div class="nx-footer">
				Open the Passage
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-5.jpeg"/>
		</div>`



	page = navbar.addPage({
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






	page.twig.innerHTML = `
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-0.jpeg"/>
			<div class="nx-header">
				Aureth, the Ember Archivist
			</div>
			<div class="nx-main">
				A keeper of extinguished timelines, Aureth gathers the final sparks of forgotten worlds. Each ember held in its wings is a memory that refused to die. Offerings made here are transmuted into preserved echoes.
			</div>
			<div class="nx-footer">
				Offer an Ember
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-1.jpeg"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-2.jpeg"/>
			<div class="nx-header">
				Veyla, the Circuit Seer
			</div>
			<div class="nx-main">
				Veyla reads the branching futures encoded in luminous circuitry. Her feathers hum with unresolved probability. Those who seek clarity bring her fragments of uncertainty to be rendered into pattern.
			</div>
			<div class="nx-footer">
				Reveal the Pattern
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-3.jpeg"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-4.jpeg"/>
			<div class="nx-header">
				Solkara, the Phoenix of Returning Paths
			</div>
			<div class="nx-main">
				Solkara governs cycles of departure and return. Every flame she sheds becomes a doorway back to something once lost. Offerings placed here are carried through the fire and returned transformed.
			</div>
			<div class="nx-footer">
				Open the Passage
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-5.jpeg"/>
		</div>`



	page = navbar.addPage({
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









	page.twig.innerHTML = `
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-0.jpeg"/>
			<div class="nx-header">
				Aureth, the Ember Archivist
			</div>
			<div class="nx-main">
				A keeper of extinguished timelines, Aureth gathers the final sparks of forgotten worlds. Each ember held in its wings is a memory that refused to die. Offerings made here are transmuted into preserved echoes.
			</div>
			<div class="nx-footer">
				Offer an Ember
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-1.jpeg"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-2.jpeg"/>
			<div class="nx-header">
				Veyla, the Circuit Seer
			</div>
			<div class="nx-main">
				Veyla reads the branching futures encoded in luminous circuitry. Her feathers hum with unresolved probability. Those who seek clarity bring her fragments of uncertainty to be rendered into pattern.
			</div>
			<div class="nx-footer">
				Reveal the Pattern
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-3.jpeg"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-4.jpeg"/>
			<div class="nx-header">
				Solkara, the Phoenix of Returning Paths
			</div>
			<div class="nx-main">
				Solkara governs cycles of departure and return. Every flame she sheds becomes a doorway back to something once lost. Offerings placed here are carried through the fire and returned transformed.
			</div>
			<div class="nx-footer">
				Open the Passage
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-5.jpeg"/>
		</div>`



	page = navbar.addPage({
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











	page.twig.innerHTML = `
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-0.jpeg"/>
			<div class="nx-header">
				Aureth, the Ember Archivist
			</div>
			<div class="nx-main">
				A keeper of extinguished timelines, Aureth gathers the final sparks of forgotten worlds. Each ember held in its wings is a memory that refused to die. Offerings made here are transmuted into preserved echoes.
			</div>
			<div class="nx-footer">
				Offer an Ember
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-1.jpeg"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-2.jpeg"/>
			<div class="nx-header">
				Veyla, the Circuit Seer
			</div>
			<div class="nx-main">
				Veyla reads the branching futures encoded in luminous circuitry. Her feathers hum with unresolved probability. Those who seek clarity bring her fragments of uncertainty to be rendered into pattern.
			</div>
			<div class="nx-footer">
				Reveal the Pattern
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-3.jpeg"/>
		</div>
		<div class="nx-card">
			<img class="nx-img-top" src="static/img/posix-nexus-image-4.jpeg"/>
			<div class="nx-header">
				Solkara, the Phoenix of Returning Paths
			</div>
			<div class="nx-main">
				Solkara governs cycles of departure and return. Every flame she sheds becomes a doorway back to something once lost. Offerings placed here are carried through the fire and returned transformed.
			</div>
			<div class="nx-footer">
				Open the Passage
			</div>
			<img class="nx-img-bottom" src="static/img/posix-nexus-image-5.jpeg"/>
		</div>`



	page = navbar.addPage({
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







*/
	/*
	cur = pool.pop(cur);
	cur = pool.pop(cur);
	cur = pool.pop(cur);
	cur = pool.pop(cur);
	cur = pool.pop(cur);
	cur = pool.pop(cur);
	cur = pool.pop(cur);
	cur = pool.pop(cur);
	cur = pool.pop(cur);
	*/
	//console.log(pool, cur)
	//cur = pool.push(cur, 999);

});

