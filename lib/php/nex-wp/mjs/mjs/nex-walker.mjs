import { nxObj } from './nex-obj.mjs';

export function nxWalker()
{
	nxObj.methods(nxWalker);
}

nxWalker.before = (node, reference) => {
	reference.parentNode.insertBefore(node, reference.nextSibling);
}

nxWalker.after = (node, reference) => {
	reference.parentNode.insertBefore(node, reference);
}

nxWalker.first = (node, reference) => {
	reference.insertBefore(node, reference.firstChild);
}

nxWalker.last = (node, reference) => {
	reference.appendChild(node);
}

nxWalker.replace = (node, reference) => {
	reference.parentNode.replaceChild(node, reference);
}

nxWalker.wrap = (node, reference) => {
	nxWalker.after(node, reference);
	nxWalker.last(reference, node);
}

nxWalker.countChildren = function (query) {
    return {
        *[Symbol.iterator]() {
            for (const element of document.querySelectorAll(query)) {

                const sum = Object.create(null);        // tag → count
                const slots = Object.create(null);      // tag → [positions]

                let index = 0;

                for (const child of element.children) {
                    const tag = child.tagName.toLowerCase();

                    // increment count
                    sum[tag] = (sum[tag] || 0) + 1;

                    // record slot index
                    (slots[tag] ||= []).push(index);

                    index++;
                }

                yield { node: element, sum, slots };
            }
        }
    };
};

