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

nexComponent.variants = [
	'primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark'
];
nexComponent.sizes = [
	'sm', 'md', 'lg', 'xl', 'xxl'
];
nexComponent.justify = [
	'evenly', 'between', 'around', 'end', 'start', 'center'
];
nexComponent.location = [
	'start', 'center', 'end'
];
nexComponent.direction = [
	'left', 'right', 'top', 'bottom'
];
nexComponent.containers = [
	'article', 'section', 'div', 'header', 'footer', 'main', 'aside', 'figure', 'nav'
];
nexComponent.formMethods = [
	'get', 'put', 'post', 'delete', 'patch'
];
nexComponent.formTargets = [
	'_self', '_blank', '_parent', '_top'
];
nexComponent.formEncrypt = [
	'text/plain', 'multipart/form-data', 'application/x-www-form-urlencoded'
];
nexComponent.inputTypes = [
	'text', 'password', 'email', 'tel', 'url', 'number', 'range', 'date', 'time',
	'datetime-local', 'month', 'week', 'color', 'checkbox', 'radio', 'file', 'submit',
	'button', 'reset', 'search', 'hidden'
];

nexComponent.options = (val, opt, def) => {
	if (! Type.isDefined(def))
		def = '';
	if (Type.isDefined(val) && Type.isDefined(opt)) {
		return Arr.shortStart(val, opt, ',', def);
	}
	return def;
}

nexComponent.text = (val, obj) => {
	if (Type.isDefined(val)) {
		if (Type.isObject(obj)) {
			if (Type.isTrue(obj.ct))
				val = `<cite>${val}</cite>`;
			if (Type.isTrue(obj.bq))
				val = `<blockquote>${val}</blockquote>`;
			if (Type.isTrue(obj.ab))
				val = `<abbr>${val}</abbr>`;
			if (Type.isTrue(obj.mk))
				val = `<mark>${val}</mark>`;
			if (Type.isTrue(obj.fg))
				val = `<figcaption>${val}</figcaption>`;
			if (Type.isTrue(obj.si))
				val = `<s>${val}</s>`;
			if (Type.isTrue(obj.sm))
				val = `<small>${val}</small>`;
			if (Type.isTrue(obj.in))
				val = `<ins>${val}</ins>`;
			if (Type.isTrue(obj.ul))
				val = `<u>${val}</u>`;
			if (Type.isTrue(obj.em))
				val = `<em>${val}</em>`;
			if (Type.isTrue(obj.dl))
				val = `<del>${val}</del>`;
			if (Type.isTrue(obj.st))
				val = `<strong>${val}</strong>`;
		}
		return val;
	}
}

nexComponent.done = (tag, arr, obj) => {
	if (Type.isDefined(tag) && Type.isArray(arr) && Type.isObject(obj)) {
		return Dom.apply({
			'tag': tag,
			'id': obj.id,
			'htmlIn': nexComponent.text(obj.text, obj),
			'clsSet': `${Str.implode(arr, ' ')} ${obj.clsSet} ${obj.cls}`,
			'css': obj.css,
			'prop': obj.prop
		});
	}
}

//| Button |///////////////////////////////////////////////////////////////////////////////////////////////|
nexComponent.button = obj => {
	obj = Dom.skel(obj);
	const cls = [ 'btn' ];
	if (! Type.isDefined(obj.tag))
		obj.tag = 'button';
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
	//| Carousel |/////////////////////////////////////////////////////////////////////////////////////////////|	
	} else if (Type.isTrue(obj.carousel)) {
		if (cls[0] === 'btn')
			cls.shift(1);
		obj.prop['data-bs-target'] = `#${obj.for}`;
		obj.prop.type = 'button';
		if (Type.isTrue(obj.next)) {
			cls.push('carousel-control-next');
			obj.prop['data-bs-slide'] = 'next';
		} else if (Type.isTrue(obj.prev)) {
			cls.push('carousel-control-prev');
			obj.prop['data-bs-slide'] = 'prev';
		} else if (Type.isIntegral(obj.slide)) {
			obj.prop['data-bs-slide-to'] = obj.slide;
			obj.prop['aria-label'] = `Slide ${obj.slide + 1}`;
		}
	//| Navbar |///////////////////////////////////////////////////////////////////////////////////////////////|
	} else if (Type.isTrue(obj.nav)) {
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
	} else if (Type.isTrue(obj.form)) {
		if (Type.isDefined(obj.submit)) {
			obj.prop.type = 'submit';
		}
	}
	if (! Type.isDefined(obj.prop.type)) {
		obj.prop.type = 'button';
		if (! Type.isDefined(obj.prop['data-bs-toggle']))
			obj.prop['data-bs-toggle'] = 'button';
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done(obj.tag, cls, obj);
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
	return nexComponent.done(obj.tag, cls, obj);
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
	obj.text = `${Str.conditional(obj.fa, '<i class="fa ', '"></i> ')}${nexComponent.text(obj.text, obj)}`;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done('a', cls, obj);
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
	return nexComponent.done('li', cls, obj);
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
	return nexComponent.done('nav', cls, obj);
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
		} else if (Type.isTrue(obj.indicators)) {
			cls.push('carousel-indicators');
		} else {
			if (Type.isTrue(obj.fade))
				cls.push('carousel-fade');
			if (Type.isTrue(obj.auto))
				obj.prop['data-bs-ride'] = 'carousel';
			else if (Type.isFalse(obj.auto))
				obj.prop['data-bs-ride'] = true;
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
	} else if (Type.isTrue(obj.form)) {
		cls.push('mb-3');
		if (Arr.in(obj.type, [ 'radio', 'checkbox' ])) {
			if (type.isTrue(obj.inline))
				cls.push('form-check-inline');
			if (type.isTrue(obj.reverse))
				cls.push('form-check-reverse');
			if (obj.type === 'checkbox') {
				cls.push('form-check');
				if (Type.isTrue(obj.toggle))
					cls.push('form-switch');
			}
		} else if (Type.isTrue(obj.group)) {
			cls.push( 'input-group')
			if (Type.isDefined(obj.size))
				cls.push(`input-group-${nexComponent.options(obj.size, nexComponent.sizes, 'md')}`);
		}
	} else if (Type.isTrue(obj.float)) {
			if (! Type.isTrue(obj.group))
				cls.push('mb-3');
			cls.push('form-floating');
	} else {
		cls.push(`container${Str.conditional(obj.size, '-')}`);
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done(obj.tag, cls, obj);
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
	return nexComponent.done('span', cls, obj);
}

