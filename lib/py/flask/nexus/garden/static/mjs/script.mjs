import { NxNav } from "./mjs/nex-nav.mjs"




class NxCSSOM
{
	static #sheet = null;
	static #root = document.documentElement;

	constructor() {
		this.sheet = document.styleSheets[0];
		try {
				this.rules = this.sheet.cssRules;
		} catch (e) {
			if (e.name === 'SecurityError')
				console.err("SecurityError caught:", e);
			else
				console.warn("Cannot read rules for", this.sheet.href);
			this.sheet = document.createElement('style');
			this.rules = this.sheet.cssRules;
			document.head.appendChild(sheet);
		}
		if (! (NxCSSOM.#sheet instanceof CSSStyleSheet))
			NxCSSOM.#sheet = document.styleSheets[0];
	}

	static createStyleSheetList(...sheets) {
		return new Proxy(sheets, {
			get(target, prop, receiver) {
				const value = Reflect.get(target, prop, target);
				if (typeof value === "function") return value.bind(target);
					return value;
			},
			set(target, prop, value, receiver) {
				return Reflect.set(target, prop, value, target);
			}
		});
	}

	set reset(text) {
		sheet.replaceSync(String(text ?? ""));
	}

	static setVar(variable, value) {
		NxCSSOM.#root.setProperty(`--${variable}`, value);
		return value;
	}

	static getVar(variable) {
		console.log(NxCSSOM.#root);
		return getComputedStyle(NxCSSOM.#root).getPropertyValue(`--${variable}`).trim();
	}

	static randomRGB(variable) {
		const hex = Math.random().toString(16).slice(2, 8);
		return this.setVar(variable, `#${hex}`);
	}

	query(text) {
		return Array.from(this.rules).filter(
			rule => rule.cssText.includes(text)
		);
	}

	querySelector(selector) {
		return Array.from(this.rules).find(
			rule => rule.type === CSSRule.STYLE_RULE && rule.selectorText === selector
		);
	}

	queryProperty(prop) {
		return Array.from(this.rules).filter(rule => {
			if (rule.type !== CSSRule.STYLE_RULE)
				return false;
			return rule.style[prop] !== "";
		});
	}

	queryMediaSelector(selector) {
		const results = [];
		for (const rule of this.rules) {
			if (rule.type === CSSRule.MEDIA_RULE) {
				for (const inner of rule.cssRules) {
					if (inner.selectorText === selector) {
						results.push(inner);
					}
				}
			}
		}
		return results;
	}

	get queryMedia() {
		return Array.from(this.rules).filter(
			rule => rule.type === CSSRule.MEDIA_RULE
		);
	}

	get queryFontFace() {
		return Array.from(this.rules).filter(
			rule => rule.type === CSSRule.FONT_FACE_RULE
		);
	}

	get length() {
		return this.rules.length;
	}
	
	text(rule) {
		rule = parseInt(rule);
		const idx = isNaN(rule) ? this.length - 1 : rule;
		if (idx < 0)
			return null;
		try {
			return this.rules[idx]?.cssText;
		} catch (e) {
			return null;
		}
	}

	set push(rule) {
		this.sheet.insertRule(String(rule), this.length);
	}
}

//nxDom.doctype('5.0', 'html');
document.addEventListener('DOMContentLoaded', () => {

	const css = new NxCSSOM();
	console.log(NxCSSOM.randomRGB('alpha'));
	console.log(NxCSSOM.get('alpha'));
	console.log('ss');
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
});

