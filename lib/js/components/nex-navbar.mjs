#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexSvg } from '../components/nex-svg.mjs';
import { nexNode } from './nex-node.mjs';
import { Arr } from '../arr.mjs';

export class nexNav extends nexNode
{
	#close;
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexNav;
		obj.tag = 'nav';
		super(obj).class({
			'add': 'nex-nav navbar nav'
		}).frag({
			'tag': 'div',
			'cls': {
				'add': 'container-fluid d-flex'
			},
		});
		this.links = [];
		this.tabs = [];
		this.locations = [];
		if (! (Type.isDefined(this.parent) && nexNode.IsNode(this.parent.element)))
			throw new Error('A nexNode instance object is required for the nexNav to object parameter');
		if (Type.isTrue(obj.navmain)) {
			this.title = nexNode.Title;
			let title = nexNode.Title;
			window.addEventListener('focus', () => nexNode.Title = title);
			window.addEventListener('visibilitychange', () => {
				nexNode.Title = `${this.title} - Sleeping`;
			});
			window.addEventListener('blur', () => {
				title = nexNode.Title;
				nexNode.Title = `${this.title} - Exploring`;
			});
		}
		this.content = this.parent.frag({
			'tag': 'main',
			'cls': {
				'add': 'w-100 py-4 position-relative d-flex flex-grow-1 justify-content-center nex-nav-content container-fluid'
			}
		}).nodes.main[0];
		if (Type.isObject(obj.brand)) {
			delete obj['brand'].tag;
			this.nodes.div[0].frag({
				'tag': 'a',
				...obj.brand
			}).nodes.a[0].class({
				'add': 'nav-brand nex-brand me-3'
			});
		}
		const toggle = Arr.shortStart(obj.toggle, [ 'offcanvas', 'collapse' ]) || 'collapse';
		if (Type.isDefined(obj.toggle)) {
			this.nodes.div[0].frag({
				'tag': 'button',
				'cls': {
					'add': 'nex-nav-tog navbar-toggler'
				},
				'prop': {
					'aria-controls': `${this.nodes.div[0].element.id}-div1`,
					'data-bs-target': `#${this.nodes.div[0].element.id}-div1`,
					'type': 'button',
					'data-bs-toggle': toggle,
					'aria-expanded': 'false',
					'aria-label': 'Toggle navigation'
				},
				'child': {
					'tag': 'span',
					'cls': {
						'add': 'nex-nav-tog-ico navbar-toggler-icon'
					}
				}
			});
		}
		const list = nexNode.ListTag(obj.toggle);
		if (! Type.isObject(obj['navbar']))
			obj['navbar'] = {};
		delete obj['navbar'].tag;
		if (! Type.isObject(obj['navbar']['navlist']))
			obj['navbar']['navlist'] = {};
		delete obj['navbar']['navlist'].tag;
		if (toggle === 'collapse') {
			this.list = this.nodes.div[0].frag({
				'tag': 'div',
				...obj.navbar
			}).div[0].class({
				'add': 'nex-nav-target collapse navbar-collapse'
			}).frag({
				'tag': list,
				...obj.navbar.navlist
			}).nodes[list][0];
		} else {
			if (! Type.isObject(obj['navbar']['navhead']))
				obj['navbar']['navhead'] = {};
			delete obj['navbar']['navhead'].tag;
			if (! Type.isObject(obj['navbar']['navhead']['button']))
				obj['navbar']['navhead']['button'] = {};
			delete obj['navbar']['navhead']['button'].tag;
			if (! Type.isObject(obj['navbar']['navhead']['title']))
				obj['navbar']['navhead']['title'] = {};
			obj['navbar']['navhead']['title'].tag = nexNode.HeaderTag(obj['navbar']['navhead']['title'].tag, 'h3', 'h3');
			if (! Type.isObject(obj['navbar']['navbody']))
				obj['navbar']['navbody'] = {};
			delete obj['navbar']['navbody'].tag;
			this.list = this.nodes.div[0].frag({
				'tag': 'div',
				...obj.navbar
			}).nodes.div[0].class({
				'add': 'nex-offcanvas offcanvas'
			}).setAttr({
				'aria-labelledby': 'offcanvasNavbarLabel',
				'data-bs-scroll': ! Type.isFalse(obj['navbar'].scroll),
				'data-bs-backdrop': Arr.shortStart(String(Type.isDefined(obj['navbar'].backdrop, 'false')), [ 'true', 'false', 'static' ]) || 'false',
				'tabindex': '-1'
			}).frag([
				{
					'tag': 'div',
					...obj.navbar.navhead
				},
				{
					'tag': 'div',
					...obj.navbar.navbody
				}
			]).nodes.div[0].class({
				'add': 'nex-offcavas-header offcanvas-header'
			}).frag([
				{
					...obj.navbar.navhead.title
				},
				{
					'tag': 'button',
					...obj.navbar.navhead.button
				}
			]).nodes[obj.navbar.navhead.title.tag][0].class({
				'add': 'nex-offcanvas-title offcanvas-title'
			}).back().nodes.button[0].class({
				'add': 'btn-close'
			}).setAttr({
				'type': 'button',
				'data-bs-dismiss': 'offcanvas',
				'aria-label': 'Close'
			}).back(2).nodes.div[1].class({
				'add': 'nex-offcanvas-body offcanvas-body'
			}).frag({
				'tag': list,
				...obj.navbar.navlist
			}).nodes[list][0];
			if (Type.isTrue(obj.close))
				this.#close = this.nodes.div[0].nodes.div[0].nodes.div[0].nodes.button[0];
		}
		this.list.class({
			'add': `navbar-nav ${Type.isDefined(obj.navbar.navlist.display, 'd-lg-flex d-block')}`
		});
		this.#hashSwitch;
		return this;
	}

	link(obj) {
		let state = this.links.length > 0 ? {
			'tab': 'none',
			'link': ''
		} : {
			'tab': 'flex',
			'link': 'active'
		};
		const cnt = {
			'link': this.links.length,
			'tab': this.tabs.length
		};
		let hash = undefined;
		if (nexNode.IsNode(obj.element) && obj instanceof nexNode && Arr.in(obj, this.links)) {
			this.tabs.push(this.content.frag({
				'tag': 'article',
				'cls': {
					'add': 'nex-tab'
				},
				'css': {
					'display': state.tab
				}
			}).nodes.article[cnt.tab]);
			cnt.link -= 1;
			hash = Str.lastChar(`#${obj.getAttr('href').href}`, '#');
		} else {
			nexNode.Skel(obj);
			obj.tag = 'li';
			if (! Type.isObject(obj['link']))
				obj['link'] = {};
			obj['link'].tag = nexNode.ButtonTag(obj['link'].tag);
			if (! Type.isObject(obj['tab']))
				obj['tab'] = {};
			delete obj['tab'].tag;
			this.links.push(this.list.frag({
				...obj
			}).nodes.li[cnt.link].class({
				'add': `nav-item rounded nex-nav-item ${Type.isDefined(obj.margins, 'me-0 me-lg-2 mb-2 mb-lg-0')} ${state.link}`
			}).frag({
				...obj['link']
			}).nodes[obj['link'].tag][0].class({
				'add': `nex-nav-link nav-link rounded ${state.link}`
			}));
			this.tabs.push(this.content.frag({
				'tag': 'article',
				...obj['tab']
			}).nodes.article[cnt.tab].css({
				'display': state.tab
			}).class({
				'add': 'nex-tab'
			}));
			hash = Str.lastChar(`#${this.links[cnt.link].getAttr('href').href}`, '#');
		}
		if (Type.isDefined(obj.svg)) {
			new nexSvg({
				'to': this.links[this.links.length - 1],
				'attach': {
					'place': 'first'
				},
				'prop': {
					'viewbox': '0 0 16 16',
					'height': '24px',
					'width': '24px',
					'class': 'me-2 mx-lg-2',
					'fill': 'currentColor'
				}
			}).svg({
				'svg': 'use',
				'href': obj.svg
			});
		}
		if (Type.isDefined(this.title)) {
			if (hash === 'undefined' || Type.isUndefined(hash)) {
				hash = Str.camelCase(obj.link.text) || Str.random(16);
				this.links[cnt.link].setAttr({ 'href': `#${hash}` });
			}
			this.locations.push(hash);
		}
		this.#tabSwitch(this.tabs[cnt.tab], this.links[cnt.link], hash);
		if (this.locations.length === 1)
			this.links[cnt.link].element.click();
		return this;
	}

	#getLocation(val, b = false) {
		const idx = this.locations.indexOf(Str.camelCase(val));
		if (idx !== -1) {
			if (Type.isTrue(b))
				return this.links[idx];
			else
				return this.tabs[idx];
		}
	}

	getLink(val) {
		return this.#getLocation(val, true);
	}

	getTab(val) {
		return this.#getLocation(val);
	}

	get #hashSwitch() {
		window.addEventListener('hashchange', () => {
			if (Type.isDefined(nexNode.Hash)) {
				const hash = Str.camelCase(Str.lastChar(nexNode.Hash, '#'));
				if (Type.isDefined(this.locations) && this.locations.indexOf(hash) !== -1) {
					this.links[this.locations.indexOf(hash)].element.click();
				}
			}
		});
	}

	#tabSwitch(t, l, h) {
		l.element.addEventListener('click', () => {
			for (let i = 0; i < this.links.length; i++) {
				this.tabs[i].css({
					'display': 'none'
				});
				this.links[i].class({
					'del': 'active'
				});
			}
			t.css({
				'display': 'flex'
			});
			l.class({
				'add': 'active'
			})
			if (Type.isDefined(this.title) && Type.isDefined(h))
				document.title = `${this.title} - ${Str.camelTitleCase(h)}`;
			if (Type.isDefined(this.#close))
				this.#close.element.click();
		});
	}
}