//| Header |///////////////////////////////////////////////////////////////////////////////////////////////|
nexComponent.h = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	obj.h = Arr.in(obj.h, Arr.range('<6', 1)) ? obj.h : 6;
	if (Type.isTrue(obj.nav)) {
		cls.push('offcanvas-title');
	}
	if (Type.isTrue(obj.display))
		cls.push(`display-${obj.h}`);
	if (Type.isTrue(obj.secondary))
		cls.push('text-secondary');
	if (Type.isDefined(obj.align))
		cls.push(`text-${nexComponent.options(obj.align, nexComponent.align, 'center')}`);
	cls.push(`h${obj.h}`);
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done(`h${obj.h}`, cls, obj);
}

nexComponent.hrule = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	//| Dropdown |/////////////////////////////////////////////////////////////////////////////////////////////|
	if (Type.isTrue(obj.dropdown))
		cls.push('dropdown-divider');
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done('hr', cls, obj);
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
	return nexComponent.done('img', cls, obj);
}

nexComponent.footer = obj => {
	obj = Dom.skel(obj);
	const cls = [ 'py-3 my-4' ]
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done('footer', cls, obj);
}

nexComponent.p = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (Type.isTrue(obj.secondary))
		cls.push('text-body-secondary');
	if (Type.isDefined(obj.align))
		cls.push(`text-${nexComponent.options(obj.align, nexComponent.align, 'center')}`);
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done('p', cls, obj);
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

nexComponent.input = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (obj.type === 'area') {
		obj.tag = 'textarea';
	} else {
		obj.tag = 'input';
		obj.prop.type = nexComponent.options(obj.type, nexComponent.inputTypes, 'text');
	}
	if (Type.isTrue(obj.disable))
		obj.prop.disabled = true;
	if (Arr.in(obj.prop.type, [ 'radio', 'checkbox' ])) {
		obj.prop.value = obj.value || '';
		cls.push('form-check-input mt-0');
		if (type.isTrue(obj.check))
			obj.prop.checked = true;
		if (type.isTrue(obj.button))
			cls.push('btn-check');
		if (type.isTrue(obj.toggle) && obj.prop.type === 'checkbox')
			obj.prop.role = 'switch';
	} else {
		cls.push('form-control');
	}
	if (obj.type ===  'file') {
		if (Type.isTrue(obj.multi))
			obj.prop.multiple = true;
	} else if (obj.type === 'color') {
		cls.push('form-control-color');
	}
	if (Type.isDefined(obj.label))
		obj.prop['aria-label'] = obj.label;
	if (Type.isDefined(obj.describe))
		obj.prop['aria-describedby'] = obj.describe;
	if (Type.isDefined(obj.placeholder) || Type.isDefined(obj.float)) {
		obj.prop.placeholder = obj.placeholder || '';
		if (! Type.isDefined(obj.prop['aria-label']));
			obj.prop['aria-label'] = obj.placeholder || '';
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done(obj.tag, cls, obj);
}

nexComponent.label = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	obj.tag = 'label';
	obj.prop.for = obj.for;
	obj.text = obj.label;
	if (Type.isTrue(obj.group)) {
		obj.tag = 'span';
		cls.push('input-group-text');
	} else if (Type.isTrue(obj.form)) {
		cls.push('form-label');
	}
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done(obj.tag, cls, obj);
}

nexComponent.form = obj => {
	obj = Dom.skel(obj);
	const cls = [];
	if (Type.isDefined(obj.action))
		obj.prop.action = obj.action;
	if (Type.isDefined(obj.submit))
		obj.prop.onsubmit = obj.submit;
	if (Type.isFalse(obj.validate))
		obj.prop.novalidate = true;
	if (Type.isDefined(obj.rel))
		obj.prop.rel = obj.rel;
	if (Type.isDefined(obj.name))
		obj.prop.name = obj.name;
	obj.prop.method = nexComponent.options(obj.method, nexComponent.formMethods, 'post');
	obj.prop.enctype = nexComponent.options(obj.enctype, nexComponent.formEncrypt, 'application/x-www-form-urlencoded');
	obj.prop.autocomplete = Type.isTrue(obj.auto) ? 'on' : 'off';
	obj.prop['accept-charset'] = 'UTF-8';
	obj.prop.target = nexComponent.options(obj.target, nexComponent.formTargets, obj.target);
	if (! Type.isDefined(obj.prop.target))
		delete obj.prop.target;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////|
	return nexComponent.done('form', cls, obj);
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

