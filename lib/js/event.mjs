#!/usr/bin/env node
import { Type } from './type.mjs';
import { Str } from './str.mjs';
import { Obj } from './obj.mjs';
import { Int } from './int.mjs';
import { nexNode } from './components/nex-node.mjs';

export function nexEvent()
{
	Obj.methods(nexEvent);
}

nexEvent.add = obj => {
	if (nexNode.IsNode(obj.to) && Type.isArray(obj.evt)) {
		obj.evt.forEach(evt => {
			switch (evt.on) {
				case 'c':
					evt.on = 'click';
					break;
				case 'dc':
					evt.on = 'dblclick';
					break;
				case 'md':
					evt.on = 'mousedown';
					break;
				case 'mh':
					evt.on = 'mouseover';
					break;
				case 'mo':
					evt.on = 'mouseout';
					break;
				case 'mm':
					evt.on = 'mousemove';
					break;
				case 'me':
					evt.on = 'mouseenter';
					break;
				case 'mu':
					evt.on = 'mouseup';
					break;
				case 'md':
					evt.on = 'mousedown';
					break;
				case 'ml':
					evt.on = 'mouseleave';
					break;
				case 'kd':
					evt.on = 'keydown';
					break;
				case 'ku':
					evt.on = 'keyup';
					break;
				case 'kp':
					evt.on = 'keypress';
					break;
				case 'ts':
					evt.on = 'touchstart';
					break;
				case 'te':
					evt.on = 'touchend';
					break;
				case 'tm':
					evt.on = 'touchmove';
					break;
				case 'tc':
					evt.on = 'touchcancel';
					break;
				case 's':
					evt.on = 'submit';
					break;
				case 'r':
					evt.on = 'reset';
					break;
				case 'i':
					evt.on = 'input';
					break;
				case 'c':
					evt.on = 'change';
					break;
				case 'f':
					evt.on = 'focus';
					break;
				case 'b':
					evt.on = 'blur';
					break;
				case 'l':
					evt.on = 'load';
					break;
				case 'd':
					evt.on = 'DOMContentLoaded';
					break;
				default:
					return;
			}
			if (Type.isFunction(evt.act)) {
				obj.to.addEventListener(evt.on, evt.act);
			}
		});
	}
}

nexEvent.mutation = (ml, obs) => {
	for (const m of ml) {
		switch(m.type) {
			case 'childList':
				console.log("A child node has been added or removed.");
				break;
			case 'attributes':
				console.log(`The ${m.attributeName} attribute was modified.`);
				break;
		}
	}
}

nexEvent.overflow = (elm) => {
    return elm.scrollHeight > elm.offsetHeight || elm.scrollWidth > elm.offsetWidth;
}

nexEvent.throttle = (func, limit) => {
	let lastFunc;
	let lastRan;
	return function(...args) {
		const now = Date.now();
		if (!lastRan || now - lastRan >= limit) {
			func.apply(this, args);
			lastRan = now;
		} else {
			clearTimeout(lastFunc);
			lastFunc = setTimeout(() => {
				if (now - lastRan >= limit) {
					func.apply(this, args);
					lastRan = now;
				}
			}, limit - (now - lastRan));
		}
	};
}

nexEvent.debounce = (func, delay) => {
	let timeoutId;
	return function(...args) {
		clearTimeout(timeoutId);
		timeoutId = setTimeout(() => func.apply(this, args), delay);
	};
}

nexEvent.delay = (ms) => new Promise(resolve => setTimeout(resolve, ms));
