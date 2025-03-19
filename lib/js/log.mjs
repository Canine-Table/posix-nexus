#!/usr/bin/env node
import { Type } from './type.mjs';
import { Obj } from './obj.mjs';
import { Arr } from './arr.mjs';
import { nexAnime } from './anime.mjs';
import { Str } from './str.mjs';
export function nexLog()
{
	Obj.methods(nexLog);
}

nexLog.logger = (obj) => {
	if (Type.isArray(obj)) {
		obj.forEach(i => {
			if (Type.isObject(i)) {
				Object.entries(i).forEach(([k, v]) => {
					switch (k) {
						case 'info':
						case 'error':
						case 'log':
						case 'warn':
						case 'trace':
						case 'table':
						case 'trace':
						case 'assert':
							console[k](v);
							break;
						default:
							console.groupCollapsed(k);
							nexLog.logger(v);
							console.groupEnd(k);
					}
				});
			}
		})
	}
}

nexLog.location = () => {
	return nexLog.logger([
		{
			'Location': [
				{ 'info': window.location.hash },
				{ 'info': window.location.host },
				{ 'info': window.location.hostname },
				{ 'info': window.location.origin },
				{ 'info': window.location.pathname },
				{ 'info': window.location.port },
				{ 'info': window.location.protocol },
				{ 'info': window.location.search }
			]
		},
	]);
}

nexLog.navigator = () => {
	return nexLog.logger([
		{
			'Navigator': [
				{ 'info': window.navigator.appCodeName },
				{ 'info': window.navigator.appName },
				{ 'info': window.navigator.appVersion },
				{ 'info': window.navigator.cookieEnabled },
				{ 'info': window.navigator.geolocation },
				{ 'info': window.navigator.language },
				{ 'info': window.navigator.onLine },
				{ 'info': window.navigator.platform },
				{ 'info': window.navigator.product },
				{ 'info': window.navigator.userAgent },
				{ 'info': window.navigator.javaEnabled() },
			]
		},
	]);
}

nexLog.window = () => {
	return nexLog.logger([
		{
			'Window': [
				{ 'info': window.frames },
				{ 'info': window.opener },
			],
		},
	]);

}

