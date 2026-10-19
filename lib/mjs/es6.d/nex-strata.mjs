import { TypeCheck } from "./nex-type-check.mjs";
import { List } from "./nex-list.mjs";
import { Pair } from "./nex-pair.mjs";
import { Fallback } from "./nex-fallback.mjs";
import { Utilities } from "./nex-utilities.mjs";

const STRATA_ADD_DIRECTION = new Set(['push', 'enqueue']);
const STRATA_DEL_DIRECTION = new Set(['pop', 'dequeue']);
const STRATA_RELATION = new Set(['child', 'parent']);

export class Strata
{
	constructor({
			advance,
			logLevel,
			branchKey,
			unique,
			shallow,
			descend,
			reuse
		} = {}) {

		const __next = this.__next = new Map();
		const __previous = this.__previous = new Map();
		const __node = this.__node = new Map();
		const __tail = this.__tail = this.buffers = new Map();
		const __child = this.__child = this.objectMap = new Map();
		const __parent = this.__parent = this.uuidMap = new Map();
		const __length = this.__length = this.cursors = new Map();
		const anchors = this.anchors = new Map();
		const castMap = this.castMap = new Map();
		const __forward = this.__forward = this.layers = new Map();
		const __head = this.__head = this.strata = new Map([
			[ __length, 0 ]
		]);
		

		const __after = this.__after = this.config = new Map([
			[ 'advance', advance !== false ],
			[ 'unique', unique !== true ],
			[ 'shallow', shallow !== false ],
			[ 'descend', descend !== false ],
			[ 'reuse', reuse !== false ],
			[
				'logLevel', Fallback.firstRange([logLevel ?? 1], [0, 6, 1], 0)
			],
			[
				'branchKey', typeof branchKey === 'symbol' ? branchKey : String(branchKey ?? 'branch')
			]
		]);

		const anchor = this._newAnchor();
		const __back = this.__back = this.cache = new Map([
			[ 'bijective', { uuid: null, object: null } ],
			[ 'status', {
				ok: true,
				code: 200,
			}],
			[
				'anchor', anchor
			]
		]);

		const __SENTINELS = this.__before = this.__SENTINELS = new Set([
			__head, __tail, __child, __parent,
			__length, anchors, castMap, __after,
			__back, __forward, __node,
			__previous, __next
		]);

		__SENTINELS.add(__SENTINELS);
		anchors.set(__SENTINELS, __node);
		anchors.set(__forward, __next);
		anchors.set(__back, __previous);


		this._anchorSentinel(anchor);
	}
	
	_setBijective(input) {
		const objectMap = this.objectMap;
		const uuidMap = this.uuidMap;
		const uuid = Utilities.getUuid();

		objectMap.set(input, null);
		objectMap.set(uuid, input);

		uuidMap.set(uuid, null);
		uuidMap.set(input, uuid);

		return this;
	}

	_deleteBijective(input) {
		this.getBijective(input);
		if (this.load === null)
			return this;
	
		const load = this.load
		this.load = null;

		const object = load.object;
		const uuid = load.uuid;
		const objectMap = this.objectMap;
		const uuidMap = this.uuidMap;

		objectMap.delete(object);
		objectMap.delete(uuid);

		uuidMap.delete(object);
		uuidMap.delete(uuid);
		
		return this;
	}

	getBijective(input) {
		const objectMap = this.objectMap;
		if (!objectMap.has(input)) {
			this.load = null;
			return this;
		}

		const uuidMap = this.uuidMap;		
		const bijective = this.cache.get('bijective');

		bijective.uuid = uuidMap.get(input) ?? input;
		bijective.object = objectMap.get(input) ?? input;
		this.load = bijective;
		return this;
	}

	_newAnchor() {
		return new Map([
			[ this.__length, 0 ]
		]);
	}

