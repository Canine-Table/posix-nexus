#!/usr/bin/env node
function tabSwitching(evt, tabIDs)
{
	let tabPanelContents = document.getElementsByClassName('container-tab');
	 tabPanelContents
	for (let i = 0; i < tabPanelContents.length; i++) {
		tabPanelContents[i].style.display = 'none';
	}
	let tabButtons = document.getElementsByClassName('tab-button');
	for (let i = 0; i < tabButtons.length; i++) {
		tabButtons[i].className = tabButtons[i].className.replace(' active', '');
	}
	document.getElementById(tabIDs).style.display = 'flex';
	evt.currentTarget.className += ' active';
}

function findTag(obj)
{
	if (isObjectType(obj) && isDefinedType(obj.tag)) {
		let content = document.body.getElementsByTagName(obj.tag);
		if (isDefinedType(obj.prop)) {
			let nodes = new Array();
			for (let i = 0; i < content.length; i++) {
				let node = content[i].attributes.getNamedItem(obj.prop);
				if (! isNullType(node) && (! isDefinedType(obj.val) || node.value === obj.val))
					nodes.push(content[i]);
			}
			return nodes;
		}
		return content;
	}
}

function getTagId(id, tag)
{
	if (! isFalseType(id)) {
		if (! isDefinedType(document.getElementById(id)))
			id = undefined;
		if (! isDefinedType(tag))
			tag = 'tag';
		return isDefinedType(id, tag + "-" + randomString(32));
	}
}

function addCss(tag, obj)
{
	if (isObjectType(obj.css) && isObjectType(tag)) {
		Object.entries(obj.css).forEach(([key, value]) => {
			tag.style[key] = value;
		});
	}
}

function addProp(tag, obj)
{
	if (isObjectType(obj.prop) && isObjectType(tag)) {
		Object.entries(obj.prop).forEach(([key, value]) => {
			tag.setAttribute(key, value);
		});
	}
}

function addClass(tag, obj)
{
	if (isObjectType(tag)) {
		if (isDefinedType(obj.clsSet))
			tag.className = trimMatch(obj.clsSet);
		if (isDefinedType(obj.clsDel))
			tag.classList.remove(trimMatch(obj.clsDel));
		if (isDefinedType(obj.clsAdd))
			tag.classList.add(trimMatch(obj.clsAdd));
	}
}

function addText(tag, obj)
{
	if (isObjectType(tag)) {
		if (isDefinedType(obj.txtOut))
			tag.outerText = obj.txtOut;
		if (isDefinedType(obj.txtIn))
			tag.innerText = obj.txtIn;
		if (isDefinedType(obj.txtAdd))
			tag.appendChild(document.createTextNode(' ' + obj.txtAdd))
	}
}

function addHtml(tag, obj)
{
	if (isObjectType(tag)) {
		if (isDefinedType(obj.htmOut))
			tag.outerHTML = obj.htmOut;
		if (isDefinedType(obj.htmIn))
			tag.innerHTML = obj.htmIn;
	}
}

function addTo(to, tag)
{
	if (isObjectType(to) && isObjectType(tag))
		to.appendChild(tag);
}

function getProp(obj, tag)
{
	if (isObjectType(obj) && isDefinedType(obj.prop) && tag !== false) {
		if (! isDefinedType(tag)) {
			return getProp(obj, document.getElementById(obj.id) || false);
		}
		if (tag.length === 1)
			return tag[0].attributes.getNamedItem(obj.prop).value;
	}
}

function addTag(obj)
{
	if (isObjectType(obj) && isDefinedType(obj.tag)) {
		let tag = document.createElement(obj.tag);
		if (isObjectType(tag)) {
			if (! isFalseType(obj.id))
				tag.id = getTagId(obj.id, obj.tag);
			addClass(tag, obj);
			addCss(tag, obj);
			addProp(tag, obj);
			addText(tag, obj);
			addHtml(tag, obj);
			if (isDefinedType(obj.to))
				addTo(getObjId(obj.to), tag);
			return tag;
		}
	}
}

function getObjId(id)
{
	if (isObjectType(id))
		return id;
	if (isDefinedType(id))
		return document.getElementById(id);
}

function getObj(val, obj)
{
	if (isDefinedType(val)) {
		if (isObjectType(val))
			return val;
		if (val === 'body')
			return document.body;
		if (val === 'head')
			return document.head;
		let para = {
			'tag': val,
		};
		if (isObjectType(obj))
			para.prop = obj;
		para.to = getObjId(para.tag) || findTag(para);
		if (isDefinedType(para.to))
			return para.to;
	}
}

function insertObj(obj)
{
	if (isObjectType(obj) && isDefinedType(obj.tag) && isDefinedType(obj.ref) && isDefinedType(obj.to)) {
		let to = getObj(obj.to);
		let tag = getObj(obj.tag);
		let ref = getObj(obj.ref);
		if (isObjectType(tag) && isObjectType(to)) {
			if (isObjectType(ref)) {
				if (isDefinedType(obj.b4))
					to.insertBefore(tag, ref);
				else
					to.insertBefore(tag, ref.nextSibling);
			} else {
				to.appendChild(tag)
			}
			return tag;
		}
	}
}

