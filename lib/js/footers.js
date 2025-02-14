#!/usr/bin/env node

function addFooter(obj)
{
	if (isObjectType(obj)) {
		getPropList(obj, 'footer');
		let cmpnt = null;
		let tag = addTo(getObj(obj.to), addTag({
			'tag': 'footer',
			'clsSet': `d-flex flex-wrap justify-content-between align-items-center py-3 my-4 border-top ${obj.clsFtr}`,
			'id': `${obj.id}Footer`
		}));
		addProp(tag, getSubProp(obj, 'Ftr'))
		addProp(addTag({
			'tag': 'div',
			'id': `${obj.id}FooterDiv`,
			'to': `${obj.id}Footer`,
			'clsSet': 'col-md-4 d-flex align-items-center'
		}), getSubProp(obj, 'InDiv'));
		if (isDefinedType(obj.cprgt)) {
			let now = new Date();
			addProp(addTag({
				'tag': 'span',
				'id': `${obj.id}FooterDivCopyRight`,
				'to': `${obj.id}FooterDiv`,
				'clsSet': 'mb-3 mb-md-0 p-2 text-body-secondary',
				'txtAdd': `© ${now.getFullYear()} by ${obj.cprgt}, all rights reserved`
			}), getSubProp(obj, 'CpRgt'));
		}
		return tag;
	}
}