	_checkTarget(input) {
		const status = this.cache.get('status');
		this.load = null;

		if (this.__SENTINELS.has(input) || !TypeCheck.isNormal(input)) {
			status.code = 400;
			return this
		}

		const config = this.config;
		const unique = config.get('unique');
		const shallow = config.get('shallow');

		status.code = 422;
		const castMap = this.castMap;
		if (castMap.has(input)) {
			if (unique)
				return this;

			do {
				this.load = input;
				input = castMap.get(input);
			} while (castMap.has(input));
			input = this.load;
		}

		const objectMap = this.objectMap;
		if (objectMap.has(input)) {
			if (unique)
				return this;
			do {
				this.load = input;
				input = objectMap.get(input);
			} while (objectMap.has(input));
			input = this.load;
		}

		if (input instanceof Map) {
			this.load = new Map(shallow ? input : [...input]);
		} else {
			this.load = TypeCheck.isPair(input)
				? Pair.getMap(input)
				: new Map([
					[ 'value', input ]
				]);
			castMap.set(input, this.load);
		}

		status.code = 200;
		return this;
	}

	_getCast(input) {
		const status = this.cache.get('status');
		this.load = null;

		if (this.__SENTINELS.has(input) || !TypeCheck.isNormal(input)) {
			status.code = 400;
			return this
		}
		
		const castMap = this.castMap;
		if (castMap.has(input)) {
			do {
				this.load = input;
				input = castMap.get(input);
			} while (castMap.has(input));
			input = this.load;
		}

		const objectMap = this.objectMap;
		if (objectMap.has(input)) {
			do {
				this.load = input;
				input = objectMap.get(input);
			} while (objectMap.has(input));
			input = this.load;
		}
		
		status.code = this.load === null
			? 404
			: 200;

		return this;
	}

	_resize(shift = 0, input = undefined) {

		let anchor, size;
		const __length = this.__length;
		shift = Number.parseInt(shift, 10) || 0;

		if (input === null) {
			anchor = this.strata;
		} else {
			this._getCast(input);
			anchor = this.load === null
				? this.cache.get('anchor')
				: this.anchors.get(this.load);
		}

		size = anchor.get(__length);
		size = size + shift || 0;

		this.load = size > 0 ? size : 0;
		anchor.set(__length, this.load);
		return this;
	}

	size(input) {
		return this._resize(0, input);
	}

	_insert(input, direction) {
		const anchor = this.cache.get('anchor');
		const __node = this.__node;

		if (TypeCheck.isList(input)) {
			if (!STRATA_ADD_DIRECTION.has(direction)) {
				direction = this.cache.get('advance')
					? 'push'
					: 'enqueue';
			}
			let list = List.getArray(input);
			let index = -1;
			while (++index < list.length) {
				const entry = list[index];
				if (TypeCheck.isList(entry)) {
					list = [
						...list.slice(0, index),
						...entry,
						...list.slice(index + 1)
					];
					index--;
					continue
				}
				this._checkTarget(entry);
				if (this.load === null)
					continue;
				this[direction](this.load);
				this._setBijective(this.load);
			}
			this.load = null;
			return this;
		} else {
			this._checkTarget(input);
			if (this.load === null)
				return this;
			input = this.load;
			this._resize(1);
			this._resize(1, null);
			this.load = input;

			if (anchor.has(__node)) {
				const before = anchor.get(__node);
				before.set(this.__after, input);
				input.set(this.__before, before);
			}

			anchor.set(__node, input);
			return this._setBijective(input);
		}
	}

	_reorder(input) {
		const __after = this.__after;
		const __before = this.__before;
		const __node = this.__node;
		const anchor = this.cache.get('anchor');
		const node = anchor.get(__node);

		if (input.has(__before)) {
			const before = input.get(__before);
			if (before.get(__after) === input) {
				if (input.has(__after)) {
					const after = input.get(__after);
					before.set(__after, after);
					after.set(__before, before);
					input.delete(__after);
				} else {
					before.delete(__after);
				}
			}
			if (node === input)
				anchor.set(__node, before);
			input.delete(__before);
		} else if (input.has(__after)) {
			const after = input.get(__after);
			after.delete(__before);
			if (node === input)
				anchor.set(__node, after);
			input.delete(__after);
		}
		return this;
	}

	_anchorSentinel(input, track) {
		const sentinels = this.anchors.get(this.__SENTINELS);
		if (!sentinels.has(input))
			sentinels.set(input, new Set());
		this.load = sentinels.get(input);
		if (track instanceof Set)
			this.load.add(track);
		return this;
	}

