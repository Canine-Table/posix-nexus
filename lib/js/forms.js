#!/usr/bin/env node
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
		if (isDefinedType(obj.lblPre) || isDefinedType(obj.lblPost)) {
			addTag({
				'tag': 'div',
				'clsSet': `input-group ${obj.clsGrp}`,
				'id': `${obj.id}Group`,
				'to': obj.id
			});
			var to = `${obj.id}Group`;
		} else {
			var to = obj.id;
		}
		if (isDefinedType(obj.lblPre)) {
			addTag({
				'tag': 'span',
				'clsSet': 'input-group-text',
				'id': `${obj.id}InputLabelPre`,
				'to': to,
				'txtAdd': obj.lblPre
			});
		}
		if (isDefinedType(obj.lblFlt)) {
			addTag({
				'tag': 'div',
				'clsSet': `form-floating ${obj.clsFlt}`,
				'id': `${obj.id}Float`,
				'to': to,
			});
			var toto = `${obj.id}Float`;
		} else {
			var toto = undefined;
		}
		obj.tag = isDefinedType(obj.tag, 'input');
		let form = addTag({
			'tag': obj.tag,
			'id': `${obj.id}Form`,
			'to': isDefinedType(toto, to),
			'clsSet': obj.clsFm
		});
		if (isDefinedType(obj.lblFlt)) {
			addTag({
				'tag': 'label',
				'txtAdd': obj.lblFlt,
				'id': `${obj.id}InputLabelFloat`,
				'to': toto,
				'prop': {
					'for': `${obj.id}Form`
				}
			});
		}
		if (isDefinedType(obj.lblPost)) {
			addTag({
				'tag': 'span',
				'clsSet': 'input-group-text',
				'id': `${obj.id}InputLabelPost`,
				'to': to,
				'txtAdd': obj.lblPost
			});
		}
		if (isDefinedType(obj.lblHlp)) {
			addTag({
				'tag': 'div',
				'txtAdd': obj.lblHlp,
				'id': `${obj.id}InputLabelHelp`,
				'to': obj.id,
				'clsSet': 'form-text'
			});
		}
		addProp(form, obj);
		return form;
	}
}

function __setFormPrepOne(obj, def, typ, tag)
{
	obj.id = getTagId(obj.id, def);
	obj.tag = isDefinedType(tag, 'input');
	console.log(obj.prop)
	if (! isObjectType(obj.prop))
		obj.prop = {};
	if (isDefinedType(typ))
		obj.prop.type = typ;
	obj.clsFm = `${obj.clsFm} form-control`;
}

function addTextForm(obj)
{
	if (isObjectType(obj)) {
		__setFormPrepOne(obj, 'textForm', 'text');
		return addForm(obj);
	}
}

function addEmailForm(obj)
{
	if (isObjectType(obj)) {
		__setFormPrepOne(obj, 'emailForm', 'email');
		return addForm(obj);
	}
}

function addAreaForm(obj)
{
	if (isObjectType(obj)) {
		__setFormPrepOne(obj, 'textAreaForm', undefined, 'textarea');
		obj.prop = isDefinedType(obj.prop.rows, 3);
		return addForm(obj);
	}
}

function addColorForm(obj)
{
	if (isObjectType(obj)) {
		__setFormPrepOne(obj, 'colorForm', 'color');
		obj.clsFm = `${obj.clsFm} form-control-color`;
		return addForm(obj);
	}
}

function addFileForm(obj)
{
	if (isObjectType(obj)) {
		__setFormPrepOne(obj, 'fileForm', 'file');
		return addForm(obj);
	}
}

function addPasswordForm(obj)
{
	if (isObjectType(obj)) {
		__setFormPrepOne(obj, 'passwordForm', 'password');
		if (isDefinedType(obj.msg)) {
			if (obj.msg === 'long')
				obj.lblHlp = 'Your password must be 8-20 characters long, contain letters and numbers, and must not contain spaces, special characters, or emoji.';
			else
				obj.lblHlp = 'Must be 8-20 characters long.';
		}
		return addForm(obj);
	}
}

