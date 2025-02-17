#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { Arr } from './arr.mjs';
import { Dom } from './dom.mjs';
import { Str } from './str.mjs';
export function Component()
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

//| Button |///////////////////////////////////////////////////////////////////////////////////////////////|
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
		obj.prop['data-bs-placement'] = Component.options(obj.direction, Component.direction, 'top');
	} else if (Type.isTrue(obj.dropdown)) {
		cls.push('dropdown-toggle');
		obj.prop['data-bs-toggle'] = 'dropdown';
		obj.prop['aria-expanded'] = 'false';
		if (Type.isTrue(obj.split))
			cls.push('dropdown-toggle-split');
	}
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.nav)) {
		if (Type.isDefined(obj.toggle)) {
			if (cls[0] === 'btn')
				cls.shift(1);
			obj.toggle = Component.options(obj.toggle, [ 'collapse', 'offcanvas' ], 'collapse');
			obj.prop['area-label'] = obj.label;
			if (Type.isTrue(obj.close)) {
				obj.prop['data-bs-dismiss'] = obj.toggle;
				cls.push('btn-close');
				obj.prop.type = 'button';
			} else {
				obj.prop['data-bs-toggle'] = obj.toggle;
				obj.prop['data-bs-target'] = `#${obj.target}`;
				obj.prop['aria-controls'] = obj.target;
				obj.prop['aria-expanded'] = Type.isTrue(obj.expanded);
				cls.push('navbar-toggler');
			}
		}
	}
	if (! Type.isDefined(obj.prop.type)) {
		obj.prop.type = 'button';
		if (! Type.isDefined(obj.prop['data-bs-toggle']))
			obj.prop['data-bs-toggle'] = 'button';
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
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
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': obj.tag,
		'id': obj.id,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Link |/////////////////////////////////////////////////////////////////////////////////////////////////|
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
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.nav)) {
		if (Type.isTrue(obj.brand))
			cls.push('navbar-brand')
	}
	if (! Type.isDefined(obj.prop.href))
		obj.prop.href = '#';
	if (Type.isDefined(obj.variant)) {
		obj.variant = Component.options(obj.variant, Arr.add(Component.variants, 'body-emphasis'), 'primary');
		cls.push(`link-${obj.variant}`);
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': 'a',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Item |/////////////////////////////////////////////////////////////////////////////////////////////////|
Component.item = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': 'li',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
Component.navbar = obj => {
	obj = Dom.skel(obj);
	const cls = [ `navbar bg-body-${Component.options(obj.variant, Arr.add(Component.variants, 'tertiary'), 'tertiary')}` ];
	obj.direction = Component.options(obj.direction, Component.direction, 'top');
	if (Type.isTrue(obj.fixed))
		cls.push(`fixed-${obj.direction}`);
	else if (Type.isTrue(obj.sticky))
		cls.push(`sticky-${obj.direction}`);
	if (Type.isDefined(obj.size))
		cls.push(`navbar-expand-${Component.options(obj.size, Component.sizes, 'lg')}`);
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': 'nav',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Div |//////////////////////////////////////////////////////////////////////////////////////////////////|
Component.div = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (Type.isDefined(obj.size))
		obj.size = Component.options(obj.size, Arr.add(Component.sizes, 'fluid'), 'fluid');
	if (Type.isDefined(obj.location))
		obj.location = Component.options(obj.location, Component.location);
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.nav)) {
		obj.toggle = Component.options(obj.toggle, [ 'collapse', 'offcanvas' ], 'collapse');
		if (Type.isTrue(obj.header) && obj.toggle === 'offcanvas') {
			cls.push('offcanvas-header');
		} else if (Type.isTrue(obj.body) && obj.toggle === 'offcanvas') {
			cls.push('offcanvas-body');
		} else {
			cls.push(`${obj.toggle}`);
			if (obj.toggle === 'collapse') {
				cls.push(`navbar-${obj.toggle}`);
			} else {
				cls.push(`${Str.conditional(obj.location, `${obj.toggle}-`)}`);
				obj.prop.tabindex = '-1';
				if (Type.isDefined(obj.label))
					obj.prop['aria-labelledby'] = obj.label;
			}
		}
	} else {
		cls.push(`container${Str.conditional(obj.size, '-')}`);
	}
	if (Type.isDefined(obj.alert)) {
		cls.push('alert');
		obj.prop.role = 'alert';
		cls.push(`alert-${Component.options(obj.alert, Component.variants, 'primary')}`);
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': 'div',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Span |/////////////////////////////////////////////////////////////////////////////////////////////////|
Component.span = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (Type.isTrue(obj.nav)) {
		if (Type.isTrue(obj.icon))
			cls.push('navbar-toggler-icon');
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': 'span',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Header |///////////////////////////////////////////////////////////////////////////////////////////////|
Component.header = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	obj.header = Arr.in(obj.header, Arr.range('<6', 1)) ? obj.header : 6;
	if (Type.isTrue(obj.nav)) {
		cls.push('offcanvas-title');
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': `h${obj.header}`,
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Image |////////////////////////////////////////////////////////////////////////////////////////////////|
Component.image = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (! Type.isDefined(obj.alt))
		obj.prop.alt = '...';
	else
		obj.prop.alt = obj.alt;
	if (Type.isTrue(obj.random) || ! Type.isDefined(obj.src)) {
		const opts = [];
		if (! Type.isNumeric(obj.width))
			obj.width = 192;
		if (! Type.isNumeric(obj.height))
			obj.height = 108
		if (! Type.isNumeric(obj.count))
			obj.count = 1;
		if (Type.isTrue(obj.grayscale))
			opts.push('&grayscale');	
		if (Type.isDefined(obj.blur)) {
			opts.push('&blur');
			if (Arr.in(obj.header, Arr.range('<10', 1)))
				opts.push(`=${obj.blur}`);
		}
		obj.prop.src = `https://picsum.photos/${obj.height}/${obj.width}?random=${obj.count}`;
		
		
	} else {
		obj.prop.src = obj.src;
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': 'img',
		'id': obj.id,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

Component.meta = (elm, arr, tag) => {
	if (Dom.isElement(elm) && Type.isArray(arr)) {
		if (! Type.isDefined(tag))
			tag = 'meta';
		arr.forEach(i => {
			Dom.append(Dom.apply({
				'tag': tag,
				'id': false,
				'prop': i
			}), elm);
		});
		return elm;
	}
}

//| Dropdown |/////////////////////////////////////////////////////////////////////////////////////////////|
//| Footer |///////////////////////////////////////////////////////////////////////////////////////////////|
//| Button |///////////////////////////////////////////////////////////////////////////////////////////////|
//| List |/////////////////////////////////////////////////////////////////////////////////////////////////|
//| Paragraph |////////////////////////////////////////////////////////////////////////////////////////////|
//| Span |/////////////////////////////////////////////////////////////////////////////////////////////////|
//| Setup |////////////////////////////////////////////////////////////////////////////////////////////////|
//| Prop |/////////////////////////////////////////////////////////////////////////////////////////////////|
///////////////////////////////////////////////////////////////////////////////////////////////////////////|

