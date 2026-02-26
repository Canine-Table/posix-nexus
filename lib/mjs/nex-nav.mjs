
export class NxNav
{
	static #weakMap = new WeakMap();
	static #constructed = null;

	constructor() {
		if (NxNav.#constructed !== null)
			return NxNav.#constructed;
		const body = document.createElement('body');
		this.header = document.createElement('header');
		this.main = document.createElement('main');
		this.footer = document.createElement('footer');
		const nav = document.createElement('nav');
		const navBody = document.createElement('div');
		const ul = document.createElement('ul');

		this.header.id = 'nx-header';
		navBody.id = 'nx-nav-body';
		this.main.id = 'nx-main';
		this.footer.id = 'nx-footer';
		nav.id = 'nx-nav';
		ul.id = 'nx-nav-ul';

		//const overflow = NxNav.overflow(nav, 'nx-hamburger');
		//const ro = new ResizeObserver(overflow);

		/*
		

		const navBodyMap = new Map([[ 'ul#nx-nav-ul', ul ]]);
		
		const navMap = new Map([
			[ 'div#nx-nav-body', navBody ],
			[ navBody, navBodyMap ]
		]);

		const headerMap = new Map([
			[ 'nav#nx-nav', nav ],
			[ nav, navMap ]
		]);

		NxNav.#weakMap.set(this.header, headerMap);


		]));
		*/


		NxNav.#weakMap.set(this.header, new Map([
			[ 'nav#nx-nav', nav ],
			[ nav,
				new Map([
					[ 'div#nx-nav-body', navBody ],
					[ navBody,
						new Map([
							[ 'ul#nx-nav-ul', ul ],
							[ ul, new WeakMap() ]
						])
					]
				])
			]
		]));

		NxNav.#weakMap.set(this.main, new Map());
		NxNav.#weakMap.set(this.footer, new Map());


		navBody.appendChild(ul);
		nav.appendChild(navBody);
		this.header.appendChild(nav);
		body.appendChild(this.header);
		body.appendChild(this.main);
		body.appendChild(this.footer);
		document.documentElement.replaceChild(body, document.body);
		NxNav.#constructed = this;

		//ro.observe(nav);

		// Run once on load
		//overflow();
	}

	static get thineself() {
		return NxNav.#constructed ?? new NxNav();
	}

	static get HEADER() {
		return new Map([
			[ 'header#nx-header', NxNav.thineself.header ],
			[ NxNav.thineself.header, NxNav.#weakMap.get(NxNav.thineself.header) ]
		]);
	}

	static get MAIN() {
		return new Map([
			[ 'main#nx-main', NxNav.thineself.main ],
			[ NxNav.thineself.main, NxNav.#weakMap.get(NxNav.thineself.main) ]
		]);
	}

	static get FOOTER() {
		return new Map([
			[ 'footer#nx-footer', NxNav.thineself.footer ],
			[ NxNav.thineself.footer, NxNav.#weakMap.get(NxNav.thineself.footer) ]
		]);
	}

	static get NAV() {
		const node = NxNav.HEADER;
		return node.get(node.get('header#nx-header'));
	}

	static get NAVBODY() {
		const node = NxNav.NAV;
		return node.get(node.get('nav#nx-nav'));
	}

	static get UL() {
		const node = NxNav.NAVBODY;
		return node.get(node.get('div#nx-nav-body'));
	}

	static #addListItem() {
		const ul = NxNav.UL.get('ul#nx-nav-ul');
		const tabs = NxNav.UL.get(ul);
		const main = NxNav.MAIN.get('main#nx-main');

		//console.log(tabs);
		const li = document.createElement('li');
		li.className = 'nx-nav-li';
		
		const a = document.createElement('a');
		a.className = 'nx-nav-a';

		const div = document.createElement('div');

		if (NxNav.UL.has('.active')) {
			div.className = 'nx-nav-div';
		} else {
			div.className = 'nx-nav-div active';
			NxNav.UL.set('.active', div);
		}

		li.appendChild(a);
		ul.appendChild(li);
		main.appendChild(div);

		tabs.set(a, div);

		return [ li, a, div ];
	}

	static rem(count = 1) {
		return parseFloat(getComputedStyle(document.documentElement).fontSize) * count;
	}

	static changed(node) {
		const config = { attributes: true, childList: true, subtree: true };
		const callback = () => {
			const nav = NxNav.NAV.get('nav#nx-nav');
			let size = 0;
			for (const element of nav.children) {
				size += element.offsetHeight;
			}
			console.log(NxNav.NAV.get(nav))
			console.log(size)
			console.log(size)
			console.log(size)
			console.log(size)

			//.set('size', size);


			//for (const mutation of mutationList) {
			//	console.log(mutation)

				/*if (mutation.type === "childList") {
					console.log("A child node has been added or removed.");
				} else if (mutation.type === "attributes") {
					console.log(`The ${mutation.attributeName} attribute was modified.`);
				}*/
			//}
		};

		// Create an observer instance linked to the callback function
		const observer = new MutationObserver(callback);

		// Start observing the target node for configured mutations
		observer.observe(node, config);
	}

	static overflow(node, cls = 'nx-overflow') {
		let overflow = null;

		NxNav.changed(node);
		return () => {
			//const overflowing = node.scrollWidth > node.clientWidth;
			//
			const overflowing = node.offsetHeight > NxNav.rem(2);
			//const overflowing = node.scrollWidth > node.clientWidth;
			//console.log(node);
			if (overflowing !== overflow) {
				node.classList[(overflow = overflowing) ? 'add' : 'remove' ](cls);
			}
		}
	}

	addListItem(txt) {
		const [ li, a, div ] = NxNav.#addListItem();
		a.innerText = txt;
		div.innerText = txt;
		return this;
	}
}
