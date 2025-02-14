#!/usr/bin/env node
/**
 * Handles tab switching by hiding all tab panels, showing the selected tab panel,
 * and updating the active tab button.
 *
 * @param {Event} evt - The event object from the tab button click event.
 * @param {string} id - The ID of the tab panel to be displayed.
*/
function tabSwitching(evt, id)
{
	// Get all elements with the class 'container-tab' (tab panels)
	let tabPanelContents = document.getElementsByClassName('container-tab');
	// Loop through all tab panels and hide them
	for (let i = 0; i < tabPanelContents.length; i++)
		tabPanelContents[i].style.display = 'none';
	// Get all elements with the class 'tab-button' (tab buttons)
	let tabButtons = document.getElementsByClassName('tab-button');
	// Loop through all tab buttons and remove the 'active' class
	for (let i = 0; i < tabButtons.length; i++)
		tabButtons[i].className = tabButtons[i].className.replace(' active', '');
	// Display the selected tab panel by setting its display style to 'flex'
	document.getElementById(id).style.display = 'flex';
	// Add the 'active' class to the tab button that was clicked
	evt.currentTarget.className += ' active';
}

/**
 * Finds HTML elements with a specific tag and, optionally, a specific attribute and value.
 *
 * @param {Object} obj - An object containing the search criteria.
 * @param {string} obj.tag - The tag name to search for.
 * @param {string} [obj.prop] - The attribute name to filter by (optional).
 * @param {string} [obj.val] - The attribute value to filter by (optional).
 * @returns {Array|HTMLCollection} An array of matching elements if `prop` is defined,
 *				   otherwise an HTMLCollection of elements with the specified tag.
*/

class Types
{
	static isObject(val) {
		return (typeof val === 'object' && val !== null && ! Array.isArray(val));
	}

	static isNumeric(val) {
		return ! isNaN(parseFloat(val)) && isFinite(val);
	}

	static isUnsigned(val) {
		return val === Math.abs(val);
	}

	static isBool(val) {
		return val === true || val === false;
	}

	static isString(val) {
		return typeof val === 'string' || val instanceof String;
	}

	static isJson(val) {
		try {
			JSON.parse(val);
		} catch (e) {
			return false;
		}
		return true;
	}
}

class DOM
{
	static isHtml(elm) {
		return elm instanceof HTMLElement;
	}

	static isDoc(elm) {
		return elm instanceof Document;
	}

	static isElement(elm) {
		return DOM.isDoc(elm) || DOM.isHtml;
	}

	static ifElement(elm, action) {
		if (DOM.isElement(elm))
			return action;
	}

	static byId(id) {
		return window.document.getElementById(id);
	}

	static byTag(tag, parent = window.document) {
		return DOM.ifElement(parent, parent.getElementsByTagName(tag))
	}

	static byClass(cls, parent = window.document) {
		return DOM.ifElement(parent, parent.getElementsByClassName(cls));
	}

	static head() {
		return window.document.head;
	}

	static body() {
		return window.document.body;
	}

	static obj(elm) {
		if (DOM.isElement(elm))
			return elm;
		if (elm === 'body')
			return DOM.body();
		if (elm === 'head')
			return DOM.head();
		return DOM.byId(elm) || DOM.body();
	}

	static attrib(elm) {
		if (DOM.isHtml(elm))
			return elm.attributes
	}

	static create(tag) {
		return window.document.createElement(tag);
	}

	static to(par, elm) {
		if (DOM.isHtml(par) && DOM.isHtml(elm))
			return par.appendChild(elm);
	}

	static class(tag, { clsSet, clsDel, clsAdd }) {
		if (DOM.isElement(tag)) {
			if (clsSet)
				tag.className = clsSet.trim();
			if (clsDel)
				tag.classList.remove(clsDel.trim());
			if (clsAdd)
				tag.classList.add(clsAdd.trim());
		}
	}

	static id(id, def = 'tag') {
		return DOM.byId(id) ? `${tag}-${randomString(32)}` : id;
	}

	static text(tag, { txtOut, txtIn, txtAdd }) {
		if (DOM.isElement(tag)) {
			if (txtOut)
				tag.outerText = txtOut;
			if (txtIn)
				tag.innerText = txtIn;
			if (txtAdd)
				tag.appendChild(window.document.createTextNode(txtAdd))
		}
	}

	static html(tag, { htmlIn, htmlOut }) {
		if (DOM.isElement(tag)) {
			if (htmlOut)
				tag.outerHTML = htmlOut;
			if (htmlIn)
				tag.innerHTML = htmlIn;
		}
	}

	static css(tag, obj) {
		if (DOM.isElement(tag) && Types.isObject(obj)) {
			Object.entries(obj).forEach(([key, value]) => {
				tag.style[key] = value;
			});
		}
	}

	static prop(tag, obj) {
		if (DOM.isElement(tag) && Types.isObject(obj)) {
			Object.entries(obj).forEach(([key, value]) => {
				tag.setAttribute(key, value);
			});
		}
	}

	static tag(obj, elm) {
		let tag = elm || DOM.create(obj.tag);
		tag.id = DOM.id(obj.id);
		DOM.css(tag, obj.css);
		DOM.prop(tag, obj.prop);
		DOM.text(tag, obj);
		DOM.html(tag, obj);
		if (obj.to)
			DOM.to(DOM.byId(obj.to), tag);
		return tag;
	}

	static find(obj) {
		if (Types.isObject(obj)) {
			let par = DOM.byId(obj.id) || DOM.body();
			let cont = DOM.byTag(obj.tag);
			if (DOM.isElement(cont)) {
				if (obj.prop && ) {
					let nd = [];
					for (let i = 0; i < cont.length; i++) {
						let n = DOM.attib(cont[i]).getNamedItem(obj.prop);
						if (n && (! obj.val || n.value === obj.val))
							nd.push(cont[i]);
					}
					return nd;
				}
				return cont;
			}
			return par;
		}
	}

