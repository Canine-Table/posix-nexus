import { NxElement } from "./nex-element.mjs"

export class NxNav
{
	static #WeakMap = new WeakMap();

	constructor(
		buttons,
		pages,
		offcanvas
	) {

		NxNav.#WeakMap.set(this, {
			active: null,
		});

		this.buttons = new NxElement(buttons);
		this.pages = new NxElement(pages);
		this.offcanvas = new NxElement(offcanvas);

		const btn = new NxElement('button', {
			plant: {
				className: 'nx-icon nx-icon-button nx-hamburger'
			}
		});
		const ofcs = new NxElement('ul', {
			plant: {
				className: 'nx-offcanvas-ul'
			}
		});
		offcanvas.appendChild(btn.twig);
		offcanvas.appendChild(ofcs.twig);
		btn.twig.addEventListener('click', () => {
			btn.twig.classList.toggle('nx-hamburger');
			btn.twig.classList.toggle('nx-close');
			ofcs.twig.classList.toggle('active');
		});
	}


	/*
	static #WeakMap = new WeakMap();

	constructor(
		buttons,
		pages,
		offcanvas
	) {

		NxNav.#WeakMap.set(this, {
			active: null,
		});

		this.buttons = new NxElement(buttons);
		this.pages = new NxElement(pages);
		this.offcanvas = new NxElement(offcanvas);

		const btn = new NxElement('button', {
			plant: {
				className: 'nx-icon nx-icon-button nx-hamburger'
			}
		});
		const ofcs = new NxElement('ul', {
			plant: {
				className: 'nx-offcanvas-ul'
			}
		});
		offcanvas.appendChild(btn.twig);
		offcanvas.appendChild(ofcs.twig);
		btn.twig.addEventListener('click', () => {
			btn.twig.classList.toggle('nx-hamburger');
			btn.twig.classList.toggle('nx-close');
		});

		return this;
	}

	addPage(properties = {}) {
		
		const wm = NxNav.#WeakMap.get(this);

		const content = new NxElement('div', {
			plant: {
				className: `nx-nav-page ${wm.active === null ? 'active' : ''}`,
			}
		});


		const button = new NxElement('button', properties);
		button.twig.classList.add('nx-nav-item')

		if (wm.active === null)
			wm.active = content;

		this.pages.appendChild(content.twig);
		this.buttons.appendChild(button.twig);
		NxNav.#WeakMap.set(button, content);

		button.twig.addEventListener('click', () => {
			NxNav.#WeakMap.get(this).active.twig.classList.remove('active');
			const page = NxNav.#WeakMap.get(button);
			NxNav.#WeakMap.get(this).active = page
			page.twig.classList.add('active');
		});

		return content;
	}
	*/
}

