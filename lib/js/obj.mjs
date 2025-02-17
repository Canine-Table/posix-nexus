#!/usr/bin/env node
import { Type } from './type.mjs';
import { Arr } from './arr.mjs';
import { Dom } from './dom.mjs';
import { Str } from './str.mjs';
import { Component } from './components.mjs';
export function Obj()
{
	Obj.methods(Obj);
}

Obj.reflect = val => {
	if (val instanceof Object) {
		const prop = Reflect.ownKeys(val.prototype);
		if (prop.length === 1)
			return Reflect.ownKeys(val);
		else
			return prop;
	}
}

Obj.methods = val => {
	console.log(Arr.left(Obj.reflect(val), ['length', 'name', 'arguments', 'caller', 'prototype', 'constructor']));
}

Obj.isProp = (val, prop) => {
	if (Type.isDefined(prop))
		return Arr.in(prop, Obj.reflect(val));
}

Obj.assign = (val, prop, obj) => {
	if (Type.isObject(obj) && Type.isObject(val)) {
		if (Type.isDefined(prop))
			Object.entries(obj).forEach(([k, v]) => val[prop][k] = v);
		else
			Object.entries(obj).forEach(([k, v]) => val[k] = v);
	}
}

Obj.promisePaths = (elm, obj) => {
	if (Dom.isElement(elm) && Type.isArray(obj)) {
		obj.forEach(i => {
			if (Type.isObject(i.paths)) {
				const attr = {};
				const prop = {};
				switch (Object.keys(i)[1]) {
					case 'script':
						attr.tag = 'script';
						attr.src = 'src';
						attr.mime = 'type';
						prop.charset = 'UTF-8';
						break;
					case 'link':
						attr.src = 'href';
						attr.tag = 'link';
						attr.mime = 'rel';
						break;
					default:
						return;
				}
				Object.entries(i.paths).forEach(([k, v]) => {
					if (Type.isArray(v)) {
						v.forEach(j => {
							if (Type.isObject(i[attr.tag][j])) {
								Obj.assign(prop, undefined, i[attr.tag][j]);
							}
							const mime = Str.lastChar(j, '.');
							switch (mime) {
								case 'mjs':
									prop[attr.mime] = 'module';
									break;
								case 'js':
									prop[attr.mime] = 'text/javascript';
									prop.defer = true;
									break;
								case 'css':
								case 'scss':
								case 'sass':
									prop[attr.mime] = 'stylesheet';
									prop.type = 'text/css';
									break;
								case 'png':
								case 'jpg':
								case 'jpeg':
								case 'tiff':
								case 'gif':
								case 'bmp':
								case 'webp':
								case 'heic':
									prop[attr.mime] = 'icon';
									prop.type = `image/${mime}`;
									break;
								case 'ico':
									prop[attr.mime] = 'icon';
									prop.type = 'image/x-icon';
									break;
								case 'svg':
									prop[attr.mime] = 'icon';
									prop.type = 'image/svg+xml';
									break;
								case 'pdf':
									prop.title = 'PDF';
								case 'json':
								case 'xml':
									prop[attr.mime] = 'alternate';
									prop.type = `application/${mime}`;
									break;
								default:
									return;
							}
							prop[attr.src] = `${k}/${j}`;
							Component.meta(elm, [prop], attr.tag);
						});
					}
				});
			}
		});
	}
}

