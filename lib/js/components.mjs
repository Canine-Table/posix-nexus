#!/usr/bin/env node

function Component()
{
	Obj.methods(Component);
}

Component.variants = [ 'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark' ];
Component.sizes = [ 'sm', 'md', 'lg', 'xl', 'xxl' ];
Component.justify = [ 'evenly', 'between', 'around', 'end', 'start', 'center' ];
Component.location = [ 'start', 'center', 'end' ];
Component.direction = [ 'left', 'right', 'top', 'bottom' ];

Component.options = (val, opt, def) => {
	if (! Type.isDefined(def))
		def = '';
	if (Type.isDefined(val) && Type.isDefined(opt)) {
		return Arr.shortStart(val, opt, ',', def);
	}
	return def;
}

Component.button = obj => {
	obj = Dom.skel(obj);
	const cls = [ 'btn' ];
	if (Type.isDefined(obj.variant)) {
		obj.variant = Component.options(obj.variant, Arr.add(Component.variants, 'link'), 'primary');
		if (Type.isTrue(obj.outline))
			obj.variant = `outline-${obj.variant}`;
		cls.push(`btn-${obj.variant}`);
	}
	if (Type.isDefined(obj.size)) {
		obj.size = Component.options(obj.size, Component.sizes);
		if (Type.isDefined(obj.size))
			cls.push(`btn-${obj.size}`);
	}
	if (Type.isTrue(obj.group)) {
		cls.push('list-group-item');
		if (Type.isTrue(obj.action))
			cls.push('list-group-item-action');
	}
	if (Type.isTrue(obj.dropitem))
		cls.push('dropdown-item');
	if (Type.isDefined(obj.tooltip)) {
		obj.prop['data-bs-toggle'] = 'tooltip';
		obj.prop['data-bs-title'] = obj.tooltip;
		obj.prop['data-bs-html'] = true;
		if (Type.isDefined(obj.direction))
			obj.prop['data-bs-placement'] = Component.options(obj.direction, Component.direction, 'top');
		else
			obj.prop['data-bs-placement'] = 'top';
	} else if (Type.isTrue(obj.dropdown)) {
		cls.push('dropdown-toggle');
		obj.prop['data-bs-toggle'] = 'dropdown';
		obj.prop['aria-expanded'] = 'false';
		if (Type.isTrue(obj.split))
			cls.push('dropdown-toggle-split');
	}
	if (! Type.isDefined(obj.prop.type))
		obj.prop.type = 'button';
	if (! Type.isDefined(obj.prop['data-bs-toggle']))
		obj.prop['data-bs-toggle'] = 'button';
	return Dom.apply({
		'tag': 'button',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

Component.list = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (Type.isTrue(obj.ordered))
		obj.tag = 'ol';
	else
		obj.tag = 'ul';
	if (Type.isDefined(obj.size))
		obj.size = Component.options(obj.size, Component.sizes);
	if (Type.isDefined(obj.location))
		obj.location = Component.options(obj.location, Component.location);
	if (Type.isTrue(obj.group)) {
		delete obj.group;
		cls.push('list-group');
		if (Type.isTrue(obj.flush)) {
			delete obj.flush;
			cls.push('list-group-flush');
		}
		if (Type.isTrue(obj.numbered)) {
			delete obj.numbered;
			cls.push('list-group-numbered');
		}
		if (Type.isTrue(obj.horizontal)) {
			delete obj.horizontal;
			cls.push(`list-group-horizontal${Str.conditional(obj.size, '-')}`);
		}
	}
	if (Type.isTrue(obj.dropdown)) {
		cls.push('dropdown-menu');
	}
	return Dom.apply({
		'tag': obj.tag,
		'id': obj.id,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

Component.link = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (Type.isTrue(obj.prop.disabled)) {
		delete obj.prop.disabled;
		cls.push('disabled');
		obj.prop['aria-disabled'] = 'true';
	}
	if (Type.isTrue(obj.dropdown)) {
		delete obj.dropdown;
		cls.push('dropdown-item');
	}	

	if (Type.isDefined(obj.variant)) {
		obj.variant = Component.options(obj.variant, Arr.add(Component.variants, 'body-emphasis'), 'primary');
		cls.push(`link-${obj.variant}`);
	}
	return Dom.apply({
		'tag': 'a',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

Component.item = obj => {
	obj = Dom.skel(obj);
	const cls = [];

	return Dom.apply({
		'tag': 'li',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

Component.navbar = obj => {

}
