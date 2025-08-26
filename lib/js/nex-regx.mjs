#!/usr/bin/env node
import { nxObj } from './nex-obj.mjs';
import { nxType } from './nex-type.mjs';

export function nxRegx()
{
	return nxObj.methods(nxRegx);
}

nxRegx.wordSeparator = (v, s = ' ') => {

	if (nxType.defined(v))
		return v.replace(/[A-Z]?[a-z]+(?=[A-Z])/g, (m, _) => {
			return m + s;
		});
	return '';
}

