#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { nexComponent } from './components.mjs';
import { Arr } from './arr.mjs';
import { Str } from './str.mjs';
export function Dom()
{
	Obj.methods(Dom);
}

Dom.isDocument = val => {
	return val instanceof Document || val instanceof DocumentType;
}

Dom.isHtml = val => {
	return val instanceof HTMLElement || val instanceof HTMLDocument;
}

Dom.isElement = val => {
	return Dom.isDocument(val) || Dom.isHtml(val);
}

Dom.head = val => {
	if (Dom.isElement(val))
		return val;
	return document.head;
}

Dom.body = val => {
	if (Dom.isElement(val))
		return val;
	return document.body;
}

Dom.document = val => {
	if (Dom.isElement(val))
		return val;
	return document;
}

Dom.byId = (val) => {
	return document.getElementById(val);
}

Dom.byTag = (elm, val) => {
	return Dom.body(val).getElementsByTagName(elm);
}

Dom.byName = (elm, val) => {
	return Dom.body(val).getElementsByName(elm);
}

Dom.byClass = (elm, val) => {
	return Dom.body(val).getElementsByClassName(elm);
}

Dom.byQuery = (elm, val) => {
	return Dom.body(val).querySelector(elm);
}

Dom.byAll = (elm, val) => {
	return Dom.body(val).querySelectorAll(elm);
}

Dom.setId = (val, len) => {
	return (Dom.byId(val) || ! Type.isDefined(val)) ? Str.random(Type.isIntegral(len) ? len : 8) : val;
}

Dom.skel = (val, noexpand) => {
	if (! Type.isObject(val))
		val = {};
	if (! Type.isTrue(noexpand))
		val = Arr.expandBoolean(val);
	if (! Type.isObject(val.css))
		val.css = {};
	if (! Type.isTrue(noexpand))
		val.css = Arr.expandBoolean(val.css);
	if (! Type.isObject(val.prop))
		val.prop = {};
	val.prop = Arr.expandBoolean(val.prop);
	return val;
}

Dom.attr = val => {
	if (Dom.isElement(val))
		return val.attributes;
}

Dom.html = (val, { htmlIn, htmlOut }) => {
	if (Dom.isElement(val)) {
		if (htmlOut)
			val.outerHtml = htmlOut;
		if (htmlIn)
			val.innerHTML = htmlIn;
	}
}

Dom.text = (val, { textOut, textIn }) => {
	if (Dom.isElement(val)) {
		if (textOut)
			val.outerText = textOut;
		if (textIn)
			val.innerText = textIn;
	}
}

Dom.class = (val, { clsSet, clsAdd, clsDel }) => {
	if (Dom.isElement(val)) {
		if (clsSet)
			val.className = Str.remove(clsSet);
		if (clsDel)
			val.classList.remove(Str.remove(clsDel));
		if (clsAdd)
			Type.isArray(Str.remove(clsAdd), ' ').forEach(i => val.classList.add(i));
	}
}

Dom.toggle = (elm, { val, opt, del, sep, def, pre, post }) => {
	val = Type.isDefined(val, def);
	if (Type.isDefined(val) && Dom.isElement(elm)) {
		opt = Type.isArray(opt, sep);
		val = Arr.shortStart(val, opt);
		if (Arr.in(val, opt)) {
			pre = pre || '';
			post = post || '';
			Dom.class(elm, {
				'clsDel': pre + del + post,
				'clsAdd': pre + val + post
			});
			return val;
		}
		return del;
	}
}

Dom.css = (val, obj) => {
	if (Dom.isElement(val) && Type.isObject(obj))
		Obj.assign(val, 'style', obj);
}

Dom.prop = (val, obj) => {
	if (Dom.isElement(val) && Type.isObject(obj))
		Object.entries(obj).forEach(([k, v]) => val.setAttribute(k, v));
}

Dom.append = (val, elm) => {
	if (Dom.isElement(val)) {
		Dom.body(elm).appendChild(val);
		return val;
	}
}

Dom.replace = (val, rpl, elm) => {
	if (Dom.isElement(val)) {
		if (Dom.isElement(rpl))
			Dom.document(elm).replaceChild(val, rpl);
		return val;
	}
}

Dom.apply = (obj, elm) => {
	let tag = '';
	obj = Dom.skel(obj);
	if (Dom.isElement(elm)) {
		tag = elm;
	} else if (Type.isDefined(obj.tag)) {
		tag = document.createElement(obj.tag);
		if (! Type.isFalse(obj.id))
			tag.id = Dom.setId(obj.id);
	} else {
		return;
	}
	Dom.css(tag, obj.css);
	Dom.prop(tag, obj.prop);
	Dom.text(tag, obj);
	Dom.html(tag, obj);
	Dom.class(tag, obj);
	if (! Dom.isElement(elm))
		Dom.append(tag, obj.to);
	return tag;
}

Dom.find = val => {
	if (Type.isObject(val)) {
		const tags = Dom.byTag(Dom.byId(val.id), val.tag);
		if (Type.isDefined(tags)) {
			if (Type.isDefined(val.attr)) {
				const arr = [];
				for (let i = 0; i < tags.length; i++) {
					let node = Dom.attr(tags[i]).getNamedItem(val.attr);
					if (node && (! val.value || node.value === val.value))
						arr.push(tags[i]);
				}
				return arr;
			}
			return tags;
		}
	}
}