	_switchAnchor(oldNode, newNode, nodes) {
		const sentinels = nodes.get(this.__SENTINELS);
		const cache = this.cache;
		const status = cache.get('status');

		if (nodes.has(newNode))
			newNode = nodes.get(newNode);

		if (!sentinels.has(newNode))
			return this;

		status.code = 200;
		if (newNode === oldNode)
			return this;

		let state = oldNode.get(this.__length) > 0
			? 'INSPECT' : 'PURGE';

		const __back = this.__back;
		const __forward = this.__forward;

		const links = new Map([
			[ true, {
				'member': nodes.get(__forward), // forwards
				'node': oldNode,
				'sentinel': __forward,
				'link':	newNode.has(__back) // newBack
					? newNode.get(__back)
					: null
			}],
			[ false, {
				'member': nodes.get(__back), // backwards
				'node': newNode,
				'sentinel': __back,
				'link': oldNode.has(__forward) // oldForward
					? oldNode.get(__forward)
					: null
			}]
		]);

		let reference = true;
		let right, left;

		do {
			switch (state) {
				case 'INSPECT': {
					left = links.get(reference);
					right = links.get(!reference);
					if (left.link !== null) {
						if (right.member.has(right.node))
							right.member.get(right.node).add(left.link)
						else
							right.member.set(right.node, new Set([left.link]))
						this._anchorSentinel(right.node,left.node);
						const nextNodes = right.member.get(right.node);
						if (nextNodes.has(left.node)) {
							nextNodes.delete(left.node);
							sentinels.get(left.node).delete(right.node);
						}
					}
					right.node.set(right.sentinel, left.node);
					if (reference !== false)
						reference = !reference
					else
						state = null;
					break;
				}

				case 'PURGE': { // ...
					break;
				}
			}
		} while (state);
		return this;
	}

	_anchorProvenance(sentinel) {
		const oldAnchor = this.cache.get('anchor');
		const newAnchor = oldAnchor.has(sentinel)
			? oldAnchor.get(sentinel)
			: null;
		if (newAnchor === null)
			return this;
		this.cache.set('anchor', newAnchor);
		return this._switchAnchor(oldAnchor, newAnchor, this.anchors);
	}

	anchorForward() {
		return this._anchorProvenance(this.__forward);
	}

	anchorBackward() {
		return this._anchorProvenance(this.__back);
	}

	//TODO
	_move(input, direction, relation, reuse, refer, origin) {
		const cache = this.cache;
		const status = cache.get('status');

		this._getCast(input);
		if (status.code !== 404)
			return this;

		const config = this.config;
		const oldAnchor = cache.get('anchor');
		const anchors = this.anchors;

		const __node = this.__node;
		const __child = this.__child;
		const __parent = this.__parent;
		const __head = this.__head;
		const __tail = this.__tail;

		if (!STRATA_ADD_DIRECTION.has(direction)) {
			direction = config.get('advance')
				? 'push'
				: 'enqueue';
		}

		if (!STRATA_RELATION.has(relation)) {
			relation = config.get('descend')
				? 'parent'
				: 'child';
		}

		const xAxis = direction === 'push'
			? __head
			: __tail;

		const yAxis = direction === 'parent'
			? __parent
			: __child;


		this._getCast(refer);
		let referAnchor;
		if (status.code !== 200) {
			this.size();
			if (this.load === 0)
				return this;
			referAnchor = oldAnchor
			this.load = oldAnchor.get(__node);
		} else {
			referAnchor = anchors.get(this.load);
		}

		refer = this.load;

		let newAnchor = this._newAnchor();
		cache.set('anchor', newAnchor);
		this[direction](input);
		this._anchorSentinel(newAnchor);
		this._switchAnchor(referAnchor, newAnchor, this.anchors);
		//...
		return this;
	}

