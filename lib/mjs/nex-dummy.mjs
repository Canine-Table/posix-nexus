import { nxObj } from './nex-obj.mjs';

export function nxDummy()
{
	nxObj.methods(nxDummy);
}

nxDummy.fetchFirstWorkingImage = async function(width = 400, height = 300)
{
	const sources = [
		`https://picsum.photos/${width}/${height}`,
		`https://placekitten.com/${width}/${height}`,
		`https://placebear.com/${width}/${height}`,
		`https://source.unsplash.com/random/${width}x${height}`
	];

	for (const url of sources) {
		try {
			const res = await fetch(url, { mode: "cors" });

			if (!res.ok) continue; // skip failed responses

			const blob = await res.blob();

			// Verify it's actually an image
			if (!blob.type.startsWith("image/")) continue;
			return blob; // success!
		} catch (err) {
			// network error -> try next source
			continue;
		}
	}

	throw new Error("No image sources succeeded");
}

nxDummy.getBaconIpsum = async function({
	type = "meat-and-filler",
	paras = 1,
	sentences = null,
	startWithLorem = false,
	spicy = false,
	format = "json"
} = {}) {

	const params = new URLSearchParams();

	params.set("type", type);
	params.set("format", format);

	if (sentences !== null) {
		params.set("sentences", sentences);
	} else {
		params.set("paras", paras);
	}

	if (startWithLorem) params.set("start-with-lorem", "1");
	if (spicy) params.set("make-it-spicy", "1");

	const url = `https://baconipsum.com/api/?${params.toString()}`;
	const res = await fetch(url);

	if (!res.ok) {
		throw new Error(`Bacon Ipsum request failed: ${res.status}`);
	}

	return format === "json" ? res.json() : res.text();
}

