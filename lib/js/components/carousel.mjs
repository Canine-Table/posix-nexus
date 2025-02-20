#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexComponent } from '../components.mjs';
import { nexContainer, nexRow, nexCol } from '../layout.mjs';
import { nexList } from './lists.mjs';
import { Dom } from '../dom.mjs';
import { Arr } from '../arr.mjs';
export class nexCarousel
{
	constructor(obj) {
		obj = Dom.skel(obj);
		if (! Dom.isHtml(obj.to))
			throw new Error("nexCarousel instances require a parent to append to");
		this.parent = obj.to;
		this.slides = [];
		this.id = `${Dom.setId(this.parent.getAttribute('id'))}-carousel`;
		obj.id = this.id;
		this.element = new nexContainer({
			'id': this.id,
			'to': this.parent,
			'true': [ 'carousel' ]
		});
		if (Type.isTrue(obj.indicators)) {
			this.indicators = true;
			this.element.addRows(1, {
				'true': [ 'carousel', 'indicators' ]
			});
		}

		this.element.addRows(1, {
			'true': [ 'carousel', 'inner' ]
		});

		if (Type.isTrue(obj.next))
			this.addControls('next');
		if (Type.isTrue(obj.prev))
			this.addControls('prev');
	}

	addControls(val) {
		const c = {
			'next': 'Next',
			'prev': 'Previous'
		}
		if (Arr.in(val, Object.keys(c)) && ! Dom.byId(`${this.id}-${val}`)) {
			const tag = Dom.append(nexComponent.button({
				'id': `${this.id}-${val}`,
				'for': this.id,
				'true': [ 'carousel', val ]
			}), this.element.element);
			Dom.append(nexComponent.span({
				'id': `${this.id}-${val}-icon`,
				'true': [ 'carousel', val ]
			}), tag);
			Dom.append(nexComponent.span({
				'id': `${this.id}-${val}-label`,
				'text': c[val],
				'true': [ 'carousel' ]
			}), tag);
			return this;
		}
	}

	addSlide(obj) {
		obj = Dom.skel(obj);
		let slideState = '';
		let slideDiv = 0;
		if (this.slides.length === 0)
			slideState = 'active';
		const slide = this.slides.length;
		if (Type.isTrue(this.indicators)) {
			slideDiv = 1;
			Dom.append(nexComponent.button({
				'id': `${this.id}-in${slide + 1}`,
				'cls': slideState,
				'true': [ 'carousel' ],
				'slide': slide,
				'for': this.id,
			}), this.element.children[0].element);
		}
		this.slides.push(Dom.append(nexComponent.div({
			'id': `${this.id}-ci${slide + 1}`,
			'cls': slideState,
			'true': [ 'carousel', 'item' ]
		}), this.element.children[slideDiv].element));
		Dom.append(nexComponent.image({
			'id': `${this.id}-cs${slide + 1}`,
			'cls': 'img-fluid',
			'src': obj.img,
			'width': obj.x,
			'height': obj.y,
			'alt': obj.alt
		}), this.slides[slide]);
		if (Type.isDefined(obj.caption)) {
			Dom.append(nexComponent.div({
				'id': `${this.id}-cp${slide + 1}`,
				'true': [ 'carousel', 'caption' ],
				'size': obj.size
			}), this.slides[slide]);
			Dom.append(nexComponent.h({
				'id': `${this.id}-cph${slide + 1}`,
				'text': obj.caption,
				'h': obj.h
			}), Dom.byId(`${this.id}-cp${slide + 1}`));
			if (Type.isDefined(obj.p)) {
				Dom.append(nexComponent.p({
					'id': `${this.id}-cpp${slide + 1}`,
					'text': obj.p
				}), Dom.byId(`${this.id}-cp${slide + 1}`));
			}
		}
		return this;
	}
}

