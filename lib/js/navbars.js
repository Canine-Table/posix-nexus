#!/usr/bin/env node
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
			'clsSet': 'offcanvas-header border-bottom'
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
				'clsSet': `p-2 container-tab ${obj.clsTab}`
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

