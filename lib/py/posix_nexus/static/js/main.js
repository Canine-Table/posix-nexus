function isObjectType(param)
{
	return (typeof param === 'object' && param !== null && ! Array.isArray(param));
}

function returnArrayType(arr, sep = ',')
{
	if (Array.isArray(arr))
		return arr
	else
		return arr.split(new RegExp(`\\s*${sep}\\s*`));
}

function isDefinedType(val, def)
{
	if (val === undefined) {
		if (def !== undefined)
			return def;
		else
			return false;
	} else {
		if (def !== undefined)
			return val;
		else
			return true;
	}
}

function isNullType(val)
{
	return (val === null)
}

function sanitizeString(val)
{
	return val.replace(/[^a-zA-Z0-9]/g, "");
}

function randomString(length)
{
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    const charactersLength = characters.length;
    for (let i = 0; i < length; i++) {
	result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

function checkId(id, elm)
{
	if (! isNullType(document.getElementById(id)))
		id = undefined;
	if (isNullType(elm))
		elm = 'tag';
	return isDefinedType(id, elm + "-" + randomString(32));
}

function newElm(obj)
{
	if (isObjectType(obj) && isDefinedType(obj.element)) {
		var content = document.createElement(obj.element)
		content.id = checkId(obj.id, obj.element)
		applyClass(content, obj);
		applyText(content, obj);
		applyAttrib(content, obj);
		applyCss(content, obj);
		applyTo(content, obj);
		return content;
	}
}

function applyTo(elm, obj)
{
	if (isObjectType(elm)) {
		if (isDefinedType(obj.to)) {
			var para = document.querySelector(obj.to)
			if (! isNullType(para))
				para.appendChild(elm)
		}
	}
}

function applyClass(elm, obj)
{
	if (isObjectType(elm)) {
		if (isDefinedType(obj.class))
			elm.className = obj.class;
		if (isDefinedType(obj.delClass))
			elm.classList.remove(obj.delClass);
		if (isDefinedType(obj.addClass))
			elm.classList.add(obj.addClass);
	}
}

function applyCss(elm, obj)
{
	if (isObjectType(obj.css) && isObjectType(elm)) {
			Object.entries(obj.css).forEach(([key, value]) => {
			elm.style[key] = value;
		});
	}
}

function applyAttrib(elm, obj)
{
	if (isObjectType(obj.attrib) && isObjectType(elm)) {
		if (isObjectType(obj.attrib)) {
			Object.entries(obj.attrib).forEach(([key, value]) => {
				elm.setAttribute(key, value);
			});
		}
	}
}

function applyText(elm, obj)
{
	if (isObjectType(elm)) {
		if (isDefinedType(obj.text))
			elm.textContent = obj.text;
		if (isDefinedType(obj.addText))
			elm.appendChild(newText(' ' + obj.addText));
	}
}

function newText(text)
{
	return document.createTextNode(text)
}

function addElm(prop, elm)
{
	if (isDefinedType(prop)) {
		var obj = document.getElementById(prop)
		if (! isObjectType(prop))
			var obj = document.querySelector(prop);
		if (! isObjectType(prop))
			return;
		if (isObjectType(elm))
			obj.appendChild(elm);
		return obj;
	}
}

function navbarItem(obj)
{
	if (isObjectType(obj) && isDefinedType(obj.to)) {
		obj.id = checkId(obj.id, 'li')
		var item = newElm({
			'element': 'li',
			'id': 'navbarItem' + obj.id,
			'to': obj.to,
			'class': 'nav-item'
		});
		var content = newElm({
			'element': 'a',
			'class': 'nav-link tab-button' + obj.class,
			'id': 'navbarLink' + obj.id,
			'to': '#navbarItem' + obj.id,
			'attrib': {
				'aria-current': 'page',
				'href': '#' + obj.id,
				'onclick': 'tabSwitching(event, "contentContainer' + obj.id + '")'
			}
		});
		content.appendChild(newElm({
			'element': 'i',
			'class': obj.faClass,
			'id': 'navbarLink' + obj.id + 'Icon',
		}));
		newElm({
			'element': 'div',
			'id': 'contentContainer' + obj.id,
			'to': '#contentContainer',
			'class': 'container-tab'
		});
		if (isDefinedType(obj.text))
			content.appendChild(newText(' ' + obj.text))
		return item;
	}
}

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

function inputForm(obj)
{
	if (isObjectType(obj) && isDefinedType(obj.id)) {
		let eid = sanitizeString(obj.label)
		newElm({
			'element': 'div',
			'class': 'mb-3',
			'to': '#' + obj.id,
			'id': obj.id + eid + 'Form'
		});
		obj.id = obj.id + eid
		newElm({
			'element': 'label',
			'id': obj.id + 'FormLabel',
			'to': '#' + obj.id + 'Form',
			'class': 'form-label',
			'text': obj.label,
			'attrib': {
				'for': obj.id + 'FormInput'
			}
		});
		newElm({
			'element': obj.element,
			'class': 'form-control',
			'id': obj.id + 'FormInput',
			'to': '#' + obj.id + 'Form',
			'attrib': {
				'placeholder': obj.placeholder,
				'type': obj.type,
				'rows': obj.rows
			}
		});
	}
}

function contactTab(id)
{
	// Email Form
	inputForm({
		'id': id,
		'label': 'Email address',
		'element': 'input',
		'placeholder': 'name@example.com',
		'type': 'email'
	});

	inputForm({
		'id': id,
		'label': 'Message',
		'element': 'textarea',
		'placeholder': 'feedback is appreciated',
		'rows': 4
	});
}

document.addEventListener('DOMContentLoaded', function() {
	document.body.appendChild(newElm({
		'element': 'nav',
		'id': 'topNavbar',
		'class': 'navbar sticky-top navbar-expand-lg bg-body-tertiary'
	}));
	document.body.appendChild(newElm({
		'element': 'div',
		'id': 'contentContainer',
		'class': 'container-fluid',
	}));
	newElm({
		'element': 'div',
		'id': 'topNavbarContainer',
		'class': 'container-fluid',
		'to': '#topNavbar',
	});
	newElm({
		'element': 'a',
		'id': 'topNavbarBrand',
		'class': 'navbar-brand',
		'to': '#topNavbar',
		'attrib': {
			'href': '#'
		}
	});
	newElm({
		'element': 'button',
		'id': 'topNavbarButton',
		'class': 'navbar-toggler',
		'to': '#topNavbar',
		'attrib': {
			'type': 'button',
			'data-bs-toggle': 'offcanvas',
			'aria-controls': 'offcanvasNavbarContainer',
			'aria-label': 'Toggle navigation',
			'data-bs-target': '#offcanvasNavbarContainer'
		}
	});
	newElm({
		'element': 'span',
		'class': 'navbar-toggler-icon',
		'to': '#topNavbarButton',
		'id': 'topNavbarButtonIcon'
	});
	newElm({
		'element': 'div',
		'class': 'offcanvas offcanvas-end',
		'to': '#topNavbarContainer',
		'id': 'offcanvasNavbarContainer',
		'attrib': {
			'tabindex': '-1',
			'aria-labelledby': 'offcanvasNavbarHeaderLabel'
		}
	});
	newElm({
		'element': 'div',
		'id': 'offcanvasNavbarHeader',
		'to': '#offcanvasNavbarContainer',
		'class': 'offcanvas-header'
	});
	newElm({
		'element': 'h5',
		'id': 'offcanvasNavHeaderLabel',
		'to': '#offcanvasNavbarHeader',
		'class': 'offcanvas-header',
		'text': 'Welcome to your template!'
	});
	newElm({
		'element': 'button',
		'id': 'offcanvasNavbarCloseButton',
		'class': 'btn-close',
		'to': '#offcanvasNavbarHeader',
		'attrib': {
			'type': 'button',
			'data-bs-toggle': 'offcanvas',
			'aria-label': 'Close'
		}
	});
	newElm({
		'element': 'div',
		'class': 'offcanvas-body',
		'id': 'offcanvasNavbarBody',
		'to': '#offcanvasNavbarContainer'
	});
	newElm({
		'element': 'ul',
		'id': 'offcanvasNavbarBodyList',
		'to': '#offcanvasNavbarBody',
		'class': 'navbar-nav justify-content-end flex-grow-1 pe-3'
	});

	// Home
	navbarItem({
		'id': 'Home',
		'to': '#offcanvasNavbarBodyList',
		'faClass': 'fa-solid fa-house',
		'text': 'Home'
	});

	// About
	navbarItem({
		'id': 'About',
		'to': '#offcanvasNavbarBodyList',
		'faClass': 'fa-solid fa-circle-info',
		'text': 'About Me'
	});
	
	// Services
	navbarItem({
		'id': 'Services',
		'to': '#offcanvasNavbarBodyList',
		'faClass': 'fa-solid fa-pen-nib',
		'text': 'My Services'
	});

	// Clients
	navbarItem({
		'id': 'Clients',
		'to': '#offcanvasNavbarBodyLis',
		'faClass': 'fa-solid fa-star',
		'text': 'Client Testimonials'
	});

	// Contact
	navbarItem({
		'id': 'Contact',
		'to': '#offcanvasNavbarBodyList',
		'faClass': 'fa-solid fa-address-book',
		'text': 'Contact Me'
	});
	contactTab('contentContainerContact')
	document.getElementById('contentContainerHome').click();
});

