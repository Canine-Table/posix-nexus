#!/usr/bin/env node
function Misc()
{
	Misc.methods(Misc);
}

Misc.methods = val => {
	if (val instanceof Object)
		console.log(Object.getOwnPropertyNames(val).filter(m => typeof val[m] === 'function'));
}

