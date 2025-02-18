#!/usr/bin/env node
import { Type } from './type.mjs';
import { Dom } from './dom.mjs';
import { Obj } from './obj.mjs';
import { Int } from './int.mjs';
import { Component } from './components.mjs';
import { Arr } from './arr.mjs';
import { Str } from './str.mjs';
export function Anime()
{
	Obj.methods(Anime);
}

Anime.fa = () => {
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

