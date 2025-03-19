import { Type } from '../../type.mjs';
import { Obj } from '../../obj.mjs';
import { Arr } from '../../arr.mjs';
import { Str } from '../../str.mjs';
import { Int } from '../../int.mjs';
import { nexEvent } from '../../event.mjs';
import { nexClass } from '../../class.mjs';
import { nexNode } from '../nex-node.mjs';
import { nexSvg } from '../nex-svg.mjs';
import { nexSvgDefs } from './nex-defs.mjs';

export class nexSvgText extends nexSvg
{
	constructor(obj) {
		nexNode.Skel(obj);
		obj.inst = nexSvgText;
		if (obj.to instanceof nexSvg)
			obj.tag = Type.isDefined(obj.tag, 'text');
		else
			obj.tag = 'text';
		return super(obj);
	}

	static get #lineDecoration() {
		return nexClass.cherryPick([ 'none', 'underline', 'overline', 'line-through', 'blink' ]);
	}

	static get #font() {
		return nexClass.cherryPick([
			'system-ui', 'serif', 'sans-serif', 'Georgia', '"Lucida Console"',
			'"Courier New"','monospace', 'Arial', 'Helvetica',
			'"Times New Roman"', 'Times', '"Lucida Sans Unicode"',
		    	'"Bernard MT Condensed"', '"Book Antiqua"', '"Calisto MT"',
			'Cambria', 'Corbel', 'Ebrima', 'Elephant', '"Engravers MT"',
			'"Eras ITC"', '"Felix Titling"', '"Courier New"', 'Verdana',
			'Palatino', 'Garamond', 'Bookman', '"Comic Sans MS"',
		    	'"Trebuchet MS"', '"Arial Black"', 'Impact', 'Tahoma',
			'"Century Gothic"', '"Lucida Console"', '"Gill Sans"', 'Futura',
			'"Franklin Gothic Medium"', 'Baskerville', 'Candara', 'Calibri',
			'Optima', 'Didot', 'Rockwell', 'Monaco', 'Consolas', 'Copperplate',
			'Papyrus', '"Brush Script MT"', '"Segoe UI"', 'Perpetua', '"Goudy Old Style"',
			'"Big Caslon"', '"Bodoni MT"', '"American Typewriter"', '"Andale Mono"',
			'"Avant Garde"', '"Bell MT"',
		]);
	}

	svgText(obj) {
		nexNode.Skel(obj);
		obj.tag = 'text';
		obj.to = this;
		nexClass.alias({
			'text-anchor': [ 'text-anchor', 'anchor', 'a' ],
			'dominant-baseline': [ 'dominant-baseline', 'baseline', 'b' ],
			'font-size': [ 'font-size', 'size', 's' ],
			'dx': [ 'dx', 'x' ],
			'dy': [ 'dy', 'y' ],
			'rotate': [ 'rotate', 'r' ],
			'textLength': [ 'textLength', 'tlength', 'tlen', 'ta' ],
			'lengthAdjust': [ 'lengthAdjust', 'adjust', 'la' ],
			'text-decoration-color': [ 'text-decoration-color', 'tdcolor', 'tdc' ],
			'text-decoration-line': [ 'text-decoration-line', 'tdline', 'tdl' ],
			'text-decoration-style': [ 'text-decoration-style', 'tds', 'ds' ]
		}, {
			'text-anchor': [ 'start', 'middle', 'end' ],
			'text-decoration-style': [ 'solid', 'double', 'dotted', 'dashed', 'wavy' ],
			'text-decoration-line': [ 'none', 'underline', 'overline', 'line-through', 'blink' ],
			'dominant-baseline': [
				'auto',
				'text-bottom',
				'alphabetic',
				'ideographic',
				'middle',
				'central',
				'mathematical',
				'hanging',
				'text-top'
			]
		}, obj);
		nexClass.defaults({
			'dx': false,
			'dy': false,
			'rotate': false,
			'textLength': false,
			'lengthAdjust': false,
			'font-size': false,
			'text-anchor': 'start',
			'dominant-baseline': 'hanging',
			'text-decoration': false,
			'text-decoration-color': false,
			'text-decoration-style': false,
			'text-decoration-line': false,
		}, obj);
		nexClass.prop([
			'shift'
		], obj, nexSvgText);
		if (obj.font === 'rand')
			obj.css['font-family'] = nexSvgText.#font;
		return new nexSvgText(obj);
	}

	pack(obj) {
		if (Type.isObject(obj)) {
			if (! nexNode.IsNode(this.svgBox)) {
				let svgBox = undefined;
				if (obj.svg instanceof nexSvg && obj.svg.tag === 'defs') {
					this.svgBox = obj.svg;
				} else {
					this.svgBox = new nexSvgDefs({
						'to': this.parent,
						'attach': {
							'place': 'first'
						},
						'size': {
							'h': '0',
							'w': '0',
						},
						'css': {
							'position': 'absolute',
							'visibility': 'hidden'
						}
					});
				}
			}

			if (Type.isDefined(obj.words))
				this.words = Type.isArray(obj.words, ',');
			if (! Type.isArray(this.words) || this.words.length === 0) {
				this.words = [
					'null', 'undefined', '404', 'infinity',
					'false', '/dev/null', 'NaN', 'bitbucket',
					'yūgen', '🤖', 'nulla', 'nil', 'mu', 'zéro',
					'foo', 'bar', 'baz', 'undefined-behavior',
					'nada','¿', 'oblivion', 'entropy-maximized',
					'λ', 'nowhere', 'vazio', '∴', 'absurdum', 'voidwalker'
				];
			}
			const coords = this.clientCoords;
			if (! Type.isArray(this.lastCoords)) {
				this.lastCoords = coords;
			} else if (! (coords[2] > this.lastCoords[2] || coords[3] > this.lastCoords[3]))
				return;
			this.lastCoords = coords;
			let i = Type.isDefined(obj.start, 0);
			let k = 1
			let j = 0;
			let s = 50;
			while (true) {
				i++;
				if (! nexNode.ById(`${i}-grad`)) {
					this.svgBox.linearGradient({
						'id': `${i}-grad`,
						'coords': 'rand',
						'stop': '5'
					});
				}
				let cur = this.svgText({
					'text': this.words[Int.loop(i, 0, this.words.length - 1)],
					's': `${s}px`,
					'b': 'h',
					'a': 's',
					'color': {
						'f': `url(#${i}-grad)`,
						's': 'rgb'
					},
					'opacity': {
						'o': '0'
					},
					'axis': {
						'x': Int.loop(Int.wholeRandom(), 0, coords[2]),
						'y': Int.loop(Int.wholeRandom(), 0, coords[3])
					}
				});
				if (this.collision(cur)) {
					cur.remove;
					--i;
					j++;
					if (j > 150) {
						if (s > 11)
							s -= 1;
						else
							break;
					}
				} else {
					setTimeout(() => {
						const interval = setInterval(() => {
							const opa = Number(cur.getAttr('opacity').opacity);
							cur.setAttr({ 'opacity': opa + 0.01 });
							if (opa >= 1)
								clearInterval(interval);
						}, 10);
					}, Number(`${++k}00`));
					j = 0;
				}
			}
		}
		return this;
	}
}

