#!/usr/bin/env node
import { Type } from './type.mjs';
import { Dom } from './dom.mjs';
import { Obj } from './obj.mjs';
import { Int } from './int.mjs';
import { nexComponent } from './components.mjs';
import { nexSvg } from './components/svg.mjs';
import { nexEvent } from './event.mjs';
import { Arr } from './arr.mjs';
import { Str } from './str.mjs';
export function nexAnime()
{
	Obj.methods(nexAnime);
}

nexAnime.fa = () => {
	const faIcons = Dom.byClass('fa');
	const animations = [ 'fa-beat', 'fa-spin-pulse', 'fa-spin', 'fa-shake', 'fa-fade', 'fa-bounce', 'fa-beat-fade' ];
	let cur = animations[Int.randomRange(animations.length - 1)];
	for (let i = 0; i < faIcons.length; i++) {
		faIcons[i].parentNode.addEventListener('mouseover', () => {
			Dom.class(faIcons[i], { 'clsAdd': cur });
		});
		faIcons[i].parentNode.addEventListener('mouseout', () => {
			Dom.class(faIcons[i], { 'clsDel': cur });
			cur = animations[Int.randomRange(animations.length - 1)];
		});
	}
}

nexAnime.setTheme = val => {
	if (! (Type.isDefined(val) && Arr.in(val, [ 'light', 'dark' ]))) {
		if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)
			val = 'dark';
		else
			val = 'light';
	}
	Dom.prop(Dom.root(), { 'data-bs-theme': val });
	for (let i of nexSvg.iterateSvg({ 'id': 'out' })) {
		Dom.css(i, { 'fill': Dom.styles(Dom.root()).color });
	}
	return val;
}

nexAnime.crawl = val => {
	const items = Dom.byAll('.nex-crawl', val);
	for (let i = 0; i < items.length; i++) {
		nexEvent.add({
			'to': Dom.parent(items[i], 2),
			'evt': [
				{
					'on': 'mh',
					'act': () => {
						Dom.class(items[i], { 'clsDel': 'nex-crawl' });
					}
				},
				{
					'on': 'mo',
					'act': () => {
						Dom.class(items[i], { 'clsAdd': 'nex-crawl' });
					}
				}
			]
		});
	}
}