	static insert(obj) {
		if (Types.isObject(obj) && obj.tag && obj.ref &&  obj.to) {
			let to = DOM.obj(obj.to);
			let tag = DOM.obj(obj.tag);
			let ref = DOM.obj(obj.ref);
			if (DOM.isHtml(tag) && DOM.isElement(to)) {
				if (DOM.isHtml(ref)) {
					if (obj.b4)
						to.insertBefore(tag, ref);
					else
						to.insertBefore(tag, ref.nextSibling);
				} else {
					to.appendChild(tag);
				}
				return tag;
			}
		}
	}
}

function findTag(obj)
{
	// Check if obj is an object and has a defined tag property
	if (isObjectType(obj) && isDefinedType(obj.tag)) {
		// Retrieve the parent element with the specified ID, or default to the document body if not found
		let parnt = document.getElementById(obj.id) || document.body;
		// Get a collection of elements with the specified tag name that are descendants of the parent element
		let content = parnt.getElementsByTagName(obj.tag);
		// If prop is defined, filter elements by the specified attribute and value
		if (isDefinedType(obj.prop)) {
			let nodes = [];
			for (let i = 0; i < content.length; i++) {
				// Get the attribute named obj.prop from the current element
				let node = content[i].attributes.getNamedItem(obj.prop);
				// Check if the attribute is not null and matches the specified value (if provided)
				if (! isNullType(node) && (! isDefinedType(obj.val) || node.value === obj.val))
					// Add the element to the nodes array
					nodes.push(content[i]);
			}
			// Return the array of matching elements
			return nodes;
		}
		// If prop is not defined, return the HTMLCollection of elements with the specified tag
		return content;
	}
}

function getTagId(id, tag)
{
	if (! isDefinedType(document.getElementById(id)))
		id = undefined;
	if (! isDefinedType(tag))
		tag = 'tag';
	return isDefinedType(id, tag + "-" + randomString(32));
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
	return tag;
}

/**
 * Retrieves the value of a specified attribute (prop) from an HTML element.
 *
 * @param {Object} obj - An object containing the attribute name (prop) and optionally an ID (id).
 * @param {HTMLElement} tag - The HTML element to retrieve the attribute from.
 * @returns {string|undefined} The value of the specified attribute, or undefined if not found.
*/
function getProp(obj, tag)
{
	// Check if obj is an object, obj.prop is defined, and tag is not false
	if (isObjectType(obj) && isDefinedType(obj.prop) && tag !== false) {
		// If tag is not defined, find the element by ID and call getProp recursively
		if (! isDefinedType(tag))
			return getProp(obj, document.getElementById(obj.id) || false);
		// Return the attribute value from the tag element directly
		return tag.attributes.getNamedItem(obj.prop).value;
	}
}

function addTag(obj, elm)
{
	if (isObjectType(obj) && (isDefinedType(obj.tag) || isObjectType(elm))) {
		if (isObjectType(elm))
			var tag = elm
		else
			var tag = document.createElement(obj.tag);
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

/**
 * Retrieves an HTML element based on the provided value (`val`) and optional object (`obj`).
 *
 * @param {string|Object} val - The value used to find the element. Can be a tag, 'body', 'head', or an object.
 * @param {Object} [obj] - An optional object containing additional properties.
 * @returns {HTMLElement|Object} The found HTML element or the input object.
*/
function getObj(val, obj)
{
	// Return val directly if it is an object
	if (isObjectType(val))
		return val;
	// Return document.body if val is 'body'
	if (val === 'body')
		return document.body;
	// Return document.head if val is 'head'
	if (val === 'head')
		return document.head;
	// Create an object para with a tag property set to val
	let para = {
		'tag': val
	};
	// Add prop property to para if obj is an object
	if (isObjectType(obj))
		para.prop = obj;
	// Find the target element using getObjId or findTag
	para.to = getObjId(para.tag) || findTag(para);
	// Return the target element if defined, otherwise return document.body
	if (isDefinedType(para.to))
		return para.to;
	else
		return getObj('body');
}

/**
 * Inserts a specified HTML element (tag) into a target container (to)
 * at a position relative to a reference element (ref).
 *
 * @param {Object} obj - An object containing the elements and insertion information.
 * @param {string} obj.tag - The ID of the tag to be inserted.
 * @param {string} obj.ref - The ID of the reference element.
 * @param {string} obj.to - The ID of the target container.
 * @param {boolean} [obj.b4] - If true, insert before the reference element. Otherwise, insert after.
 * @returns {HTMLElement|undefined} The inserted tag element, or undefined if insertion failed.
*/
function insertObj(obj)
{
	// Check if obj is an object and required properties are defined
	if (isObjectType(obj) && isDefinedType(obj.tag) && isDefinedType(obj.ref) && isDefinedType(obj.to)) {
		// Retrieve the elements based on IDs
		let to = getObj(obj.to);
		let tag = getObj(obj.tag);
		let ref = getObj(obj.ref);
		// Check if tag and to are valid objects
		if (isObjectType(tag) && isObjectType(to)) {
			// Check if ref is a valid object
			if (isObjectType(ref)) {
				// Insert tag before ref if obj.b4 is defined, otherwise insert after ref
				if (isDefinedType(obj.b4))
					to.insertBefore(tag, ref);
				else
				to.insertBefore(tag, ref.nextSibling);
			} else {
				// If ref is not a valid object, append tag to the to container
				to.appendChild(tag);
			}
			// Return the inserted tag element
			return tag;
		}
	}
}