	_pluck(input) {
		const status = this.cache.get('status');

		this.size();
		let size = this.load;

		// 204: Queue is empty
		if (size === 0) {
			this.load = null;
			status.ok = undefined;
			status.code = 204;
			return this;
		}

		this._getCast(input);
		if (this.load === null) {
			status.code = 422;
			return this;
		}

		input = this.load;
		const cache = this.cache;


		const anchors = this.anchors;

		const anchor = anchors.get(input);
		cache.set('anchor', anchor);

		const __head = this.__head;
		const __tail = this.__tail;
		const headNode = anchor.get(__head);
		const tailNode = anchor.get(__tail);


		const __parent = this.__parent;
		const __child = this.__child;

		// 409: Conflict - Node is bound in a parent/child relational dimension
		if (input.has(__child) || anchor.has(__parent)) {
			this.load = null;
			status.ok = false;
			status.code = 409;
			return this;
		}

		this._reorder(input);

		this._resize(-1);
		this._resize(-1, null);

		// 404: Not Found - Node isn't registered in strata or is a root anchor node
		if (input === headNode || input === tailNode) {
			status.ok = false;
			status.code = 404;
			return this;
		}

		const __next = this.__next;
		const __previous = this.__previous;

		// 200: Success
		status.ok = true;
		status.code = 200;

		const previousNode = input.get(__previous);
		const nextNode = input.get(__next);

		previousNode.set(__next, nextNode);
		nextNode.set(__previous, previousNode);

		// Clear unlinked node sentinels
		input.set(__next, null);
		input.set(__previous, null);

		this.anchors.delete(input);
		return this._deleteBijective(input);
	}

	_remove(input, head, tail, previous, next) {
		const cache = this.cache;
		const status = cache.get('status');
		const anchor = cache.get('anchor');

		this._pluck(input ?? anchor.get(head));
		if (status.code !== 404)
			return this;
		input = this.load;

		if (anchor.has(head)) {
			const popNode = anchor.get(head);
			input = this.load = popNode;

			if (popNode.has(previous)) {
				const previousNode = popNode.get(previous);
				previousNode.delete(next);
				if (anchor.get(tail) === popNode)
					anchor.delete(tail);
				else
					anchor.set(head, previousNode);
			} else {
				anchor.delete(head);
				anchor.delete(tail);
			}
		} else {
			this.load = null;
			return this;
		}

		this.anchors.delete(input);
		return this._deleteBijective(input);
	}

	_add(input, direction, head, tail, previous, next) {
		this._insert(input, direction);
		if (this.load === null)
			return this;

		input = this.load;
		const anchors = this.anchors;

		const anchor = this.cache.get('anchor');

		if (anchor.has(tail)) {
			const nextNode = anchor.get(tail);
			input.set(next, nextNode);
			nextNode.set(previous, input);
		} else {
			anchor.set(head, input);
		}

		anchor.set(tail, input);
		anchors.set(input, anchor);

		return this;
	}

	*_direction(input, front, forward) {
		const anchor = this.cache.get('anchor');
		if (!anchor.has(front))
			return;

		const objectMap = this.objectMap;
		this._getCast(input);
		let node = this.load ?? anchor.get(front);

		do {
			yield node;
			node = node.get(forward);
		} while (objectMap.has(node));
	}

	[Symbol.iterator](input) {
			return this.config.get('advance')
				? this.forward(input)
				: this.reverse(input);
	}

	nodeLog(input) {
		this._getCast(input);
		if (this.load === null)
			return this;
		const sentinels = this.__SENTINELS;
		input = this.load;
		console.log(input.has(this.__previous), '<- (', this.uuidMap.get(input), ') ->' , input.has(this.__next));

		for (const [k, v] of input) {
			if (sentinels.has(k))
				continue;
			console.log('\t', k, '=', v);
		}
		return this;
	}

	ordered(input) {
		return this._direction(
			input,
			this.__node,
			this.__before
		)
	}

	forward(input) {
		return this._direction(
			input,
			this.__tail,
			this.__next
		)
	}

	reverse(input) {
		return this._direction(
			input,
			this.__head,
			this.__previous
		)
	}

	enqueue(input) {
		return this._add(
			input,
			'enqueue',
			this.__head,
			this.__tail,
			this.__previous,
			this.__next
		);
	}

	push(input) {
		return this._add(
			input,
			'push',
			this.__tail,
			this.__head,
			this.__next,
			this.__previous
		);
	}

	pop(input) {
		return this._remove(
			input,
			this.__head,
			this.__tail,
			this.__previous,
			this.__next
		);
	}

	dequeue(input) {
		return this._remove(
			input,
			this.__tail,
			this.__head,
			this.__next,
			this.__previous
		);
	}
}


