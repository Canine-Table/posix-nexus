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
	return Dom.body(val).getElementsByTagName(elm);
}

Dom.byName = (val, elm) => {
	return Dom.body(val).getElementsByName(elm);
}

Dom.byClass = (val, elm) => {
	return Dom.body(val).getElementsByClassName(elm);
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
	val = Arr.expandBoolean(val);
	if (! Type.isObject(val.css))
		val.css = {};
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
		Obj.assign(val, undefined, obj);
}

Dom.append = (val, elm) => {
	if (Dom.isElement(val)) {
		if (Dom.isHtml(elm))
			elm.appendChild(val);
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
		val.elm = Type.isHtml(val.elm) ? val.elm : Dom.byId(val.id);
		val.to = Type.isElement(val.to) ? val.to : Dom.body(Dom.byId(val.to));
		val.ref = Type.isHtml(val.ref) ? val.ref : Dom.byId(val.ref);
		if (Dom.isHtml(val.elm)) {
			if (Dom.isHtml(val.ref)) {
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