Dom.insert = (val, elm) => {
	if (Type.isObject(val)) {
		val.elm = Dom.isElement(val.elm) ? val.elm : Dom.byId(val.id);
		val.to = Dom.isElement(val.to) ? val.to : Dom.body(Dom.byId(val.to));
		val.ref = Dom.isElement(val.ref) ? val.ref : Dom.byId(val.ref);
		if (Dom.isElement(val.elm)) {
			if (Dom.isElement(val.ref)) {
				if (Type.isTrue(val.b4))
					val.to.insertBefore(val.elm, val.ref);
				else
					val.to.insertBefore(val.elm, val.ref.nextSibling);
			} else {
				Dom.append(val.to, val.elm);
			}
			return val.elm;
		}
	}
}

Dom.parent = val => {
	if (Dom.isElement(val));
		return val.parentElement;
}

Dom.isTag = (elm, tag) => {
	if (Dom.isElement(elm))
		return elm.tagName === Str.toUpper(tag);
}

Dom.parentTag = (elm, tag) => {
	if (Dom.isElement(elm) && Type.isDefined(tag)) {
		tag = Str.toUpper(tag);
		while (elm) {
			elm = Dom.parent(elm, tag);
			if (elm && Dom.isTag(elm, tag))
				return elm;
		}
	}
}

Dom.meta = ({ val, mth = 'name', rtn = 'content', tag = 'meta', node = Dom.head() }) => {
	if (Type.isDefined(val)) {
		let res = '';
		Dom.byAll(tag, node).forEach(i => {
			if (i[mth] === val)
				res = i[rtn];
		});
		return res;
	}
}

Dom.doctype = val => {
	const dt = { 'qualifiedName': 'html' }
	switch (val) {
		case 'xs':
			dt.publicid = '-//W3C//DTD XHTML 1.0 Strict//EN';
			dt.systemid = 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd';
			break;
		case 'xt':
			dt.publicid = '-//W3C//DTD XHTML 1.0 Transitional//EN';
			dt.systemid = 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd';
			break;
		case 'xf':
			dt.publicid = '-//W3C//DTD XHTML 1.0 Frameset//EN';
			dt.systemid = 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd';
			break;
		case 'x':
			dt.publicid = '-//W3C//DTD XHTML 1.1//EN';
			dt.systemid = 'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd';
			break;
		case 's':
			dt.publicid = '-//W3C//DTD HTML 4.01//EN';
			dt.systemid = 'http://www.w3.org/TR/html4/strict.dtd';
			break;
		case 't':
			dt.publicid = '-//W3C//DTD HTML 4.01 Transitional//EN';
			dt.systemid = 'http://www.w3.org/TR/html4/loose.dtd';
			break;
		case 'f':
			dt.publicid = '-//W3C//DTD HTML 4.01 Frameset//EN';
			dt.systemid = 'http://www.w3.org/TR/html4/frameset.dtd';
			break;	
		case '':
			dt.publicid = '';
			dt.systemid = '';
			break;
		default:
			return document.doctype;
	}
	dt.d = document.implementation.createDocumentType(dt.qualifiedName, dt.publicid, dt.systemid)
	if(! Type.isDefined(document.doctype))
		Dom.insert({
			'to': document,
			'b4': true,
			'ref': document.documentElement,
			'elm': dt.d
		});
	else
		Dom.replace(dt.d, document.doctype);
}

Dom.boilerplate = ({
	lang = 'en',
	dir = 'ltr',
	title = 'website',
	description = 'A brief description of the document',
	keywords = 'HTML, CSS, JavaScript',
	author = 'John Doe',
	robots = 'index,follow',
	googlebot = 'index,follow',
	referrer = 'no-referrer',
	app = 'bootstraped',
	icon = 'https://static-00.iconduck.com/assets.00/404-page-not-found-illustration-512x319-sk5drr0e.png',
	refresh = 3600,
	expires = 0,
	cache = 'no-cache',
	doctype = '',
	links,
	scripts,
	theme
}) => {
	const bp = Dom.apply({
		'tag': 'html',
		'id': false,
		'prop': {
			'lang': lang,
			'dir': dir,
			'title': title
		}
	});
	const hd = Dom.append(Dom.apply({
		'tag': 'head',
		'id': false,
	}), bp);
	Dom.append(Dom.apply({
		'tag': 'title',
		'id': false,
		'textIn': title
	}), hd);
	nexComponent.meta(hd, [
		{ 'charset': 'UTF-8' },
		{ 'name': 'viewport', 'content': 'width=device-width, initial-scale=1.0' },
		{ 'name': 'description', 'content': description },
		{ 'name': 'keywords', 'content': keywords },
		{ 'name': 'author', 'content': author },
		{ 'name': 'robots', 'content': robots },
		{ 'name': 'googlebot', 'content': googlebot },
		{ 'name': 'referrer', 'content': referrer },
		{ 'name': 'application-name', 'content': app },
		{ 'name': 'content-security-policy', 'content': 'default-src "self"' },
		{ 'http-equiv': 'X-UA-Compatible', 'content': 'IE=edge' },
		{ 'http-equiv': 'refresh', 'content': refresh },
		{ 'http-equiv': 'cach-control', 'content': cache },
		{ 'http-equiv': 'expires', 'content': expires },
	]);
	Obj.expandPaths(hd, links);
	const bd = Dom.append(Dom.apply({
		'tag': 'body',
		'id': false,
		'prop': {
			'data-bs-theme': nexComponent.options(theme, [ 'light', 'dark' ], 'dark')
		}
	}), bp);
	Obj.expandPaths(bd, scripts);
	Dom.replace(bp, document.documentElement);
	Dom.doctype(doctype);
}

