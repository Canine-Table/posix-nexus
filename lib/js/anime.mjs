#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { Int } from './int.mjs';
import { nexNode } from './components/nex-node.mjs';
import { nexSvg } from './components/nex-svg.mjs';
import { nexEvent } from './event.mjs';
import { Arr } from './arr.mjs';
import { Str } from './str.mjs';
export function nexAnime()
{
	Obj.methods(nexAnime);
}

nexAnime.setTheme = val => {
	const theme = window.sessionStorage.getItem('data-bs-theme');
	if (! (Type.isDefined(val) && Arr.in(val, [ 'light', 'dark' ]))) {
		if (Type.isDefined(theme))
			val = theme;
		else if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches)
			val = 'dark';
		else
			val = 'light';
	}
	if (val !== theme)
		window.sessionStorage.setItem('data-bs-theme', val);
	nexNode.SetAttr(nexNode.Root, { 'data-bs-theme': val });
	return val;
}


nexAnime.setOpacity = async function(elm) {
	//if (elm instanceof nexSvg)) {
//
	//}
}
