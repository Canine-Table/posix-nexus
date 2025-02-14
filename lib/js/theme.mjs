#!/usr/bin/env node

function Theme()
{
	Obj.methods(Theme);
}

Theme.pallet = obj => {
	obj = Dom.skel(obj);
	const pallet = [ 'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark', 'black' ];
	let color = Arr.shortStart(Type.isDefined(obj.color, 'dark'), pallet, ',', 'dark');
	return `text-${color}-emphasis bg-${color} border border-primary`;
}
