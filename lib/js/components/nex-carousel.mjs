#!/usr/bin/env node
import { Type } from '../type.mjs';
import { Obj } from '../obj.mjs';
import { Str } from '../str.mjs';
import { nexNode } from './nex-node.mjs';
import { Arr } from '../arr.mjs';
import { nexEvent } from '../event.mjs';

export class nexCarousel extends nexNode
{
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexCarousel;
		obj.tag = 'div';
		if (Type.isDefined(obj.ride))
			obj.prop['data-bs-ride'] = Arr.shortStart(String(obj.ride), [ 'true', 'false', 'carousel' ]) || 'carousel';
		if (Type.isDefined(obj.pause))
			obj.prop['data-bs-pause'] = Arr.shortStart(String(obj.pause), [ 'hover', 'mouseenter', 'mouseleave', 'touchend', 'false' ]) || 'false';
		super(obj).class({
			'add': 'carousel slide w-100 h-100'
		}).setAttr({
			'data-bs-touch': ! Type.isFalse(obj.touch),
			'data-bs-keyboard': ! Type.isFalse(obj.keyboard),
			'data-bs-wrap': ! Type.isFalse(obj.wrap)
		}).back().class({
			'add': 'container-fluid'
		});
		if (Type.isTrue(obj.indicators)) {
			this.indicators = this.frag({
				'tag': 'div',
				'cls': {
					'add': 'carousel-indicators'
				}
			}).nodes.div[0];
		}
		if (! Type.isObject(obj['inner']))
			obj['inner'] = {};
		obj['inner'].tag = 'div';
		this.inner = this.frag({
			...obj['inner']
		}).nodes.div[this.nodes.div.length - 1].class({
			'add': 'carousel-inner h-100'
		});
		this.slides = [];
		if (Type.isTrue(obj.prev))
			this.#controls('prev');
		if (Type.isTrue(obj.next))
			this.#controls('next');
		if (Type.isDefined(obj.image))
			this.image = obj.image;
		return this;
	}

	#controls(to) {
		const label = to === 'prev' ? 'Previous' : 'Next';
		this.frag({
			'tag': 'button',
			'prop': {
				'type': 'button',
				'data-bs-target': `#${this.getAttr('id').id}`,
				'data-bs-slide': to
			},
			'cls': {
				'add': `carousel-control-${to}`
			},
			'child': [
				{
					'tag': 'span',
					'cls': {
						'add': `carousel-control-${to}-icon`
					},
					'prop': {
						'aria-hidden': 'true'
					}
				},
				{
					'tag': 'span',
					'text': label,
					'cls': {
						'add': 'visually-hidden'
					}
				}
			]
		});
	}

	slide(obj) {
		nexNode.Skel(obj);
		const state = this.slides.length > 0 ? '' : 'active';
		if (Type.isDefined(this.indicators)) {
			this.indicators.frag({
				'tag': 'button',
				'cls': {
					'add': `nex-carousel-indicators ${state}`
				},
				'prop': {
					'data-bs-target': `#${this.getAttr('id').id}`,
					'data-bs-slide-to': this.slides.length,
					'aria-label': `Slide ${this.slides.length + 1}`,
					'aria-current': state === 'active' ? 'true' : 'false'
				}
			});
		}

		if (! Type.isObject(obj['image']))
			obj['image'] = {};
		nexNode.Skel(obj['image']);
		obj['image']['prop'].src = Type.isDefined(obj['image']['prop'].src, this.image);
		obj.tag = 'div';
		let cur = this.inner.frag(obj).nodes.div[this.inner.nodes.div.length - 1].class({
			'add': `carousel-item h-100 ${state}`
		});
		if (Type.isDefined(obj['image']['prop'].src)) {
			obj['image'].tag = 'img'
			obj['image']['prop'].alt = Type.isDefined(obj['image']['prop'].alt, '...');
			cur.frag(obj['image']).nodes.img[0].class({
				'add': `d-block w-100 h-100 object-fit-fill rounded border`
			});
		}

		if (Type.isObject(obj['caption']))
			obj['caption'] = [obj['caption']];
		this.slides.push(cur.frag({
			'tag': 'div',
			'cls': {
				'add': 'h-100 carousel-caption top-0 py-5'
			},
			'css': {
				'font-size': '1.5rem'
			}
		}).nodes.div[0].frag([
			{
				'tag': 'div',
				'cls': {
					'add': 'nex-scroll-container flex-column justify-content-center w-100 py-3 h-100 border-bottom border-top'
				},
				'child': obj['caption']
			},
		]).nodes.div[0]);
		cur = cur.nodes.div[0].nodes.div[0];
		new ResizeObserver(() => {
			if (nexEvent.overflow(cur.element))
				cur.class({ 'del': 'd-flex' });
			else
				cur.class({ 'add': 'd-flex' });
		}).observe(cur.element);
		return this;
	}
}

