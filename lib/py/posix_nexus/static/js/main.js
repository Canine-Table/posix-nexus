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
	return (val === null);
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
		let content = document.body.getElementsByTagName(obj.tag)
		if (isDefinedType(obj.attrib)) {
			let nodes = new Array();
			for (let i = 0; i < content.length; i++) {
				let node = content[i].attributes.getNamedItem(obj.attrib)
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

function trimMatch(str, mth)
{
	mth = isDefinedType(mth, 'null|undefined');
	return str.replace(new RegExp(`(^ *| +)?(${mth})( +| *$)`, "g"), " ").replace(/(^ *| *$)/g, "");
}

function addTag(obj)
{
	if (isObjectType(obj) && isDefinedType(obj.tag)) {
		let tag = document.createElement(obj.tag);
		if (isObjectType(tag)) {
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

function addNavBar(obj)
{
	if (isObjectType(obj)) {
		obj.theme = isDefinedType(obj.theme, 'dark');
		obj.tog = isDefinedType(obj.tog, 'offcanvas');
		obj.id = getTagId(obj.id, '-nav');
		let tag = addTag({
			'tag': 'nav',
			'id': `navBar${obj.id}`,
			'to': obj.to,
			'clsSet': `navbar sticky-top p-2 bg-body-tertiary ${obj.clsNav}`,
			'prop': {
				'data-bs-theme': obj.theme
			}
		});
		if (! isDefinedType(obj.to))
			document.body.appendChild(tag);
		addTag({
			'tag': 'div',
			'id': `navBar${obj.id}Container`,
			'to': `navBar${obj.id}`,
			'clsSet': 'container-fluid'
		});
		addTag({
			'tag': 'a',
			'id': `navBar${obj.id}Brand`,
			'to': `navBar${obj.id}`,
			'clsSet': 'navbar-brand'
		});
		addTag({
			'tag': 'button',
			'id': `navBar${obj.id}Button`,
			'to': `navBar${obj.id}`,
			'clsSet': 'navbar-toggler',
			'prop': {
				'type': 'button',
				'data-bs-toggle': obj.tog,
				'aria-controls': `navBar${obj.id}ContentContainer`,
				'aria-label': 'Toggle navigation',
				'data-bs-target': `#navBar${obj.id}ContentContainer`
			}
		});
		addTag({
			'tag': 'span',
			'clsSet': 'navbar-toggler-icon',
			'id': `navBar${obj.id}ButtonIcon`,
			'to': `navBar${obj.id}Button`
		});
		addTag({
			'tag': 'div',
			'clsSet': `${obj.tog} ${obj.clsTog}`,
			'id': `navBar${obj.id}ContentContainer`,
			'to': `navBar${obj.id}Container`,
			'prop': {
				'tabindex': '-1',
				'aria-labelledby': `navBar${obj.id}ContentContainerLabel`
			}
		});
		return tag;
	}
}

function addOffCanvasNavBar(obj)
{
	if (isObjectType(obj)) {
		obj.theme = isDefinedType(obj.theme, 'dark');
		obj.tog = isDefinedType(obj.tog, 'offcanvas');
		obj.id = getTagId(obj.id, '-nav');
		let tag = addNavBar(obj);
		addTag({
			'tag': 'div',
			'id': `navBar${obj.id}ContentContainerHeader`,
			'to': `navBar${obj.id}ContentContainer`,
			'clsSet': 'offcanvas-header'
		});
		addTag({
			'tag': 'h5',
			'id': `navBar${obj.id}ContentContainerLabel`,
			'to': `navBar${obj.id}ContentContainerHeader`,
			'clsSet': 'offcanvas-header',
			'txtAdd': obj.txtHdr
		});
		addTag({
			'tag': 'button',
			'id': `navBar${obj.id}ContentContainerCloseButton`,
			'clsSet': 'btn-close',
			'to': `navBar${obj.id}ContentContainerHeader`,
			'prop': {
				'type': 'button',
				'data-bs-toggle': 'offcanvas',
				'aria-label': 'Close'
			}
		});
		addTag({
			'tag': 'div',
			'clsSet': 'offcanvas-body',
			'id': `navBar${obj.id}ContentContainerBody`,
			'to': `navBar${obj.id}ContentContainer`
		});
		addTag({
			'tag': 'ul',
			'id': `navBar${obj.id}ContentContainerBodyList`,
			'to': `navBar${obj.id}ContentContainerBody`,
			'clsSet': `navbar-nav ${obj.clsBdy}`
		});
		return tag;
	}
}

function addNavBarItem(obj)
{
	if (isObjectType(obj)) {
		let tag = getObjId(`navBar${obj.to}ContentContainerBodyList`);
		if (isObjectType(tag)) {
			obj.id = getTagId(obj.id, '-navItem');
			obj.cur = isDefinedType(obj.tog, 'page');
			obj.lnk = isDefinedType(obj.lnk, '#');
			let id = `navBar${obj.to}ContentContainerBodyList`;
			addTag({
				'tag': 'li',
				'id': `${id}${obj.id}`,
				'to': id,
			});
			let lnk = addTag({
				'tag': 'a',
				'id': `${id}${obj.id}Link`,
				'to': `${id}${obj.id}`,
				'clsSet': `nav-link tab-button ${obj.clslnk}`,
				'prop': {
					'onclick': `tabSwitching(event, "contentContainer${obj.id}")`,
					'aria-current': obj.cur,
					'href': obj.lnk
				}
			});
			if (isDefinedType(obj.fa)) {
				addTag({
					'tag': 'i',
					'clsSet': obj.fa,
					'id': `${id}${obj.id}LinkIcon`,
					'to': `${id}${obj.id}Link`
				});
			}
			let tab = addTag({
				'tag': 'div',
				'id': `contentContainer${obj.id}`,
				'clsSet': `container-tab ${obj.clsTab}`
			});
			addText(lnk, obj);
			if (isObjectType(obj.on))
				addTo(obj.on, tab);
			else
				addTo(document.body, tab);
			return tag;
		}
	}
}

function addForm(obj)
{
	if (isObjectType(obj)) {
		obj.id = getTagId(obj.id, 'form');
		addTag({
			'tag': 'div',
			'id': obj.id,
			'to': obj.to,
			'clsSet': `p-1, mb-3 ${obj.clsDiv}`
		});
		if (isDefinedType(obj.lbl)) {
			addTag({
				'tag': 'label',
				'txtAdd': obj.lbl,
				'id': `${obj.id}InputLabel`,
				'to': obj.id,
				'clsSet': 'form-label',
				'prop': {
					'for': `${obj.id}Form`
				}
		});
		}
		obj.tag = isDefinedType(obj.tag, 'input');
		let form = addTag({
			'tag': obj.tag,
			'id': `${obj.id}Form`,
			'to': obj.id,
			'clsSet': obj.clsFm,
		});
		addProp(form, obj);
		return form;
	}
}


function addCarousel()
{

}

function addEmailForm(obj)
{
	if (isObjectType(obj) && isDefinedType(obj.to)) {
		let form = addTag({
			'tag': 'form',
			'id': `${obj.id}Form`,
			'to': obj.to,
			'clsSet': 'p-5'
		});
		// Name Form
		addForm({
			'lbl': 'Name',
			'id': `${obj.id}NameForm`,
			'to':  `${obj.id}Form`,
			'clsFm': 'form-control',
			'prop': {
				'type': 'text',
				'placeholder': 'name'
			}
		});
		// Email Form
		addForm({
			'lbl': 'Email',
			'to':  `${obj.id}Form`,
			'id': `${obj.id}EmailForm`,
			'clsFm': 'form-control',
			'prop': {
				'type': 'email',
				'placeholder': 'name@example.com'
			}
		});
		// Attachment Form
		addForm({
			'lbl': 'Attachments',
			'to':  `${obj.id}Form`,
			'id': `${obj.id}AttachmentForm`,
			'clsFm': 'form-control',
			'prop': {
				'type': 'file',
			}
		});
		// Message Form
		addForm({
			'tag': 'textarea',
			'lbl': 'Message',
			'to':  `${obj.id}Form`,
			'id': `${obj.id}MessageForm`,
			'clsFm': 'form-control',
			'prop': {
				'rows': '3',
				'placeholder': 'message'
			}
		});
		// Send Button
		addText(addForm({
			'tag': 'button',
			'id':  `${obj.id}FormButton`,
			'to':  `${obj.id}Form`,
			'clsFm':`btn ${obj.clsBtn}`,
			'prop': {
				'type': 'submit',
			}
		}), obj);
		return form;
	}
}

document.addEventListener('DOMContentLoaded', function()
{
	addOffCanvasNavBar({
		'id': 'Top',
		'clsTog': 'offcanvas-end',
		'txtHdr': 'Welcome to your bootstap template!'
	});

	// Home Page
	addNavBarItem({
		'to': 'Top',
		'id': 'Home',
		'fa': 'fa-solid fa-house',
		'txtAdd': 'Home',
		'lnk': '#Home',
		'clsTab': 'active'
	});

	// Clients
	addNavBarItem({
		'to': 'Top',
		'id': 'Testimonials',
		'fa': 'fa-solid fa-star',
		'txtAdd': 'Client Testimonials',
		'lnk': '#Testimonials'
	});

	// Contact Page
	addNavBarItem({
		'to': 'Top',
		'id': 'Contact',
		'fa': 'fa-solid fa-address-book',
		'txtAdd': 'Contact Me',
		'lnk': '#Contact'
	});
	addEmailForm({
		'id': 'contact',
		'to': 'contentContainerContact',
		'clsBtn': 'btn-primary',
		'txtIn': 'Send'
	});

	// Services
	addNavBarItem({
		'to': 'Top',
		'id': 'Services',
		'fa': 'fa-solid fa-pen-nib',
		'txtAdd': 'My Services',
		'lnk': '#Services'
	});

	// About
	addNavBarItem({
		'fa': 'fa-solid fa-circle-info',
		'txtAdd': 'About Me'
	});
	document.getElementById('contentContainerHome').click();
});

