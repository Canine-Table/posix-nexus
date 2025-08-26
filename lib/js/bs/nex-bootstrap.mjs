import { nxObj } from '../nex-obj.mjs';
import { nxArr } from '../nex-arr.mjs';
import { nxType } from '../nex-type.mjs';
import { nxDom } from '../components/nex-dom.mjs';

export function nxBootstrap()
{
	return nxObj.methods(nxBootstrap);
}

nxBootstrap.size = (v, d = 'lg') => {
	return nxArr.isIn({
		'find': v,
		'from': [ 'sm', 'md', 'lg', 'xl', 'xxl' ]
	}) ? v : d;
}

