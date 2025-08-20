#!/usr/bin/env node
import { Obj } from './obj.mjs';
export function Regx()
{
	Obj.methods(Regx);
}

Regx.wordSeparator = (val, sep = ' ') => {
	return val.replace(/[A-Z]?[a-z]+(?=[A-Z])/g, (m, _) => {
		return m + sep;
	});
}

