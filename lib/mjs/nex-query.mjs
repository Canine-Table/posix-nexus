
export function nxQuery(e)
{
	return document.getElementById(e) ?? document.querySelector(e);
}

nxQuery.head = (e) => {
	return _.root(e, document.head);
}

nxQuery.body = (e) => {
	return _.root(e, document.body);
}

const _ = {
	root(e, p) {
		const c = query(e);
		return p.contains(c) ? c : p;
	}
};

