#!/usr/bin/env node
import { nxObj } from './nex-obj.mjs';

export function nxRegx()
{
	return nxObj.methods(nxRegx);
}

nxRegx.wordSeparator = (val, sep = ' ') => {
	return val.replace(/[A-Z]?[a-z]+(?=[A-Z])/g, (m, _) => {
		return m + sep;
	});
}

