

export class NxCss
{
	static #cssRoot = document.querySelector(':root');

	static get rgb() {
		return '#' + Math.random().toString(16).slice(2, 8);
	}

	static set rgb(variable) {
		NxCss.#cssRoot.style.setProperty(`--${variable}`, NxCss.rgb);
	}

	static colorFall(
		index,
		node,
		speed = 0.1,
		occurs = 1,
		tag,
	) {
		let nodes = [];
		index ??= 0;
		tag ??= 'span'
		node ??= 'main'
		speed ??= 0.25;
		const selector = `${node} ${tag}`;
		function updateBuffer() {
			nodes = Array.from(document.querySelectorAll(selector));
		}
		const observer = new MutationObserver(updateBuffer);
		observer.observe(document.querySelector(node), {
			childList: true,
			subtree: true
		});

		updateBuffer();
		const interval = setInterval(() => {
			if (nodes.length === 0) return;

			const i = Math.floor(index);
			const j = Math.floor(index + speed);

			if (nodes[i]) nodes[i].style.color = NxCss.rgb;
			if (nodes[j]) nodes[j].style.color = NxCss.rgb;
			index += speed;
			if (index >= nodes.length || index <= 0)
				speed = -speed;
		}, occurs);
		return [ interval, observer ];
	}
}
