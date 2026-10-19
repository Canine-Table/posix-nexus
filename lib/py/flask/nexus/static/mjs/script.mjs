import { Pair } from "./mjs/es6.d/nex-pair.mjs"
import { Strata } from "./mjs/es6.d/nex-strata.mjs"


document.addEventListener('DOMContentLoaded', () => {
	const grph = new Strata();
	grph.push([
		{
			name: 'test C',
			value: 'this'
		}
	]).enqueue({
		name: 'test B',
		value: 'world'
	})._move({
		name: 'test D',
		value: 'is'
	}).enqueue({
		name: 'test A',
		value: 'hello'
	}).enqueue({
		name: 'test E',
		value: 'tom'
	}).anchorBackward();

	console.log('\nback');
	for (const g of grph.reverse()) {
		grph.nodeLog(g);
	}
	
	console.log('\nforward');
	grph.anchorForward()
	for (const g of grph.ordered()) {
		grph.nodeLog(g);
	}
});

