import { NxNav } from "./mjs/nex-nav.mjs"
import { nxObj } from "./mjs/nex-obj.mjs"
import { NxCSSOM } from "./mjs/nex-css.mjs"
import { NxForm } from "./mjs/nex-form.mjs"

async function nxCSSReset() {
	const cache = await caches.open("css-cache");
	const url = "https://meyerweb.com/eric/tools/css/reset/reset.css";
	let response = await cache.match(url);

	if (!response) {
		response = await fetch(url);
		await cache.put(url, response.clone());
	}

	const css = await response.text();

	const sheet = new CSSStyleSheet();
	sheet.replaceSync(css);
	return sheet;
}

//nxDom.doctype('5.0', 'html');
document.addEventListener('DOMContentLoaded', () => {
	document.body.appendChild(
		new NxForm("Offering to the Constructs")
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
			pattern: "[0-9]+",
			required: true
		})
		.addFields("email", {
			type: "email",
			label: "Email",
			pattern: "^[A-Za-z0-9._%+-]+@[a-zA-Z]+\\.[a-zA-Z]+$",
			required: true
		})
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
		}).mailTo().form
	);

	const css = new NxCSSOM();
	[
		`
			body {
				background: black;
				padding: 1rem;
				box-sizing: border-box;
			}
		`,`
			form {
				margin: 0 auto;
				box-sizing: border-box;
				background: #000;
				color: #e0e0e0;
				padding: 2rem;
				border: 1px solid #222;
				max-width: 40rem;
				font-family: "Linux Libertine", serif;
				width: 100%;
				overflow-x: hidden;
			}
		`,`
			fieldset {
				border: 1px solid #333;
				padding: 1.5rem;
				max-width: 100%;
				width: 100%;
				box-sizing: border-box;
				overflow-x: hidden;
			}
		`,`
			legend {
				padding: 0 0.5rem;
				font-size: 1.25rem;
				color: #fff;
				letter-spacing: 0.03em;
			}
		`,`
			label {
				display: flex;
				flex-direction: column;
				gap: 0.25rem;
				margin-bottom: 1rem;
				font-size: 0.95rem;
			}
		`,`
			label input[type=radio] {
				display: flex;
				flex-direction: row-reverse;
				align-items: center;
				gap: 0.5rem;
			}
		`,`
			input[type="text"],
			input[type="tel"],
			input[type="email"],
			textarea,
			select {
				background: #111;
				color: #eee;
				border: 1px solid #333;
				padding: 0.5rem;
				font-size: 1rem;
				font-family: inherit;
			}
		`,`
			textarea {
				width: 100%;
				max-width: 100%;
				box-sizing: border-box;
				resize: vertical;
			}
		`,`
			input[type="radio"],
			input[type="checkbox"] {
				accent-color: #888;
				transform: scale(1.1);
			}
		`,`
			input[disabled] {
				background: #000;
				color: #444;
				border: 1px dashed #222;
				pointer-events: none;
			}
		`,`
			input[type="submit"],
			input[type="reset"] {
				background: #111;
				color: #eee;
				border: 1px solid #444;
				padding: 0.5rem 1rem;
				cursor: pointer;
				font-family: inherit;
				transition: background 0.2s ease, color 0.2s ease;
			}
		`,`
			input,
			textarea,
			select {
				width: 100%;
				max-width: 100%;
				box-sizing: border-box;
			}
		`,`
			input[type="submit"]:hover,
			input[type="reset"]:hover {
				background: #222;
				color: #fff;
			}
		`,`
			input:focus, textarea:focus, select:focus {
				outline: 1px solid #444;
				outline-offset: 2px;
			}
		`,`
			input[type="radio"],
			input[type="checkbox"] {
				accent-color: #666;
				width: 1rem;
				height: 1rem;
			}
		`,`
			.nx-checkbox, .nx-radio {
				display: flex;
				flex-direction: row;
				align-items: center;
				gap: 0.5rem;
			}
		`
	].forEach(rule => css.push = rule);
});



	//get sheet() {
	//	return NxCSSOM.#styleSheets.cssRules;
	//}



/*<dl class="irrational-animals">
new Map([
	[
		'Zero - The Anchor Beast',
		'The first reference, the unmoving point, the only stable creature in the irrational domain.',
	],[
		'The Empty Set - The Hollow Warden'
		'The shape of absence, the container that contains nothing yet defines containment.'
	],[
		'Nothing - The Unseen Predator'
		'The unreferable outside, the non-state that erases possibility and cannot be pointed at'
	],[
		'Entropy - The Divergence Serpent'
		'The pressure toward divergence, the generator of forks, the wandering force that forced Zero into existence.'
	]
]);
	</dd>
</dl>
*/



		/*
		const handler = {
			get(target, prop, receiver) {
				const value = Reflect.get(target, prop, target);
				console.log("GET", prop, value, target);
				if (typeof value === "function")
					return value.bind(target);
			return value;
		},
		set(target, prop, value, receiver) {
			console.log("SET", prop, value, target);
			return Reflect.set(target, prop, value, target);
			}
		}
		this.sheets = new Proxy(document.styleSheets, handler);
		if (this.sheets.length >= 1) {
			this.sheets.item(this.sheets.length - 1);
		} else if (NxCSSOM.#sheets instanceof StyleSheetList) {
			this.sheets = NxCSSOM.#sheets;
		}
		*/
/*
	const nav = new NxNav();

	console.log(NxNav.NAV);

	nav
		.addListItem('greet')
		.addListItem('greet')
		.addListItem('greet')
		.addListItem('greet')
		.addListItem('greet')
		.addListItem('greet')
		.addListItem('greet')
		.addListItem('greet')
		.addListItem('greet')
		.addListItem('greet');
*/

