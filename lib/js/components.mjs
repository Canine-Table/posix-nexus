#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { Arr } from './arr.mjs';
import { Dom } from './dom.mjs';
import { Str } from './str.mjs';
export function nexComponent()
{
	Obj.methods(nexComponent);
}

nexComponent.variants = [ 'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark' ];
nexComponent.sizes = [ 'sm', 'md', 'lg', 'xl', 'xxl' ];
nexComponent.justify = [ 'evenly', 'between', 'around', 'end', 'start', 'center' ];
nexComponent.location = [ 'start', 'center', 'end' ];
nexComponent.direction = [ 'left', 'right', 'top', 'bottom' ];
nexComponent.containers = [ 'article', 'section', 'div', 'header', 'footer', 'main', 'aside', 'figure', 'nav' ];

nexComponent.options = (val, opt, def) => {
	if (! Type.isDefined(def))
		def = '';
	if (Type.isDefined(val) && Type.isDefined(opt)) {
		return Arr.shortStart(val, opt, ',', def);
	}
	return def;
}

//| Button |///////////////////////////////////////////////////////////////////////////////////////////////|
nexComponent.button = obj => {
	obj = Dom.skel(obj);
	const cls = [ 'btn' ];
	if (Type.isDefined(obj.variant)) {
		obj.variant = nexComponent.options(obj.variant, Arr.add(nexComponent.variants, 'link'), 'primary');
		if (Type.isTrue(obj.outline))
			obj.variant = `outline-${obj.variant}`;
		cls.push(`btn-${obj.variant}`);
	}
	if (Type.isDefined(obj.size)) {
		obj.size = nexComponent.options(obj.size, nexComponent.sizes);
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
		obj.prop['data-bs-placement'] = nexComponent.options(obj.direction, nexComponent.direction, 'top');
	} else if (Type.isTrue(obj.dropdown)) {
		cls.push('dropdown-toggle');
		obj.prop['data-bs-toggle'] = 'dropdown';
		obj.prop['aria-expanded'] = 'false';
		if (Type.isTrue(obj.split))
			cls.push('dropdown-toggle-split');
	}
	//| Carousel |/////////////////////////////////////////////////////////////////////////////////////////////|	
	if (Type.isTrue(obj.carousel)) {
		if (Type.isTrue(obj.next)) {
			obj.prop['data-bs-target'] = `#${obj.for}`;
			cls.push('carousel-control-next');
			obj.prop['data-bs-slide'] = 'next';
			obj.prop.type = 'button';
		} else if (Type.isTrue(obj.prev)) {
			obj.prop['data-bs-target'] = `#${obj.for}`;
			cls.push('carousel-control-prev');
			obj.prop['data-bs-slide'] = 'prev';
			obj.prop.type = 'button';
		}
	}
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.nav)) {
		if (Type.isDefined(obj.toggle)) {
			if (cls[0] === 'btn')
				cls.shift(1);
			obj.toggle = nexComponent.options(obj.toggle, [ 'collapse', 'offcanvas' ], 'collapse');
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

nexComponent.list = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (Type.isTrue(obj.ordered))
		obj.tag = 'ol';
	else
		obj.tag = 'ul';
	if (Type.isDefined(obj.size))
		obj.size = nexComponent.options(obj.size, nexComponent.sizes);
	if (Type.isDefined(obj.location))
		obj.location = nexComponent.options(obj.location, nexComponent.location);
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
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.nav)) {
		cls.push(`nav ${Str.conditional(obj.location, 'justify-content-')}`);
		if (Type.isTrue(obj.tab))
			cls.push('nav-tabs');
		if (Type.isTrue(obj.pill))
			cls.push('nav-pills');	
		if (Type.isTrue(obj.underline))
			cls.push('nav-underline');
		if (Type.isTrue(obj.fill))
			cls.push('nav-fill');
		if (Type.isTrue(obj.justify))
			cls.push('nav-justified');

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
nexComponent.link = obj => {
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
		if (Type.isTrue(obj.link))
			cls.push('nav-link')
	}
	if (! Type.isDefined(obj.prop.href))
		obj.prop.href = '#';
	if (Type.isDefined(obj.variant)) {
		obj.variant = nexComponent.options(obj.variant, Arr.add(nexComponent.variants, 'body-emphasis'), 'primary');
		cls.push(`link-${obj.variant}`);
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|

	return Dom.apply({
		'tag': 'a',
		'id': obj.id,
		'htmlIn': `${Str.conditional(obj.fa, '<i class="fa ', '"></i> ')}${obj.text}`,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Item |/////////////////////////////////////////////////////////////////////////////////////////////////|
nexComponent.item = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.nav)) {
		if (Type.isTrue(obj.item))
			cls.push('nav-item')
	}
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
nexComponent.navbar = obj => {
	obj = Dom.skel(obj);
	const cls = [ `navbar bg-body-${nexComponent.options(obj.variant, Arr.add(nexComponent.variants, 'tertiary'), 'tertiary')}` ];
	obj.direction = nexComponent.options(obj.direction, nexComponent.direction, 'top');
	if (Type.isTrue(obj.fixed))
		cls.push(`fixed-${obj.direction}`);
	else if (Type.isTrue(obj.sticky))
		cls.push(`sticky-${obj.direction}`);
	if (Type.isDefined(obj.size))
		cls.push(`navbar-expand-${nexComponent.options(obj.size, nexComponent.sizes, 'lg')}`);
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
nexComponent.div = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	obj.tag = nexComponent.options(obj.tag, nexComponent.containers, 'div');
	if (Type.isDefined(obj.size))
		obj.size = nexComponent.options(obj.size, Arr.add(nexComponent.sizes, 'fluid'), 'fluid');
	if (Type.isDefined(obj.location))
		obj.location = nexComponent.options(obj.location, nexComponent.location);
	//| Carousel |/////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.carousel)) {
		if (Type.isTrue(obj.inner)) {
			cls.push('carousel-inner');
		} else if (Type.isTrue(obj.item)) {
			if (Type.isIntegral(obj.iterval))
				obj.prop['data-bs-interval'] = obj.interval;
			cls.push('carousel-item');
		} else if (Type.isTrue(obj.caption)) {
			cls.push(`carousel-caption d-none d-${nexComponent.options(obj.size, nexComponent.sizes, 'md')}-block`);
		} else {
			if (Type.isTrue(obj.fade))
				cls.push('carousel-fade');
			if (Type.isTrue(obj.auto))
				obj.prop['data-bs-ride'] = 'carousel';
			if (Type.isFalse(obj.touch))
				obj.prop['data-bs-touch'] = false;
			cls.push('carousel slide');
		}
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
	} else if (Type.isTrue(obj.nav)) {
		obj.toggle = nexComponent.options(obj.toggle, [ 'collapse', 'offcanvas' ], 'collapse');
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
	} else if (Type.isDefined(obj.alert)) {
		cls.push('alert');
		obj.prop.role = 'alert';
		cls.push(`alert-${nexComponent.options(obj.alert, nexComponent.variants, 'primary')}`);
	} else {
		cls.push(`container${Str.conditional(obj.size, '-')}`);
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': obj.tag,
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.clsSet} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Span |/////////////////////////////////////////////////////////////////////////////////////////////////|
nexComponent.span = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	//| Carousel |/////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.carousel)) {
		if (Type.isTrue(obj.next)) {
			cls.push('carousel-control-next-icon');
			obj.prop['aria-hidden'] = true;
		} else if (Type.isTrue(obj.prev)) {
			cls.push('carousel-control-prev-icon');
			obj.prop['aria-hidden'] = true;
		} else {
			cls.push('visually-hidden');
		}
	}
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
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
nexComponent.header = obj => {
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

nexComponent.hrule = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	//| Dropdown |/////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.dropdown))
		cls.push('dropdown-divider');
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return Dom.apply({
		'tag': 'hr',
		'id': obj.id,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

//| Image |////////////////////////////////////////////////////////////////////////////////////////////////|
nexComponent.image = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (! Type.isDefined(obj.alt))
		obj.prop.alt = '...';
	else
		obj.prop.alt = obj.alt;
	if (! Type.isIntegral(obj.width))
			obj.width = window.innerWidth;
	obj.prop.width = obj.width;
	if (! Type.isIntegral(obj.height))
		obj.height = window.innerHeight;
	obj.prop.height = obj.height;
	if (Type.isTrue(obj.random) || ! Type.isDefined(obj.src)) {
		const opts = [];
		if (! Type.isIntegral(obj.count))
			obj.count = 1;
		if (Type.isTrue(obj.grayscale))
			opts.push('&grayscale');	
		if (Type.isDefined(obj.blur)) {
			opts.push('&blur');
			if (Arr.in(obj.header, Arr.range('<10', 1)))
				opts.push(`=${obj.blur}`);
		}
		obj.prop.src = `https://picsum.photos/${obj.width}/${obj.height}?random=${obj.count}`;
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

nexComponent.footer = obj => {
	obj = Dom.skel(obj);
	const cls = [ 'py-3 my-4' ]
	return Dom.apply({
		'tag': 'footer',
		'id': obj.id,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

nexComponent.p = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	return Dom.apply({
		'tag': 'p',
		'id': obj.id,
		'textIn': obj.text,
		'clsSet': `${Str.implode(cls, ' ')} ${obj.cls}`,
		'css': obj.css,
		'prop': obj.prop
	});
}

nexComponent.meta = (elm, arr, tag) => {
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

