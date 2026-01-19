import { nxVm } from "./js/nex-vm.mjs"
import { nxBit32 } from "./js/nex-bit32.mjs"
import { nxMath } from "./js/nex-math.mjs"


document.addEventListener('DOMContentLoaded', () => {
        /*console.log("hello world");
	const stk = NxVm();
	console.log(stk[0])
	*/
	//let num = 0;
	//let sz = 1024
	//let pl = 64
	//let hdr = 8

	const encoder = new TextEncoder();
	const bytes = encoder.encode('hello world');
	let i
	for (i in bytes)
		console.log(bytes[i])
	//num = Math.floor(sz / pl);
	//const halloc = hdr * num
	//const palloc = sz - halloc
	//console.log(halloc, "+", palloc, "=", sz)

});

