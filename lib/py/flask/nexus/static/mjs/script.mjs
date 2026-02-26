/*import { NxNav } from "./mjs/nex-nav.mjs"
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

*/

// Step 1: Create a Symbol to act as a private key
const SECRET_KEY = Symbol("why");

// Step 2: Create a class that stores nothing useful
class PizzaStringBuilder {
	constructor() {
		this[SECRET_KEY] = [..."Pizza is the best!"]
			.map(c => String.fromCharCode(c.charCodeAt(0)));
	}

	// Step 3: Rebuild the string every time
	get value() {
		return this[SECRET_KEY].reduce((a, b) => a + b, "");
	}
}

// Step 4: Wrap the class in a Proxy that PRETENDS to be a Promise
const pizzaProxy = new Proxy(new PizzaStringBuilder(), {
	get(target, prop) {
		// Step 5: Make the ENTIRE PROXY thenable :D
		if (prop === "then") {
			return (resolve, reject) => {
				// Step 6: Resolve asynchronously for no reason
				queueMicrotask(() => {
					try {
						resolve(target.value);
					} catch (err) {
						reject(err);
					}
				});

				// Step 7: Return ANOTHER thenable to allow chaining
				return pizzaProxy;
			};
		}

		// Step 8: Keep your original cursed async getter
		if (prop === "value") {
			return (async () => target.value)();
		}

		return target[prop];
	}
});

// Step 1: Build "Hello World." as char codes
const HELLO_WORLD_CODES = [
	..."Hello World."
].map(c => c.charCodeAt(0));

// Step 2: Create a generator that yields one char at a time
function* helloWorldGenerator(codes) {
	for (const code of codes) {
		yield String.fromCharCode(code);
	}
}

// Step 3: Wrap the generator in a Proxy that pretends to be async-iterable
const helloWorldProxy = new Proxy(helloWorldGenerator(HELLO_WORLD_CODES), {
	get(target, prop) {
		if (prop === Symbol.asyncIterator) {
			return async function* () {
				for (const value of target) {
					// Step 4: Artificial async delay for no reason
					await new Promise(r => setTimeout(r, 0));
					yield value;
				}
			};
		}
		return target[prop];
	}
});


document.addEventListener('DOMContentLoaded', async () => {
	// Step 6: Extract the string through an async IIFE
	pizzaProxy
		.then(v => v.toUpperCase())
		.then(v => console.log(v));



	// Step 5: Consume the async iterator to assemble the string, then log it
	(async () => {
		let result = "";
		for await (const ch of helloWorldProxy) {
			result += ch;
		}
		console.log(result); // "Hello World."
	})();


});

//nxDom.doctype('5.0', 'html');

// Step 7: result is now a string containing "Pizza is the best!"


/*
	window.addEventListener("orientationchange", () => {
		document.querySelector("meta[name=viewport]")
		.setAttribute("content",
			"width=device-width, initial-scale=1, maximum-scale=1, viewport-fit=cover"
		);
	});

	/*
	const css = new NxCSSOM();
	const form = 

	// First Name
	document.body.appendChild(
		new NxForm('Welcome to the abyss')

		.addFields("firstName", {
			type: "text",
			label: "First Name",
			required: true
		})

		// Last Name
		.addFields("lastName", {
			type: "text",
			label: "Last Name",
			required: true

		}).form);
		*/

	//get sheet() {
	//	return NxCSSOM.#styleSheets.cssRules;
	//}




/*<dl class="irrational-animals">
new Map([
	[
		'Zero — The Anchor Beast',
		'The first reference, the unmoving point, the only stable creature in the irrational domain.',
	],[
		'The Empty Set — The Hollow Warden'
		'The shape of absence, the container that contains nothing yet defines containment.'
	],[
		'Nothing — The Unseen Predator'
		'The unreferable outside, the non-state that erases possibility and cannot be pointed at'
	],[
		'Entropy — The Divergence Serpent'
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

