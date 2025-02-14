#!/usr/bin/env node
function Dom()
{
	Obj.methods(Dom);
}

Dom.isDocument = val => {
	return val instanceof Document;
}

Dom.isHtml = val => {
	return val instanceof HTMLElement;
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

Dom.byId = (val, elm) => {
	return document.getElementById(val);
}

Dom.byTag = (val, elm) => {
	return Dom.body(val).getElementByTagName(elm);
}

Dom.byClass = (val, elm) => {
	return Dom.body(val).getElementByClassName(elm);
}

Dom.byQuery = (val, elm) => {
	return Dom.body(val).querySelector(elm);
}

Dom.byAll = (val, elm) => {
	return Dom.body(val).querySelectorAll(elm);
}

Dom.setId = val => {
	return (Dom.byId(val) || ! Type.isDefined(val)) ? Str.random(32) : val;
}

Dom.skel = val => {
	if (! Type.isObject(val))
		val = {};
	if (! Type.isObject(val.css))
		val.css = {};
	if (! Type.isObject(val.prop))
		val.prop = {};
	if (! Type.isObject(val.theme))
		val.theme = {};
	return val;
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
			val.classList.add(Str.remove(clsAdd));
	}
}

Dom.toggle = (elm, { val, opt, del, sep, def, pre, post }) => {
	val = Type.isDefined(val, def);
	if (Type.isDefined(val) && Dom.isElement(elm)) {
		//console.log(opt)
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
		Obj.assign(val, 'setAttribute', obj);
}

Dom.append = (val, elm) => {
	if (Dom.isElement(val) && Dom.isElement(elm))
		elm.appendChild(val);
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
	Dom.append(tag, obj.to);
	return tag;
}

