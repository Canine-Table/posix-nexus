/*import { NxNav } from "./mjs/nex-nav.mjs"
import { nxObj } from "./mjs/nex-obj.mjs"
import { NxCSSOM } from "./mjs/nex-css.mjs"
import { NxForm } from "./mjs/nex-form.mjs"
*/

//import { NxElement } from "./mjs/nex-element.mjs"
//

import { NxFragment } from "./mjs/nex-fragment.mjs"
import { NxStack } from "./mjs/buffer.d/nex-stack.mjs"
import { nxBit32 } from "./mjs/nex-bit32.mjs"

import { NxForm } from "./mjs/nex-form.mjs"
import { NxNav } from "./mjs/nex-nav.mjs"
import { NxDom } from "./mjs/nex-dom.mjs"



document.addEventListener('DOMContentLoaded', () => {

	const navbar = new NxNav(
		document.querySelector('body > div.nx-page > nav.nx-nav'),
		document.querySelector('body > div.nx-page > main.nx-main'),
		document.querySelector('body > div.nx-page > header.nx-header')
	);
	console.log(navbar, "aaeae")
});

