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
		const cls = [ 'carousel' ];
		if (Type.isTrue(obj.auto))
			cls.push('auto');
		if (Type.isTrue(obj.fade))
			cls.push('fade');
		this.parent = obj.to;
		this.slides = [];
		this.id = `${Dom.setId(this.parent.getAttribute('id'))}-carousel`;
		obj.id = this.id;
		this.element = new nexContainer({
			'id': this.id,
			'to': this.parent,
			'true': cls
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
		return this;
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
			if (! Type.isObject(obj.button))
				obj.button = {};
			Dom.append(nexComponent.button({
				'id': `${this.id}-in${slide + 1}`,
				'cls': slideState,
				'true': [ 'carousel' ],
				'slide': slide,
				'for': this.id,
				...obj.button
			}), this.element.children[0].element);
		}
		if (! Type.isObject(obj.carousel))
			obj.carousel = {};
		this.slides.push(Dom.append(nexComponent.div({
			'id': `${this.id}-ci${slide + 1}`,
			'cls': `${obj.carousel.cls} ${slideState}`,
			'true': [ 'carousel', 'item' ],
			...obj.carousel
		}), this.element.children[slideDiv].element));
		if (Type.isObject(obj.image)) {
			Dom.append(nexComponent.image({
				'id': `${this.id}-cs${slide + 1}`,
				'src': obj.image.src,
				'width': obj.image.x,
				'height': obj.image.y,
				'alt': obj.image.alt,
				'float': obj.image.float,
				'thumbnail': obj.image.thumbnail,
				'fluid': obj.image.fluid,
				...obj.image
			}), this.slides[slide]);
		}
		if (Type.isObject(obj.caption)) {
			Dom.append(nexComponent.div({
				'id': `${this.id}-cp${slide + 1}`,
				'true': [ 'carousel', 'caption' ],
				...obj.caption
			}), this.slides[slide]);
			if (! Type.isObject(obj.header))
				obj.header = {};
			Dom.append(nexComponent.h({
				'id': `${this.id}-cph${slide + 1}`,
				...obj.header,
			}), Dom.byId(`${this.id}-cp${slide + 1}`));
			if (Type.isObject(obj.paragraph)) {
				Dom.append(nexComponent.p({
					'id': `${this.id}-cpp${slide + 1}`,
					...obj.paragraph
				}), Dom.byId(`${this.id}-cp${slide + 1}`));
			}
		}
		return this;
	}
}

